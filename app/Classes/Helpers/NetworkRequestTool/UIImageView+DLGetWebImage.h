//
//  UIImageView+DLGetWebImage.h
//  app
//
//  Created by 申家 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface UIImageView (DLGetWebImage)

/**
 * 请求原始图
 */
- (void)dlGetRouteWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image;

/**
 * 请求指定大小的图，可指定是否刷新
 */
- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size NeedRefresh:(Boolean)needRefresh;

/**
 * 请求指定大小的图
 */
- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size;

- (void)dlGetLocalImageWithUrl:(NSString *)url size:(CGSize)size completed:(SDWebImageCompletionBlock)completedBlock;
@end
