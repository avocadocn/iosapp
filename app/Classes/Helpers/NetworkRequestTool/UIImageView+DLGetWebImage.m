//
//  UIImageView+DLGetWebImage.m
//  app
//
//  Created by 申家 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UIImageView+DLGetWebImage.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (DLGetWebImage)

- (void)dlGetRouteWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image
{
    if (![str hasPrefix:@"/"]) {
        str = [NSString stringWithFormat:@"/%@", str];
    }
    NSString *roude = [NSString stringWithFormat:@"%@", ROUDEADDRESS];  //字符串拼接
    
    NSString *urlStr = [roude stringByReplacingOccurrencesOfString:@"3002/v2_0" withString:[NSString stringWithFormat:@"3000%@", str]];
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    [self dlGetWebImageWithUrl:[NSURL URLWithString:newUrlStr] placeholderImage:image]; //请求网络图片
}

- (void)dlGetWebImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image];
}

@end
