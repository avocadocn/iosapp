//
//  SchoolTempModel.m
//  app
//
//  Created by 申家 on 15/9/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "SchoolTempModel.h"

@implementation SchoolTempModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"photo"] || [key isEqualToString:@"uri"]) {
        self.photo = value;
    }
    
}





@end
