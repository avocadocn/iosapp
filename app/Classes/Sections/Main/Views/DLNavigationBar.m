//
//  DLNavigationBar.m
//  app
//
//  Created by 张加胜 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DLNavigationBar.h"

@implementation DLNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *view in self.subviews) {
            
        }
        
        UIView *view = [[UIView alloc]init];
        [view setFrame:CGRectMake(0, 0, DLScreenWidth, 44)];
        [view setBackgroundColor:[UIColor redColor]];
        [self insertSubview:view atIndex:0];
     
        
    }
    return self;
}

@end
