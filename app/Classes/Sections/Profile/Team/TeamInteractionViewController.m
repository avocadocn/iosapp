//
//  TeamInteractionViewController.m
//  app
//
//  Created by tom on 15/10/13.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "TeamInteractionViewController.h"
#import "CurrentActivitysShowCell.h"
#import "Interaction.h"
#import "Account.h"
#import "AccountTool.h"
#import "getIntroModel.h"
#import "RestfulAPIRequestTool.h"
#import "GiFHUD.h"
#import "PollModel.h"
#import "DetailActivityShowController.h"
#import "VoteTableController.h"
#import "HelpTableViewController.h"
#import <MJRefresh.h>
#import "GroupCardModel.h"
#import "DetailActivityShowView.h"
@interface TeamInteractionViewController ()
@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong) NSIndexPath *index;
@end

@implementation TeamInteractionViewController
static NSString * const ID = @"CurrentActivitysShowCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArray = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentActivitysShowCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.footer = footer;
    [self builtUI];
    [self requestNet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDate) name:@"POSTEXIT" object:nil];
    
}
//上拉加载
- (void)loadMoreData
{
    NSLog(@"load more data called");
    Account *acc= [AccountTool account];
    getIntroModel *model = [[getIntroModel alloc]init];
    [model setUserId:acc.ID];
    [model setLimit:@10];
    [model setRequestType:@1];
    if (self.requestType) {
        [model setRequestType:self.requestType];
    }
    [model setTeam:@"1"];
    if (self.team) {
        [model setTeam:self.team];
    }
    [model setTeamId:self.groupCardModel.groupId];
    Interaction* last =[self.modelArray lastObject];
    [model setCreateTime:last.createTime];
    switch (self.type) {
        case TeamInteractionActivity:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionActivity]];
            break;
        case TeamInteractionVote:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionVote]];
            break;
        case TeamInteractionHelp:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionHelp]];
            break;
        default:
            break;
    }
    [self.tableView.footer beginRefreshing];
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:model useKeys:@[@"interactionType", @"requestType", @"createTime",@"limit", @"userId"] success:^(id json) {
        NSLog(@"获取成功   %@", json);
        if ([json count]!=0) {
            [self analyDataWithJson:json];
        }
        
        [self.tableView.footer endRefreshing];
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        
        [self.tableView.footer endRefreshing];
        NSString *str = [errorJson objectForKey:@"msg"];
        if ([str isEqualToString:@"您没有登录或者登录超时，请重新登录"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"身份信息过期" message:@"您没有登录或者登录超时，请重新登录" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
            
        }
        
    }];
}
- (void)refreshData
{
    Account *acc= [AccountTool account];
    
    getIntroModel *model = [[getIntroModel alloc]init];
    [model setUserId:acc.ID];
    [model setLimit:@10];
    [model setRequestType:@1];
    [model setTeam:@"1"];
    [model setTeamId:self.groupCardModel.groupId];
    switch (self.type) {
        case TeamInteractionActivity:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionActivity]];
            break;
        case TeamInteractionVote:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionVote]];
            break;
        case TeamInteractionHelp:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionHelp]];
            break;
        default:
            break;
    }
    if (self.requestType) {
        [model setRequestType:self.requestType];
    }
    if (self.team) {
        [model setTeam:self.team];
    }

    [self.tableView.header beginRefreshing];
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:model useKeys:@[@"interactionType", @"requestType", @"limit", @"userId"] success:^(id json) {
        NSLog(@"获取成功   %@", json);
        if ([json count]!=0) {
            self.modelArray = [NSMutableArray new];
            [self analyDataWithJson:json];
        }
        [self.tableView.header endRefreshing];
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        [self.tableView.header endRefreshing];
        NSString *str = [errorJson objectForKey:@"msg"];
        if ([str isEqualToString:@"您没有登录或者登录超时，请重新登录"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"身份信息过期" message:@"您没有登录或者登录超时，请重新登录" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrentActivitysShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell reloadCellWithModel:inter];
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149 ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    switch ([inter.type integerValue]) {
        case 1:{  // 活动详情
            DetailActivityShowController * activityController = [[DetailActivityShowController alloc] init];
            activityController.quitState = YES;
            activityController.orTrue = YES;
            activityController.model = inter;
            self.index = indexPath;
            [self.navigationController pushViewController:activityController animated:YES];
            break;
        }
        case 2:{  // 投票详情
            VoteTableController *voteController = [[VoteTableController alloc]init];  /// 投票
            voteController.voteArray = [NSMutableArray array];
            [voteController.voteArray addObject:inter];
            [self.navigationController pushViewController:voteController animated:YES];
            
            break;
        }
        case 3:  // 求助详情
        {
            HelpTableViewController *helpController = [[HelpTableViewController alloc]init];  // 求助
            helpController.model = inter;
            [self.navigationController pushViewController:helpController animated:YES];
            break;
        }
        default:
            break;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)builtUI
{
    switch (self.type) {
        case TeamInteractionActivity:
            self.title=@"活动";
            break;
        case TeamInteractionVote:
            self.title=@"投票";
            break;
        case TeamInteractionHelp:
            self.title=@"求助";
            break;
        default:
            break;
    }
}
- (void)requestNet
{
    Account *acc= [AccountTool account];
    
    getIntroModel *model = [[getIntroModel alloc]init];
    [model setUserId:acc.ID];
    [model setLimit:@10];
    [model setRequestType:@1];
    [model setTeam:@"1"];
    [model setTeamId:self.groupCardModel.groupId];
    if (self.requestType) {
        [model setRequestType:self.requestType];
    }
    [model setTeam:@"1"];
    if (self.team) {
        [model setTeam:self.team];
    }
    switch (self.type) {
        case TeamInteractionActivity:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionActivity]];
            break;
        case TeamInteractionVote:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionVote]];
            break;
        case TeamInteractionHelp:
            [model setInteractionType:[NSNumber numberWithInt:TeamInteractionHelp]];
            break;
        default:
            break;
    }
    NSLog(@"请求的类型为 %@", model.interactionType);
    [GiFHUD show];
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:model useKeys:@[@"interactionType", @"requestType", @"limit", @"userId"] success:^(id json) {
        NSLog(@"获取成功   %@", json);
        [self analyDataWithJson:json];
        [GiFHUD dismiss];
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        [GiFHUD dismiss];
        NSString *str = [errorJson objectForKey:@"msg"];
        if ([str isEqualToString:@"您没有登录或者登录超时，请重新登录"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"身份信息过期" message:@"您没有登录或者登录超时，请重新登录" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
            
        }
        
    }];
}
- (void)analyDataWithJson:(id)json
{
    for (NSDictionary *dic  in json) {
        Interaction *inter = [[Interaction alloc]init];
        [inter setValuesForKeysWithDictionary:dic];
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if ([str isEqualToString:[NSString stringWithFormat:@"%d", 2]])  //只有投票
        {
            PollModel *poll = [[PollModel alloc]init];
            [poll setValuesForKeysWithDictionary:[dic objectForKey:@"poll"]];
            [inter setPoll:poll];
        }
        
        [self.modelArray addObject:inter];
    }
    [self.tableView reloadData];
    //    [self.modelArray writeToFile:[self.path stringByAppendingPathComponent:@"modelArray"]atomically:YES];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    if (self.tableView) {
//        [self refreshData];
//    }
//}
- (void) deleteDate {
    [self.modelArray removeObjectAtIndex:self.index.row];
    [self.tableView reloadData];
}
@end
