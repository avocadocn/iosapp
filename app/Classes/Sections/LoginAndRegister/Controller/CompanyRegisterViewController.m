//
//  CompanyRegisterViewController.m
//  app
//
//  Created by 申家 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyRegisterViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "ChoosePhotoController.h"
#import "DLNetworkRequest.h"
#import "RegisterViewController.h"
#import "CompanyEmailComplete.h"


@interface CompanyRegisterViewController ()<ArrangeState, DLNetworkRequestDelegate>

@end

@implementation CompanyRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"公司注册";
    
    [self builtInterface];
    
}
- (void)builtInterface
{
    CGFloat imageButtonWidth = [UIScreen mainScreen].bounds.size.width / 2.56;
    self.companyLogoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.companyLogoButton.layer.masksToBounds = YES;
    self.companyLogoButton.backgroundColor = DLSBackgroundColor;
    self.companyLogoButton.layer.cornerRadius = imageButtonWidth / 2.0;  //弧度
    [self.companyLogoButton addTarget:self action:@selector(companyLogoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.companyLogoButton];
    [self.companyLogoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(imageButtonWidth, imageButtonWidth));
    }];
    [self builtTextfield];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginButton addTarget:self action:@selector(companyLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton setBackgroundColor:[UIColor orangeColor]];
    [self.loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 45 / 2.0;
    
    [self.view addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.view.mas_bottom).offset(-150);
    }];
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.companyNameTextField.rac_textSignal, self.companyPasswordTextField.rac_textSignal] reduce:^(NSString * UserNick, NSString *userPassword){
        return @(UserNick.length > 6 && userPassword.length > 6);
    }];  //长度统统大于6
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)companyLogoButtonAction:(UIButton *)sender
{
    ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];
    choose.delegate = self;
    choose.allowSelectNum = 1;
    [self.navigationController pushViewController:choose animated:YES];
}
- (void)companyLoginAction:(UIButton *)sender
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.companyNameTextField.text forKey:@"name"];
    [dic setObject:@"上海市" forKey:@"province"];
    [dic setObject:@"上海市" forKey:@"city"];
    [dic setObject:@"黄浦区" forKey:@"district"];
    [dic setObject:self.companyEmail forKey:@"email"];
    [dic setObject:self.companyPasswordTextField.text forKey:@"password"];
    
    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
    request.delegate = self;
    [request dlRouteNetWorkWithNetName:@"companyQuickRegister" andRequestType:@"POST" paramter:dic];
    
    
    
}
- (void)sendParsingWithDictionary:(NSDictionary *)dictionary
{
    CompanyEmailComplete *company = [[CompanyEmailComplete alloc]init];
    NSString *str = [dictionary objectForKey:@"inviteKey"];
    company.comEmail = [NSString stringWithFormat:@"%@", self.companyEmail];
    company.inviteKey = str;
    
    [self.navigationController pushViewController:company animated:YES];
}

- (void)builtTextfield
{
    NSArray *labelNameArray = @[@"输入您公司的昵称", @"输入您公司的密码"];
    self.companyNameTextField = [UITextField new];
    self.companyPasswordTextField = [UITextField new];
    
    NSArray *componentArray = @[self.companyNameTextField, self.companyPasswordTextField];
    
    NSInteger i  =0;
    for (NSString *str in labelNameArray) {
        
        UITextField *textfield = [componentArray objectAtIndex:i];
        textfield.placeholder = str;
        textfield.textAlignment = NSTextAlignmentCenter;
        
        [textfield placeholder];
        
        [self.view addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.companyLogoButton.mas_bottom).offset(20 + 40 * i);
            make.left.mas_equalTo(self.view.mas_left).offset(30);
            make.right.mas_equalTo(self.view.mas_right).offset(-30);
            make.height.mas_equalTo(30);
        }];
        
        UIView *view = [UIView new];
        [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.8]];
        [textfield addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textfield.mas_bottom).offset(-.5);
            make.left.mas_equalTo(textfield.mas_left);
            make.right.mas_equalTo(textfield.mas_right);
            make.bottom.mas_equalTo(textfield.mas_bottom);
        }];
        i++;
    }
    self.companyPasswordTextField.secureTextEntry = YES;
    self.companyPasswordTextField.textColor = [UIColor colorWithWhite:.2 alpha:.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    [self.companyLogoButton setBackgroundImage:[array lastObject] forState:UIControlStateNormal];
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
