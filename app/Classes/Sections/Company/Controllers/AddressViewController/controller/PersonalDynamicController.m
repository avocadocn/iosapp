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


@interface PersonalDynamicController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PersonalDynamicController
// 个人动态
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
    
}


- (void)builtInterface
{
    self.dynamicTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.dynamicTableView.separatorColor = [UIColor clearColor];
    [self.dynamicTableView setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.9]];
    
    [self.dynamicTableView registerClass:[DynamicTableViewCell class] forCellReuseIdentifier:@"otherCell"];
    
    TableHeaderView *header = [[TableHeaderView alloc]
                               initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight / (667 / 250.0))
                               andImage:[UIImage imageNamed:@"DaiMeng.jpg"]];
    self.dynamicTableView.tableHeaderView = header;
    
    [self.view addSubview:self.dynamicTableView];
}

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (DLScreenHeight / (667 / 305.0));
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
    [cell reloadCellWithModel:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
