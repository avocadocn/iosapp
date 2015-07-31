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
#import "RegisterViewController.h"
#import "CardChooseView.h"
//#import "CompanyRegisterViewController.h"
#import <ReactiveCocoa.h>
#import "DLNetworkRequest.h"
typedef NS_ENUM(NSInteger, SelectStateOfCompany){
    SelectStateOfCompanyNo,
    SelectStateOfCompanyYes
};

@interface CheckViewController ()<UITableViewDataSource, UITableViewDelegate, CardChooseViewDelegate, DLNetworkRequestDelegate>

@end

@implementation CheckViewController


- (void)requestNetWithSuffix:(NSString *)str
{
    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"email"];
    request.delegate = self;
    [request dlRouteNetWorkWithNetName:@"companySearch" andRequestType:@"POST" paramter:dic];
    
}

- (void)sendParsingWithDictionary:(NSDictionary *)dictionary
{
    if (!self.modelArray) {
        self.modelArray = [NSMutableArray array];
    }
    NSArray *array = [dictionary objectForKey:@"companies"];
    for (NSDictionary *dic in array) {
        CompanyModel *model = [[CompanyModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:model];
    }
    [self.companyTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self requestNet];
    [self builtInterface];
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
    self.title = @"找到";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:@"返回" forState: UIControlStateNormal];
    button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:YES];

        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = DLSBackgroundColor;
    UILabel *label = [UILabel new];
    label.text = @"为您找到的公司";
    label.textColor = [UIColor colorWithWhite:.5 alpha:1];
    label.backgroundColor = DLSBackgroundColor;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    if (!(indexPath.row == [self.modelArray count])) {
        RegisterViewController *regi = [[RegisterViewController alloc]init];
        regi.comMail = self.mailURL;
        regi.companyCid = [NSString stringWithFormat:@"%@", model.ID];
        CompanyModel *model = [self.modelArray objectAtIndex:indexPath.row];
        [regi builtEnterTextNameWithString:model.name];
        [self.navigationController pushViewController:regi animated:YES];
    }
}

- (void)skipButtonAction:(UIButton *)sender
{
//    CardChooseView *card = [[CardChooseView alloc]initWithTitleArray:@[@"个人账号", @"企业账号"]];
//    card.delegate = self;
//    [self.view addSubview:card];
//    [card show];
    
    RegisterViewController *reg = [[RegisterViewController alloc]init];
    reg.comMail = [NSString stringWithFormat:@"%@", self.mailURL];  //注册是没有公司名的
    
    [self.navigationController pushViewController:reg animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelArray count] + 1;
}

- (void)cardActionWithButton:(UIButton *)sender
{
    switch (sender.tag) {  //公司账户已存在
        case 1:{
            
            RegisterViewController *comReg = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:comReg animated:YES];
            break;
        }
        case 2:
        {  //公司账号
//            CompanyRegisterViewController *reg = [[CompanyRegisterViewController alloc]init];
//            reg.companyEmail = [NSString stringWithFormat:@"%@", self.mailURL];
//            [self.navigationController pushViewController:reg animated:YES];
            break;
        }
        case 3:
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
