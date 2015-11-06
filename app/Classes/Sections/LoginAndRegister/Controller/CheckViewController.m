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
@interface CheckViewController ()<UITableViewDataSource, UITableViewDelegate, DLDatePickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)NSMutableArray *pickerArray;

@property (nonatomic, strong)UIView *tempView;
@property (nonatomic, assign)BOOL selectState;

@property (nonatomic, strong)UIPickerView *picker;

@end

@implementation CheckViewController



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
    [self getTempSchool];
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
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(tapAction:) image:@"new_navigation_back@2x" highImage:@"new_navigation_back_helight@2x"];
    
}

- (void)builtSchoolAndTime
{
    self.school = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 , DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"school"] andPlaceHolder:@"学校"];
    
    [self.school.textfield.rac_textSignal subscribeNext:^(NSString *str) {
        // search ..
        SearchSchoolModel *searchmodel = [[SearchSchoolModel alloc]init];
        [searchmodel setName:str];
        [searchmodel setPage:@"1"];
        
        if (str.length > 3 && self.schoolID.length) {
            self.label.userInteractionEnabled = YES;
            self.label.textColor = RGBACOLOR(253, 185, 0, 1);
        } else {
            self.label.userInteractionEnabled = NO;
            self.label.textColor = [UIColor lightGrayColor];
        }
        
        [RestfulAPIRequestTool routeName:@"companySearch" requestModel:searchmodel useKeys:@[@"name", @"city", @"page"] success:^(id json) {
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
    NSArray *array = [NSArray array];
    NSArray *newArray = [[array.rac_sequence map:^id(id value) {
        
        return value;
        
    }] array];
    
    
    [self.view addSubview:self.school];
    
    self.time = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(50.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"starTime"] andPlaceHolder:@"入学时间"];
    
    self.time.textfield.userInteractionEnabled = NO;
    UITapGestureRecognizer *timeSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeSelect:)];
    
    [self.time addGestureRecognizer:timeSelect];
    [self.view addSubview:self.time];
    
}
- (void)timeSelect:(UITapGestureRecognizer *)tap
{
    if (self.selectState == NO) {
        
        self.selectState = YES;
        self.tempView = [[UIView alloc]initWithFrame:CGRectMake(0, DLScreenHeight, DLScreenWidth, DLScreenHeight)];
        [self.view addSubview:self.tempView];
        self.pickerArray = [NSMutableArray array];
        for (int i = 2015 - 100; i <= 2015; i++) {
            
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.pickerArray addObject:str];
        }
        self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DLScreenHeight - DLMultipleHeight(250.0) + 49.0, DLScreenWidth, DLMultipleHeight(250.0))];
        
        self.picker.delegate = self;
        self.picker.dataSource = self;
        
        self.picker.showsSelectionIndicator = YES;
        self.picker.backgroundColor = [UIColor whiteColor];
        [self.picker selectRow:100 inComponent:0 animated:YES];
        self.tempView.userInteractionEnabled = YES;
        [self.tempView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction:)]];
        [self.tempView addSubview:self.picker];
        UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [returnButton setTitle:@"确认" forState:UIControlStateNormal];
        [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [returnButton setBackgroundColor:[UIColor whiteColor]];
        [returnButton addTarget:self action:@selector(returnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //    [returnButton setBackgroundColor:[UIColor greenColor]];
        [self.tempView addSubview:returnButton];
        [returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.picker.mas_top);
            make.right.mas_equalTo(self.picker.mas_right);
            make.left.mas_equalTo(self.picker.centerX);
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        [cancelButton setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(returnButton.mas_bottom);
            make.left.mas_equalTo(self.picker.mas_left);
            make.right.mas_equalTo(returnButton.mas_left);
            make.top.mas_equalTo(returnButton.mas_top);
        }];
        
        [UIView animateWithDuration:.4 animations:^{
            self.tempView.frame = [UIScreen mainScreen].bounds;
            [self.school.textfield resignFirstResponder];
        }];
    }
}
- (void)dismissAction:(UITapGestureRecognizer *)tap
{
    [self pickerViewDismiss];
    
    self.time.textfield.text = [self.pickerArray objectAtIndex:[self.picker selectedRowInComponent:0]];
    
}
- (void)returnButtonAction:(UIButton *)sender
{
    [self pickerViewDismiss];
    
    self.time.textfield.text = [self.pickerArray objectAtIndex:[self.picker selectedRowInComponent:0]];
}

- (void)cancelButtonAction:(UIButton *)sender
{
    [self pickerViewDismiss];
}
- (void)pickerViewDismiss
{
    [UIView animateWithDuration:.4 animations:^{
        self.tempView.frame = CGRectMake(0, DLScreenHeight, DLScreenWidth, DLScreenHeight);

    } completion:^(BOOL finished) {
        [self.tempView removeFromSuperview];
        self.selectState = NO;
        [self.school.textfield becomeFirstResponder];
        [self.school.textfield resignFirstResponder];
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.pickerArray objectAtIndex:row];
}


/*
 - (void)timeSelect:(UITapGestureRecognizer *)tap
 {
 [self.school.textfield resignFirstResponder];
 DLDatePickerView *time = [[DLDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
 time.delegate = self;
 //    time.picker.datePickerMode = UIDatePickerModeDate;
 NSDate *minDate = [[NSDate alloc]initWithTimeInterval:- 60 * 60 * 24 * 365 * 60 sinceDate:[NSDate date]];
 NSDate *maxDate = [NSDate date];
 [time reloadWithMaxDate:maxDate minDate:minDate dateMode:UIDatePickerModeCountDownTimer];
 
 [self.view addSubview:time];
 [time show];
 }  */
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
    [self.school.textfield becomeFirstResponder];
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
    if (indexPath.row < [self.modelArray count]) {
        SearchSchoolModel *model = [self.modelArray objectAtIndex:indexPath.row];
        self.school.textfield.text = model.name;
        self.schoolID = [NSString stringWithFormat:@"%@", model.ID];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.school.textfield resignFirstResponder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeFlaseValue
{
    self.modelArray = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        SearchSchoolModel *model = [[SearchSchoolModel alloc]init];
        [model setName:@"上海大学"];
//        [model setID:@"55d44d2219d8c913768fce8c"];
        [self.modelArray addObject:model];
    }
}

- (void)getTempSchool
{
    SearchSchoolModel *searchmodel = [[SearchSchoolModel alloc]init];
    searchmodel.name = @"上海大学";
    
    [RestfulAPIRequestTool routeName:@"companySearch" requestModel:searchmodel useKeys:@[@"name", @"city", @"page"] success:^(id json) {
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
    
}


- (void)nextController:(UITapGestureRecognizer *)tap
{
    if (self.schoolID) {
    LoginSinger *singer = [LoginSinger shareState];
    [singer setEnrollment:self.time.textfield.text];  // 入学年份
    [singer setCid:self.schoolID];
    
    [self.school.textfield resignFirstResponder];
    FillInformationCon *fill = [[FillInformationCon alloc]init];
    [self.navigationController pushViewController:fill animated:YES];
    }
}


@end
