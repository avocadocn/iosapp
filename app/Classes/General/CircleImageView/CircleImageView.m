//
//  CircleImageView.m
//  DLDemo
//
//  Created by jason on 15/7/13.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "CircleImageView.h"

@interface CircleImageView()


@end
@implementation CircleImageView


+(instancetype)circleImageViewWithImage:(UIImage *)image diameter:(CGFloat)diameter{
    CircleImageView *cv = [[CircleImageView alloc]init];
    [cv setImage:image];
    
    [cv.layer setCornerRadius:diameter / 2];
    cv.layer.masksToBounds = YES;
    
    cv.size = CGSizeMake(diameter, diameter);
    return cv;
}

@end
