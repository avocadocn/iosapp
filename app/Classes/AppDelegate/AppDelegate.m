//
//  AppDelegate.m

#import "MainController.h" // 首页
#import "GuidePageViewController.h" //引导页
#import "AppDelegate+EaseMob.h"
#import "Account.h"
#import "AccountTool.h"
#import "DLNavigationController.h"
#import <SMS_SDK/SMS_SDK.h>  //sharesdk 短信
//测试用
#import "PersonalDynamicController.h"
#import "RestfulAPIRequestTool.h"
#import "FMDBSQLiteManager.h"
#import "Group.h"
#import "InteractiveViewController.h"
@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //shareSDK 短信的设置
    [SMS_SDK registerApp:@"96e27f7829b0" withSecret:@"b9187305412315ed038b8f9e2c43a520"];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    //修改控制器的statusBar样式,需要注意在info.plist里配置一下
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.window.rootViewController = [self judgeLoginState];
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultCenterAction:) name:@"changeRootViewController" object:nil];
    
    NSLog(@"连接状态为 %lu", (unsigned long)_connectionState);
    
    [self setupEaseMobWith:application withOptions:launchOptions];
    
    // iOS8系统需要注册本地通知，这样才能正常使用
    if ([UIApplication instanceMethodSignatureForSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (id)judgeLoginState{
    Account *myAccount = [AccountTool account];
    if (myAccount.token) {  //账户已经登录过了
        MainController *main = [[MainController alloc]init];
        self.mainController = main;
        return main;
    } else
    {
        GuidePageViewController *gu = [[GuidePageViewController alloc]init];
        DLNavigationController *nav = [[DLNavigationController alloc]initWithRootViewController:gu];
        return nav;
    }
    return nil;
}

- (void)defaultCenterAction:(id)sender
{
    MainController *main = [[MainController alloc]init];
    [self.window setRootViewController:main];
}

/**
 *  初始化环信
 *
 *  @param application   <#application description#>
 *  @param launchOptions <#launchOptions description#>
 */
-(void)setupEaseMobWith:(UIApplication *)application withOptions:(NSDictionary *)launchOptions{
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    Account *acc = [AccountTool account];
    // 如果是第二次启动应用，是可以登录的，但第一次启动时，用户还未登录，此时用户账号信息为空，无法登录环信
    Boolean isAuto=[[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if ( ![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        [self.mainController loginWithUsername:acc.ID password:acc.ID];
    }
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"ddfjeofjewofjweofjawojf收到通知单了");
     application.applicationIconBadgeNumber = 0;
    [InteractiveViewController cancelLocalNotificationWithKey:@"key"];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
     application.applicationIconBadgeNumber = 0;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
