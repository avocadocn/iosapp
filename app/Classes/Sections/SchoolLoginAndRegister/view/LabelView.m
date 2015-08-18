//
//  LabelView.m
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LabelView.h"
#import <Masonry.h>

@implementation LabelView

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
    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor colorWithWhite:.5 alpha:1];
    
    [self addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(9.0));
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(DLMultipleWidth(45.0));
    }];
    
    [self setBackgroundColor:[UIColor whiteColor]];
}

@end
