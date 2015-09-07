//
//  UILabel+DLTimeLabel.m
//  app
//
//  Created by 申家 on 15/9/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UILabel+DLTimeLabel.h"

@implementation UILabel (DLTimeLabel)


- (void)judgeTimeWithString:(NSString *)string
{
    
    NSDate *aNewDate = [self dateFromString:string];
    NSDate *tempDate = [self getNowDateFromatAnDate:[NSDate date]];
    NSTimeInterval sec = [tempDate timeIntervalSinceDate:aNewDate];
    NSLog(@"相差了 %f秒", sec);
    
    if (sec < 3600.00) {
        self.text = [NSString stringWithFormat:@"%.f分钟前", sec / 60];
    } else if (sec >= 3600 && [self compareDate:aNewDate]) // 今天
    {
        self.text = [NSString stringWithFormat:@"%@", [self getHourAndMinuteWithDate:aNewDate]];
    } else
    {
        self.text = [NSString stringWithFormat:@"%.f天前", sec / (24 * 60 * 60)];
    }
    
}
-(BOOL)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    //    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    //    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return YES;
    } else
    {
        return NO;
    }
}  // 判断是否为今天
- (NSString *)getHourAndMinuteWithDate:(NSDate *)date  // 得到小时和分钟
{
    NSString *str = [NSString stringWithFormat:@"%@", date];
    NSArray *array = [str componentsSeparatedByString:@" "];
    NSString *newStr = [array objectAtIndex:1];
    NSArray *newArray = [newStr componentsSeparatedByString:@":"];
    NSString *returnStr = [NSString stringWithFormat:@"%@:%@", [newArray firstObject], [newArray objectAtIndex:1]];
    return returnStr;
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSArray *array = [dateString componentsSeparatedByString:@"."];
    NSString *aNewStr = [array firstObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *localDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@Z", aNewStr]];    //  ＋0000 表示的是当前时间是个世界时间。
    
    NSLog(@"该朋友圈发送的时间为 %@", [self getNowDateFromatAnDate:localDate]);
    return [self getNowDateFromatAnDate:localDate];
}




@end
