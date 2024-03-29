//
//  CriticWordView.m
//  app
//
//  Created by 申家 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CriticWordView.h"
#import <Masonry.h>

@implementation CriticWordView

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
    self.userInteractionEnabled = YES;
    self.criticIamge = [UIImageView new];
    self.criticIamge.userInteractionEnabled = YES;
    [self addSubview:self.criticIamge];
    
    [self.criticIamge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(79.0));
        make.width.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.criticText = [UILabel new];
    self.criticText.userInteractionEnabled = YES;
    self.criticText.textColor = [UIColor colorWithWhite:.5 alpha:1];
//    [self.criticText setBackgroundColor:[UIColor greenColor]];
    self.criticText.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.criticText];
    
    [self.criticText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.criticIamge.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.criticIamge.mas_right).offset(self.height + 5);
        make.bottom.mas_equalTo(self.criticIamge.mas_bottom);
    }];
    
}


@end
