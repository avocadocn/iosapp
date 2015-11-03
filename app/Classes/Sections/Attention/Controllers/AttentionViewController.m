//
//  AttentionViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//
#import <MJRefresh.h>
#import "PersonalDynamicController.h"
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "AttentionViewController.h"
#import "AttentionViewCell.h"
#import "ColleaguesInformationController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "AddressBookModel.h"
#import "CompanyModel.h"
#import "Concern.h"

@interface AttentionViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

static AttentionViewController *att = nil;

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtInterface];
    [self loadLocalData];
    [self requestNet];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestNet];
}
+ (AttentionViewController *)shareInsten
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        if (!att) {
            att = [[AttentionViewController alloc]init];
        }
    });
    return att;
}
- (void)loadLocalData
{
    Concern* c = [self getLocalConcerns];
    if (c) {
        [self getDetailInforFromJson:c.concernIds];
    }
}
- (void)requestNet
{
    Account *acc = [AccountTool account];
    acc.userId = acc.ID;
    // 获取关注列表
    [RestfulAPIRequestTool routeName:@"getCorcernList" requestModel:acc useKeys:@[@"userId"] success:^(id json) {
        NSLog(@"获取用户关注列表成功 %@", json);
        [self saveLocalConcerns:json];
        [self getDetailInforFromJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取用户列表失败  %@", errorJson);
    }];
}
- (void)saveLocalConcerns:(id)data
{
    if (data) {
        FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
        Account *acc = [AccountTool account];
        Concern* c=[Concern initWithPersonId:acc.ID AndConcernIds:data];
        [fmdb saveConcerns:c];
    }
}
- (Concern*)getLocalConcerns
{
    FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
    return [fmdb getConcerns];
}
- (void)getDetailInforFromJson:(id)array
{
    self.modelArray = [NSMutableArray array];
//    __block int i = 0;
    for (NSMutableDictionary *dic in array) {
        [dic setObject:[dic objectForKey:@"_id"] forKey:@"userId"];
        
//        [RestfulAPIRequestTool routeName:@"getUserInfo" requestModel:dic useKeys:@[@"userId"] success:^(id json) {
//            
//            AddressBookModel *addressModel = [[AddressBookModel alloc]init];
//            CompanyModel *companyModel = [[CompanyModel alloc]init];
//            [companyModel setValuesForKeysWithDictionary:[json objectForKey:@"company"]];
//            [addressModel setValuesForKeysWithDictionary:json];
//            [addressModel setCompany:companyModel];
//            addressModel.attentState = YES;
//            
//            [self.modelArray addObject:addressModel];
//            i++;
//            if (i == [array count]) {
//                [self.attentionTableView reloadData];
//            }
//            
//        } failure:^(id errorJson) {
//            NSLog(@"没有获取到关注的用户信息 %@", errorJson);
//        }];
#pragma mark-
#pragma per 存的太慢导致数据不能及时取出来而崩溃
        
        Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:[dic objectForKey:@"_id"]];
        [self.modelArray addObject:per];
        
    }
    [self.attentionTableView reloadData];
    
}

- (void)builtInterface{
    
    self.attentionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    self.attentionTableView.delegate = self;
    self.attentionTableView.dataSource = self;
    self.attentionTableView.separatorColor = [UIColor clearColor];
    
    [self.attentionTableView registerClass:[AttentionViewCell class] forCellReuseIdentifier:@"AttentionViewCell"];
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [gifFooter setImages:@[] forState:MJRefreshStateRefreshing];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [footer setTitle:@"" forState: MJRefreshStateIdle];
    self.attentionTableView.footer = footer;
    
    MJRefreshNormalHeader *aHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    aHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    
    self.attentionTableView.header = aHeader;
    
    [self.view addSubview:self.attentionTableView];
}

- (void)refreshAction
{
    [UIView animateWithDuration:.7 animations:^{
        
        [self.attentionTableView.footer endRefreshing];
    }];
}

- (void)headerAction
{
    [self requestNet];
    [UIView animateWithDuration:.7 animations:^{
        [self.attentionTableView.header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AttentionViewCell";
    AttentionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AttentionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Person *model = [[Person alloc]init];
    
    model = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell cellBuiltWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Person *model = [self.modelArray objectAtIndex:indexPath.row];
    
    PersonalDynamicController *fold = [[PersonalDynamicController alloc]init];
    fold.userModel = [[AddressBookModel alloc]init];
    fold.userModel.ID = model.userId;
//    fold.userModel.photo = model.imageURL;
    
    [self.navigationController pushViewController:fold animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.modelArray count];
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DLMultipleHeight(67.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
