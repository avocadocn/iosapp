//
//  RouteManager.m
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RouteManager.h"
#import "RouteInfoModel.h"
#import "RouteInfoModel.h"

@implementation RouteManager

static RouteManager *sharedRouteManagerInstance = nil;

static dispatch_once_t predicate;

+ (RouteManager *)sharedManager
{
    dispatch_once(&predicate, ^{
        sharedRouteManagerInstance = [[self alloc] init];
    });
    return sharedRouteManagerInstance;
}

-(NSMutableDictionary *)routeDict{
    if (_routeDict == nil) {
        _routeDict = [NSMutableDictionary dictionary];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"RouteInfo"  ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            RouteInfoModel *model = [RouteInfoModel infoModelWithDict:dict];
            [_routeDict setObject:model forKey:model.routeName];
        }
    }
    return _routeDict;
}



@end
