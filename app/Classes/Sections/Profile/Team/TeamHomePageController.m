//
//  TeamHomePageController.m
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "HelpTableViewController.h"
#import "VoteTableController.h"
#import "DetailActivityShowController.h"
#import "Account.h"
#import "AccountTool.h"
#import "PollModel.h"
#import "UIImageView+DLGetWebImage.h"
#import "TeamHomePageController.h"
#import "TeamInfomationViewController.h"
#import "GroupDetileModel.h"
#import <UIImageView+WebCache.h>
#import "CurrentActivitysShowCell.h"
#import "OtherActivityShowCell.h"
#import "VoteTableViewCell.h"
#import "HelpTableViewCell.h"
#import "RestfulAPIRequestTool.h"
#import "TempCompany.h"
#import "CurrentActivitysShowCell.h"

static NSString *ID = @"feasfsefse";
#define headViewHeight (DLMultipleHeight(256.0))

@interface TeamHomePageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *modelArray;

//@property (nonatomic, strong)
/**
 *  记录scrollView上次偏移的Y距离
 */
@property (nonatomic, assign) CGFloat scrollY;
/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  导航栏背景
 */
@property (nonatomic, strong) UIView *naviView;

/**
 *  头部的View
 */
@property (nonatomic, strong) UIView *headView;

/**
 *  头部的imageView
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  设置按钮
 */
@property (nonatomic, strong) UIButton *settingBtn;

/**
 *  导航条上的文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TeamHomePageController

 /**
 *  活动cell
 */
static NSString * const avtivityCellID = @"avtivityCellID";
/**
 *  投票cell
 */
static NSString * const voteCellID = @"voteCellID";
/**
 *  求助cell
 */
static NSString * const helpCellID = @"helpCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestNet];

}

-(void)viewWillAppear:(BOOL)animated{
    // 初始化界面
    [self setupUI];
    
    // 初始化导航条
    [self setupNavigationBar];
}

-(void)setupUI{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView  = [[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherActivityShowCell" bundle:nil] forCellReuseIdentifier:avtivityCellID];
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:voteCellID];
    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:helpCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentActivitysShowCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.headView = [[UIView alloc]init];
    [self.headView setFrame:CGRectMake(0, 0, DLScreenWidth, headViewHeight)];
    self.tableView.tableHeaderView = self.headView;
    
    self.headImageView = [[UIImageView alloc]initWithFrame:self.headView.frame];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView dlGetRouteWebImageWithString:self.informationModel.logo placeholderImage:nil];
    
    [self.headView addSubview:self.headImageView];
    
    [self.view addSubview:self.tableView];

    
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
            helpController.model = inter;
            [self.navigationController pushViewController:helpController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)requestNet
{
    
//    getIntroModel *model = [[getIntroModel alloc]init];
//    [model setUserId:acc.ID];
//
    
    Account *acc = [AccountTool account];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"temp"];
    [dic setObject:self.informationModel.ID forKey:@"tempId"];
    [dic setObject:@2 forKey:@"requestType"];
    [dic setObject:@4 forKey:@"interactionType"];
    [dic setObject:@10 forKey:@"limit"];
    [dic setObject:acc.ID forKey:@"userId"];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:dic useKeys:@[@"interactionType", @"requestType", @"limit", @"userId", @"teamId", @"team"] success:^(id json) {
        NSLog(@"获取数据互动成功   %@", json);
        [self analyDataWithJson:json];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
////            [self loadingContacts]; // 加载通讯录信息
//        });
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

-(void)setupNavigationBar{
    
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, 64)];
    self.naviView.backgroundColor = [UIColor blackColor];
    self.naviView.alpha = 0.1f;
    [self.view addSubview:self.naviView];
    //添加返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(12, 30, 12, 20);
    [self.backBtn setImage:[UIImage imageNamed:@"new_navigation_back@2x"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //按钮
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(DLScreenWidth - 36, 34, 19, 19);
    [self.settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    
    [self.settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingBtn];
    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.size = CGSizeMake(200, 18);
    self.titleLabel.centerX = DLScreenWidth / 2;
    self.titleLabel.y = 64 - self.titleLabel.size.height - 13;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.text = @"小队主页";
//    self.titleLabel.text = self.informationModel.name;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
}



#pragma mark - 按钮监听方法
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)settingBtnClicked:(id)sender{
    TeamInfomationViewController *infomationController = [[TeamInfomationViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    // 数组为测试数据，与内容无关，至于数组的count有关，这边的count数目决定了里面用户头像的个数，界面内容会根据count的大小自动排版
    [infomationController setMemberInfos:self.informationModel.member];
    
    //主页 --> 信息
    infomationController.detilemodel = [[GroupDetileModel alloc]init];
    infomationController.detilemodel = self.informationModel;
    
    [self.navigationController pushViewController:infomationController animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:avtivityCellID forIndexPath:indexPath];
    CurrentActivitysShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell reloadCellWithModel:inter];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149 ;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

//    TempCompany *company = [[TempCompany alloc]init];
//    [company setName:@"动力哈"];
//    [company setPassword:@"asdfasd"];
//    [company setEmail:@"asdfa@qq.com"];
//    
//    [RestfulAPIRequestTool routeName:@"companyQuickRegister" requestModel:company useKeys:@[@"name",@"email",@"password"] success:^(id json) {
//        NSLog(@"%@",json);
//    } failure:^(id errorJson) {
//        NSLog(@"%@",errorJson);
//    }];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 290 * DLScreenWidth / 375;
//}
*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // NSLog(@"%f",scrollView.contentOffset.y);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat factorWidth = DLScreenWidth / headViewHeight * (headViewHeight - offsetY);
        self.headView.frame = CGRectMake(0, offsetY, DLScreenWidth, headViewHeight - offsetY);
        self.headImageView.frame = CGRectMake(-(factorWidth - DLScreenWidth) / 2, offsetY, factorWidth, headViewHeight - offsetY);
    }
   
}

@end
