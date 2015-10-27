//
//  InvatingViewController.m
//  app
//
//  Created by burring on 15/8/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InvatingViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AddressTableViewCell.h"
#import "AddressBookModel.h"
#import "RestfulAPIRequestTool.h"
#import "InvatingModel.h"
#import "ChineseToPinyin.h"
@interface InvatingViewController ()<UITableViewDataSource,UITableViewDelegate,addressTableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *contactArray; // 联系人
@property (nonatomic, strong)NSMutableArray *invatePhone; // 区头
@property (nonatomic, strong)NSMutableDictionary *wordDic;
@end

@implementation InvatingViewController
-(NSMutableArray *)contactArray {
    if (_contactArray == nil) {
        self.contactArray = [@[]mutableCopy];
    }
    return _contactArray;
}
-(NSMutableArray *)invatePhone {
    if (_invatePhone == nil) {
        self.invatePhone = [@[]mutableCopy];
    }
    return _invatePhone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    注册cell
    [self.tableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self ReadAllPeoples];
    [self invateButtonAction]; //
}
#pragma tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.contactArray[section];
    NSArray *array = dic[@"array"];
    
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contactArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    NSDictionary *dic = self.contactArray[indexPath.section];
//    [cell reloCellWithAddressBook:person andStateString:[dic objectForKey:@"state"]];
    
    NSArray *array = dic[@"array"];
    
    AddressBookModel *model = array[indexPath.row];
    cell.myModel = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


-(void)ReadAllPeoples { // 获取本地联系人
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook =ABAddressBookCreate();
    }
    if (tip) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
//   二、获取通讯录联系人详细信息
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    //进行遍历
    for (NSInteger i=0; i<number; i++) {
        //获取联系人对象的引用
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        NSLog(@"%@",firstName);
        //获取当前联系人姓氏
        NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        NSString *contactName = [[NSString alloc] init];
        if (lastName && firstName) {
            contactName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        } else if (firstName){
            contactName = [NSString stringWithFormat:@"%@",firstName];
        } else {
            contactName = [NSString stringWithFormat:@"%@",lastName];
        }
        //获取当前联系人的电话 数组
//        NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
//        ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
//        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
//            [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
//        }
        ABMultiValueRef tmpPhones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        NSString *contactPhoneNumber = @"";
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSMutableString* tmpPhoneIndex = (__bridge NSMutableString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            if (tmpPhoneIndex.length >= 13 && ![tmpPhoneIndex hasPrefix:@"("]) {
                contactPhoneNumber = tmpPhoneIndex;
            }else {
            }
        }
//        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        if (![contactName isEqualToString:@""] && ![contactPhoneNumber isEqualToString:@""]) {
            AddressBookModel *model = [self getAddressModel:(__bridge id)(people)];
//            [tempDic setObject:model forKey:@"person"];
//            [tempDic setObject:@"0" forKey:@"state"];  // 未被选中
//            [self.contactArray addObject:tempDic];
            [model setSelectState:0];
            [self.contactArray addObject:model];
        }
    }
    
    [self getSortArrayWithArray:self.contactArray];
}
- (AddressBookModel *)getAddressModel:(id)person
{
    AddressBookModel *model = [[AddressBookModel alloc] init];
    
    NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty); // FirstName
    NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);// LastName
    //    phoneNumber
    ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
        NSData *userImage=(__bridge NSData*)(ABPersonCopyImageData((__bridge ABRecordRef)(person))); //获取当前联系人头像图片
        if (userImage) {
            model.imageData = userImage;
        }
    for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
    {
        NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
        if (tmpPhoneIndex.length >= 13) {
            model.phone = tmpPhoneIndex;
            
        }else {
        }
    }
    
    if (tmpLastName && tmpFirstName) {   // lastname 不一定有
        model.realname = [NSString stringWithFormat:@"%@ %@",tmpFirstName,tmpLastName];
    } else if (tmpFirstName){
        model.realname = [NSString stringWithFormat:@"%@",tmpFirstName];
    } else {
        model.realname = [NSString stringWithFormat:@"%@",tmpLastName];
    }
    return model;
}

