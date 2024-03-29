//
//  DLNavigationController.m
//  app
//
//  Created by 张加胜 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "DLLoading.h"
#import "DLNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "ChoosePhotoController.h"
#import "DSNavigationBar.h"
#import <DGActivityIndicatorView.h>

@interface DLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation DLNavigationController

+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
//    // 设置整个项目所有的导航栏
//    UINavigationBar *bar = [UINavigationBar appearance];
  
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
////    NSMutableArray *array = [NSMutableArray array];
////    [array addObject:[UIColor whiteColor]];
////    [array addObject:[UIColor lightGrayColor]];
////    DSNavigationBar *bar = [[DSNavigationBar alloc]init];
////    [bar setNavigationBarWithColors:array];
////      [self setValue:bar forKey:@"navigationBar"];
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
    }
}

/**
 *  拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 && ![viewController isKindOfClass:[ChoosePhotoController class]]) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"new_navigation_back@2x" highImage:@"new_navigation_back_helight@2x"];
        
        // 设置右边的更多按钮
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    
    //所有得页面都进行键盘隐藏事件的监听
    [viewController setupForDismissKeyboard];
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
#warning 这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
        if ([window viewWithTag:19921223] ) {
            [DLLoading dismisss];
        }

    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}



@end
