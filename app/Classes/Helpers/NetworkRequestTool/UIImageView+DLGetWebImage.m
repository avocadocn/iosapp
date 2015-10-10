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

#define path [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]

@implementation UIImageView (DLGetWebImage)



/**
 *
 * 请求原图
 */

- (void)dlGetRouteWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image
{

    self.backgroundColor = ArcColor;
    NSString * newUrlStr = [self getUrlStringWithString:str];
    
    [self dlGetWebImageWithUrl:[NSURL URLWithString:newUrlStr] placeholderImage:image]; //请求网络图片
    
}

/**
 * 请求缩略图
 */

- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size
{
    NSString *newUrlStr = [self getUrlStringWithString:str];
    
    NSString *newStr = [newUrlStr  stringByAppendingString:[NSString stringWithFormat:@"/resize/%.f/%.f", size.width, size.height]];
    
    [self dlGetWebImageWithUrl:[NSURL URLWithString:newStr] placeholderImage:nil];
}
- (void)dlGetWebImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    // 先判断本地有没有此图
    
    BOOL localState = [self judgeLocalImage:url];
    if (localState) {
        
        self.image = [self readImageWithUrl:url];
        NSLog(@"本地有图片");
        
    } else {
        
        [self sd_setImageWithURL:url placeholderImage:image];
        NSLog(@"本地没图片");
        [RACObserve(self, self.image) subscribeNext:^(UIImage *image) {
            if (image) {
                NSLog(@"图片加载完毕 %@", self.image);
                [self saveImageWithUrl:url];
            }
        }];
    }
}

/**
 * 存图片
 */

- (void)saveImageWithUrl:(NSURL *)url
{
    NSString *str = [self getAddressWithUrl:url];
    NSData *data = UIImagePNGRepresentation(self.image);
    NSError *error = nil;
    
    [data writeToFile:str atomically:error];
    if (!error) {
        NSLog(@"保存图片成功");
    }
    
}
/**
 * 判断本地有没有图片
 */
- (BOOL)judgeLocalImage:(NSURL *)url
{
    NSString *str = [self getAddressWithUrl:url];
    NSFileManager *manger = [NSFileManager defaultManager];
    
    BOOL judge = [manger fileExistsAtPath:str];
    return judge;
}

/**
 * 读取本地的图片
 */

- (UIImage *)readImageWithUrl:(NSURL *)url
{
    
    NSData *data = [NSData dataWithContentsOfFile:[self getAddressWithUrl:url]];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"获取本地图片成功");
    return image;
}


- (NSString *)getUrlStringWithString:(NSString *)str
{
    if (![str hasPrefix:@"/"]) {
        str = [NSString stringWithFormat:@"/%@", str];
    }
    NSString *roude = [NSString stringWithFormat:@"%@", BaseUrl];  //字符串拼接
    
    NSString *urlStr = [roude stringByReplacingOccurrencesOfString:@"3002/v2_0" withString:[NSString stringWithFormat:@"3000%@", str]];
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    return newUrlStr;
}
- (NSString *)getAddressWithUrl:(NSURL *)url
{
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", url];
    NSArray *array = [str componentsSeparatedByString:@"/"];
    // 判断缩略图的大图存不存在
    NSString * temp = [array objectAtIndex:array.count - 3];
    if ([temp isEqualToString:@"resize"]) {
        
        NSString *returnStr = [NSString stringWithFormat:@"%@/%@%@", path, [array objectAtIndex:(array.count - 5)] ,[array objectAtIndex:array.count - 4]];
        
        NSLog(@"%@", returnStr);
        return returnStr;
    }
    
    NSString *returnStr = [NSString stringWithFormat:@"%@/%@%@", path, [array objectAtIndex:(array.count - 2)] ,[array lastObject]];

    NSLog(@"%@", returnStr);
    return returnStr;
}


@end
