//
//  CuntomFolderView.m
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//


#import "CuntomFolderView.h"

#import <Masonry.h>
#import <ReactiveCocoa.h>

@implementation CuntomFolderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInterface];
    }
    return self;
}

- (void)setInterface
{
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;  //文字偏左
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(75.0);
    }];
    
    self.informationTextField = [UITextField new];
    self.informationTextField.delegate = self;
    [self addSubview:self.informationTextField];
    self.informationTextField.userInteractionEnabled = NO;
    self.informationTextField.textAlignment = NSTextAlignmentCenter;
    
    [self.informationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.8]];
    [self.informationTextField addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.informationTextField.mas_bottom);
        make.left.mas_equalTo(self.informationTextField.mas_left);
        make.right.mas_equalTo(self.informationTextField.mas_right);
        make.height.mas_equalTo(.5);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.informationTextField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
