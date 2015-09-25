//
//  ApertureView.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ApertureView.h"
#import <Masonry.h>
#import "UIImageView+DLGetWebImage.h"

@implementation ApertureView

// 自定义的带光圈的 view

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image withBorderColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterfaceWithImage:image withBorderColor:color];
    }
    return self;
}

- (void)builtInterfaceWithImage:(NSString *)image withBorderColor:(UIColor *)color{
//    UIView *newView = [UIView new];
//    
//    [self addSubview:newView];
//    
//    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.width - 6, self.frame.size.width - 6));
//    }];
    CGFloat width = (self.frame.size.width  - 6) / 2.0;
//
    
//    newView.frame = CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.width - 6);
    /*
    newView.layer.contents = (__bridge id)image.CGImage;
    newView.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    newView.layer.masksToBounds = YES;
    newView.layer.cornerRadius = (self.frame.size.width - 6) / 2.0;
    */
    
      
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.width - 6)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView dlGetRouteThumbnallWebImageWithString:image placeholderImage:nil withSize:CGSizeMake(200, 200)];
//    [imageView dlGetRouteWebImageWithString:image placeholderImage:nil];
    
    imageView.layer.masksToBounds = YES;
    
    imageView.layer.cornerRadius = width;
//    imageView.layer.borderWidth = 1;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];

     
    
    
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
