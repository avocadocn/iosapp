//
//  GroupCardViewCell.m
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupCardViewCell.h"
#import <Masonry.h>
#import "GroupCardModel.h"
#import <UIImageView+WebCache.h>



@implementation GroupCardViewCell

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
    self.groupImageView = [UIImageView new];
    [self addSubview:self.groupImageView];
    [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    self.colorView = [UIView new];
    [self addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupImageView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    self.groupIntroLabel = [UILabel new];
    self.groupIntroLabel.numberOfLines = 0;
    self.groupIntroLabel.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    [self addSubview:self.groupIntroLabel];
    [self.groupIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    
//    [self setBackgroundColor:[UIColor blackColor]];
    
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.cache.itlily.com/tdb/song/a5/60/1381978129.jpg"]]; // 图片
    CGFloat red = arc4random() % 100 / 100.0;
    CGFloat blue = arc4random() % 100 / 100.0;
    CGFloat green = arc4random() % 100 / 100.0;
    self.colorView.backgroundColor = [UIColor colorWithRed:red green:blue blue:green alpha:1];
    
    self.groupIntroLabel.text = @"空军建军节";
    self.groupIntroLabel.font = [UIFont systemFontOfSize:14];
    self.groupIntroLabel.textAlignment = NSTextAlignmentCenter;
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)cellReconsitutionWithModel:(GroupCardModel *)model
{
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]]; // 图片
    CGFloat red = arc4random() % 100 / 100.0;
    CGFloat blue = arc4random() % 100 / 100.0;
    CGFloat green = arc4random() % 100 / 100.0;
    self.colorView.backgroundColor = [UIColor colorWithRed:red green:blue blue:green alpha:1];
    
    self.groupIntroLabel.text = model.intro;
    
}

@end
