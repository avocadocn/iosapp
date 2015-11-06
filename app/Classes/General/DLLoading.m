//
//  DLLoading.m
//  app
//
//  Created by 申家 on 15/10/21.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "DLLoading.h"
#import <DGActivityIndicatorView.h>

static NSInteger timeNum = 0;
static DLLoading *load = nil;

@implementation DLLoading

- (void)loading
{
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        if (!load) {
//            load = [DLLoading alloc];
//        }
//        
//    });
//    
       
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![window viewWithTag:19921223]) {
        
        timeNum = 0;
        DGActivityIndicatorView *dga = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeFiveDots tintColor:RGBACOLOR(253, 185, 0, 1) size:40.0f];
        dga.frame = CGRectMake(DLScreenWidth / 2 - 40, DLScreenHeight / 2 - 40, 80.0f, 80.0f);
        dga.backgroundColor = RGBACOLOR(132, 123, 123, 0.52);
        
        [dga.layer setMasksToBounds:YES];
        [dga.layer setCornerRadius:10.0];
        dga.tag = 19921223;
        [window addSubview:dga];
        
        [dga startAnimating];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
}
- (void)timeAction:(NSTimer *)sender
{
    timeNum ++;
    if (timeNum == 3) {
        [DLLoading dismisss];
        [sender invalidate];
    }
}

+ (void)dismisss{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if ([window viewWithTag:19921223]) {
        
        DGActivityIndicatorView *dga = (DGActivityIndicatorView *)[window viewWithTag:19921223];
        
        [dga removeFromSuperview];
    }
}


@end
