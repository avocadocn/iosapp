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
@property (nonatomic, strong) NSMutableArray *voteArray;

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
    
    [self loadVoteData];
    
    
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:ID];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _staticNavi = self.navigationController;
}

-(void)loadVoteData{
    if (!self.voteArray) {
        self.voteArray = [NSMutableArray array];
    }
    NSArray *colorArray = [NSArray arrayWithObjects:
                           RGBACOLOR(246, 139, 67, 1),
                           RGBACOLOR(0, 174, 239, 1),
                           RGBACOLOR(1, 207, 151, 1),
                           RGBACOLOR(248, 170, 2, 1),
                           RGBACOLOR(73, 198, 216, 1),
                           RGBACOLOR(0, 160, 233, 1),nil];
    for (int i = 0; i < 10; i++) {
            VoteInfoModel *voteInfoModel = [[VoteInfoModel alloc]init];
        voteInfoModel.name = [NSString stringWithFormat:@"杨同%zd",i];
        voteInfoModel.time = @"7分钟前 来自 动梨基地";
        voteInfoModel.voteImageURL = @"DaiMeng.jpg";
        voteInfoModel.voteText = @"杨彤美么";
        voteInfoModel.avatarURL = @"1";
        voteInfoModel.voteCount = 100;
        NSInteger num = arc4random() % 100;
        VoteOptionsInfoModel *optionInfo1 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo1 setOptionName:@"美"];
        [optionInfo1 setOptionCount:num];
        [optionInfo1 setVoteInfoColor:[colorArray objectAtIndex:(arc4random()% 6)]];
        
        VoteOptionsInfoModel *optionInfo2 = [[VoteOptionsInfoModel alloc]init];
        [optionInfo2 setOptionName:@"不美"];
        [optionInfo2 setOptionCount:100 - num];
        [optionInfo2 setVoteInfoColor:[colorArray objectAtIndex:(arc4random()% 6)]];
        
        voteInfoModel.options = [NSArray arrayWithObjects:optionInfo1,optionInfo2, nil];
        VoteCellFrame *f = [[VoteCellFrame alloc]init];
        [f setVoteInfoModel:voteInfoModel];

        [self.voteArray addObject:f];  // 设置假的 color
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
    
    NSLog(@"点击cell的事件已经取消，进入评论界面可点击下方的评论按钮进入");
}
//}
@end