- (void)getSortArrayWithArray:(NSArray *)array
{
    int i = 0;
    for (AddressBookModel *model in array) {
        NSString *str = model.realname;
        [self judgeNameFormat:str andIndex:i];
        i++;
    }
    [self getArrayWithDic:self.wordDic];
    NSLog(@"%@", self.contactArray);
}


#pragma addresstableDelegate
/*
//-(void)passValue:(NSString *)phonNuember { // 添加邀请对象
//    if ([phoneNumber isEqualToString:@""]) {
//        NSLog(@"%@",phoneNumber);
//    } else {
//        [self.invatePhone addObject:phoneNumber];
//    }
//    NSLog(@"%lu%@",(unsigned long)self.invatePhone.count,self.invatePhone);
//}
//-(void)deleteValue:(NSString *)phoneNumber { // 移除邀请对象
//    [self.invatePhone removeObject:phoneNumber];
//    NSLog(@"%lu%@",(unsigned long)self.invatePhone.count,self.invatePhone);
//}
*/
- (void)sendIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.contactArray[indexPath.section];
    NSArray *array  = dic[@"array"];
    AddressBookModel *model = array[indexPath.row];
    
    if (model.selectState) {
        model.selectState = NO;
    } else{
        model.selectState = YES;
    }
    
}

// 邀请

- (void)invateButtonAction
{
    self.invatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    [label setBackgroundColor:[UIColor blackColor]];
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editButtonAction:)];
    [self.invatingLabel addGestureRecognizer:tap];
    self.invatingLabel.text = @"邀请";
    self.invatingLabel.textAlignment = NSTextAlignmentRight;
    self.invatingLabel.font = [UIFont systemFontOfSize:15];
    self.invatingLabel.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.invatingLabel];}
-(void)editButtonAction:(UITapGestureRecognizer *)gesture {
    
    NSArray *array = [self getInviteArrayWithArray];
    for (NSString *number in array) {
        if ([number containsString:@"-"]) {
            NSRange range = [number rangeOfString:@"-"];
           NSString  *number1 = [number stringByReplacingCharactersInRange:range withString:@""];
            NSRange range2 = [number1 rangeOfString:@"-"];
            NSString *number2 = [number1 stringByReplacingCharactersInRange:range2 withString:@""];
            [self.invatePhone addObject:number2];
        }
    }
//    NSLog(@"邀请人的列表有 %@", array);

    InvatingModel *model = [[InvatingModel alloc] init];
    [model setPhones:self.invatePhone];
    [RestfulAPIRequestTool routeName:@"userInvate" requestModel:model useKeys:@[@"phones"] success:^(id json) {
        NSLog(@"邀请成功");
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"邀请成功" delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
    } failure:^(id errorJson) {
//        NSLog(@"邀请失败的原因 %@",[errorJson objectForKey:@"msg"]);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"邀请失败" message:[errorJson objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.7]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    NSDictionary *dic = [self.contactArray objectAtIndex:section];
    NSString *str = [dic objectForKey:@"letter"];
    label.text = str;

    [view addSubview:label];

    return view;
}
- (NSArray *)getInviteArrayWithArray
{
    NSMutableArray *array  = [NSMutableArray array];
    for (NSDictionary *dic in self.contactArray) {
        NSArray *tempArray = dic[@"array"];
        for (AddressBookModel *model in tempArray) {
            if (model.selectState) {
                [array addObject:model.phone];
            }
        }
        
        
        /*if ([[dic objectForKey:@"state"] isEqualToString:@"1"]) {//选中了
            id person = [dic objectForKey:@"person"];
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            {
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                if (j == (ABMultiValueGetCount(tmpPhones) - 1)) {
                    [array addObject:tmpPhoneIndex];
                }
            }
        }*/
    }
    return array;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.contactArray[indexPath.section];
    NSArray *array  = dic[@"array"];
    AddressBookModel *model = array[indexPath.row];
    
    if (model.selectState) {
        model.selectState = NO;
    } else{
        model.selectState = YES;
    }
    
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)getArrayWithDic:(NSMutableDictionary *)dic
{
    self.contactArray = [NSMutableArray array];
    NSArray *array = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",@"I",@"J", @"K", @"L",@"M", @"N",@"O", @"P", @"Q", @"R", @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (NSString *str in array) {
        if ([dic objectForKey:str]) {
            NSArray *array = [dic objectForKey:str];
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithObject:array forKey:@"array"];
            [tempDic setObject:str forKey:@"letter"];
            [self.contactArray addObject:tempDic];
        }
    }
    NSArray *numArray = @[@"0", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableDictionary * myTempDic = [NSMutableDictionary dictionary];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *str in numArray) {
        if ([dic objectForKey:str]) {
            [tempArray addObjectsFromArray:[dic objectForKey:str]];
        }
    }
    
    if (tempArray.count) { // 存在特殊字符
        [myTempDic setObject:tempArray forKey:@"array"];
        [myTempDic setObject:@"#" forKey:@"letter"];
        
        [self.contactArray addObject:myTempDic];
    }
    
    
    
    //    NSLog(@"排列完的数组为 %@", self.modelArray);
}


