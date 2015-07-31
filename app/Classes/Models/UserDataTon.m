//
//  UserDataTon.m
//  app
//
//  Created by 申家 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UserDataTon.h"


static UserDataTon *userData = nil;

@implementation UserDataTon

+ (UserDataTon *)shareState
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!userData) {
            userData = [[UserDataTon alloc]init];
        }
    });
    return userData;
}


@end
