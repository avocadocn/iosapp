//
//  AppDelegate.m
//  etrst
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "CheckViewController.h"
#import "LoginViewController.h"
#import "DLNetworkRequest.h"
#import "GuidePageViewController.h" //引导页

@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    GuidePageViewController *guide = [[GuidePageViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:guide];
    
    [self.window setRootViewController:nav];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpPageAction:) name:@"changeRootViewController" object:nil];  //  接受跳转通知
    
    //修改控制器的statusBar样式,需要注意在info.plist里配置一下
    [self.window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    return YES;
}
- (void)jumpPageAction:(UIButton *)sender
{
    [self.window setRootViewController:nil];
    
    MainController *main = [[MainController alloc]init];

    self.window.rootViewController = main;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
