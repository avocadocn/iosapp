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
#import "InformationModel.h"


@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NYSegmentedControl *segment;
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSMutableArray *modelArray;

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
    
    [self reloadLocalData];
}

- (void)reloadLocalData
{
    Account *acc = [AccountTool account];
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@-notice", DLLibraryPath, acc.ID];
    NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
    NSLog(@"本地的 notice 文件为 %@", array);
    
    self.modelArray = [NSMutableArray array];
    for (NSString *str in array) {
        InformationModel *model = [[InformationModel alloc]initWithInforString:@"notice" andIDString:str];
        [self.modelArray addObject:model];
    }
    [self.tableView reloadData];
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
    view.navigationController = self.navigationController;
    [self.scrollView addSubview:view];
}
- (void)netWorkRequest {// 网路请求
    Account *account = [AccountTool account];
    getIntroModel *model = [[getIntroModel alloc] init];
    [model setUserId:account.ID];
    [model setNoticeType:@"notice"];
    [RestfulAPIRequestTool routeName:@"getPersonalInteractionList" requestModel:model useKeys:@[@"content"] success:^(id json) {
        NSLog(@"获取消息列表成功 %@",json);
        
        for (NSDictionary *dic in json) {
            InformationModel *infor = [[InformationModel alloc]init];
            [infor setValuesForKeysWithDictionary:dic];
            [infor save:@"notice"];
        }
        
    } failure:^(id errorJson) {
        NSLog(@"获取消息列表失败 %@",[errorJson objectForKey:@"msg"]);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    InformationModel *model = self.modelArray[indexPath.row];
    NSLog(@"model的 action 为 %@", model.action);
}

- (void)layoutSegmentedControl {  // 创建segment
    
    NYSegmentedControl *segment = [[NYSegmentedControl alloc] initWithItems:@[@"消息", @"互动"]];
    segment.frame = CGRectMake(10, 30, 160, 30);
    segment.titleTextColor = [UIColor blackColor];//未选中的字体也是
    
    segment.selectedTitleTextColor = [UIColor blackColor];//选中后的字体颜色
    segment.segmentIndicatorBackgroundColor = RGBACOLOR(254, 221, 71, 1);//设置选中背景颜色
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
    return self.modelArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
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
