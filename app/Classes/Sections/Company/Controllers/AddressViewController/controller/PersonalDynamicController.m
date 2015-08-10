//
//  PersonalDynamicController.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PersonalDynamicController.h"
#import "ApertureView.h"
#import "TableHeaderView.h"
#import "DynamicTableViewCell.h"
#import <Masonry.h>

@interface PersonalDynamicController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PersonalDynamicController
// 个人动态
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeFlaseData];
    self.title = @"个人动态";
    [self builtInterface];
    
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
    self.dynamicTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.dynamicTableView.separatorColor = [UIColor clearColor];
    [self.dynamicTableView setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.9]];
    
    [self.dynamicTableView registerClass:[DynamicTableViewCell class] forCellReuseIdentifier:@"otherCell"];
    
        self.header = [[TableHeaderView alloc]
                                   initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(250.0))
                                   andImage:[UIImage imageNamed:@"DaiMeng.jpg"]];
    
    
    self.dynamicTableView.tableHeaderView = self.header;
    
    [self.view addSubview:self.dynamicTableView];
}
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateImg];
}


- (void)updateImg {
    CGFloat yOffset   = self.dynamicTableView.contentOffset.y + 64;
    if (yOffset < 0) {
        
        CGFloat factor = ((ABS(yOffset)+250.0)*375)/250.0;
        CGRect f = CGRectMake(-(factor-375.0)/2, 0, factor, 250.0+ABS(yOffset));
        self.header.frame = f;
        self.header.y += yOffset;
    }
}
*/
- (UIView *)tableViewHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight / (667 / 250.0))];
    UIImage *image = [UIImage imageNamed:@"DaiMeng.jpg"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, image.size.height * (view.frame.size.width / image.size.width))];
    imageView.image = image;
    
    ApertureView *aper = [[ApertureView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 12.0), DLScreenHeight / (667 / 97.0), DLScreenWidth / (375 / 100.00), DLScreenWidth / (375 / 100.00)) andImage:image withBorderColor:[UIColor whiteColor]];
    [view addSubview:aper];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(45))];
    
    [view setBackgroundColor:[UIColor colorWithWhite:.95 alpha:.9]];
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(DLMultipleWidth(60.0), 0, .5, DLMultipleHeight(20.0))];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DLMultipleHeight(305.0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
    [cell reloadCellWithModel:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.modelArray objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"array"];
    
    return [array count];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
