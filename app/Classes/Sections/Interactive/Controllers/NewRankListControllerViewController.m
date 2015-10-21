//
//  NewRankListControllerViewController.m
//  app
//
//  Created by tom on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "NewRankListControllerViewController.h"
#import "AccountTool.h"
#import "Account.h"
#import "RestfulAPIRequestTool.h"
#import <DGActivityIndicatorView.h>
#import "RankDetileModel.h"
#import "GroupCardModel.h"
#import "TeamHomePageController.h"
#import "AddressBookModel.h"
#import "ColleaguesInformationController.h"
#import "FMDBSQLiteManager.h"
#import "NewRankListTableViewCell.h"

@interface NewRankListControllerViewController ()

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)NSMutableArray *manArray;
@property (nonatomic, strong)NSMutableArray *womanArray;
@property (nonatomic, strong)NSMutableArray *populArray;

@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;
@end
static NSString* ID = @"NewRankListTableViewCell";
@implementation NewRankListControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self builtInterFace];
    // 设置标题栏
    [self setUpNavTitleWithRankListType:self.listType];
}
- (void)builtInterFace
{
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - 设置标题栏
-(void)setUpNavTitleWithRankListType:(NewRankListType)rankListType{
    // 设置标题栏
    NSString *title;
    switch (rankListType) {
        case NewRankListTypeMenGod:
            title = @"男神榜";
            if (!self.manArray) {
                [self requestNetWithType:NewRankListTypeMenGod];
            } else
            {
                [self loadWithArray:self.manArray];
            }
            break;
        case NewRankListTypeWomenGod:
            title = @"女神榜";
            if (!self.womanArray) {
                [self requestNetWithType:NewRankListTypeWomenGod];
            } else
            {
                [self loadWithArray:self.womanArray];
            }
            break;
        case NewRankListTypePopularity:
            title = @"社团榜";
            if (!self.populArray) {
                [self requestNetWithType:NewRankListTypePopularity];
            }else
            {
                [self loadWithArray:self.populArray];
            }
            break;
            
        default:
            break;
    }
    self.title = title;
}
- (void)loadWithArray:(NSArray *)array
{
    self.modelArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

- (void)requestNetWithType:(NewRankListType)num
{
    Account *acc = [AccountTool account];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"page"];
    [dic setObject:@20 forKey:@"limit"];
    if (self.activityIndicatorView) {
        
        [self.activityIndicatorView removeFromSuperview];
    }
    [self loadingImageView];
    if (num!=NewRankListTypePopularity) {
        [dic setObject:acc.cid forKey:@"cid"];
        [dic setObject:[NSNumber numberWithInteger:num] forKey:@"type"];
        [RestfulAPIRequestTool routeName:@"getCompaniesFavoriteRank" requestModel:dic useKeys:@[@"cid", @"type", @"page", @"limit",@"vote"] success:^(id json) {
            NSLog(@"获取排行榜成功  %@", json);
            [self.activityIndicatorView removeFromSuperview];
            [self reloadRankDataWithJson:json AndType:num == NewRankListTypeMenGod?NewRankListTypeMenGod:NewRankListTypeWomenGod];
            
        } failure:^(id errorJson) {
            NSLog(@"获取排行榜失败  %@", errorJson);
            [self.activityIndicatorView removeFromSuperview];
        }];
    }else{
        [RestfulAPIRequestTool routeName:@"getTeamsFavoriteRank" requestModel:dic useKeys:@[@"page", @"limit",@"vote"] success:^(id json) {
            NSLog(@"获取排行榜成功  %@", json);
            [self.activityIndicatorView removeFromSuperview];
            [self reloadRankDataWithJson:json AndType:NewRankListTypePopularity];
            
        } failure:^(id errorJson) {
            NSLog(@"获取排行榜失败  %@", errorJson);
            [self.activityIndicatorView removeFromSuperview];
        }];
    }
}

- (void)reloadRankDataWithJson:(id)json AndType:(NewRankListType)type
{
    self.modelArray = [NSMutableArray array];
    NSArray *ranking;
    if (type==NewRankListTypeMenGod||type==NewRankListTypeWomenGod) {
        ranking = [json objectForKey:@"ranking"];
    }else if(type==NewRankListTypePopularity){
        ranking = json;
    }
    NSInteger i = 0;
    for (NSDictionary *dic  in ranking) {
        RankDetileModel *model = [[RankDetileModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        if (type!=NewRankListTypePopularity) {
            [model setLogo:[dic objectForKey:@"photo"]];
            [model setName:[dic objectForKey:@"nickname"]];
        }
        [model setIndex:[NSString stringWithFormat:@"%ld", i + 1]];
        [model setType:type];
        
        [self.modelArray addObject:model];
        i++;
    }
    [self.tableView reloadData];
}

//加载Loading动画
- (void)loadingImageView {
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeFiveDots tintColor:[UIColor yellowColor] size:40.0f];
    //修正错误的坐标
    activityIndicatorView.frame = CGRectMake(DLScreenWidth / 2.0 - 40, DLScreenHeight / 2.0 - 40, 80.0f, 80.0f);
    activityIndicatorView.backgroundColor = RGBACOLOR(214, 214, 214, 0.5);
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView.layer setMasksToBounds:YES];
    [activityIndicatorView.layer setCornerRadius:10.0];
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
}

#pragma mark - tableView 代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RankDetileModel *model = [self.modelArray objectAtIndex:indexPath.row];
    if (self.listType == NewRankListTypePopularity) {
        //跳转到群组详情
        [self jumpToTeamWithID:model.ID];
    }else{
        //跳转到个人详情
        [self jumpToPeopleWithID:model.ID];
    }
}

- (void)jumpToTeamWithID:(NSString*)groupId
{
    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getGroupInfor" requestModel:[NSDictionary dictionaryWithObjects:@[groupId]  forKeys:@[@"groupId"]] useKeys:@[@"groupId"] success:^(id json) {
        [self.activityIndicatorView removeFromSuperview];
        GroupCardModel *model = [GroupCardModel new];
        NSDictionary* d = [json objectForKey:@"group"];
        [model setName:[d objectForKey:@"name"]];
        [model setLogo:[d objectForKey:@"logo"]];
        [model setGroupId:[d objectForKey:@"_id"]];
        [model setAllInfo:YES];
        TeamHomePageController *groupDetile = [[TeamHomePageController alloc]init];
        groupDetile.groupCardModel = model;
        [self.navigationController pushViewController:groupDetile animated:YES];
    } failure:^(id errorJson) {
        [self.activityIndicatorView removeFromSuperview];
    }];
    
    
}
- (void)jumpToPeopleWithID:(NSString*)peopleId
{
    FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
    Boolean attentState = [fmdb containConcernWithId:peopleId];
    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getUserInfo" requestModel:[NSDictionary dictionaryWithObjects:@[peopleId]  forKeys:@[@"userId"]] useKeys:@[@"userId"] success:^(id json) {
        [self.activityIndicatorView removeFromSuperview];
        AddressBookModel* model = [AddressBookModel new];
        [model setValuesForKeysWithDictionary:json];
        [model setAttentState:attentState];
        ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
        coll.model = [[AddressBookModel alloc]init];
        coll.model = model;
        coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.navigationController pushViewController:coll animated:YES];
    } failure:^(id errorJson) {
        [self.activityIndicatorView removeFromSuperview];
    }];
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

@end
