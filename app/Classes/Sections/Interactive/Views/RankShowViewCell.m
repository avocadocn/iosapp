//
//  RankShowViewCell.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankShowViewCell.h"

@implementation RankShowViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 40, 40)];
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

@end
