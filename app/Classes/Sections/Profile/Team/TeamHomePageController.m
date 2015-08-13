//
//  TeamHomePageController.m
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TeamHomePageController.h"
#import "TeamInfomationViewController.h"

#import <UIImageView+WebCache.h>
#import "CurrentActivitysShowCell.h"
#import "OtherActivityShowCell.h"
#import "VoteTableViewCell.h"
#import "HelpTableViewCell.h"


#define headViewHeight 264

@interface TeamHomePageController ()<UITableViewDataSource,UITableViewDelegate>


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
    
    
    self.headView = [[UIView alloc]init];
    [self.headView setFrame:CGRectMake(0, 0, DLScreenWidth, 264)];
    self.tableView.tableHeaderView = self.headView;
    
    self.headImageView = [[UIImageView alloc]initWithFrame:self.headView.frame];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:@"2.jpg"]];
    
    [self.headView addSubview:self.headImageView];
    
    [self.view addSubview:self.tableView];

    
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
    [self.backBtn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //按钮
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(DLScreenWidth - 36, 34, 19, 19);
    [self.settingBtn setImage:[UIImage imageNamed:@"btn_setting_normal"] forState:UIControlStateNormal];
    
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
    [infomationController setMemberInfos:@[@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf",@"asd",@"af",@"asdf"]];
    [self.navigationController pushViewController:infomationController animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:avtivityCellID forIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290 * DLScreenWidth / 375;
}

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
