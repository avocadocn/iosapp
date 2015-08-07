//
//  UITextView+PlaceHolder.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>



@implementation UITextView (PlaceHolder)


- (void)placeHolderWithString:(NSString *)str
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    label.text = str;
    label.textColor = [UIColor colorWithWhite:.5 alpha:1];
    label.font = self.font;
    label.userInteractionEnabled = NO;
    [self addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top);
//        make.left.mas_equalTo(self.mas_left).offset(5);
//        make.size.mas_equalTo(CGSizeMake(100, 20));
//    }];
    [label setBackgroundColor:[UIColor redColor]];
    
    __block BOOL labelState = YES;
    
    [self.rac_textSignal subscribeNext:^(NSString *str) {
        if (str.length > 0 && labelState == YES ) {
            [label removeFromSuperview];
            labelState = NO;
        }
    }];
}







@end
