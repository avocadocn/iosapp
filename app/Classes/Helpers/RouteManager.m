//
//  RouteManager.m
//  app
//
//  Created by 张加胜 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RouteManager.h"
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

-(NSMutableArray *)routeArray{
    if (_routeArray == nil) {
        _routeArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"RouteInfo"  ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            RouteInfoModel *model = [RouteInfoModel infoModelWithDict:dict];
            [_routeArray addObject:model];
        }
    }
    return _routeArray;
}



@end
