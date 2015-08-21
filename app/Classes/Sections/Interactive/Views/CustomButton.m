//
//  CustomButton.m
//  DWBubbleMenuButtonExample
//
//  Created by 申家 on 15/8/21.
//  Copyright (c) 2015年 Derrick Walker. All rights reserved.
//

#import "CustomButton.h"
#import <Masonry.h>
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)builtInterface{
    self.myLabel = [UILabel new];
    self.myLabel.textAlignment = NSTextAlignmentRight;
    self.myLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.myLabel];
    
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-self.frame.size.height);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    self.coriusImage = [UIImageView new];
    self.coriusImage.backgroundColor = RGBACOLOR(253, 185, 0, 1);
    self.coriusImage.layer.masksToBounds = YES;
    self.coriusImage.layer.cornerRadius = self.frame.size.height / 2.0;
    
    [self addSubview:self.coriusImage];
    [self.coriusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.myLabel.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)reloarWithString:(NSString *)str andImage:(UIImage *)image
{
    self.myLabel.text = str;
    self.coriusImage.image = image;
}




@end
