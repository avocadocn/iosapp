//
//  PhotoShouCell.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PhotoShouCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "UIScrollView+DLTouch.h"

#define window [UIApplication sharedApplication].keyWindow

@interface PhotoShouCell ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UILabel *downloadPro;

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
    NSLog(@"传过来的 imageurl 为%@", image);
    NSArray *array = [image componentsSeparatedByString:@"/_"];
    
    NSString *last = [array lastObject];
    if ([image isKindOfClass:[NSString class]]) {
        
        NSArray *lastArray = [last componentsSeparatedByString:@"/"];
        CGFloat one = [lastArray[0] floatValue];
        CGFloat two = [lastArray[1] floatValue];
        
        [self.showImageView dlGetLocalImageWithUrl:[array firstObject] size:CGSizeMake(one, two) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self reloadImage:image];
            }
        }];
    }
    else
    {
        self.showImageView.image = image;
    }
    
    SDWebImageManager *manger = [SDWebImageManager sharedManager];
    
    [manger downloadImageWithURL:[NSURL URLWithString:[self getUrlStringWithString:[array firstObject]]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat num =   (CGFloat)receivedSize  / (CGFloat)expectedSize  * 100;
        self.downloadPro.text = [NSString stringWithFormat:@"%.f", num];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [self reloadImage:image];
        }
            [self.downloadPro removeFromSuperview];
    }];
    
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}

- (void)builtInterface
{

    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    
    
    self.showImageView = [UIImageView new];
    self.showImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    ap.numberOfTapsRequired = 2;
    [self.showImageView addGestureRecognizer:ap];
    
    
//    UITapGestureRecognizer *apap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(apImageAction:)];
//    apap.numberOfTapsRequired = 1;
//    [self.showImageView addGestureRecognizer:apap];
    
    
    self.downloadPro = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.downloadPro.backgroundColor = [UIColor colorWithWhite:.2 alpha:.5];
    self.downloadPro.layer.masksToBounds = YES;
    self.downloadPro.layer.cornerRadius = 20;
    self.downloadPro.textAlignment = NSTextAlignmentCenter;
    self.downloadPro.center = window.center;
    self.downloadPro.textColor = [UIColor whiteColor];
    self.scroll.maximumZoomScale = 3;
    self.scroll.alwaysBounceVertical = YES;
    self.scroll.delegate = self;
    [self.scroll addSubview:self.showImageView];
    self.scroll.contentSize = CGSizeMake(DLScreenWidth, 0);
    [self addSubview:self.scroll];
    [self addSubview:self.downloadPro];
    [self bringSubviewToFront:self.downloadPro];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    NSTimeInterval delay = 1;
    
    NSLog(@"%ld", touch.tapCount);
    
}

- (void)apImageAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"时尚  %ld %ld", sender.numberOfTapsRequired, sender.numberOfTouchesRequired );
    
}

- (void)imageAction:(UITapGestureRecognizer *)sender
{
    float newScale = 1;
    
    switch ((int)self.scroll.zoomScale) {
        case 1:
            newScale = self.scroll.zoomScale * 2.0;
            break;
        default:
            break;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];
    [self.scroll zoomToRect:zoomRect animated:YES];
    
}

- (void)reloadImage:(UIImage *)image{
    self.showImageView.image = image;
    CGFloat width = self.scroll.frame.size.width / self.showImageView.image.size.width; // scroll 与 image 的横比例
    CGFloat height = self.showImageView.image.size.height * width; // 根据比例算出高度
    
    self.showImageView.frame = CGRectMake(0, 0, self.scroll.frame.size.width, height);
    self.showImageView.center = window.center;
    if (self.showImageView.frame.size.height > self.scroll.frame.size.height) { // 增加偏移量
//        self.scroll.contentSize = CGSizeMake(DLScreenWidth, height);
        }
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (self.scroll == scrollView) {
//        NSArray *array = scrollView.subviews;
//        for (UIScrollView *scr in array) {
//            if ([scr isKindOfClass:[UIScrollView class]]) {
//                [scr setZoomScale:1.0f];
//            }
//        }
//    }
    scrollView.zoomScale = 1.0f;

}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

@end
