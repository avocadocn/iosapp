//
//  CircleImageView.m
//  DLDemo
//
//  Created by jason on 15/7/13.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*
 默认传入的图片为正方形
 */
-(void)setImg:(UIImage *)img{
    _img = img;
    self.image = img;
    CGFloat height = img.size.height;
    [self.layer setCornerRadius:height / 2];
    self.layer.masksToBounds = YES;
    self.width = height;
    self.height = height;
    // NSLog(@"%@",NSStringFromCGRect(self.frame));
    
}


@end
