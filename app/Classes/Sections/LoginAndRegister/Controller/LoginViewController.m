//
//  LoginViewController.m
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>
#import "DLNetworkRequest.h"

#import "UserDataTon.h"
#import <ReactiveCocoa.h>
#import "Account.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"  // 负责账户 model
#import "AccountTool.h"  // 负责账户的存取

@interface LoginViewController ()<DLNetworkRequestDelegate, UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
    
}
- (void)builtInterface{
    self.title = @"登录";
    self.view.backgroundColor = DLSBackgroundColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 200, DLScreenWidth - 20, 70)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    returnButton.frame = CGRectMake(10, 25, 30, 25);
    [returnButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [returnButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];

    returnButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:returnButton];
    [self.view addSubview:returnButton];
    
    self.mailTextField = [UITextField new];
    self.mailTextField.placeholder = @"132-XXXX-3804";
    [self.mailTextField placeholder]; self.mailTextField.delegate = self;
    self.mailTextField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:self.mailTextField];
    
    [self.mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.right.mas_equalTo(view.mas_right);
        make.width.mas_equalTo(view.width - view.height / 2.0);
       
        make.bottom.mas_equalTo(view.mas_bottom).offset(- view.height / 2.0 - 1);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    [self.passwordTextField placeholder];
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    [view addSubview:self.passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailTextField.mas_bottom).offset(2);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.mailTextField.mas_left);
        make.right.mas_equalTo(view.mas_right);
    }];
    [self.view addSubview:view];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登录" forState: UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(view.height / 2.0 + 5);
    }];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];

}

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    [self.mailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)loginButtonAction:(UIButton *)sender
{
    
    [self.mailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    Account *acc = [[Account alloc]init];
    acc.phone = self.mailTextField.text;
    acc.password = self.passwordTextField.text;
    
    [RestfulAPIRequestTool routeName:@"userLogin" requestModel:acc useKeys:@[@"phone", @"password"] success:^(id json) {
        
        // 存取用户值
        NSLog(@"登录成功");
        
        [acc setKeyValues:json];
        [AccountTool saveAccount:acc];
        
        //注册通知
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRootViewController" object:nil userInfo:dic];
        
    } failure:^(id errorJson) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendParsingWithDictionary:(NSDictionary *)dictionary
{
    UserDataTon *ton = [UserDataTon shareState];
    
    ton.company_cid = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"cid"]];
    ton.user_id = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
    ton.user_token = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"token"]];
    
    //注册通知
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRootViewController" object:nil userInfo:dic];

}
- (void)sendErrorWithDictionary:(NSDictionary *)dictionary
{
    NSString *str = [dictionary objectForKey:@"msg"];
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:@"重试" otherButtonTitles: nil, nil];
    [al show];
}

@end
