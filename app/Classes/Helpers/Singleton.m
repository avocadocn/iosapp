//
//  Singleton.m
//  app
//
//  Created by burring on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(Singleton *)shareSingleton {
    static Singleton *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[Singleton alloc] init];
    });
    return single;
}
@end
