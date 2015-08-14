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

@interface AddressViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self requestNet];
    [self builtInterFace];
}
- (void)builtInterFace
{
    self.title = @"公司通讯录";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    /*
     self.searchColleague = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, 30)];
     self.searchColleague.layer.borderWidth = 2;
     
     
     //    self.searchColleague.backgroundColor = [UIColor clearColor];
     NSLog(@"子视图有%@", [self.searchColleague subviews]);
     [[self.searchColleague.subviews objectAtIndex:0] removeFromSuperview];
     
     self.searchColleague.delegate = self;
     
     //[self.searchColleague setBackgroundColor:[UIColor greenColor]];
     [self.view addSubview:self.searchColleague];
     */
    
    self.addressSearch = [[EMSearchBar alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, 40)];
    
    self.addressSearch.placeholder = @"Search";  [self.addressSearch placeholder];
    self.addressSearch.layer.borderWidth = 5;
    self.addressSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addressSearch.backgroundColor = DLSBackgroundColor;
    [self.view addSubview:self.addressSearch];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, DLScreenWidth, DLScreenHeight - 64 - 30) style:UITableViewStylePlain];
    [self.myTableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"addressTableViewCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    [self.view addSubview:self.myTableView];
    
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

- (void)requestNet
{
    AddressBookModel *model = [[AddressBookModel alloc]init];
    
    [model setCompanyId:@"53aa6fc011fd597b3e1be250"];
    
    [RestfulAPIRequestTool routeName:@"getCompanyAddressBook" requestModel:model useKeys:@[@"companyId"] success:^(id json) {
        NSLog(@"获取数据成功, 获取到的数据为: %@", json);
        
        [self relodaViewWithData:json];
        
    } failure:^(id errorJson) {
        NSLog(@"获取数据失败, 失败原因为: %@", errorJson);
    }];
}

- (void)relodaViewWithData:(id)json
{
    if (!self.modelArray) {
        self.modelArray = [NSMutableArray array];
    }
    // 分析数据
    NSInteger i = 0;
    for (NSDictionary *dic in json) {
        NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"realname"]];  //根据用户的真名进行排序
        [self judgeNameFormat:str andIndex:i];
        i++;
    }
    NSLog(@"排列完的字典为%@", self.wordDic);
}

//  index 为 字符串所在字典 在数组中的下标
- (void)judgeNameFormat:(NSString *)str andIndex:(NSInteger)index
{
    unichar uc = [str characterAtIndex: 0];
    NSLog(@"%hu", uc);
    //    uc 在 ascii 码表中的位置
    // 大写                            小写
    if ((uc >= 65 && uc <=90) || (uc >= 97 && uc <= 122) ) { //英文
        NSLog(@"这个字符为英文");
        [self orderWordWithString:uc andIndex:index];
    } else if (uc >= 48 && uc <= 57){
        NSLog(@"这个字符为数字");
        [self orderWordWithString:uc andIndex:index];
    }
    else if (uc >= 33 && uc <= 255)
    {
        NSLog(@"这个字符为标点符");  //  标点符号取消
    } else
    {
        NSString *newStr = [ChineseToPinyin pinyinFromChineseString:str];
        NSLog(@"这个字符为, 转化为拼音为 %@", newStr);
        if ([newStr integerValue]) {
            NSLog(@"这是特殊字符%@", str);
        }
        else {
            [self judgeNameFormat:newStr andIndex:index];
        }
    }
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
    
    NSString *newStr = [NSString stringWithFormat:@"%c", str];
    
    if (![self.wordDic objectForKey:newStr]) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self.wordDic setObject:array forKey:newStr];
    } else
    {
        NSMutableArray *array = [self.wordDic objectForKey:newStr];
        [array addObject:model];
    }
    NSLog(@"%@", self.wordDic);
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.7]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressTableViewCell" forIndexPath:indexPath];
    [cell cellReloadWithAddressModel:nil];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
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
    
    //找到相对应的资料model,跳到相对应的资料页面
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navigationController pushViewController:coll animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",@"I",@"J", @"K", @"L",@"M", @"N",@"O", @"P", @"Q", @"R", @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", @"#"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    return 26;
}


@end
