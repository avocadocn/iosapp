//
//  ImageHolderView.m
//  app
//
//  Created by 申家 on 15/8/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//


#import "ImageHolderView.h"
#import <Masonry.h>

@implementation ImageHolderView

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceHolder:(NSString *)placeHolder
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtWithImage:image andPlaceHolder:placeHolder];
    }
    return self;
}

- (void)builtWithImage:(UIImage *)image andPlaceHolder:(NSString *)placeHolder
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    imageView.image = image;
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(9.0));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(30.0), DLMultipleHeight(30.0)));
    }];
    
    self.textfield = [UITextField new];
    self.textfield.font = [UIFont systemFontOfSize:15];
    self.textfield.placeholder = placeHolder;
    [self.textfield placeholder];
    [self addSubview:self.textfield];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(imageView.mas_right).offset(DLMultipleWidth(10.0));
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(imageView.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
}

@end
