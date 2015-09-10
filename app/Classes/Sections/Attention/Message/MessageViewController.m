//
//  MessageViewController.m
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "RestfulAPIRequestTool.h"
#import "NYSegmentedControl.h"
#import "InteractionView.h"
#import "getIntroModel.h"
#import "Account.h"
#import "AccountTool.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NYSegmentedControl *segment;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"消息列表";
//    self.navigationController.navigationBar.translucent = NO;
    [self creatScrollView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-35, DLScreenWidth, DLScreenHeight + 35) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollView addSubview:self.tableView];
//  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageTableViewCell"];
    [self layoutSegmentedControl];
//
    [self netWorkRequest];
}
- (void)creatScrollView { // 创建scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(DLScreenWidth * 2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
//    self.scrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.scrollView];
    InteractionView *view = [[InteractionView alloc] initWithFrame:CGRectMake(DLScreenWidth, 0, DLScreenWidth, DLScreenHeight)];
    [self.scrollView addSubview:view];
}
- (void)netWorkRequest {// 网路请求
    getIntroModel *model = [[getIntroModel alloc] init];
    Account *account = [AccountTool account];
    [model setUserId:account.ID];
    [model setNoticeType:@"notice"];
    [RestfulAPIRequestTool routeName:@"getPersonalNotificationsList" requestModel:model useKeys:@[@"noticeType",@"interaction",@"interactionType",@"userId",@"action"] success:^(id json) {
        NSLog(@"获取消息列表成功 %@",json);
    } failure:^(id errorJson) {
        NSLog(@"获取消息列表失败 %@",[errorJson objectForKey:@"msg"]);
    }];
}
- (void)layoutSegmentedControl {  // 创建segment
    
    NYSegmentedControl *segment = [[NYSegmentedControl alloc] initWithItems:@[@"消息", @"互动"]];
    segment.frame = CGRectMake(10, 30, 160, 30);
    segment.titleTextColor = [UIColor blackColor];//未选中的字体也是
    
    segment.selectedTitleTextColor = [UIColor blackColor];//选中后的字体颜色
    segment.segmentIndicatorBackgroundColor = [UIColor lightTextColor];//设置选中背景颜色
    segment.backgroundColor = [UIColor whiteColor];
    segment.cornerRadius = CGRectGetHeight(segment.frame) / 2.0f;//设置圆角
    self.segment = segment;
    [segment addTarget:self action:@selector(handleSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}
- (void)handleSegment:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
            break;
        case 1:
            [self.scrollView setContentOffset:CGPointMake(DLScreenWidth, -64) animated:YES];
            break;
        default:
            break;
    }
}
#pragma scrollView delegate 
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offSet = self.scrollView.contentOffset;
    int index = offSet.x / DLScreenWidth;
    self.segment.selectedSegmentIndex = index;
}
#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"D大调";
    cell.contentLabel.text = @"快来参加活动。。。";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
