//
//  CircleContextModel.m
//  app
//
//  Created by 申家 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CircleContextModel.h"

@implementation CircleContextModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
}


@end
