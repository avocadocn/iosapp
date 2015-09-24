//
//  UIImageView+DLGetWebImage.m
//  app
//
//  Created by 申家 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <ReactiveCocoa.h>
#import "UIImageView+DLGetWebImage.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (DLGetWebImage)

/**
 *
 * 请求原图
 */

- (void)dlGetRouteWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image
{
    NSString * newUrlStr = [self getUrlStringWithString:str];
    
    [self dlGetWebImageWithUrl:[NSURL URLWithString:newUrlStr] placeholderImage:image]; //请求网络图片
    
    
    
}

/**
 * 请求缩略图
 */

- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size
{
    NSString *newUrlStr = [self getUrlStringWithString:str];
    
    NSString *newStr = [newUrlStr stringByAppendingString:[NSString stringWithFormat:@"/resize/%.f/%.f", size.width, size.height]];
    
    [self dlGetWebImageWithUrl:[NSURL URLWithString:newStr] placeholderImage:nil];
}
- (void)dlGetWebImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image];
    
    
    
    RACSignal *imageAvailableSignal = [RACObserve(self, self.image) map:^id(id x){
        
        return x ? @YES : @NO;
    }];
    
}


- (NSString *)getUrlStringWithString:(NSString *)str
{
    if (![str hasPrefix:@"/"]) {
        str = [NSString stringWithFormat:@"/%@", str];
    }
    NSString *roude = [NSString stringWithFormat:@"%@", ROUDEADDRESS];  //字符串拼接
    
    NSString *urlStr = [roude stringByReplacingOccurrencesOfString:@"3002/v2_0" withString:[NSString stringWithFormat:@"3000%@", str]];
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    return newUrlStr;
}



@end
