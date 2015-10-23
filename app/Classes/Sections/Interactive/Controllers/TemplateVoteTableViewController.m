//
//  TemplateVoteTableViewController.m
//  app
//
//  Created by tom on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TemplateVoteTableViewController.h"
#import "PollModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "Interaction.h"
#import "VoteTableViewCell.h"
#import "VoteCellFrame.h"
#import "VoteInfoModel.h"
#import "VoteOptionsInfoModel.h"
#import "CommentsViewController.h"
#import "getTemplateModel.h"
#import "RestfulAPIRequestTool.h"
#import "TemplateVoteTableViewCell.h"
#import <MJRefresh.h>
#import <DGActivityIndicatorView.h>

@interface TemplateVoteTableViewController ()

@end

@implementation TemplateVoteTableViewController

static UINavigationController *_staticNavi;
static NSInteger pageLimit = 10;

+(UINavigationController *)shareNavigation{
    return _staticNavi;
}

static NSString * const ID = @"TemplateVoteTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voteArray = [NSMutableArray array];
    self.voteData = [NSMutableArray new];
    
    self.title = @"投票";
//    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    self.tableView.height -=44 ;
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.footer = footer;
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.header = header;
//    [self.tableView registerClass:[TemplateVoteTableViewCell class] forCellReuseIdentifier:ID];
    
    [self requestNet];

}

//上拉加载
- (void)loadMoreData
{
    NSLog(@"load more data called");
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:2]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    Interaction* last =[self.voteData lastObject];
    [model setCreateTime:last.createTime];
    
    [self.tableView.footer beginRefreshing];
//    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
//        NSLog(@"success:-->%@",json);
        [self.tableView.footer endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
    } failure:^(id errorJson) {
//        NSLog(@"failed:-->%@",errorJson);
        [self.tableView.footer endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
    }];
}
- (void)refreshData
{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:2]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    [self.tableView.header beginRefreshing];
//    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        if ([json count]!=0) {
             self.voteData = [NSMutableArray new];
            self.voteArray= [NSMutableArray new];
             [self analyDataWithJson:json];
        }
        [self.tableView.header endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
        //        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
        [self.tableView.header endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
        //        NSLog(@"failed:-->%@",errorJson);
    }];
}
//进行网络数据获取
- (void)requestNet{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:2]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
//        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
//        NSLog(@"failed:-->%@",errorJson);
    }];
}
//解析返回的数据
- (void)analyDataWithJson:(id)json
{
    
    for (NSDictionary *dic  in json) {
        Interaction *inter = [[Interaction alloc]init];
        [inter setValuesForKeysWithDictionary:dic];
        [self.voteData addObject:inter];
        [self loadVoteDataWithInter:inter];
    }
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _staticNavi = self.navigationController;
}

-(void)loadVoteDataWithInter:(Interaction *)inter{  // 改造 model
//    self.voteArray = [NSMutableArray array];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           RGBACOLOR(246, 139, 67, 1),
                           RGBACOLOR(0, 174, 239, 1),
                           RGBACOLOR(1, 207, 151, 1),
                           RGBACOLOR(248, 170, 2, 1),
                           RGBACOLOR(73, 198, 216, 1),
                           RGBACOLOR(0, 160, 233, 1),nil];
    
    VoteInfoModel *voteInfoModel = [[VoteInfoModel alloc]init];
    voteInfoModel.name = [NSString stringWithFormat:@"Warm助手"];
    voteInfoModel.time = inter.createTime;
    voteInfoModel.voteImageURL = [[inter.photos firstObject] objectForKey:@"uri"];
    voteInfoModel.voteText = inter.theme;
    voteInfoModel.avatarURL = @"1";
    
    voteInfoModel.options = [NSMutableArray array];
    NSNumber * num = 0;
    for (NSDictionary *dic in inter.option) {
        NSArray *array = [dic objectForKey:@"voters"];
        VoteOptionsInfoModel *optionInfo2 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo2 setOptionName:[[dic objectForKey:@"value"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        num = [NSNumber numberWithInteger:[num integerValue] + array.count];
        
        [optionInfo2 setOptionCount:[NSNumber numberWithInteger:array.count]];
        optionInfo2.interactionId = inter.ID;
        optionInfo2.voteInfoColor = [colorArray objectAtIndex:arc4random() % 6];
        [voteInfoModel.options addObject:optionInfo2];
        
    }
    Account *acc = [AccountTool account];
    for (NSString *tempStr in inter.members) {
        if ([tempStr isEqualToString:acc.ID]) {
            voteInfoModel.judgeVote = YES;
        }
    }
    
    VoteCellFrame *f = [[VoteCellFrame alloc]init];
    f.voteNum = num;
    //使用模板专用的方法初始化frames
    [f setTemplateVoteInfoModel:voteInfoModel];
    
    [self.voteArray addObject:f];  // 设置假的 color
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.voteArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TemplateVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[TemplateVoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell setVoteCellFrame:self.voteArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContext:self];
    [cell setModel:[self.voteData objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((VoteCellFrame *)self.voteArray[indexPath.row]).cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CommentsViewController *commentsController = [[CommentsViewController alloc]init];
    //    [self.navigationController pushViewController:commentsController animated:YES];'
    VoteCellFrame *vote = [self.voteArray firstObject];
    
}


@end
