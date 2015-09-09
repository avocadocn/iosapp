//
//  Interaction.m
//  app
//
//  Created by 申家 on 15/8/25.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Interaction.h"

@implementation Interaction


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.interactionId = value;
        self.ID = value;
    }
}




@end
