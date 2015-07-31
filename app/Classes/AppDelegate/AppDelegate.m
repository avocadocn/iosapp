//
//  AppDelegate.m
//  etrst
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "AppDelegate.h"

#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "CheckViewController.h"
#import "LoginViewController.h"
#import "DLNetworkRequest.h"
#import "GuidePageViewController.h" //引导页

#import "AppDelegate+EaseMob.h"

@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    UIScrollView *scrollview = [self builtScrollview];
//    [self.window addSubview:scrollview];
//    [self.window makeKeyAndVisible];
    
       //修改控制器的statusBar样式,需要注意在info.plist里配置一下
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    MainController *main = [[MainController alloc]init];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    
    
    self.mainController = main;
    
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];

    // 登陆
    if ( ![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        [self.mainController loginWithUsername:@"789" password:@"789"];
    }
    

    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
  
   
//
//    if (_mainController) {
//        [_mainController jumpToChatList];
//    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}




- (UIScrollView *)builtScrollview
{
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollview.contentSize = CGSizeMake(DLScreenWidth * 4, 0);
    scrollview.pagingEnabled = YES;
    CGFloat red = arc4random() %100 / 100.0;
    CGFloat blue = arc4random() %100 / 100.0;
    CGFloat yellow = arc4random() %100 / 100.0;
    scrollview.backgroundColor = [UIColor colorWithRed:red green:blue blue:yellow alpha:1];
    for (int i = 1; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i - 1) * DLScreenWidth, 0, DLScreenWidth, DLScreenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome-%d", i]];
        [scrollview addSubview:imageView];
    }
    
    // 登录/注册逻辑 View  小元件都放在上面
    UIView *loginLogicView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * 3, 0, DLScreenWidth, DLScreenHeight)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerTapAction:)];
    [loginLogicView addGestureRecognizer:tap];   //需要进行传值
    [scrollview addSubview:loginLogicView];

    self.mailBoxTextField = [UITextField new];
    self.mailBoxTextField.placeholder = @"请输入您的邮箱...";
    [self.mailBoxTextField placeholder];
    self.mailBoxTextField.font = [UIFont systemFontOfSize:20];
    self.mailBoxTextField.textColor = [UIColor whiteColor];
    [loginLogicView addSubview:self.mailBoxTextField];
    [self.mailBoxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(loginLogicView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
    
    RAC(tap, enabled) = [RACSignal combineLatest:@[self.mailBoxTextField.rac_textSignal] reduce:^(NSString *mailStr){
        return @(mailStr.length >= 6);
    }];
    
    UIButton *loginButton = [self builttingButtonWithTitle:@"登录" tag:1];
    
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginLogicView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginLogicView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth, 55));
        make.centerX.mas_equalTo(loginLogicView.mas_centerX);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpPageAction:) name:@"loseView" object:nil];  //  接受返回通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeViewAction:) name:@"loginAccount" object:nil];  //  接受返回通知

    
    return scrollview;
}
- (void)jumpPageAction:(UIButton *)sender
{
    [self.window setRootViewController:nil];
    
    MainController *main = [[MainController alloc]init];

    self.window.rootViewController = main;
}


@end
