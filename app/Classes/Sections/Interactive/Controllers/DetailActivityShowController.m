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
//- (void)localNotifications {
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    if (notification) {
//        NSDate *currentDate = [self getParsedDateStringFromString:self.model.remindTime];
//        notification.fireDate = currentDate; // 通知开始时间
//        //            notification.repeatInterval = NSCalendarUnitSecond; // 设置重复间隔
//        notification.alertBody = self.model.theme; // 通知提醒内容
//        //        notification.applicationIconBadgeNumber = 0; //
//        //        notification.alertAction = NSLocalizedString(@"", nil);
//        notification.soundName = UILocalNotificationDefaultSoundName; // 通知提示音
//        NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:@"inteaction" forKey:@"key"];
//        notification.userInfo = userInfoDic;
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //
//    }
//}
//- (NSDate*)getParsedDateStringFromString:(NSString*)dateString
//{
//    if (dateString==nil) {
//        return nil;
//    }
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
//    NSDate * date = [formatter dateFromString:dateString];
//    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
//    //    NSString* str = [formatter stringFromDate:date];
//    //设置源日期时区
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
//    //    str = [formatter stringFromDate:destinationDateNow];
//    
//    return destinationDateNow;
//}
//
//+ (void)cancelLocalNotificationWithKey:(NSString *)key {
//    // 获取所有本地通知数组
//    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
//    
//    for (UILocalNotification *notification in localNotifications) {
//        NSDictionary *userInfo = notification.userInfo;
//        if (userInfo) {
//            // 根据设置通知参数时指定的key来获取通知参数
//            NSString *info = userInfo[key];
//            
//            // 如果找到需要取消的通知，则取消
//            if (info != nil) {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                break;
//            }
//        }
//    }
//    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//}
//

@end
