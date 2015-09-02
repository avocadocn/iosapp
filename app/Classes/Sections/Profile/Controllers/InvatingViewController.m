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
@interface InvatingViewController ()<UITableViewDataSource,UITableViewDelegate,addressTableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *contactArray; // 联系人
@property (nonatomic, strong)NSMutableArray *invatePhone; // 邀请人
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
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
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
    return self.contactArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    NSDictionary *dic = self.contactArray[indexPath.row];  //
    id person = [dic objectForKey:@"person"];
    [cell reloCellWithAddressBook:person andStateString:[dic objectForKey:@"state"]];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
-(void)ReadAllPeoples { // 获取本地联系人
    CFErrorRef error = NULL;
    ABAddressBookRef tmpAddressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray *tmpPeoples = [NSArray array];
    if (tmpAddressBook) {
       tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    }
    for(id tmpPerson in tmpPeoples) {
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty); // FirstName
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);// LastName
        NSString *contactName = [NSString stringWithFormat:@"%@ %@",tmpFirstName,tmpLastName];
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSString *contactPhoneNumber = @"";
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            if (tmpPhoneIndex.length >= 13 && [tmpPhoneIndex hasPrefix:@"("]) {
                contactPhoneNumber = tmpPhoneIndex;
            }else {
            }
        }
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        if (![contactName isEqualToString:@""] && ![contactPhoneNumber isEqualToString:@""]) {
            [tempDic setObject:tmpPerson forKey:@"person"];
            [tempDic setObject:@"0" forKey:@"state"];  // 未被选中
            [self.contactArray addObject:tempDic];
        }
    }
    [self.tableView reloadData];
    //取得本地通信录名柄
/*    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
    //取得本地所有联系人记录
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSLog(@"First name:%@", tmpFirstName);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSLog(@"Last name:%@", tmpLastName);
        //获取的联系人单一属性:Nickname
        NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty);
        NSLog(@"Nickname:%@", tmpNickname);
        //获取的联系人单一属性:Company name
        NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);
        NSLog(@"Company name:%@", tmpCompanyname);
        //获取的联系人单一属性:Job Title
        NSString* tmpJobTitle= (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty);
        NSLog(@"Job Title:%@", tmpJobTitle);
        //获取的联系人单一属性:Department name
        NSString* tmpDepartmentName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty);
        NSLog(@"Department name:%@", tmpDepartmentName);

        //获取的联系人单一属性:Email(s)
        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
        for(NSInteger j = 0; ABMultiValueGetCount(tmpEmails); j++)
        {
            NSString* tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
            NSLog(@"Emails%ld:%@", (long)j, tmpEmailIndex);
        
        }
        CFRelease(tmpEmails);
        //获取的联系人单一属性:Birthday
        NSDate* tmpBirthday = (__bridge NSDate*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty);
        NSLog(@"Birthday:%@", tmpBirthday);
        //获取的联系人单一属性:Note
        NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNoteProperty);
        NSLog(@"Note:%@", tmpNote);
        //获取的联系人单一属性:Generic phone number
//        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
//        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
//        {
//            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
//            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
//        }
    }
 */
    
}
#pragma addresstableDelegate
/*
//-(void)passValue:(NSString *)phoneNumber { // 添加邀请对象
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
    NSMutableDictionary *dic = self.contactArray[indexPath.row];
    switch ([[dic objectForKey:@"state"] integerValue]) {
        case 0:{
            [dic setObject:@"1" forKey:@"state"];
            break;
        }
        case 1:
        {
            [dic setObject:@"0" forKey:@"state"];
            break;
        }
        default:
            break;
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
    NSLog(@"邀请人的列表有 %@", array);

    NSLog(@"%lu",(unsigned long)self.invatePhone.count);
    InvatingModel *model = [[InvatingModel alloc] init];
    [model setPhone:self.invatePhone];
    [RestfulAPIRequestTool routeName:@"userInvate" requestModel:model useKeys:@[@"phone"] success:^(id json) {
        NSLog(@"邀请成功");
    } failure:^(id errorJson) {
        NSLog(@"邀请失败的原因 %@",[errorJson objectForKey:@"msg"]);
    }];
    
}

- (NSArray *)getInviteArrayWithArray
{
    NSMutableArray *array  = [NSMutableArray array];
    for (NSDictionary *dic in self.contactArray) {
        if ([[dic objectForKey:@"state"] isEqualToString:@"1"]) {//选中了
            id person = [dic objectForKey:@"person"];
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            {
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                if (j == (ABMultiValueGetCount(tmpPhones) - 1)) {
                    [array addObject:tmpPhoneIndex];
                }
            }
        }
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
    NSMutableDictionary *dic = self.contactArray[indexPath.row];
    switch ([[dic objectForKey:@"state"] integerValue]) {
        case 0:{
            [dic setObject:@"1" forKey:@"state"];
            break;
        }
        case 1:
        {
            [dic setObject:@"0" forKey:@"state"];
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
