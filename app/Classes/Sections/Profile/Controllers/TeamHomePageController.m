//
//  TeamHomePageController.m
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TeamHomePageController.h"

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
 *  头部的imageView
 */
@property (nonatomic, strong) UIImageView *headView;


/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  设置按钮
 */
@property (nonatomic, strong) UIButton *sharedBtn;

/**
 *  导航条上的文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TeamHomePageController

static NSString * const ID = @"TeamHomePageController";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
 
    
    // 初始化界面
    [self setupUI];
    
    // 初始化导航条
    [self setupNavigationBar];
}

-(void)setupUI{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headView = [[UIImageView alloc]init];
    [self.headView setFrame:CGRectMake(0, 0, DLScreenWidth, 264)];
    [self.headView setImage:[UIImage imageNamed:@"2.jpg"]];
    [self.headView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.headView];
    
    self.tableView  = [[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), DLScreenWidth, DLScreenHeight - CGRectGetHeight(self.headView.frame))];
    [self.tableView setBackgroundColor:[UIColor yellowColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.view addSubview:self.tableView];
}


-(void)setupNavigationBar{
    
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, 64)];
    self.naviView.backgroundColor = [UIColor greenColor];
    self.naviView.alpha = 0.0;
    [self.view addSubview:self.naviView];
    //添加返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(5, 30, 25, 25);
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    
    //分享按钮
    self.sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sharedBtn.frame = CGRectMake(DLScreenWidth - 36, 34, 26, 17);
    [self.sharedBtn setImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
    [self.view addSubview:self.sharedBtn];
    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFrame:CGRectMake(30, 32, DLScreenWidth - 35 - 50, 25)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    self.titleLabel.text = @"维尼的小熊最爱吃烧烤和火锅";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    CGFloat offsetY = currentOffsetY - self.scrollY;
    
    
 
  
    self.scrollY = currentOffsetY;
    
    
// 以下为纠偏代码
    if (currentOffsetY > 200.0) {
        self.headView.y = -200;
        self.tableView.y = 64;
        self.tableView.height = DLScreenHeight - 64;
        self.naviView.alpha = 1;
        return;
    }else if (currentOffsetY < 0.0f){
        self.headView.y = 0;
        self.tableView.y = 264;
        self.tableView.height = DLScreenHeight - 264;
        self.naviView.alpha = 0;
    }
    self.headView.y -= offsetY;
    self.tableView.y -= offsetY;
    self.tableView.height += offsetY;
    self.naviView.alpha = currentOffsetY / 200.0 * 1;
}

@end
