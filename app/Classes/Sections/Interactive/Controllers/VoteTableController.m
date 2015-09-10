//
//  VoteTableController.m
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
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

@interface VoteTableController ()

@end

@implementation VoteTableController

static UINavigationController *_staticNavi;

+(UINavigationController *)shareNavigation{
    return _staticNavi;
}

static NSString * const ID = @"VoteTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票";
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    [self loadVoteData];
    
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:ID];
    [self loadVoteDataWithInter:[self.voteArray firstObject]];
}

-(void)viewWillAppear:(BOOL)animated{
    _staticNavi = self.navigationController;
}

-(void)loadVoteDataWithInter:(Interaction *)inter{  // 改造 model
    self.voteArray = [NSMutableArray array];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           RGBACOLOR(246, 139, 67, 1),
                           RGBACOLOR(0, 174, 239, 1),
                           RGBACOLOR(1, 207, 151, 1),
                           RGBACOLOR(248, 170, 2, 1),
                           RGBACOLOR(73, 198, 216, 1),
                           RGBACOLOR(0, 160, 233, 1),nil];
    
    VoteInfoModel *voteInfoModel = [[VoteInfoModel alloc]init];
    voteInfoModel.name = [NSString stringWithFormat:@"桃地再不斩"];
    voteInfoModel.time = inter.createTime;
    voteInfoModel.voteImageURL = [[inter.photo firstObject] objectForKey:@"uri"];
    voteInfoModel.voteText = inter.theme;
    voteInfoModel.avatarURL = @"1";
    
    voteInfoModel.options = [NSMutableArray array];
    NSNumber * num = 0;
    for (NSDictionary *dic in inter.poll.option) {
        NSArray *array = [dic objectForKey:@"voters"];
        VoteOptionsInfoModel *optionInfo2 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo2 setOptionName:[dic objectForKey:@"value"]];
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
    [f setVoteInfoModel:voteInfoModel];
    
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
    
    VoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
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
//}
@end
