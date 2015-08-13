//
//  CommendPersonLabel.m
//  app
//
//  Created by 申家 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CommendPersonLabel.h"

@implementation CommendPersonLabel

- (instancetype)initWithId:(NSString *)str
{
    self = [super init];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)builtInterface
{
    self.textColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:1];
}

@end
