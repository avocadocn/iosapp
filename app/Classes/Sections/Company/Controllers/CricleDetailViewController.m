//
//  CricleDetailViewController.m
//  app
//
//  Created by 申家 on 15/9/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "PhotoPlayController.h"
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
#import "ReportViewController.h"


static NSString * const ID = @"VoteCommentViewCell";
static NSString *userId = nil;
static NSString *colleague = @"colleagueView";
static NSString *comment = @"VoteCommentViewCell";
static NSString *circleCardCell = @"circleCardCell";
static BOOL state;


@interface CricleDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)UITableView *detileTableview;
@property (nonatomic, strong)CommentViewCell *defaultCell;
@property (nonatomic, strong)CircleContextModel *model;
@property (nonatomic, strong) CustomKeyBoard *keyBoard;
@property (nonatomic, assign)BOOL deleteState;
@end

@implementation CricleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    [self builtInterface];
    [self setupForDismissKeyboard];
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
    //add report
    [self addReportItem];
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
        NSArray *tempArray = [cell.userInterView subviews];
        int i = 0;

        for (UIView * tempView in tempArray) {
            NSArray *viewArray = [tempView subviews];
            for (id tempImageView in viewArray) {
                if ([tempImageView isKindOfClass:[UIImageView class]]) {
                    i++;
                    NSLog(@"有 image");
                    UIImageView *image = (UIImageView *)tempImageView;
                    image.tag = i;
                    image.userInteractionEnabled = YES;
                    [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)]];
                }
            }
        }
        Account *acc = [AccountTool account];
        
        if ([acc.ID isEqualToString:self.model.postUserId]) {
            cell.deleteButton.alpha = 1;
            [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
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
- (void)deleteAction:(UIButton *)sender
{
    NSLog(@"删除");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定删除吗?" message: nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"举报"]) {
        if (buttonIndex==1) {
            ReportViewController* r = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
            r.reportSection = ReportSectionCircle;
            r.data = [[NSDictionary alloc] initWithObjectsAndKeys:self.model.content,REPORT_TITLE,self.model.ID,REPORT_ID,nil];
            [self.navigationController pushViewController:r animated:YES];
        }
    }
    else{
        if (alertView.tag == 1) {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"取消");
                    break;
                    
                default:{
                    [self.delegate deleteIndexPath:self.index];
                    self.deleteState = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"好的");
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.model.ID forKey:@"contentId"];
                    [RestfulAPIRequestTool routeName:@"deleteCircle" requestModel:dic useKeys:@[@"contentId"] success:^(id json) {
                        NSLog(@"删除成功  %@", json);
                    } failure:^(id errorJson) {
                        NSLog(@"删除同事圈失败  %@", errorJson);
                    }];
                    
                    //                dispatch_queue_t concurrent = dispatch_queue_create("2", DISPATCH_QUEUE_SERIAL);
                    //                dispatch_async(concurrent, ^{
                    //                    NSLog(@"消失");
                    //
                    //
                    //                });
                    //                dispatch_async(concurrent, ^{
                    //                    NSLog(@"删除");
                    //                });
                }
                    break;
            }
        }
    }
}

- (void)runfor
{
    NSLog(@"删除");
}
- (void)dismiss{
    NSLog(@"消失");
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
        
//        CircleContextModel *self.model = [[CircleContextModel alloc]initWithString:model.ID];  // 取出来的
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
        if (!self.model.comments){
            self.model.comments = [NSMutableArray array];
        }
        
        [self.model.comments addObject:temp];
        
        [self.detileTableview reloadData];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
    
}

- (void)praiseAction:(UITapGestureRecognizer *)sender
{
    CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"appreciate" forKey:@"kind"];
    [dic setObject:self.model.postUserId forKey:@"targetUserId"];
    [dic setObject:self.model.ID forKey:@"contentId"];
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
        
        [self.model.commentUsers addObject:dic];
    } else
    {
        for (NSDictionary *dic in self.model.commentUsers) {
            if ([userId isEqualToString:[dic objectForKey:@"_id"]]) { // 如果是本人的话
                tempModel.commentId = [dic objectForKey:@"_id"];
            }
        }
        BOOL state = NO;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < self.model.commentUsers.count; i++) {
            
            NSDictionary *dic = [self.model.commentUsers objectAtIndex:i];
            if ([[dic objectForKey:@"_id"] isEqualToString:userId]) {
                state = YES;
                [tempArray addObject:dic];
                break;
            }
        }
        if (state == YES) {  // 自己点过赞
            [self.model.commentUsers removeObjectsInArray:tempArray];
        }
        
        criView.criticText.text = [NSString stringWithFormat:@"%ld", ([criView.criticText.text integerValue] - 1)];
        criView.criticIamge.image = [UIImage imageNamed:@"DonLike"];
        nsl = @"取消赞成功";
        routeString = @"deleteCompanyCircle";
        temp = @[@"contentId", @"commentId"];
    }
    
    [self.detileTableview reloadData];
    
    [RestfulAPIRequestTool routeName:routeString requestModel:tempModel useKeys:temp success:^(id json) {
        
        NSLog(@"点赞的结果为   %@ %@", nsl, json);
        
        //        [self.inputTextView resignFirstResponder];
        Account *acc = [AccountTool account];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:acc.ID forKey:@"_id"];
        
        
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
    [super viewWillDisappear:animated];
    if (!self.deleteState) {
        [self.model save];
        [self.delegate reloadDataWithModel:self.model andIndexPath:self.index];
    }
    
}
- (void)imageAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击");
    
    PhotoPlayController *play = [[PhotoPlayController alloc]initWithPhotoArray:self.photoArray indexOfContentOffset:tap.view.tag - 1];
    [self.navigationController pushViewController:play animated:YES];
    
}

#pragma mark - add report

- (void)addReportItem
{
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [clearButton setImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(reportDanger) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
}
- (void)reportDanger
{
    NSLog(@"report clicked");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"举报" message:@"是否举报？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}


@end