//  index 为 字符串所在字典 在数组中的下标
- (void)judgeNameFormat:(NSString *)str andIndex:(NSInteger)index
{
    unichar uc = [str characterAtIndex: 0];
    //    NSLog(@"%hu", uc);
    //    uc 在 ascii 码表中的位置
    // 大写                            小写
    if ((uc >= 65 && uc <=90) || (uc >= 97 && uc <= 122) ) { //英文
        //        NSLog(@"这个字符为英文");
        [self orderWordWithString:uc andIndex:index];
    } else if (uc >= 48 && uc <= 57){
        //        NSLog(@"这个字符为数字");
        [self orderWordWithString:uc andIndex:index];
    }
    else if (uc >= 33 && uc <= 255)
    {
        //        NSLog(@"这个字符为标点符");  //  标点符号取消
    } else
    {
        NSMutableString *newStr = (NSMutableString *)[ChineseToPinyin pinyinFromChineseString:str];
        //        NSLog(@"这个字符为汉字, 转化为拼音为 %@", newStr);
        NSString *judgeStr = [self judgeString:newStr];
        if ([judgeStr integerValue]) {
            //            NSLog(@"这是特殊字符%@", str);
        }
        else {
            [self judgeNameFormat:judgeStr andIndex:index];
        }
    }
}
// 判断字符串有没有空格开头
- (NSString *)judgeString:(NSMutableString *)str
{
    NSMutableString *strNew = [NSMutableString string];
    
    if ([str hasPrefix:@" "]) {
        strNew = (NSMutableString *)[str substringFromIndex:1];
    } else
    {
        return str;
    }
    if (![strNew hasPrefix:@" "]) {
        return strNew;
    } else
    {
        [self judgeString:strNew];
    }
    
    return nil;
}

// 根据判断得来的字符在ASCII码中的字符 wordDic里创建相对应的数组
- (void)orderWordWithString:(UniChar)str andIndex:(NSInteger)index
{
    if (!self.wordDic) {
        self.wordDic = [NSMutableDictionary dictionary];
    }
    
    AddressBookModel *model = [self.contactArray objectAtIndex:index];
    
    if ((str >= 97 && str <= 122)  ) {
        str -= 32;
    }
    
    int asciiCode = str;
    NSString *newStr = [NSString stringWithFormat:@"%c", asciiCode];
    //    NSLog(@"用户名的首字母为 %@", newStr);
    if (![self.wordDic objectForKey:newStr]) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self.wordDic setObject:array forKey:newStr];
    } else
    {
        NSMutableArray *array = [self.wordDic objectForKey:newStr];
        [array addObject:model];
    }
}
// 设置索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.contactArray) {
        NSString *str = dic[@"letter"];
        [arry addObject:str];
    }
    return arry;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    return [self.contactArray count];
}

@end
