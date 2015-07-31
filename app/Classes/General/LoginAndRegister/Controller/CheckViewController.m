//
//  CheckViewController.m
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CheckViewController.h"
#import <AFNetworking.h>
#import "CompanyModel.h"
#import "CompanyTableViewCell.h"
#import <Masonry.h>
#import "LoginMailTableViewCell.h"

@interface CheckViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFlaseData];
//    [self requestNet];
    [self builtInterface];
}
- (void)makeFlaseData
{
    self.modelArray = [NSMutableArray array];
    NSInteger num = arc4random()% 20;
    for (NSInteger i = 0; i < num; i++) {
        CompanyModel *model = [[CompanyModel alloc]init];
        model.company = @"上海动梨科技有限公司";
        model.title = @"简介";
        model.imageString = @"http://3p.pic.ttdtweb.com/online.dongting.com/imgcache/paihang/1398247929.jpg";
        [self.modelArray addObject:model];
    }
}

- (void)requestNet
{
    NSString *str = [self.mailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // reauest Net...
    [manger GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)builtInterface
{
    
//    self.companyTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = DLSBackgroundColor;
    UILabel *label = [UILabel new];
    label.text = @"为您找到的公司";
    label.textColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(250, 20));
        make.left.mas_equalTo(self.view.mas_left).offset(10);
    }];
    
    self.companyTableView = [UITableView new];
    self.companyTableView.delegate = self;
    self.companyTableView.dataSource = self;
    self.companyTableView.backgroundColor = DLSBackgroundColor;
    [self.companyTableView registerClass:[CompanyTableViewCell class] forCellReuseIdentifier:@"companyCell"];
    [self.companyTableView registerClass:[LoginMailTableViewCell class] forCellReuseIdentifier:@"loginMail"];
    self.companyTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.companyTableView];
    [self.companyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.modelArray count];
    if (!(indexPath.row == count)) {
        CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell"];
        CompanyModel *model = [self.modelArray objectAtIndex:indexPath.row];
        
        [cell setCompanyCellWithModel:model];
        return cell;
    }
     else
     {
         LoginMailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginMail"];
         [cell.skipButton addTarget:self action:@selector(skipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
     }
}
- (void)skipButtonAction:(UIButton *)sender
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
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
