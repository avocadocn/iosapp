//
//  DetailActivityShowController.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//  活动详情界面
#import "RestfulAPIRequestTool.h"
#import "DetailActivityShowController.h"
#import "DetailActivityShowView.h"
#import "interaction.h"

@interface DetailActivityShowController ()<DetailActivityShowViewDelegate>

@property (nonatomic, assign) NSInteger number;

@end

@implementation DetailActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.view setBackgroundColor:RGB(235.0, 234.0, 236.0)];
    if (self.model) {
        DetailActivityShowView *detailView = [[DetailActivityShowView alloc]initWithModel:self.model andButtonState:self.quitState];
        detailView.delegate = self;
        [self.view addSubview:detailView];
        
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotifications) name:@"KPOSTNAME" object:nil];
//    [self localNotifications];

}

-(void)sendRemindTime:(NSDate *)remindTime Theme:(NSString *)theme {
    [self localNotificationsWithDate:remindTime Theme:theme];
}
- (void)DetailActivityShowViewDismiss
{
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInteraction:(NSString *)interaction
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:interaction forKey:@"interactionId"];
    [dic setObject:self.interactionType forKey:@"interactionType"];
    
    [RestfulAPIRequestTool routeName:@"getInterDetails" requestModel:dic useKeys:@[@"interactionType", @"interactionId"] success:^(id json) {
        NSLog(@" 获得的求助详情微 %@", json);
        self.model = [[Interaction alloc]init];
        [self.model setValuesForKeysWithDictionary:json];
        
        DetailActivityShowView *detailView = [[DetailActivityShowView alloc]initWithModel:self.model andButtonState:NO];
        [self.view addSubview:detailView];

        
    } failure:^(id errorJson) {
        NSLog(@"获取求朱详情失败 %@",errorJson);
    }];
}
- (void)localNotificationsWithDate:(NSDate *)date Theme:(NSString *)theme {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {

        NSTimeInterval time = [date timeIntervalSinceNow];
        //设置本地时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
        
        notification.fireDate = fireDate; // 通知开始时间
        
//        notification.repeatInterval = NSCalendarUnitSecond; // 设置重复间隔
        
        notification.alertTitle = @"活动提醒";
        
        notification.alertBody = [NSString stringWithFormat:@"活动提醒:%@",theme]; // 通知提醒内容
        
        notification.applicationIconBadgeNumber = 0; //
        
        notification.alertAction = NSLocalizedString(@"", nil);
        
        notification.soundName = UILocalNotificationDefaultSoundName; // 通知提示音
        
        self.number += 1;
    
        NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:theme forKey:[NSString stringWithFormat:@"%ld",(long)self.number]];
        
        notification.userInfo = userInfoDic;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //

    }
        NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    NSLog(@"%lu",(unsigned long)localNotifications.count);
}

+ (void)cancelLocalNotificationWithKey:(NSString *)key {  // 删除对应的本地通知
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSArray *arry = notification.userInfo.allKeys;
        if ([arry containsObject:key]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    NSLog(@"%lu",(unsigned long)localNotifications.count);
}


@end
