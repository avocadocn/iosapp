//
//  RankDetileModel.m
//  app
//
//  Created by 申家 on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankDetileModel.h"

@implementation RankDetileModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
}

@end
