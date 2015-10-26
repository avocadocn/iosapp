//
//  AddressViewController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AddressViewController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "AddressTableViewCell.h"
#import "AddressBookModel.h"
#import "ColleaguesInformationController.h"
#import "RestfulAPIRequestTool.h"
#import "ChineseToPinyin.h"
#import "EMSearchBar.h"
#import "Account.h"
#import "AccountTool.h"
#import "GroupDetileModel.h"
#import <MJRefresh.h>

#define path [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]

@interface AddressViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, addressTableViewDelegate, UIAlertViewDelegate>
/**
 *  用做用户搜索
 */
@property (nonatomic, strong)NSArray *jsonArray;
@property (nonatomic, strong)NSArray *bigArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readLocalAddress];
    [self requestNet];
    [self builtInterFace];
    [self loadingImageView];
    
}

- (void)loadingImageView {
    
    
    
    
}


- (void)readLocalAddress
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *Str = [NSString stringWithFormat:@"%@/address", path];
    
    NSArray *array = [manger subpathsAtPath:Str];
    
    NSArray *big = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/bigAddress", path]];
    NSLog(@" 本地 %@" , big);
    
    NSLog(@"获取到的本地文件  %@", array);
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *str in array) {
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", Str, str]];
        AddressBookModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.nickname forKey:@"nickname"];
//        [dic setObject:model.gender forKey:@"gender"];
        [dic setObject:model.ID forKey:@"_id"];
        [dic setObject:model.photo forKey:@"photo"];
        [dic setObject:model.realname forKey:@"realname"];
        [mutableArray addObject:dic];
    }
    [self relodaViewWithData:mutableArray];
}

- (void)builtInterFace
{
    self.title = @"学校通讯录";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.addressSearch = [[EMSearchBar alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, 40)];
    self.addressSearch.placeholder = @"Search";  [self.addressSearch placeholder];
    
    self.addressSearch.delegate = self;
    [self.view addSubview:self.addressSearch];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, DLScreenWidth, DLScreenHeight - 64 - 30) style:UITableViewStylePlain];
    [self.myTableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"addressTableViewCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
//    [footer setTitle:@"加载更多" forState: MJRefreshStateIdle];
    self.myTableView.footer = footer;
    
    MJRefreshNormalHeader *aHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    aHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    
    self.myTableView.header = aHeader;
    
    
    [self.view addSubview:self.myTableView];
    
}
- (void)refreshAction
{
    [UIView animateWithDuration:.7 animations:^{
        
        [self.myTableView.footer endRefreshing];
    }];
}

