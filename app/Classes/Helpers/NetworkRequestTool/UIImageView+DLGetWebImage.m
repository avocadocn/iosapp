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

#define path [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CacheImage"]

@implementation UIImageView (DLGetWebImage)



/**
 *
 * 请求原图
 */

- (void)dlGetRouteWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image
{

    self.backgroundColor = ArcColor;
    NSString * newUrlStr = [self getUrlStringWithString:str];
//    [self dlGetWebImageWithUrl:[NSURL URLWithString:newUrlStr] placeholderImage:image]; //请求网络图片
    [self dlGetWebImageWithDefaultCacheWithUrl:[NSURL URLWithString:newUrlStr] placeholderImage:image];
}

/**
 * 请求指定大小的图，可指定是否刷新
 */
- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size NeedRefresh:(Boolean)needRefresh
{
    if(needRefresh){
        self.backgroundColor = ArcColor;
        // 得到网络请求的字符串
        NSString *newUrlStr = [self getUrlStringWithString:str];
        
        NSString *newStr = [newUrlStr  stringByAppendingString:[NSString stringWithFormat:@"/%.f/%.f", size.width, size.height]];
        
        //    [self dlGetWebImageWithUrl:[NSURL URLWithString:newStr] placeholderImage:image];
        [self dlGetWebImageWithDefaultCacheAndRefreshWithUrl:[NSURL URLWithString:newStr] placeholderImage:image];
    }else{
        [self dlGetRouteThumbnallWebImageWithString:str placeholderImage:image withSize:size];
    }
}

/**
 * 请求指定大小的图
 */
- (void)dlGetRouteThumbnallWebImageWithString:(NSString *)str placeholderImage:(UIImage *)image withSize:(CGSize)size
{
    self.backgroundColor = ArcColor;
    // 得到网络请求的字符串
    NSString *newUrlStr = [self getUrlStringWithString:str];
    
    NSString *newStr = [newUrlStr  stringByAppendingString:[NSString stringWithFormat:@"/%.f/%.f", size.width, size.height]];
    NSLog(@"the app path is :%@",path);
//    [self dlGetWebImageWithUrl:[NSURL URLWithString:newStr] placeholderImage:image];
    [self dlGetWebImageWithDefaultCacheWithUrl:[NSURL URLWithString:newStr] placeholderImage:image];
}

//直接使用第三方库的缓存
- (void)dlGetWebImageWithDefaultCacheWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image options:SDWebImageProgressiveDownload|SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
//直接使用第三方库的缓存,带刷新
- (void)dlGetWebImageWithDefaultCacheAndRefreshWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image options:SDWebImageProgressiveDownload|SDWebImageHighPriority|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

//自己进行图片的缓存
- (void)dlGetWebImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    // 先判断本地有没有此图
    
    BOOL localState = [self judgeLocalImage:url];
    if (localState) {
        
        self.image = [self readImageWithUrl:url];
        NSLog(@"本地有图片");
        self.backgroundColor = [UIColor clearColor];
        
    } else {
        NSLog(@"本地没有图片");
        [self sd_setImageWithURL:url placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self saveImageWithUrl:url];
            self.backgroundColor = [UIColor clearColor];
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
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExist=[manger fileExistsAtPath:path isDirectory:&isDir];
    if (!isExist&&!isDir) {
        BOOL CreateDir=[manger createDirectoryAtPath:path withIntermediateDirectories:FALSE attributes:nil error:nil];
        if (CreateDir) {
            NSLog(@"Create Dir OK!");
        }else{
            NSLog(@"Create Dir Failed!");
        }
    }
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", url];
    NSArray *array = [str componentsSeparatedByString:@"/"];
    // 判断缩略图的大图存不存在
    NSString * temp = [array lastObject];
    if ([temp componentsSeparatedByString:@"."].count==1) {// 请求的是缩略图的话
        
        NSString *returnStr = [NSString stringWithFormat:@"%@/%@%@%@%@", path,
                               [array objectAtIndex:(array.count - 2)],
                               [array lastObject],
                               [array objectAtIndex:(array.count - 4)] ,
                               [array objectAtIndex:array.count - 3]
                               ];
        
        NSLog(@"得到的地址为 %@",  returnStr);
        return returnStr;
    }
    
    NSString *returnStr = [NSString stringWithFormat:@"%@/%@%@", path, [array objectAtIndex:(array.count - 2)] ,[array lastObject]];

    NSLog(@"得到的地址为 %@", returnStr);
    return returnStr;
}


@end
