//
//  CricleDetailViewController.m
//  app
//
//  Created by 申家 on 15/9/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Account.h"
#import "AccountTool.h"
#import "CustomKeyBoard.h"
#import "RestfulAPIRequestTool.h"
#import "CriticWordView.h"
#import "CricleDetailViewController.h"
#import "ColleagueViewCell.h"
#import "CommentViewCell.h"
#import "CircleContextModel.h"
#import "CommentCardCell.h"
#import "CircleCommentModel.h"
#import "AddressBookModel.h"
#import <MJRefresh.h>


static NSString * const ID = @"VoteCommentViewCell";
static NSString *userId = nil;
static NSString *colleague = @"colleagueView";
static NSString *comment = @"VoteCommentViewCell";
static NSString *circleCardCell = @"circleCardCell";
static BOOL state;


@interface CricleDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *detileTableview;
@property (nonatomic, strong)CommentViewCell *defaultCell;
@property (nonatomic, strong)CircleContextModel *model;
@property (nonatomic, strong) CustomKeyBoard *keyBoard;

@end

@implementation CricleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    [self builtInterface];
}

- (void)builtInterface
{
    if (!userId) {
        userId = [AccountTool account].ID;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.detileTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -8, DLScreenWidth, DLScreenHeight - 35 + 8) style:UITableViewStylePlain];
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

    [self setupKeyBoard];
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
        
        [cell.commondButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommondAction:)]];
        [cell.praiseButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseAction:)]];
        
        
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

- (void)tapCommondAction:(UITapGestureRecognizer *)tap
{
    [self.keyBoard.inputView becomeFirstResponder];
    self.keyBoard.inputView.placeholder = @"说说你的想法...";
}

- (void)commond
{
    // 评论
    CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];  //上传评论数据的 model
    
    tempModel.content = self.keyBoard.inputView.text;
    
    __block CircleContextModel *model = self.model;
    state = YES;
    if (state) {  //发给用户  flase
        tempModel.targetUserId = model.poster.ID;  // 这个要改
        tempModel.contentId = model.ID;  //这个也要改
        
    } else
    {
        //        tempModel.targetUserId = tergetUserId;
        //        tempModel.contentId = contentId;
    }
    
    tempModel.kind = @"comment";
    [tempModel setIsOnlyToContent:state];
    
    [RestfulAPIRequestTool routeName:@"publisheCircleComments" requestModel:tempModel useKeys:@[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"] success:^(id json) {
        NSLog(@"评论成功 %@",json);
        self.keyBoard.inputView.text = nil;
        [self.keyBoard.inputView resignFirstResponder];
        
        CircleContextModel *cir = [[CircleContextModel alloc]initWithString:model.ID];  // 取出来的
        CircleContextModel *temp = [[CircleContextModel alloc]init];
        NSDictionary *circleComment = [json objectForKey:@"circleComment"];
        [temp setValuesForKeysWithDictionary:circleComment];
        NSDictionary *dic = [circleComment objectForKey:@"poster"];
        temp.poster = [[AddressBookModel alloc]init];
        [temp.poster setValuesForKeysWithDictionary:dic];
        if ([circleComment objectForKey:@"target"]) {
            NSDictionary *target = [circleComment objectForKey:@"target"];
            temp.target = [[AddressBookModel alloc]init];
            [temp.target setValuesForKeysWithDictionary:target];
        }
        
        
        [cir.comments addObject:temp];
        [cir save];
        [self.model.comments addObject:temp];
        [self.detileTableview reloadData];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
    
}

- (void)praiseAction:(UITapGestureRecognizer *)sender
{
    CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];
    CircleContextModel *model = self.model;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"appreciate" forKey:@"kind"];
    [dic setObject:model.poster.ID forKey:@"targetUserId"];
    [dic setObject:model.ID forKey:@"contentId"];
    [tempModel setValuesForKeysWithDictionary:dic];
    [tempModel setIsOnlyToContent:true];
    
    NSString *routeString = nil;
    CriticWordView *criView = (CriticWordView *)sender.view;
    NSArray *temp = [NSArray array];
    __block NSString *nsl = nil;
    if ([criView.criticIamge.image isEqual:[UIImage imageNamed:@"DonLike"]]) {
        routeString = @"publisheCircleComments";
        temp = @[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"];
        criView.criticIamge.image = [UIImage imageNamed:@"Like"];
        nsl = @"点赞成功";
        criView.criticText.text = [NSString stringWithFormat:@"%ld", ([criView.criticText.text integerValue] + 1)];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[userId] forKeys:@[@"_id"]];
        
        [model.commentUsers addObject:dic];
    } else
    {
        for (NSDictionary *dic in model.commentUsers) {
            if ([userId isEqualToString:[dic objectForKey:@"_id"]]) { // 如果是本人的话
                tempModel.commentId = [dic objectForKey:@"_id"];
            }
        }
        BOOL state = NO;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < model.commentUsers.count; i++) {
            
            NSDictionary *dic = [model.commentUsers objectAtIndex:i];
            if ([[dic objectForKey:@"_id"] isEqualToString:userId]) {
                state = YES;
                [tempArray addObject:dic];
                break;
            }
        }
        if (state == YES) {  // 自己点过赞
            [model.commentUsers removeObjectsInArray:tempArray];
        }
        
        criView.criticText.text = [NSString stringWithFormat:@"%ld", ([criView.criticText.text integerValue] - 1)];
        criView.criticIamge.image = [UIImage imageNamed:@"DonLike"];
        nsl = @"取消赞成功";
        routeString = @"deleteCompanyCircle";
        temp = @[@"contentId", @"commentId"];
    }
    
    [RestfulAPIRequestTool routeName:routeString requestModel:tempModel useKeys:temp success:^(id json) {
        
        NSLog(@"%@ %@", nsl, json);
//        [self.inputTextView resignFirstResponder];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
  
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 15)];
//    view.backgroundColor = [UIColor yellowColor];
////    view.backgroundColor  = RGBACOLOR(236, 236, 239, 1);
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 15)];
    
    view.backgroundColor = tableView.numberOfSections == 3 ? (section != 2 ? RGBACOLOR(236, 236, 239, 1) : [UIColor clearColor]):(section != 1 ? RGBACOLOR(236, 236, 239, 1) : [UIColor clearColor]);
    
    return view;

}

-(void)setupKeyBoard{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CustomKeyBoard" owner:self
                                               options:nil];
    CustomKeyBoard *keyBoard = nibs.firstObject;
    keyBoard.width = DLScreenWidth;
    keyBoard.x = 0;
    keyBoard.y = self.view.height - keyBoard.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commond) name:@"POSTTEXT" object:nil];
    self.keyBoard = keyBoard;
    
//    self.inputAccessoryView = self.keyBoard;
    [self.view addSubview:keyBoard];
    
}

- (void)keyBoardWasShown:(id)str
{
    NSNotification *ntf = (NSNotification *)str;
    NSDictionary *userInfo = ntf.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.keyBoard.y = keyboardF.origin.y - self.keyBoard.height ;
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate reloadData:self.index];
}

@end
