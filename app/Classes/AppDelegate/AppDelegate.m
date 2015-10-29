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
#import "Person.h"
#import "Group.h"
#import "DetailActivityShowController.h"
#import "Concern.h"
#import "AddressBookModel.h"
@interface AppDelegate ()<UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *contactsArray;

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
    
    [self initLocalData];
    [self loadingContacts]; // 加载通讯录 学校信息
    return YES;
}
- (void)initLocalData
{
    //加载关注列表
    [self initConcernsData];
}
- (void)initConcernsData
{
    Account *acc = [AccountTool account];
    acc.userId = acc.ID;
    // 获取关注列表
    [RestfulAPIRequestTool routeName:@"getCorcernList" requestModel:acc useKeys:@[@"userId"] success:^(id json) {
        NSLog(@"获取用户关注列表成功 %@", json);
        if (json) {
            Concern* c = [Concern initWithPersonId:acc.ID AndConcernIds:json];
            FMDBSQLiteManager* fmdb = [FMDBSQLiteManager  shareSQLiteManager];
            [fmdb saveConcerns:c];
        }
    } failure:^(id errorJson) {
        NSLog(@"获取用户关注列表失败  %@", errorJson);
    }];
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
// 接受到本地通知调用
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    for (NSString * key in notification.userInfo.allKeys) {
        
        [DetailActivityShowController cancelLocalNotificationWithKey:key];
        
    }
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

}

-(void)applicationDidBecomeActive:(UIApplication *)application {
     application.applicationIconBadgeNumber = 0;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma Company and Contacts Info
- (void)loadingContacts { // 加载学校信息
    Account *account = [AccountTool account];
    [self getCompanyNameWithCid:account.cid]; // 获取学校信息
}

- (void)getCompanyNameWithCid:(NSString *)cid {
    NSLog(@"学校ID 为 %@",cid);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:cid forKey:@"companyId"];
    [RestfulAPIRequestTool routeName:@"getCompaniesInfos" requestModel:dic useKeys:@[@"companyId"] success:^(id json) {
        [self ismembermentJson:json Cid:cid];
        NSLog(@"获取的学校信息为  %@",json);
        
    } failure:^(id errorJson) {
        NSLog(@"%@", [errorJson objectForKey:@"msg"]);
    }];
}

- (void)ismembermentJson:(id)json Cid:(NSString *)cid
{
    NSDictionary *dic = [json objectForKey:@"company"];
    NSDictionary *infoDic = [dic objectForKey:@"info"];
    NSString *temp = [NSString stringWithFormat:@"来自 %@", [infoDic objectForKey:@"name"]];
    
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjects:@[RGBACOLOR(80, 125, 175, 1)] forKeys:@[NSForegroundColorAttributeName]];
    //    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:temp attributes:tempDic];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自 %@", [infoDic objectForKey:@"name"]]] ;
    NSInteger num = temp.length - 3;
    //    [attStr addAttributes:@{[UIColor orangeColor]} range:NSMakeRange(3, num)];
    [attStr setAttributes:tempDic range:NSMakeRange(3, num)];
    
    NSString *companyName = [attStr string];
    if (companyName.length != 0) {
        
        [self getcontactPersonsWithCid:cid comapnyName:companyName];  // 加载通讯录信息
        
    }
    NSLog(@"huoqudexuexiaoming %@",companyName);
}

- (void)getcontactPersonsWithCid:(NSString *)cid comapnyName:(NSString *)companyName {
    
    AddressBookModel *model = [[AddressBookModel alloc] init];
    [model setCompanyId:cid];
    [RestfulAPIRequestTool routeName:@"getCompanyAddressBook" requestModel:model useKeys:@[@"companyId"] success:^(id json) {
        NSLog(@"请求成功 %@",json);
        [self reloadWithJson:json companyName:companyName];
    } failure:^(id errorJson) {
        NSLog(@"请求失败 %@",[errorJson objectForKey:@"msg"]);
    }];
    
}

- (void)reloadWithJson:(id)json companyName:(NSString *)companyName {  // 将获取的 通讯录信息 和 学校信息 写入数据库
    if (!self.contactsArray) {
        self.contactsArray = [NSMutableArray arrayWithArray:json];
    }
    for (NSDictionary *dic in self.contactsArray) {
        Person *per = [[Person alloc] init];
        per.name = dic[@"realname"];
        per.imageURL = dic[@"photo"];
        per.userId = dic[@"_id"];
        if (companyName.length != 0) {
            per.companyName = companyName;
            
        } else {
            per.companyName = per.companyName;
        }
        [[FMDBSQLiteManager shareSQLiteManager] insertPerson:per];
    }
    
    
}




@end
