//
//  PhotoShouCell.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PhotoShouCell.h"
#import "UIImageView+DLGetWebImage.h"
@interface PhotoShouCell ()<UIScrollViewDelegate>

@end

@implementation PhotoShouCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)settingUpImageViewWithImage:(id)image
{
    if ([image isKindOfClass:[NSString class]]) {
        [self.showImageView dlGetRouteThumbnallWebImageWithString:image placeholderImage:nil withSize:self.showImageView.size];
    }
    else
    {
        self.showImageView.image = image;
    }
//    self.showImageView.image = image;
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    scroll.maximumZoomScale = 3;
    scroll.alwaysBounceVertical = YES;
    CGFloat width = scroll.frame.size.width / self.showImageView.image.size.width; // scroll 与 image 的横比例
    CGFloat height = self.showImageView.image.size.height * width; // 根据比例算出高度
    scroll.delegate = self;
    
    self.showImageView.frame = CGRectMake(0, 0, scroll.frame.size.width, height);
    
    if (self.showImageView.frame.size.height > scroll.frame.size.height) { // 增加偏移量
        scroll.contentSize = CGSizeMake(0, self.showImageView.frame.size.height);
    }
    else {
    self.showImageView.center = scroll.center;  // 中心点设置
    }
    [scroll addSubview:self.showImageView];
    [self addSubview:scroll];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}

- (void)builtInterface
{
    self.showImageView = [UIImageView new];
    self.showImageView.userInteractionEnabled = YES;
    
}

@end
