//
//  LoginViewController.m
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>


@interface LoginViewController ()

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
    
    NSInteger num = 10;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left).offset(num);
//        make.right.mas_equalTo(self.view.mas_right).offset(-num);
//        make.top.mas_equalTo(self.view.mas_top).offset(250);
//        make.height.mas_equalTo(60);
//    }];
    
    
    
    self.mailTextField = [UITextField new];
    self.mailTextField.placeholder = @"domomchon@donler.com";
    [self.mailTextField placeholder];
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
    [view addSubview:self.passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailTextField.mas_bottom).offset(2);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.mailTextField.mas_left);
        make.right.mas_equalTo(view.mas_right);
    }];
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"登录" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(view.height / 2.0 + 5);
    }];
    
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
