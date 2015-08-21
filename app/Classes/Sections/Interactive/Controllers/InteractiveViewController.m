//
//  InteractiveViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//  主页面

#import "InteractiveViewController.h"
#import "ActivitysShowView.h"
#import "ActivityShowTableController.h"
#import "CurrentActivitysShowCell.h"
#import "ActivityShowTableController.h"
#import "DWBubbleMenuButton.h"
#import "OtherController.h"
#import "RankListController.h"
#import "CustomButton.h"
#import "VoteTableController.h"
#import "HelpTableViewController.h"
#import <DCPathButton.h>
#import <Masonry.h>
#import "LaunchEventController.h"
#import "PublishVoteController.h"
#import "PublishSeekHelp.h"

@interface InteractiveViewController ()<ActivitysShowViewDelegate,UITableViewDataSource,UITableViewDelegate,DCPathButtonDelegate, DWBubbleMenuViewDelegate>

@property (nonatomic ,strong) ActivitysShowView *asv;
@property (atomic,assign)BOOL asvHidden ;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGPoint currentPoint;
@property (nonatomic ,assign) CGPoint startPoint;
@property (nonatomic ,assign) CGRect asvFrame;
@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;
/**
 *  path菜单
 */
@property (strong, nonatomic) DCPathButton *plusButton;

@end

@implementation InteractiveViewController

static NSString * const ID = @"CurrentActivitysShowCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置背景颜色
    [self.view setBackgroundColor:RGB(235, 235, 235)];
    
    // 上方活动展示view
    [self setupActivitysShowView];
    
  //  NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
    
    // 活动展示table
    [self setupActivityShowTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    // 弹出式菜单
//    [self setupPathButton];
    [self builtInterface];
    
}
- (void)sendBool:(BOOL)state
{
    if (state == YES){
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:view];
        [self.view bringSubviewToFront:self.upMenuView];
        view.tag = 1999;
        [UIView animateWithDuration:.1 animations:^{
            view.backgroundColor = RGBACOLOR(0, 0, 0, .6);
        }];
    } else
    {
        UIView *view = (UIView *)[self.view viewWithTag:1999];
        [UIView animateWithDuration:.1 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}
- (void)builtInterface
{
    UILabel *homeLabel = [self createHomeButtonView];
    
    
    self.upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - homeLabel.frame.size.width - 10.f,
                                                                                          [UIScreen mainScreen].bounds.size.height
                                                                                          - homeLabel.frame.size.height - DLMultipleHeight(72.0),
                                                                                          homeLabel.frame.size.width,
                                                                                          homeLabel.frame.size.height)
                                                            expansionDirection:DirectionUp];
    self.upMenuView.homeButtonView = homeLabel;
    self.upMenuView.delegate = self;
    [self.upMenuView addButtons:[self createDemoButtonArray]];
    
    [self.view addSubview:self.upMenuView];
}
- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, DLMultipleWidth(96.0), DLMultipleWidth(48.0))];
    
    UILabel * myLabel = [UILabel new];
    myLabel.textAlignment = NSTextAlignmentRight;
    myLabel.text = @"退出";
    myLabel.textColor = [UIColor whiteColor];
    [label addSubview:myLabel];
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_top);
        make.left.mas_equalTo(label.mas_left);
        make.right.mas_equalTo(label.mas_right).offset(-label.frame.size.height);
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    
    UIImageView * coriusImage = [UIImageView new];
    
    coriusImage.backgroundColor = RGBACOLOR(253, 185, 0, 1);
    coriusImage.layer.masksToBounds = YES;
    coriusImage.layer.cornerRadius = label.frame.size.height / 2.0;
    
    [label addSubview:coriusImage];
    [coriusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_top);
        make.left.mas_equalTo(myLabel.mas_right);
        make.right.mas_equalTo(label.mas_right);
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"活动  ", @"投票  ", @"求助  "]) {
        CustomButton *button = [[CustomButton alloc]initWithFrame:CGRectMake(0.f, 0.f, DLMultipleWidth(96.0), DLMultipleWidth(48.0))];
        
        [button reloarWithString:title andImage:nil];
        
        button.tag = ++i;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            NSLog(@"活动");
            LaunchEventController *lauge = [[LaunchEventController alloc]init];
            [self.navigationController pushViewController:lauge animated:YES];
            
            break;
        }
            
        case 2:{
            PublishVoteController *vote = [[PublishVoteController alloc]init];
            [self.navigationController pushViewController:vote animated:YES];
            NSLog(@"投票");
            break;
        }
        case 3:
        {
            NSLog(@"求助");
            PublishSeekHelp *seek = [[PublishSeekHelp alloc]init];
            [self.navigationController pushViewController:seek animated:YES];
            break;
        }
        default:
            break;
    }
    
}

/*
-(void)setupPathButton{
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 itemButton_4,
                                 itemButton_5
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 100.0f;
    
   
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bottomViewColor = [UIColor grayColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
    dcPathButton.dcButtonCenter = CGPointMake(DLScreenWidth - 25,DLScreenHeight - 100);
    
    [self.view addSubview:dcPathButton];
    
}
*/

