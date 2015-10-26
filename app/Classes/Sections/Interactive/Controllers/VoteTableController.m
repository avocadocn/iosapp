//
//  VoteTableController.m
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "RestfulAPIRequestTool.h"
#import "PollModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "Interaction.h"
#import "VoteTableController.h"
#import "VoteTableViewCell.h"
#import "VoteCellFrame.h"
#import "VoteInfoModel.h"
#import "VoteOptionsInfoModel.h"
#import "CommentsViewController.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "VoteInfoTableViewController.h"
#import "PollModel.h"
#import "UILabel+DLTimeLabel.h"
@interface VoteTableController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)Interaction *interactionModel;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)NSMutableArray *colorArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VoteTableController

static UINavigationController *_staticNavi;

+(UINavigationController *)shareNavigation{
    return _staticNavi;
}

static NSString * const ID = @"VoteTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    self.title = @"投票";
    [self createColorArray];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - 32, DLScreenWidth, DLScreenHeight + 24) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:RGBACOLOR(235, 235, 235, 1)];
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //    [self loadVoteData];
    
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:ID];
    [self loadVoteDataWithInter:[self.voteArray firstObject]];
    
}
- (void)createColorArray {
   self.colorArray = [NSMutableArray arrayWithObjects:
                                  RGBACOLOR(0, 147, 255, 1),
                                  RGBACOLOR(144, 200, 255, 1),
                                  RGBACOLOR(251, 174, 140, 1),
                                  RGBACOLOR(253, 216, 192, 1),
                                  RGBACOLOR(251, 204, 52, 1),
                                  RGBACOLOR(244, 230, 208, 1),
                                  RGBACOLOR(211, 209, 209, 1),
                                  RGBACOLOR(233, 233, 234, 1),nil];
}

-(void)viewWillAppear:(BOOL)animated{
    _staticNavi = self.navigationController;
}

-(void)loadVoteDataWithInter:(Interaction *)inter{  // 改造 model
    
    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:inter.poster[@"_id"]];
    self.voteArray = [NSMutableArray array];
    VoteInfoModel *voteInfoModel = [[VoteInfoModel alloc]init];
    voteInfoModel.name = [NSString stringWithFormat:@"%@",per.name];
    voteInfoModel.time = inter.createTime;
    voteInfoModel.voteImageURL = [[inter.photos firstObject] objectForKey:@"uri"];
    voteInfoModel.voteText = inter.theme;
    voteInfoModel.avatarURL = per.imageURL;
    voteInfoModel.interactionId = inter.interactionId;
    voteInfoModel.model = inter.poll;
    voteInfoModel.cid = inter.cid;
    voteInfoModel.companyName = per.companyName;
    voteInfoModel.voteCount = inter.members.count;

    
    voteInfoModel.options = [NSMutableArray array];
    NSNumber * num = 0;
    for (NSDictionary *dic in inter.poll.option) {
        NSArray *array = [dic objectForKey:@"voters"];
        VoteOptionsInfoModel *optionInfo2 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo2 setOptionName:[dic objectForKey:@"value"]];
        num = [NSNumber numberWithInteger:[num integerValue] + array.count];
        
        [optionInfo2 setOptionCount:[NSNumber numberWithInteger:array.count]];
        optionInfo2.interactionId = inter.ID;
        NSLog(@"%lu",(unsigned long)self.colorArray.count);
        
        self.index = arc4random_uniform((unsigned long)self.colorArray.count - 1);
        
        NSLog(@"%ld",(long)self.index);
//        随机颜色
        optionInfo2.voteInfoColor = [self.colorArray objectAtIndex:self.index];
        [self.colorArray removeObjectAtIndex:self.index];
        
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
    [f setVoteInfoModel:voteInfoModel];
    
    [self.voteArray addObject:f];  //
    
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
    
    VoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //    cell.interModel = self.interactionModel;
    [cell setVoteCellFrame:self.voteArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
-(void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGESTATE" object:nil];
}

- (void)setInteraction:(NSString *)interaction
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:interaction forKey:@"interactionId"];
    [dic setObject:self.interactionType forKey:@"interactionType"];
    
    [RestfulAPIRequestTool routeName:@"getInterDetails" requestModel:dic useKeys:@[@"interactionType", @"interactionId"] success:^(id json) {
        NSLog(@" 获得的求助详情微 %@", json);
        
        Interaction *model = [[Interaction alloc]init];
        [model setValuesForKeysWithDictionary:json];
         NSDictionary *pollDic = [json objectForKey:@"poll"];
        
        
        model.poll = [[PollModel alloc]init];
        [model.poll setValuesForKeysWithDictionary:pollDic];
        [self loadVoteDataWithInter:model];
        [self.tableView reloadData];
    } failure:^(id errorJson) {
        NSLog(@"获取求朱详情失败 %@",errorJson);
    }];
}


//}
@end
