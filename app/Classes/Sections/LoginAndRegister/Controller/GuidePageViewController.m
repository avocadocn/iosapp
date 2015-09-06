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


@interface GuidePageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *pag;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollview = [self builtScrollview];
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    [self builtLoginAndSrg];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)builtLoginAndSrg
{
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, DLMultipleHeight(600.0), DLScreenWidth, DLMultipleWidth(44.0))];
    [self.view addSubview:tempView];
    UILabel *orge = [[UILabel alloc]initWithFrame:CGRectMake(DLMultipleWidth(195.0), 0, DLMultipleWidth(150.0), DLMultipleHeight(44.0))];
    UITapGestureRecognizer *atapWithLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(atapWithLoginAction:)];
    orge.userInteractionEnabled = YES;
    orge.text = @"登录";
    orge.font = [UIFont systemFontOfSize:15];
    orge.textAlignment = NSTextAlignmentCenter;
    [orge addGestureRecognizer:atapWithLogin];
    [orge setBackgroundColor:[UIColor whiteColor]];
    [tempView addSubview:orge];
    
    UILabel *regiLabel = [UILabel new];
    [regiLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTapAction:)]];
    
    regiLabel.userInteractionEnabled = YES;
    regiLabel.text = @"注册";
    regiLabel.font = [UIFont systemFontOfSize:15];
    regiLabel.textAlignment = NSTextAlignmentCenter;
    regiLabel.backgroundColor = RGBACOLOR(255, 230, 102, 1);
    [tempView addSubview:regiLabel];
    
    CGFloat orX = DLScreenWidth - DLMultipleWidth(195.0) - DLMultipleWidth(150.0);
    [regiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orge.mas_top);
        make.bottom.mas_equalTo(orge.mas_bottom);
        make.left.mas_equalTo(orX);
        make.width.mas_equalTo(orge.mas_width);
    }];
    
    [self.view bringSubviewToFront:tempView];
    
    self.pag = [UIPageControl new];
    self.pag.numberOfPages = 3;
    self.pag.userInteractionEnabled = NO;
    
    
    [self.view addSubview:self.pag];
    
    [self.pag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tempView.mas_top);
        make.left.mas_equalTo(tempView.mas_left);
        make.right.mas_equalTo(tempView.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(60.0));
    }];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / DLScreenWidth;
    self.pag.currentPage = scrollView.contentOffset.x / DLScreenWidth;
    
    UIView *titleLabel = (UIView *)[scrollView viewWithTag:1001 + i];
    UIView *strLabel = (UIView *)[scrollView viewWithTag:2001 + i];
    
    [UIView animateWithDuration:.8 animations:^{
        titleLabel.backgroundColor = [UIColor clearColor];
        strLabel.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [titleLabel removeFromSuperview];
        [strLabel removeFromSuperview];
    }];
    
    switch (i) {
        case 0:{
            
            [UIView animateWithDuration:3 animations:^{
                UIView *view = (UIView *)[scrollView viewWithTag:3005];
                [UIView animateWithDuration:1 animations:^{
                    view.backgroundColor = [UIColor clearColor];
                }];
            
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1 animations:^{
                    for (int num = 3003; num < 3005; num ++) {
                        UIView *view = (UIView *)[scrollView viewWithTag:num];
                        [UIView animateWithDuration:1 animations:^{
                            view.backgroundColor = [UIColor clearColor];
                        }];
                    }
                } completion:^(BOOL finished) {
                    for (int num = 3001; num < 3003; num ++) {
                        UIView *view = (UIView *)[scrollView viewWithTag:num];
                        [UIView animateWithDuration:1 animations:^{
                            view.backgroundColor = [UIColor clearColor];
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
                    }
                }];
            }];
            
            
            
            break;
        }
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)builtScrollview
{
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, DLScreenWidth, DLScreenHeight + 20)];
    scrollview.contentSize = CGSizeMake(DLScreenWidth * 3, 0);
    scrollview.pagingEnabled = YES;
    scrollview.showsVerticalScrollIndicator = FALSE;
    scrollview.showsHorizontalScrollIndicator = FALSE;
    scrollview.backgroundColor = RGBACOLOR(255, 212, 48, 1);

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeViewAction:) name:@"loginAccount" object:nil];  //  接受返回通知
    
    NSArray *strArray = @[@"一大波小鲜肉正在靠近, 近水楼台, 先睹为快", @"私人定制, 臭味相投, 我的社团我做主", @"男神, 女神, 原理TA就在你隔壁的教室"];
    NSArray *titleArray = @[@"新生报到", @"牛叉社团", @"人气排行"];
    
    NSInteger i = 0;
    for (NSString *str in strArray) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(DLScreenWidth * i, DLMultipleHeight(78.0), DLScreenWidth, 32.0)];
        titleLabel.text = [titleArray objectAtIndex:i];
        titleLabel.font = [UIFont systemFontOfSize:25.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;

        [scrollview addSubview:titleLabel];
        
        UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * i, DLMultipleHeight(78.0), DLScreenWidth, 32.0)];
        tempView.backgroundColor = RGBACOLOR(255, 212, 48, 1);
        tempView.tag = 1001 + i;
        [scrollview addSubview:tempView];
        
        UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake(DLScreenWidth * i, DLMultipleHeight(510.0), DLScreenWidth, 17.0)];
        strLabel.text = str;
        strLabel.font = [UIFont systemFontOfSize:14.0];
        strLabel.textAlignment = NSTextAlignmentCenter;
        [scrollview addSubview:strLabel];
        
        UIView *tempViewOne = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * i, DLMultipleHeight(510.0), DLScreenWidth, 17.0)];
        tempViewOne.backgroundColor = RGBACOLOR(255, 212, 48, 1);
        tempViewOne.tag = 2001 + i;
        [scrollview addSubview:tempViewOne];
        
        i++;
    }
    
    NSArray *frameArray = @[
                            @[@44.0, @260.0, @130.0, @153.0],
                            @[@190.0, @154.0, @127.0, @128.0],
                            @[@30.0, @146.0, @146.0, @175.0],
                            @[@214.0, @271.0, @127.0, @170.0],
                            @[@94.0, @212.0, @190.0, @248.0]
  ];
    NSInteger j = 0;
    for (NSArray *array in frameArray) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              DLMultipleWidth([[array objectAtIndex:0] floatValue]),
                                                                              DLMultipleHeight([[array objectAtIndex:1]floatValue]),
                                                                              DLMultipleWidth([[array objectAtIndex:2] floatValue]),
                                                                              DLMultipleHeight([[array objectAtIndex:3] floatValue]))];
        NSInteger num = 301 + j;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", num]];
        [self.view addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        [scrollview addSubview:imageView];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(
                                                              DLMultipleWidth([[array objectAtIndex:0] floatValue]),
                                                              DLMultipleHeight([[array objectAtIndex:1]floatValue]),
                                                              DLMultipleWidth([[array objectAtIndex:2] floatValue]),
                                                              DLMultipleHeight([[array objectAtIndex:3] floatValue]))];
        view.backgroundColor = RGBACOLOR(255, 212, 48, 1);
        view.tag = 3001 +j;
        [scrollview addSubview:view];
        j++;
    }
    
    
    
    
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
//    self.navigationController.navigationBarHidden = NO;

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
    [UIView animateWithDuration:.4 delay:.1 usingSpringWithDamping:.1 initialSpringVelocity:.1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
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
