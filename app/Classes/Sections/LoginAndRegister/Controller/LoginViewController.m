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
#import "ForgetPasswordController.h"
#import "UserDataTon.h"
#import <ReactiveCocoa.h>
#import "Account.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"  // 负责账户 model
#import "AccountTool.h"  // 负责账户的存取

@interface LoginViewController ()<DLNetworkRequestDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UILabel *phoneNumber;
@property (nonatomic, strong)UILabel *passwordLabel;

@property (nonatomic, strong)UITextField *textField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
            self.navigationController.navigationBarHidden = NO;
//    [self builtInterface];
    
    [self builtNewInterface];
//    [self makeF];
}
- (void)makeF
{
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 300, 100, 30)];
    self.textField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.textField];
    UIButton *butto = [UIButton buttonWithType:UIButtonTypeSystem];
    butto.frame = CGRectMake(100, 300, 100, 100);
    butto.backgroundColor = [UIColor yellowColor];
    [butto addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butto];
}
- (void)builtNewInterface
{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSInteger num = 44;
    self.mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(num, 20 + 64, DLScreenWidth - num * 2, num)];
    self.mailTextField.placeholder = @"手机号";
    self.mailTextField.font = [UIFont systemFontOfSize:14];
    self.mailTextField.delegate = self;
    self.mailTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, num - .5, DLScreenWidth - num * 2, .5)];
    view.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [self.mailTextField addSubview:view];
    [self.view addSubview:self.mailTextField];
    
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(num, 60 + 64, DLScreenWidth - num * 2, num)];
    self.passwordTextField.placeholder=  @"密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14];
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    UIView *tempView =[[UIView alloc]initWithFrame:CGRectMake(0, num - .5, DLScreenWidth - num * 2, .5)];
    tempView.backgroundColor = RGBACOLOR(230, 230, 230, 1);

    [self.passwordTextField addSubview:tempView];
    [self.view addSubview:self.passwordTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(38, 165 + 64, DLScreenWidth - 38 * 2, 44);
    
    button.backgroundColor = RGBACOLOR(241, 214, 51, 1);
    [button addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor =[UIColor whiteColor];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(DLMultipleWidth(270.0), 110 + 64, 150, 50)];
    label.text = @"忘记密码?";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGBACOLOR(155, 155, 155, 1);
    label.font  = [UIFont systemFontOfSize:12];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetAction:)]];
    label.userInteractionEnabled = YES;
    
    [self.view addSubview:label];
    
}



- (void)builtInterface{
    self.title = @"登录";
    self.view.backgroundColor = DLSBackgroundColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(33, 65, DLScreenWidth - 76, 88)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    returnButton.frame = CGRectMake(10, 25, 30, 25);
    [returnButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [returnButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];

    returnButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
//        self.navigationController.navigationBarHidden = YES;
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
    self.phoneNumber = [UILabel new];
    self.phoneNumber.text = @"手机号";
    self.phoneNumber.textColor = RGBACOLOR(203, 200, 200, 1);
    self.phoneNumber.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.phoneNumber];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(view.mas_left);
        make.width.mas_equalTo(view.height / 4 + 20);
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
    self.passwordLabel = [UILabel new];
    self.passwordLabel.text = @" 密码";
    self.passwordLabel.font = [UIFont systemFontOfSize:16];
    self.passwordLabel.textColor = RGBACOLOR(203, 200, 200, 1);
    [view addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailTextField.mas_bottom).offset(2);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(view.mas_left);
//        make.right.mas_equalTo(view.mas_right);
    }];

    
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
        make.height.mas_equalTo(view.height / 4);
    }];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
    UILabel *forgetPassword = [[UILabel alloc] initWithFrame:CGRectMake(DLScreenWidth / 2 + 30, 380, 80, 20)];
    forgetPassword.text = @"忘记密码";
    forgetPassword.textColor = [UIColor blackColor];
    forgetPassword.font = [UIFont systemFontOfSize:14];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushView:)];
    [forgetPassword addGestureRecognizer:tap];
    forgetPassword.userInteractionEnabled = YES;
    [self.view addSubview:forgetPassword];
}
- (void)pushView:(UITapGestureRecognizer *)tap {
    NSLog(@"+++");
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
- (void)forgetAction:(UITapGestureRecognizer *)tap
{
    ForgetPasswordController *forget = [[ForgetPasswordController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mailTextField) {
        
    
    if (self.mailTextField.text.length == 11) {
        return NO;
    }}
    else {
        
        if (self.passwordTextField.text.length > 16) {
            return NO;
        }
    }
    return YES;
}



@end
