//
//  OtherController.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "OtherController.h"
#import "OtherSegmentButton.h"

#import "OtherActivityShowCell.h"

@interface OtherController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableView;
@end

@implementation OtherController

static NSString * const ID = @"OtherActivityShowCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"其他活动";
    [self.view setBackgroundColor:RGB(235, 235, 235)];
    
    // 添加标签视图
    [self addSegmentBtn];
    
    // 添加活动展示table
    [self addActivitysShowTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addSegmentBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 74, DLScreenWidth, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    OtherSegmentButton *btn = [OtherSegmentButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"%f--%f",btn.centerY,view.centerY);
    btn.y += (view.height - btn.height) / 2.0;
    btn.x += 8.0f;
    [btn setName:@"热门活动"];
    
    // NSLog(@"%@",NSStringFromCGRect(btn.frame));
    [view addSubview:btn];
    [self.view addSubview:view];
}

-(void)addActivitysShowTable{
    
    
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[OtherActivityShowCell class] forCellReuseIdentifier:ID];
    // 设置分割线样式
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView setFrame:CGRectMake(0 , 99, DLScreenWidth, DLScreenHeight - 99)];
    [tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    //    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
    //        NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    //        make.right.equalTo(self.tableView.mas_right);
    //    }];
    // NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
    // Configure the cell...
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    OtherActivityShowCell *cell = (OtherActivityShowCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"%@",cell.subviews[0]);
}


@end
