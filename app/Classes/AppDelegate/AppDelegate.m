//
//  AppDelegate.m


#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "MainController.h"
#import "CheckViewController.h"
#import "LoginViewController.h"
#import "DLNetworkRequest.h"
#import "DLNetworkRequest.h"
#import "GuidePageViewController.h" //引导页
#import "AppDelegate+EaseMob.h"
#import "Account.h"
#import "AccountTool.h"
#import "LaunchEventController.h"
#import "DLNavigationController.h"
#import <SMS_SDK/SMS_SDK.h>
//测试用
#import "PersonalDynamicController.h"


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
    
    // 登陆界面
    
  /*
    GuidePageViewController *gu = [[GuidePageViewController alloc]init];
    DLNavigationController *nav = [[DLNavigationController alloc]initWithRootViewController:gu];
    [self.window setRootViewController:nav];
*/
    
    // main 页面
/*
    MainController *main = [[MainController alloc]init];
 */
    
    self.window.rootViewController = [self judgeLoginState];
    /*
//       self.mainController = main;
//       self.mainController = main;
*/
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultCenterAction:) name:@"changeRootViewController" object:nil];
    return YES;
}

- (id)judgeLoginState{
    Account *myAccount = [AccountTool account];
    if (myAccount) {  //账户已经登录过了
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
    
    // 登陆
    if ( ![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        [self.mainController loginWithUsername:@"789" password:@"789"];
    }
    
}

- (void)loginButtonAction:(UIButton *)sender
{
    LoginViewController *login = [[LoginViewController alloc]init];
    
    [self.window setRootViewController:login];
}

- (void)registerTapAction:(UITapGestureRecognizer *)tap  //注册的点击事件
{
    // 邮箱格式的判断
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL mailFormat = [emailTest evaluateWithObject:self.mailBoxTextField.text];

    
    if (mailFormat) { //正确的邮箱格式
        CheckViewController *check = [[CheckViewController alloc]init];
        check.mailURL = [NSString stringWithFormat:@"%@", self.mailBoxTextField.text];  //接受到的邮箱内容
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:check];
        self.window.rootViewController = nav;
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


@end
