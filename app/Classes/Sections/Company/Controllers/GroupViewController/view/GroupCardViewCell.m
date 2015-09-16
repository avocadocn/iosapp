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
#import "UIImageView+DLGetWebImage.h"



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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.5;
    
    
    self.groupImageView = [UIImageView new];
    
    self.groupImageView.clipsToBounds = YES;
    self.groupImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.groupImageView];
    [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    self.groupIntroLabel = [UILabel new];
    self.groupIntroLabel.numberOfLines = 0;
    self.groupIntroLabel.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    [self addSubview:self.groupIntroLabel];
    [self.groupIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupImageView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.groupIntroLabel.font = [UIFont systemFontOfSize:14];
    self.groupIntroLabel.textAlignment = NSTextAlignmentCenter;
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)cellReconsitutionWithModel:(GroupCardModel *)model
{
    [self.groupImageView dlGetRouteWebImageWithString:model.logo placeholderImage:nil];
    self.groupIntroLabel.text = model.name;
}


@end
