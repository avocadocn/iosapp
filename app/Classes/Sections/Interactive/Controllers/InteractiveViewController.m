//
//  InteractiveViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//  主页面
#import "getIntroModel.h"
#import "InteractiveViewController.h"
#import "ActivitysShowView.h"
#import "ActivityShowTableController.h"
#import "TemplateActivityShowTableController.h"
#import "TemplateVoteTableViewController.h"
#import "TemplateHelpTableViewController.h"
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
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "Interaction.h"
#import "DetailActivityShowController.h"
#import "PollModel.h"
#import "LoginViewController.h"
#import "Singletons.h"

enum InteractionType{
    InteractionTypeActivityTemplate,
    InteractionTypeVoteTemplate,
    InteractionTypeHelpTemplate
};

@interface InteractiveViewController ()<ActivitysShowViewDelegate,UITableViewDataSource,UITableViewDelegate,DCPathButtonDelegate, DWBubbleMenuViewDelegate, UIAlertViewDelegate>

@property (nonatomic ,strong) ActivitysShowView *asv;
@property (atomic,assign)BOOL asvHidden ;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGPoint currentPoint;
@property (nonatomic ,assign) CGPoint startPoint;
@property (nonatomic ,assign) CGRect asvFrame;
@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;
@property (nonatomic, strong) UIView *coriusView;
@property (nonatomic, strong)UIImageView *coriusImage;
@property (nonatomic, strong)NSMutableArray *modelArray;


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
    [self requestNet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshData:) name:@"KPOSTNAME" object:nil];
}

- (void)reFreshData:(NSNotification *)notice {
    NSLog(@"%@",notice.userInfo);
    Account *acc= [AccountTool account];
    
    getIntroModel *model = [[getIntroModel alloc]init];
    [model setUserId:acc.ID];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:model useKeys:@[@"interactionType", @"requestType", @"createTime", @"limit", @"userId"] success:^(id json) {
        NSLog(@"获取成功   %@", json);
        [self analyDataWithJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        
        NSString *str = [errorJson objectForKey:@"msg"];
        if ([str isEqualToString:@"您没有登录或者登录超时，请重新登录"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"身份信息过期" message:@"您没有登录或者登录超时，请重新登录" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
            
        }
        
    }];
    [self.tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    // 弹出式菜单
//    [self setupPathButton];
    [self builtInterface];
    
}
- (void)sendBool:(BOOL)state
{
    if (state == YES){
        NSLog(@"出现");
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:view];
        [self.view bringSubviewToFront:self.upMenuView];
        view.tag = 1999;
        [UIView animateWithDuration:.1 animations:^{
            view.backgroundColor = RGBACOLOR(0, 0, 0, .6);
            self.coriusImage.image = [UIImage imageNamed:@"mistakeo"];
            self.coriusView.backgroundColor = [UIColor whiteColor];
            
            self.coriusImage.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else
    {
        NSLog(@"收起");
        UIView *view = (UIView *)[self.view viewWithTag:1999];
        [UIView animateWithDuration:.1 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            self.coriusView.backgroundColor = RGBACOLOR(253, 185, 0, 1);
            self.coriusImage.image = [UIImage imageNamed:@"mistake"];
                self.coriusImage.transform = CGAffineTransformMakeRotation(M_PI_2 / 2);
        }];
    }
}
- (void)builtInterface
{
    UILabel *homeLabel = [self createHomeButtonView];
    if (!self.upMenuView) {
        
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
}
- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, DLMultipleWidth(96.0), DLMultipleWidth(48.0))];
    
    UILabel * myLabel = [UILabel new];
    myLabel.textAlignment = NSTextAlignmentRight;
    myLabel.textColor = [UIColor whiteColor];
    [label addSubview:myLabel];
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_top);
        make.left.mas_equalTo(label.mas_left);
        make.right.mas_equalTo(label.mas_right).offset(-label.frame.size.height);
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    
    self.coriusView = [UIView new];
    
    self.coriusView.backgroundColor = RGBACOLOR(253, 185, 0, 1);
    self.coriusView.layer.masksToBounds = YES;
    self.coriusView.layer.cornerRadius = label.frame.size.height / 2.0;
    
    [label addSubview:self.coriusView];
    [self.coriusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_top);
        make.left.mas_equalTo(myLabel.mas_right);
        make.right.mas_equalTo(label.mas_right);
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    
    self.coriusImage = [UIImageView new];
    self.coriusImage.image = [UIImage imageNamed:@"mistake"];
    [self.coriusView addSubview:self.coriusImage];
    
    [self.coriusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.coriusView.mas_centerX);
        make.centerY.mas_equalTo(self.coriusView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(27.0), DLMultipleWidth(27.0)));
    }];
    self.coriusImage.transform = CGAffineTransformMakeRotation(M_PI_2 / 2);
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    NSArray *array = @[[UIImage imageNamed:@"huodongs"], [UIImage imageNamed:@"toupiaos"], [UIImage imageNamed:@"qiuzhus"]];
    for (NSString *title in @[@"活动  ", @"投票  ", @"求助  "]) {
        CustomButton *button = [[CustomButton alloc]initWithFrame:CGRectMake(0.f, 0.f, DLMultipleWidth(96.0), DLMultipleWidth(48.0))];
        
        [button reloarWithString:title andImage:[array objectAtIndex:i]];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testTapAction:)];
        [button.coriusImage addGestureRecognizer:tap];
        button.coriusImage.tag = ++i;
        
        button.tag = i;
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}


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
                if (idx == InteractionTypeActivityTemplate) {
                    TemplateActivityShowTableController *tableViewController = [[TemplateActivityShowTableController alloc] init];
                    tableViewController.title = title;
                    [viewControllers addObject:tableViewController];
                }else if(idx == InteractionTypeVoteTemplate){
                    TemplateVoteTableViewController *tableViewController = [[TemplateVoteTableViewController alloc] init];
                    tableViewController.title = title;
                    [viewControllers addObject:tableViewController];
                }else if (idx == InteractionTypeHelpTemplate) {
                    TemplateHelpTableViewController *tableViewController = [[TemplateHelpTableViewController alloc] init];
                    tableViewController.title = title;
                    [viewControllers addObject:tableViewController];
                }
                
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
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
            DetailActivityShowController * activityController = [[DetailActivityShowController alloc]init];
            activityController.orTrue = YES;
            activityController.model = inter;
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
            [self.navigationController pushViewController:helpController animated:YES];
            
            break;
        }
        default:
            break;
    }
}

- (void)requestNet
{
    Account *acc= [AccountTool account];
    
    getIntroModel *model = [[getIntroModel alloc]init];
    [model setUserId:acc.ID];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:model useKeys:@[@"interactionType", @"requestType", @"createTime", @"limit", @"userId"] success:^(id json) {
        NSLog(@"获取成功   %@", json);
        [self analyDataWithJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        
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
    self.modelArray = [NSMutableArray array];
    
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
}
- (void)testTapAction:(UITapGestureRecognizer *)sender {
    
    [self.upMenuView dismissButtons];
    switch (sender.view.tag) {
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

- (void)test:(UIButton *)sender {
    [self.upMenuView dismissButtons];
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
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

@end
