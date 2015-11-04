//
//  UIImage+DLExtension.h
//  app
//
//  Created by tom on 15/11/3.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DLExtension)
/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;

@end
