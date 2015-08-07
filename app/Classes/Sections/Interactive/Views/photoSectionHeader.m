//
//  photoHeader.m
//  ICover
//
//  Created by 太阳 on 15/6/27.
//  Copyright (c) 2015年 三人. All rights reserved.
//

#import "photoSectionHeader.h"

@implementation photoSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}
- (void)builtInterface
{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 220, 25)];
    [self.label setBackgroundColor:[UIColor orangeColor]];
    [self.label setBackgroundColor: [UIColor clearColor]];
    
    [self addSubview:self.label];
}

@end
