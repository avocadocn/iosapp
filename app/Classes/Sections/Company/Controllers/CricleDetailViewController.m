//
//  CricleDetailViewController.m
//  app
//
//  Created by 申家 on 15/9/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CricleDetailViewController.h"
#import "ColleagueViewCell.h"
#import "CommentViewCell.h"
#import "CircleContextModel.h"
#import "CommentCardCell.h"
#import "CircleCommentModel.h"
#import "AddressBookModel.h"
#import <MJRefresh.h>


static NSString * const ID = @"VoteCommentViewCell";

static NSString *colleague = @"colleagueView";
static NSString *comment = @"VoteCommentViewCell";
static NSString *circleCardCell = @"circleCardCell";

@interface CricleDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *detileTableview;
@property (nonatomic, strong)CommentViewCell *defaultCell;
@property (nonatomic, strong)CircleContextModel *model;

@end

@implementation CricleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    [self builtInterface];
}

- (void)builtInterface
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.detileTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight - 0) style:UITableViewStylePlain];
    self.detileTableview.delegate = self;
    self.detileTableview.dataSource = self;
    [self.detileTableview registerClass:[ColleagueViewCell class] forCellReuseIdentifier:colleague];
    [self.detileTableview registerClass:[CommentCardCell class] forCellReuseIdentifier:circleCardCell];
    [self.detileTableview registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
//    self.detileTableview.separatorColor = [UIColor clearColor];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 10)];
//    view.backgroundColor = [UIColor whiteColor];
//    self.detileTableview.tableFooterView = view;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerAction:)];
//    self.detileTableview.footer = footer;
    
    

    CommentViewCell *cell = [self.detileTableview dequeueReusableCellWithIdentifier:ID];
    self.defaultCell = cell;
    [self.view addSubview:self.detileTableview];


}
- (void)footerAction:(id)sender
{
    [self.detileTableview.footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.model.commentUsers.count) {
        return 2;
    }
    
    return 3;  // 共有三个 section?
}

- (void)setTempModel:(CircleContextModel *)tempModel
{
    self.model = tempModel;
//    [self builtInterface];
    [self.detileTableview reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.model.detileView.height + 125;
    }
    
    if (indexPath.section == 1 && self.model.commentUsers.count) {
        return 64;
    }
    
    CircleContextModel *model = [[CircleContextModel alloc]init];
    model = self.model.comments[indexPath.row];
    
    CGFloat currentWidth = self.defaultCell.comment.width;
    
    CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:self.defaultCell.comment.font};
    CGSize commentLabelSize = [model.content boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    return self.defaultCell.comment.y + commentLabelSize.height + 12;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.model.commentUsers.count) {
        if (section == 2 ) { //存在点赞人数
            return [self.model.comments count];
        }
    } else
    {
        if (section == 1) {
            return [self.model.comments count];
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ColleagueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:colleague forIndexPath:indexPath];
        cell.userInterView.height = self.model.detileView.height;
        
        [cell.userInterView insertSubview:self.model.detileView atIndex:0];
        
        [cell reloadCellWithModel:self.model andIndexPath:indexPath];
        
        return cell;
    }
    if (self.model.commentUsers.count && indexPath.section == 1) {
        CommentCardCell *cell = [tableView dequeueReusableCellWithIdentifier:circleCardCell forIndexPath:indexPath];
        
        [cell reloadCellWithPhotoArray:self.model.commentUsers];
        
        return cell;
    }
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
//    CircleContextModel *model = [[CircleContextModel alloc]init];
//    AddressBookModel *poster = [[AddressBookModel alloc]init];
    CircleContextModel *temp = [self.model.comments objectAtIndex:indexPath.row];
//    NSDictionary *posterDic = temp.poster;
//    [poster setValuesForKeysWithDictionary:posterDic];
//    [model setValuesForKeysWithDictionary:[self.model.comments objectAtIndex:indexPath.row]];
//    [model setPoster:poster];

    [cell setCommentModel:temp];
    
    return cell;
    
    
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 15)];
    view.backgroundColor = [UIColor yellowColor];
//    view.backgroundColor  = RGBACOLOR(236, 236, 239, 1);
    return view;
}


@end
