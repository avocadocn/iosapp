//
//  MainController.m
//  DLDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "MainController.h"
#import "InteractiveViewController.h"
#import "ChatViewController.h"
#import "CompanyViewController.h"
#import "AttentionViewController.h"
#import "ProfileViewController.h"


@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 添加主页面VC
    InteractiveViewController *interactiveVC = [[InteractiveViewController alloc]init];
    [self addOneTabWithVC:interactiveVC title:@"互动"];
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    [self addOneTabWithVC:chatVC title:@"聊天"];
    
    CompanyViewController *companyVC = [[CompanyViewController alloc]init];
    [self addOneTabWithVC:companyVC title:@"公司"];
    
    AttentionViewController *attentionVC = [[AttentionViewController alloc]init];
    [self addOneTabWithVC:attentionVC title:@"关注"];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    [self addOneTabWithVC:profileVC title:@"我"];
    
    
}

- (void)addOneTabWithVC:(UIViewController *)viewController title:(NSString *)title{
    viewController.title = title;
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:nav];
    
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
