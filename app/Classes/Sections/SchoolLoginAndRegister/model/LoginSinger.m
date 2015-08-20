//
//  LoginSinger.m
//  app
//
//  Created by 申家 on 15/8/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LoginSinger.h"

static LoginSinger *singer = nil;

@implementation LoginSinger

+ (LoginSinger *)shareState
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        if (!singer) {
            singer = [[LoginSinger alloc]init];
        }
    });
    return singer;
}




@end
