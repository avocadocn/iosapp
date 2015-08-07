//
//  optionsView.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//


#import "optionsView.h"
#import <Masonry.h>


@implementation optionsView


/**
*
*
*初始化赋予其 tag 值来搭建界面与找到其子视图
*
*
*/


- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterfaceWithTag:tag];
    }
    return self;
}

- (void)builtInterfaceWithTag:(NSInteger)tag
{
    self.tag = tag;
    NSString *str = [NSString stringWithFormat:@"%ld", tag];
    self.optionTagLabel = [UILabel new];
    self.optionTagLabel.text = str;
    self.optionTagLabel.font = [UIFont systemFontOfSize:15];
    self.optionTagLabel.textColor = [UIColor colorWithWhite:.5 alpha:.8];
    self.optionTagLabel.textAlignment = NSTextAlignmentCenter;
    self.optionTagLabel.layer.masksToBounds = YES;
    self.optionTagLabel.layer.borderWidth = 1;
    self.optionTagLabel.layer.borderColor = [UIColor colorWithWhite:.5 alpha:.8].CGColor;
    
    self.optionTagLabel.layer.cornerRadius = DLMultipleWidth((20 / 2.0));
    
    [self addSubview:self.optionTagLabel];
    
    
    [self.optionTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(20.0), DLMultipleWidth(20.0)));
    }];
    
    self.optionTextField = [UITextField new];
    self.optionTextField.placeholder = @"输入选项";
    [self.optionTextField placeholder];
    self.optionTextField.textAlignment = NSTextAlignmentLeft;
    self.optionTextField.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.optionTextField];
    
    [self.optionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.optionTagLabel.mas_right).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
    
}












@end
