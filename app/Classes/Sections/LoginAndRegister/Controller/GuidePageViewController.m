//
//  GuidePageViewController.m
//  app
//
//  Created by 申家 on 15/7/29.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GuidePageViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "LoginViewController.h"
#import "MainController.h"
#import "CheckViewController.h"
#import "DLNetworkRequest.h"


@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollview = [self builtScrollview];
    [self.view addSubview:scrollview];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)builtScrollview
{
//    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, DLScreenWidth, DLScreenHeight + 20)];
    scrollview.contentSize = CGSizeMake(DLScreenWidth * 3, 0);
    scrollview.pagingEnabled = YES;
    
    UITapGestureRecognizer *scrollTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollTapAction:)];
    [scrollview addGestureRecognizer:scrollTap];
    CGFloat red = arc4random() %100 / 100.0;
    CGFloat blue = arc4random() %100 / 100.0;
    CGFloat yellow = arc4random() %100 / 100.0;
    scrollview.backgroundColor = [UIColor colorWithRed:red green:blue blue:yellow alpha:1];
    for (int i = 1; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i - 1) * DLScreenWidth, 0, DLScreenWidth, DLScreenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome-%d", i]];
        [scrollview addSubview:imageView];
    }

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeViewAction:) name:@"loginAccount" object:nil];  //  接受返回通知
    
    UIView *orge = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(45.0))];
    UITapGestureRecognizer *atapWithLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(atapWithLoginAction:)];
    [orge addGestureRecognizer:atapWithLogin];
    [orge setBackgroundColor:[UIColor redColor]];
    
    [scrollview addSubview:orge];
    
    return scrollview;
}

- (void)atapWithLoginAction:(UITapGestureRecognizer *)tap
{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)scrollTapAction:(UITapGestureRecognizer *)tap
{
    CheckViewController *check = [[CheckViewController alloc]init];
    [self.navigationController pushViewController:check animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)changeViewAction:(UIButton *)sender
{
}

- (void)loginButtonAction:(UIButton *)sender
{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
    self.navigationController.navigationBarHidden = NO;

}

- (void)registerTapAction:(UITapGestureRecognizer *)tap  //注册的点击事件
{
    // 邮箱格式的判断
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL mailFormat = [emailTest evaluateWithObject:self.mailBoxTextField.text];
    
    if (mailFormat) { //正确的邮箱格式
        CheckViewController *check = [[CheckViewController alloc]init];
        [self.navigationController pushViewController:check animated:YES];
        self.navigationController.navigationBarHidden = NO;
        check.mailURL = [NSString stringWithFormat:@"%@", self.mailBoxTextField.text];  //接受到的邮箱内容
//        NSArray *array = [check.mailURL componentsSeparatedByString:@"@"];
//        NSString *str = [array lastObject];
//        [check requestNetWithSuffix:check.mailURL];
        
        [self.navigationController pushViewController:check animated:YES];
        self.navigationController.navigationBarHidden = NO;

    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你给的邮箱格式不正确" message: nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"开始");
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"结束");
}
//button 的便利构造器
- (UIButton *)builttingButtonWithTitle:(NSString *)str tag:(NSInteger)tag
{
    @autoreleasepool {
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];  //登陆 button
        [loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.tag = tag;
        [loginButton setTitle:str forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [loginButton setBackgroundColor:[UIColor colorWithRed:.4 green:.5 blue:1 alpha:.8]];
        
        return loginButton;
    }
}

- (void)buttonAction:(UIButton *)sender  //登录逻辑
{
    //        MainController *main = [[MainController alloc]init];
    //        self.window.rootViewController = main;
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
