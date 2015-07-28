//
//  RouteManager.h
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteManager : NSObject

/**
 *  获取单例的方法
 *
 *  @return return value description
 */
+ (RouteManager *)sharedManager;


@property (strong,nonatomic) NSMutableArray *routeArray;

@end
