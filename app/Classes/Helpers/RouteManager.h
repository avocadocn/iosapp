//
//  RouteManager.h
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RouteInfoModel;

/**
    RouteManager *mag = [RouteManager sharedManager];
    RouteInfoModel *model  = mag.routeDict[@"Login"];
    NSLog(@"%@",model.routeURL);
 */
@interface RouteManager : NSObject

/**
 *  获取单例的方法
 *
 *  @return 单例
 */
+ (RouteManager *)sharedManager;

- (RouteInfoModel *)getModelWithNetName:(NSString *)str;

@property (strong,nonatomic) NSMutableDictionary *routeDict;

@end
