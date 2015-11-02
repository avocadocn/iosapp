//
//  UILabel+DLSendLabel.m
//  header 编辑
//
//  Created by 申家 on 15/10/27.
//  Copyright © 2015年 申家. All rights reserved.
//

#import "UILabel+DLSendLabel.h"
static NSInteger num = 0;

static NSTimer *timer;

@implementation UILabel (DLSendLabel)

- (void)reload{
    num = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self  selector:@selector(timerSelect) userInfo:nil repeats:YES];
    
    [timer fire];
}

- (void)timerSelect{
    num ++;
    
    if (num == 30) {
        [timer invalidate];
    }
    
    NSMutableString *str =[NSMutableString stringWithFormat:@"%@", self.text];
    
    NSString *new = [str stringByPaddingToLength:4 withString:str startingAtIndex:0];
    NSInteger temp = num % 6;
    for (int i = 0; i < temp; i++) {
        new = [NSString stringWithFormat:@"%@.", new];
    }
    self.text = new;
    NSLog(@"%@", new);
    
}
//- (void)removeFromSuperview
//{
//    [self removeFromSuperview];
//    [timer invalidate];
//}

@end

