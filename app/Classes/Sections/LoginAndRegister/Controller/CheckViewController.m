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
#import "RestfulAPIRequestTool.h"
#import "ImageHolderView.h"
#import "DLDatePickerView.h"
#import "SearchSchoolModel.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "FillInformationCon.h"
#import "UIBarButtonItem+Extension.h"
#import "LoginSinger.h"

typedef NS_ENUM(NSInteger, SelectStateOfCompany){
    SelectStateOfCompanyNo,
    SelectStateOfCompanyYes
};
// CardChooseViewDelegate   DLNetworkRequestDelegate
@interface CheckViewController ()<UITableViewDataSource, UITableViewDelegate, DLDatePickerViewDelegate>

@end

@implementation CheckViewController

/*
- (void)requestNetWithSuffix:(NSString *)str
{
//    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:str forKey:@"email"];
//    request.delegate = self;
//    [request dlRouteNetWorkWithNetName:@"companySearch" andRequestType:@"POST" paramter:dic];
    
    CompanyModel *company = [[CompanyModel alloc]init];
    [company setValue:str forKey:@"email"];
    
    [RestfulAPIRequestTool routeName:@"companySearch" requestModel:company useKeys:@[@"email"] success:^(id json) {
        [self sendParsingWithDictionary:json];
    } failure:^(id errorJson) {
        [self sendErrorWithDictionary:errorJson];
    }];
    
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
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self builtSchoolAndTime];
    [self builtRightBarItem];
    [self builtSchoolTable];
    /*
     //    [self requestNet];
     [self builtInterface];
     */  //第一个版本  公司版本
    [self makeFlaseValue];
}


- (void)builtRightBarItem
{
    self.title = @"大学信息";
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    self.label.text = @"下一步";
    self.label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
    [self.label addGestureRecognizer:labelTap];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.label];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(tapAction:) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
    
}

- (void)builtSchoolAndTime
{
    self.school = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 , DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"school"] andPlaceHolder:@"学校"];
    
    [self.school.textfield.rac_textSignal subscribeNext:^(NSString *str) {
        // search ..
        SearchSchoolModel *searchmodel = [[SearchSchoolModel alloc]init];
        [searchmodel setName:str];
//        [searchmodel setCity:@"上海"];
        [searchmodel setPage:@"1"];
        
        if (str.length > 3 && self.time.textfield.text.length >3 ) {
            self.label.userInteractionEnabled = YES;
            self.label.textColor = RGBACOLOR(253, 185, 0, 1);
        } else {
            self.label.userInteractionEnabled = NO;
            self.label.textColor = [UIColor lightGrayColor];
        }
        
        [RestfulAPIRequestTool routeName:@"companySearch" requestModel:searchmodel useKeys:@[@"name", @"city", @"page"] success:^(id json) {
            NSLog(@"成功");
            self.modelArray = [NSMutableArray array];
            NSArray *array = [json objectForKey:@"companies"];
            for (NSDictionary *dic in array) {
                SearchSchoolModel *model = [[SearchSchoolModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.modelArray addObject:model];
            }
            
            [self.searchTableView reloadData];
        } failure:^(id errorJson) {
            NSLog(@"失败, %@", errorJson);
        }];
    }];
    [self.view addSubview:self.school];
    
    self.time = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(50.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"starTime"] andPlaceHolder:@"入学时间"];
    
    self.time.textfield.userInteractionEnabled = NO;
    UITapGestureRecognizer *timeSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeSelect:)];
    [self.time addGestureRecognizer:timeSelect];
    [self.view addSubview:self.time];
}
- (void)timeSelect:(UITapGestureRecognizer *)tap
{
    [self.school.textfield resignFirstResponder];
    DLDatePickerView *time = [[DLDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    time.delegate = self;
//    time.picker.datePickerMode = UIDatePickerModeDate;
    
    NSDate *minDate = [[NSDate alloc]initWithTimeInterval:- 60 * 60 * 24 * 365 * 3 sinceDate:[NSDate date]];
    NSDate *maxDate = [[NSDate alloc]initWithTimeInterval:60 * 60 * 24 * 365 * .5 sinceDate:[NSDate date]];
    [time reloadWithMaxDate:maxDate minDate:minDate dateMode:UIDatePickerModeDate];
    
    [self.view addSubview:time];
    [time show];
}
- (void)outPutStringOfSelectDate:(NSString *)str withTag:(NSInteger)tag
{
    NSArray *array = [str componentsSeparatedByString:@" "];
    self.time.textfield.text = [array firstObject];
    if (self.school.textfield.text.length >= 4)
    {
        self.label.userInteractionEnabled = YES;
        self.label.textColor = RGBACOLOR(253, 185, 0, 1);
    } else {
        self.label.userInteractionEnabled = NO;
        self.label.textColor = [UIColor lightGrayColor];
    }

    
}

- (void)builtSchoolTable
{
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 +DLMultipleHeight(100.0), DLScreenWidth, DLScreenHeight - DLMultipleHeight(100.0) - 64) style:UITableViewStylePlain];
    
    self.searchTableView.separatorColor = [UIColor clearColor];
    self.searchTableView.backgroundColor = DLSBackgroundColor;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    [self.view addSubview:self.searchTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelArray count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.modelArray count]) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        SearchSchoolModel *model = [self.modelArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        
        return cell;
        
    } else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(160.0))];
        image.image = [UIImage imageNamed:@"schoolCan"];
        [cell addSubview:image];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.school.textfield resignFirstResponder];
    if (indexPath.row < [self.modelArray count]) {
        SearchSchoolModel *model = [self.modelArray objectAtIndex:indexPath.row];
        self.school.textfield.text = model.name;
        self.schoolID = [NSString stringWithFormat:@"%@", model.ID];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.modelArray count]) {
        return DLMultipleHeight(50.0);
        
    } else
    {
        return DLMultipleHeight(160.0);
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(34.0))];
    
    label.text =  @"   您身边的学校";
    label.textColor = [UIColor colorWithWhite:.1 alpha:1];
    label.backgroundColor = DLSBackgroundColor;
    label.font = [UIFont systemFontOfSize:12.5];
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DLMultipleHeight(34.0);
}

/*
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
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeFlaseValue
{
    self.modelArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        SearchSchoolModel *model = [[SearchSchoolModel alloc]init];
        [model setName:@"上海大学"];
        [self.modelArray addObject:model];
    }
}
- (void)nextController:(UITapGestureRecognizer *)tap
{
    NSArray *array = [self.time.textfield.text componentsSeparatedByString:@"-"];
    
    LoginSinger *singer = [LoginSinger shareState];
    [singer setEnrollment:[array firstObject]];  // 入学年份
    [singer setCid:self.schoolID];
    
    [self.school.textfield resignFirstResponder];
    FillInformationCon *fill = [[FillInformationCon alloc]init];
    [self.navigationController pushViewController:fill animated:YES];
}


@end
