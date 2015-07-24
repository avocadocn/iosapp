//
//  PaggingScrollView.m
//  app
//
//  Created by 张加胜 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PaggingScrollView.h"

@interface PaggingScrollView()
{
    /**
     *  左滑返回区域
     */
    CGRect _rect;
}

@end

@implementation PaggingScrollView



-(instancetype)initWithFrame:(CGRect)frame{
    
    _rect = CGRectMake(frame.origin.x, frame.origin.y, 13.0, frame.size.height);
    return [super initWithFrame:frame];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 判断点是否在左滑返回区域内
    if (CGRectContainsPoint(_rect, point)) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}


@end
