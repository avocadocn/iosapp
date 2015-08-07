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

#import "OtherController.h"
#import "RankListController.h"

#import "VoteTableController.h"
#import "HelpTableViewController.h"

#import <LGPlusButtonsView.h>
#import <LGDrawer.h>

@interface InteractiveViewController ()<ActivitysShowViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) ActivitysShowView *asv;
@property (atomic,assign)BOOL asvHidden ;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGPoint currentPoint;
@property (nonatomic ,assign) CGPoint startPoint;
@property (nonatomic ,assign) CGRect asvFrame;

/**
 *  path菜单
 */
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsView;

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
    
    [self addLGPlusButtonsView];
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


/**
 * 添加plusButtonView
 */
-(void)addLGPlusButtonsView{
    _plusButtonsView = [[LGPlusButtonsView alloc] initWithView:self.tableView
                                               numberOfButtons:3
                                               showsPlusButton:YES
                                                 actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                        {
                            NSLog(@"%@, %@, %i", title, description, (int)index);
                        }
                                       plusButtonActionHandler:nil];
    
    [_plusButtonsView setButtonsTitles:@[@"+", @"1", @"2", @"3"] forState:UIControlStateNormal];
    
    [_plusButtonsView setDescriptionsTexts:@[@"", @"求助", @"投票", @"活动"]];
    _plusButtonsView.position = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsView.showWhenScrolling = YES;
    _plusButtonsView.appearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    _plusButtonsView.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideHorizontal;
    _plusButtonsView.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    [_plusButtonsView setButtonsTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_plusButtonsView setButtonsAdjustsImageWhenHighlighted:NO];
    
    [_plusButtonsView showAnimated:NO completionHandler:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    CGFloat shadowBlur = 3.f;
    CGFloat buttonSide = 48.f;
    CGFloat buttonsFontSize =  30.f ;
    CGFloat plusButtonFontSize = buttonsFontSize*1.5;
    
    _plusButtonsView.contentInset = UIEdgeInsetsMake(shadowBlur, shadowBlur, shadowBlur, shadowBlur);
    [_plusButtonsView setButtonsTitleFont:[UIFont boldSystemFontOfSize:buttonsFontSize]];
    
    _plusButtonsView.plusButton.titleLabel.font = [UIFont systemFontOfSize:plusButtonFontSize];
    _plusButtonsView.plusButton.titleOffset = CGPointMake(0.f, -plusButtonFontSize*0.1);
    
    UIImage *circleImageNormal = [LGDrawer drawEllipseWithImageSize:CGSizeMake(buttonSide, buttonSide)
                                                               size:CGSizeMake(buttonSide-shadowBlur*2, buttonSide-shadowBlur*2)
                                                             offset:CGPointZero
                                                             rotate:0.f
                                                    backgroundColor:nil
                                                          fillColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f]
                                                        strokeColor:nil
                                                    strokeThickness:0.f
                                                         strokeDash:nil
                                                         strokeType:LGDrawerStrokeTypeInside
                                                        shadowColor:[UIColor colorWithWhite:0.f alpha:0.5]
                                                       shadowOffset:CGPointZero
                                                         shadowBlur:shadowBlur];
    
    UIImage *circleImageHighlighted = [LGDrawer drawEllipseWithImageSize:CGSizeMake(buttonSide, buttonSide)
                                                                    size:CGSizeMake(buttonSide-shadowBlur*2, buttonSide-shadowBlur*2)
                                                                  offset:CGPointZero
                                                                  rotate:0.f
                                                         backgroundColor:nil
                                                               fillColor:[UIColor colorWithRed:0.2 green:0.7 blue:1.f alpha:1.f]
                                                             strokeColor:nil
                                                         strokeThickness:0.f
                                                              strokeDash:nil
                                                              strokeType:LGDrawerStrokeTypeInside
                                                             shadowColor:[UIColor colorWithWhite:0.f alpha:0.5]
                                                            shadowOffset:CGPointZero
                                                              shadowBlur:shadowBlur];
    
    [_plusButtonsView setButtonsImage:circleImageNormal forState:UIControlStateNormal];
    [_plusButtonsView setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted];
    [_plusButtonsView setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted|UIControlStateSelected];
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
            
            NSArray *titles = @[ @"活动", @"求助", @"投票"];
            
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
