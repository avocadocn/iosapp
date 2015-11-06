//
//  PersonalDynamicController.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "PollModel.h"
#import "CurrentActivitysShowCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "PersonalDynamicController.h"
#import "ApertureView.h"
#import "TableHeaderView.h"
#import "DynamicTableViewCell.h"
#import <Masonry.h>
#import "Interaction.h"
#import "DetailActivityShowController.h"
#import "VoteTableController.h"
#import "HelpTableViewController.h"
#import "AddressBookModel.h"

@interface PersonalDynamicController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIButton *settingBtn;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *naviView;
@end

static NSString *ID = @"CurrentActivitysShowCell";

@implementation PersonalDynamicController
// 个人动态
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeFlaseData];
    self.view.backgroundColor = RGB(234, 234, 236);
    [self builtInterface];
    
    [self requestNet];
//    [self setupNavigationBar];
    [self setupNavigationBar];
    
}

- (void)requestNet{
    
    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:self.userModel.ID];
    NSLog(@"用户名 为 %@", per.nickName);
    
    self.header = [[TableHeaderView alloc]
                   initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(250.0))
                   andImage:self.userModel.ID];
    
    self.dynamicTableView.tableHeaderView = self.header;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"0" forKey:@"requestType"];
    [dic setObject:self.userModel.ID forKey:@"userId"];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:dic useKeys:@[@"requestType", @"userId"] success:^(id json) {
        NSLog(@"请求关注用户的互动列表成功  %@", json);
        [self analyDataWithJson:json];
        
    } failure:^(id errorJson) {
        NSLog(@"请求关注用户的互动列表失败   %@", errorJson);
    }];
}

- (void)makeFlaseData
{
    self.modelArray = [NSMutableArray array];
    
    int num = arc4random()%(4 - 1) + 1;
    for (int i = 0; i < num; i++) {
        int numnum = arc4random()%(15 - 1) + 1;
        
        NSMutableDictionary *bigdic = [NSMutableDictionary dictionary];
        [bigdic setObject:[NSString stringWithFormat:@"%d", (i * 3)] forKey:@"date"];
        NSMutableArray *smarr = [NSMutableArray array];
        for (int j = 0; j < numnum; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"刚锅锅的小彤彤" forKey:@"name"];
            [smarr addObject:dic];
        }
        [bigdic setObject:smarr forKey:@"array"];
        [self.modelArray addObject:bigdic];
    }
}

- (void)builtInterface
{
    self.dynamicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.dynamicTableView.separatorColor = [UIColor clearColor];
    
    self.dynamicTableView.backgroundColor = RGB(234, 234, 236);
//    [self.dynamicTableView registerClass:[DynamicTableViewCell class] forCellReuseIdentifier:@"otherCell"];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:@"CurrentActivitysShowCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    [self.view addSubview:self.dynamicTableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 45.0;
    return 0;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(45))];
    
    [view setBackgroundColor:[UIColor colorWithWhite:.95 alpha:.9]];
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(DLMultipleWidth(60.0));
        make.width.mas_equalTo(.5);
        make.height.mas_equalTo(15.0);
    }];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(DLMultipleWidth(60.0), DLMultipleHeight(20.0), 20, 15)];
    UILabel *label = [UILabel new];
    label.centerX = lineView.centerX;
    [label setTextColor:[UIColor orangeColor]];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"23";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.centerX.mas_equalTo(lineView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
//    UILabel *smaLable = [[UILabel alloc]initWithFrame:CGRectMake(0, DLMultipleHeight(10.0), 100, 15)];
    UILabel *smaLable = [UILabel new];
    smaLable.centerX = label.centerX;
    smaLable.font = [UIFont systemFontOfSize:10];
    smaLable.textColor = [UIColor lightGrayColor];
    NSString *str = @"2015-8-15";
    smaLable.text = str;
    [view addSubview:smaLable];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(1000000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil];
    
    [smaLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.centerX.mas_equalTo(label.mas_centerX);
        make.width.mas_equalTo(rect.size.width + 5);
    }];
    
    return view;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
    [cell reloadCellWithModel:nil];
    return cell;
     */
    
    
    CurrentActivitysShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell reloadCellWithModel:inter];
//    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149 ;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{/Users/taiyang/Desktop/Simulator Screen Shot 2015年10月16日 下午2.33.26.png
//    return [self.modelArray count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
            VoteTableController *voteController = [[VoteTableController alloc]init]; /// 投票
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    
    
    
    [self.dynamicTableView reloadData];
}


-(void)setupNavigationBar{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, 64)];
    self.naviView.backgroundColor = [UIColor blackColor];
    self.naviView.alpha = .2f;
    [self.view addSubview:self.naviView];
    //添加返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(12, 30, 12, 20);
    [self.backBtn setImage:[UIImage imageNamed:@"new_navigation_back@2x"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //按钮
//    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.settingBtn.frame = CGRectMake(DLScreenWidth - 36, 34, 19, 19);
//    [self.settingBtn setImage:[UIImage imageNamed:@"new_navigation_back_helight@2x"] forState:UIControlStateHighlighted];
//    
//    [self.settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.settingBtn];
//    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.size = CGSizeMake(200, 18);
    self.titleLabel.centerX = DLScreenWidth / 2;
    self.titleLabel.y = 64 - self.titleLabel.size.height - 13;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"个人动态";
    [self.view addSubview:self.titleLabel];
}
- (void)backBtnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end

