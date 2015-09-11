//
//  Singleton.m
//  app
//
//  Created by burring on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Singletons.h"

@implementation Singletons

+(Singletons *)shareSingleton {
    static Singletons *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[Singletons alloc] init];
    });
    return single;
}
@end