- (void)headerAction
{
    [UIView animateWithDuration:.7 animations:^{
        [self.myTableView.header endRefreshing];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    // 找寻
    NSLog(@"要搜索的文字为  %@", searchText);
    if (![searchText isEqualToString:@""]) {
        self.wordDic = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in self.jsonArray) {
            NSString *str = [dic objectForKey:@"realname"];
        
            if([str rangeOfString:searchText].location !=NSNotFound)//_roaldSearchText { NSLog(@"yes");
            {
                NSLog(@"找到了  %@", str);
                [mutableArray addObject:dic];
            }
        }
        
        [self relodaViewWithData:mutableArray];
    }
    else
    {
        
        self.modelArray = [NSMutableArray arrayWithArray:self.bigArray];
        NSLog(@"重新刷新");
        [self.myTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"结束");
}




- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

//  公司网络请求
- (void)requestNet
{
    Account *acc = [AccountTool account];
    
    AddressBookModel *model = [[AddressBookModel alloc]init];
    
    [model setCompanyId:acc.cid];
    
    [RestfulAPIRequestTool routeName:@"getCompanyAddressBook" requestModel:model useKeys:@[@"companyId"] success:^(id json) {
        NSLog(@"获取通讯录成功 , %@", json);
        
        
        self.jsonArray = [NSArray arrayWithArray:json];
        
        [self relodaViewWithData:json];
        
        self.bigArray = [NSArray arrayWithArray:self.modelArray];
        
        [self saveDataWithJson:json];
        /*
        NSString *str = [NSString stringWithFormat:@"%@/bigAddress", path];
        NSFileManager *mag = [NSFileManager defaultManager];
        if ([mag fileExistsAtPath:str]) {
            [mag removeItemAtPath:str error:nil];
            [self.bigArray writeToFile:str atomically:YES];
        } else
        {
            [self.bigArray writeToFile:str atomically:YES];
        }
        */
        
        acc.userId = acc.ID;
        // 获取关注列表
        [RestfulAPIRequestTool routeName:@"getCorcernList" requestModel:acc useKeys:@[@"userId"] success:^(id json) {
//            NSLog(@"获取用户关注列表成功 %@", json);
            
            [self compareJsonWithArray:json];
        } failure:^(id errorJson) {
            NSLog(@"获取用户列表失败  %@", errorJson);
        }];
        
    } failure:^(id errorJson) {
        NSLog(@"获取通讯录失败 , %@", errorJson);
        
//        NSArray *array = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/addressBook", path]];
//        for (NSString *str in array) {
//            AddressBookModel *model = [[AddressBookModel alloc]initWithString:str];
//            
//        }
        
        
    }];
}
- (void)compareJsonWithArray:(id)array {
//    NSLog(@"和这个 array 比较%@", self.modelArray);
    for (NSDictionary *dic in self.modelArray) {
        NSArray *tempArray = [dic objectForKey:@"array"];
        int i = 0;
        for (AddressBookModel *model in tempArray) {
            for (NSDictionary *tempDic in array) {
                if ([[tempDic objectForKey:@"user"] isEqualToString:model.ID]) {
                    model.attentState = YES;
                }
            }
            i++;
        }
    }
}
- (void)relodaViewWithData:(id)json
{
//    if (!self.modelArray) {
        self.modelArray = [NSMutableArray arrayWithArray:json];
//    }
    
    self.wordDic = [NSMutableDictionary dictionary];
    
    // 分析数据
    NSInteger i = 0;
    for (NSDictionary *dic in json) {
        
        AddressBookModel *model = [[AddressBookModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        
        NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"realname"]];  //根据用户的真名进行排序
//        NSLog(@"用户名为 %@", str);
        [self judgeNameFormat:str andIndex:i];
        i++;
    }
//    NSLog(@"排列完的字典为%@", self.wordDic);
//        self.modelArray = [NSMutableArray array];
    [self getArrayWithDic:self.wordDic];
    [self.myTableView reloadData];
}

- (void)getArrayWithDic:(NSMutableDictionary *)dic
{
    self.modelArray = [NSMutableArray array];
    NSArray *array = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",@"I",@"J", @"K", @"L",@"M", @"N",@"O", @"P", @"Q", @"R", @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (NSString *str in array) {
        if ([dic objectForKey:str]) {
            NSArray *array = [dic objectForKey:str];
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithObject:array forKey:@"array"];
            [tempDic setObject:str forKey:@"letter"];
            [self.modelArray addObject:tempDic];
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
        
        [self.modelArray addObject:myTempDic];
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
    
    NSDictionary *dic = [self.modelArray objectAtIndex:index];
    
    AddressBookModel *model = [[AddressBookModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dic];
    
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.7]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    NSDictionary *dic = [self.modelArray objectAtIndex:section];
    NSString *str = [dic objectForKey:@"letter"];
    label.text = str;
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"array"];
    AddressBookModel *model = [array objectAtIndex:indexPath.row];
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressTableViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell cellReloadWithAddressModel:model];
    cell.editState = self.selectState;
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.modelArray objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"array"];
    
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //找到相对应的资料model, 跳到相对应的资料页面
    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"array"];
    AddressBookModel *model = [array objectAtIndex:indexPath.row];
    
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    coll.model = [[AddressBookModel alloc]init];
    coll.model = model;
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navigationController pushViewController:coll animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in self.modelArray) {
        [tempArray addObject:[dic objectForKey:@"letter"]];
    }
    return tempArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    return [self.modelArray count];
}
- (void)sendIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"array"];
    AddressBookModel *model = [array objectAtIndex:indexPath.row];
    if (model.selectState) {
        model.selectState = NO;
    } else
    {
        model.selectState = YES;
    }
}

- (void)setSelectState:(BOOL)selectState
{
    _selectState = selectState;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    label.text = @"邀请";
    label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
        label.userInteractionEnabled = YES;
    [label addGestureRecognizer:labelTap];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
}

- (void)nextController:(UITapGestureRecognizer *)tap
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in self.modelArray) {
        NSArray *temp = [dic objectForKey:@"array"];
        
        for (AddressBookModel *model in temp) {
            if (model.selectState) {
//                [array addObject:model];
                [array addObject:model.ID];
            }
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:array forKey:@"userIds"];
    [dic setObject:self.detileModel.ID forKey:@"groupId"];
    [RestfulAPIRequestTool routeName:@"postInvitationInfosURL" requestModel:dic useKeys:@[@"groupId", @"userIds"] success:^(id json) {
        NSLog(@"邀请成功  %@", json);
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"您的邀请发送成功" message: nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        al.delegate = self;
        [al show];
        
    } failure:^(id errorJson) {
        NSLog(@"邀请失败  %@", errorJson);
    }];
}

- (void)saveDataWithJson:(id)json
{
    NSMutableArray *mutable = [NSMutableArray array];
    
    
    for (NSDictionary *dic in json) {
        AddressBookModel *model = [[AddressBookModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [mutable addObject:model.ID];
        
        [model save];
    }
    NSString *str = [NSString stringWithFormat:@"%@/addressBook", path];
    [mutable writeToFile:str atomically:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDetileModel:(GroupDetileModel *)detileModel
{
    _detileModel = detileModel;
}

@end
