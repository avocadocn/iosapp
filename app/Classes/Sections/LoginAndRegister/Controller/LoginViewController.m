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
    returnButton.frame = CGRectMake(0, 0, 30, 30);
    [returnButton setTitle:@"返回" forState: UIControlStateNormal];
    returnButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:returnButton];
    
    
    self.mailTextField = [UITextField new];
    self.mailTextField.placeholder = @"132-XXXX-3804";
    [self.mailTextField placeholder]; self.mailTextField.delegate = self;
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
}
- (void)loginButtonAction:(UIButton *)sender
{
//    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
//    request.delegate = self;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:self.mailTextField.text forKey:@"email"];
//    [dic setObject:self.passwordTextField.text forKey:@"password"];
//    
//    [request dlRouteNetWorkWithNetName:@"userLogin" andRequestType:@"POST" paramter:dic];
    Account *acc = [[Account alloc]init];
    acc.phone = self.mailTextField.text;
    acc.password = self.passwordTextField.text;
    
    [RestfulAPIRequestTool routeName:@"userLogin" requestModel:acc useKeys:@[@"phone", @"password"] success:^(id json) {
        
        // 存取用户值
        NSLog(@"登录成功");
        Account *acca =[[Account alloc]init];
        
        [acca setKeyValues:json];
        [AccountTool saveAccount:acca];
        
        NSLog(@"%@", acca);
        
        
        //注册通知
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRootViewController" object:nil userInfo:dic];
        
        
        
    } failure:^(id errorJson) {
        NSLog(@"失败, 请求到的数据为%@", errorJson);
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
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if (toBeString.length > 11) {
//        textField.text = [toBeString substringToIndex:11];
//        
//        return NO;
//    }
//    return YES;
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
