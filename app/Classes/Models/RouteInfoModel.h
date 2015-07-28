//
//  RouteInfoModel.h
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteInfoModel : NSObject

/**
 *  路由url
 */
@property (copy,nonatomic) NSString *routeURL;

/**
 *  路由名称
 */
@property (copy,nonatomic) NSString *routeName;

+ (instancetype)infoModelWithDict:(NSDictionary *)dict;
@end
