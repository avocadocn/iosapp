//
//  VoteTableController.m
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteTableController.h"
#import "VoteTableViewCell.h"
#import "VoteCellFrame.h"
#import "VoteInfoModel.h"
#import "VoteOptionsInfoModel.h"
#import "CommentsViewController.h"

@interface VoteTableController ()
/**
 *  投票的Frames
 */
@property (nonatomic, strong) NSMutableArray *voteFrames;

@end

@implementation VoteTableController


static NSString * const ID = @"VoteTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票";
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self loadVoteData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:ID];
    
}

-(void)loadVoteData{
    if (!self.voteFrames) {
        self.voteFrames = [NSMutableArray array];
    }
    for (int i = 0; i < 10; i++) {
            VoteInfoModel *voteInfoModel = [[VoteInfoModel alloc]init];
        voteInfoModel.name = [NSString stringWithFormat:@"杨同%zd",i];
        voteInfoModel.time = @"7分钟前 来自 动梨基地";
        voteInfoModel.voteImageURL = @"DaiMeng.jpg";
        voteInfoModel.voteText = @"杨彤美么";
        voteInfoModel.avatarURL = @"1";
        voteInfoModel.voteCount = 100;
        
        VoteOptionsInfoModel *optionInfo1 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo1 setOptionName:@"美"];
        [optionInfo1 setOptionCount:50];
        
        VoteOptionsInfoModel *optionInfo2 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo2 setOptionName:@"不美"];
        [optionInfo2 setOptionCount:50];
        
        voteInfoModel.options = [NSArray arrayWithObjects:optionInfo1,optionInfo2, nil];
        VoteCellFrame *f = [[VoteCellFrame alloc]init];
        [f setVoteInfoModel:voteInfoModel];

        [self.voteFrames addObject:f];
    }
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    [cell setVoteCellFrame:self.voteFrames[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((VoteCellFrame *)self.voteFrames[indexPath.row]).cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsViewController *commentsController = [[CommentsViewController alloc]init];
    [self.navigationController pushViewController:commentsController animated:YES];
}
@end
