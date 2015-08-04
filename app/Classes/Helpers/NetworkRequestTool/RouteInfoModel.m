//
//  RouteInfoModel.m
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RouteInfoModel.h"
#import <MJExtension.h>

@implementation RouteInfoModel



+(instancetype)infoModelWithDict:(NSDictionary *)dict{
    RouteInfoModel *model = [[RouteInfoModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"routeName:%@,routeUrl:%@,routeMethod:%@",self.routeName,self.routeURL,self.routeMethod];
}

@end