#pragma mark - pathbutton 的代理方法
-(void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex{
    NSLog(@"%zd",itemButtonIndex);
}

-(void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton{
    // self.tabBarController.tabBar.hidden = YES;
}

-(void)setupActivitysShowView{
    // 上方活动展示view
    ActivitysShowView *asv = [[ActivitysShowView alloc]init];
    asv.y += 64;
    
    // 设置代理
    [asv setDelegate:self];
    [self.view addSubview:asv];
    
    self.asv = asv;
}

-(void)setupActivityShowTableView{
    UITableView *tableView = [[UITableView alloc]init];
    //    [tableView registerClass:[CurrentActivitysShowCell class] forCellReuseIdentifier:ID];
    [tableView registerNib:[UINib nibWithNibName:@"CurrentActivitysShowCell" bundle:nil] forCellReuseIdentifier:ID];
    [tableView setFrame:self.view.frame];
    tableView.y = CGRectGetMaxY(self.asv.frame);
    tableView.height = DLScreenHeight - tableView.y - 50;
    [tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:self.view.backgroundColor];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.asvFrame = self.asv.frame;
    self.asvHidden = NO;
}






-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startPoint = scrollView.contentOffset;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // NSLog(@"%@",NSStringFromCGPoint(velocity));
    if (velocity.y > 0.0f) {
        if (self.asvHidden == NO) {
            [self hiddenASV];
            return;
        }
        
        
    }else if (velocity.y < -0.6f){
        if (self.asvHidden == YES) {
            [self showASV];
            return;
        }
        
    }
    self.currentPoint = scrollView.contentOffset;
    if (self.currentPoint.y - self.startPoint.y > 0) {
        if (self.asvHidden == NO) {
            [self hiddenASV];
        }
        return;
    }
    
    
}
/**
 *  隐藏asv
 */
-(void)hiddenASV{
    self.asvHidden = YES;

    [UIView animateWithDuration:0.2f animations:^{
        self.asv.y -= 100;
        self.tableView.y -= 100 ;
        self.tableView.height +=100;
        self.asv.alpha = 0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
//             self.navigationController.navigationBar.height = 0;
        }];
    }];
}

/**
 *  显示asv
 */
-(void)showASV{
    self.asvHidden = NO;
[UIView animateWithDuration:0.2f animations:^{
    self.asv.alpha = 1;
    self.asv.y += 100 ;
    self.tableView.y += 100 ;
    self.tableView.height -= 100 ;
    
} completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2f animations:^{
        
    }];
}];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)activitysShowView:(ActivitysShowView *)activitysShowView btnClickedByIndex:(NSInteger)index{
    switch (index) {
        case 0: // 男神
        {
            RankListController  *controller =  [[RankListController alloc]initWithRankListType:RankListTypeMenGod];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1: // 女神
        {
            RankListController  *controller =  [[RankListController alloc]initWithRankListType:RankListTypeWomenGod];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2: // 人气
        {
            RankListController  *controller =  [[RankListController alloc]initWithRankListType:RankListTypePopularity];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3: // 什么活动
        {

            OtherController *twitterPaggingViewer = [[OtherController alloc]init];
            
            
            NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
            
            NSArray *titles = @[@"活动", @"投票", @"求助"];
            
            [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
                ActivityShowTableController *tableViewController = [[ActivityShowTableController alloc] init];
                tableViewController.title = title;
                [viewControllers addObject:tableViewController];
            }];
            [titles enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
                
            }];
            twitterPaggingViewer.viewControllers = viewControllers;
            
            twitterPaggingViewer.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
              
            };

            
            [self.navigationController pushViewController:twitterPaggingViewer animated:YES];
        }
            break;
            
        
        default:
            break;
    }
}



#pragma mark - tableView的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrentActivitysShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.InteractiveTypeIcon.image = [UIImage imageNamed:@"Interactive_activity_icon"];
        cell.InteractiveTitle.text = @"活动进行中";
        cell.InteractiveText.text = @"快来捡肥皂吧";
    }else if (indexPath.row == 1){
        cell.InteractiveTypeIcon.image = [UIImage imageNamed:@"Interactive_vote_icon"];
        cell.InteractiveTitle.text = @"投票进行中";
        cell.InteractiveText.text = @"你觉得我美么";
    }else if (indexPath.row == 2){
        cell.InteractiveTypeIcon.image = [UIImage imageNamed:@"Interactive_help_icon"];
        cell.InteractiveTitle.text = @"求助进行中";
        cell.InteractiveText.text = @"刚锅锅怎么样才会爱我？";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149 ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 1) {
        VoteTableController *voteController = [[VoteTableController alloc]init];
        [self.navigationController pushViewController:voteController animated:YES];
    }else if (indexPath.row == 2){
        HelpTableViewController *helpController = [[HelpTableViewController alloc]init];
        [self.navigationController pushViewController:helpController animated:YES];
    }else if (indexPath.row == 0){
        ActivityShowTableController *activityController = [[ActivityShowTableController alloc]init];
        [self.navigationController pushViewController:activityController animated:YES];
    }
    
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
