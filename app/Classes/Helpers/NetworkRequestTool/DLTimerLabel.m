//
//  DLTimerLabel.m
//  app
//
//  Created by 申家 on 15/11/2.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "DLTimerLabel.h"

@interface DLTimerLabel ()

@property (nonatomic, assign)NSInteger num;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation DLTimerLabel

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
        
    }
    return self;
}

- (void)reload{
    self.num = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self  selector:@selector(timerSelect) userInfo:nil repeats:YES];
    
    [self.timer fire];
}

- (void)timerSelect{
    self.num ++;
    
    if (self.num == 30) {
        [self.timer invalidate];
        [self.superview removeFromSuperview];
    }
    
    NSMutableString *str =[NSMutableString stringWithFormat:@"%@", self.text];
    
    NSString *new = [str stringByPaddingToLength:4 withString:str startingAtIndex:0];
    NSInteger temp = self.num % 6;
    for (int i = 0; i < temp; i++) {
        new = [NSString stringWithFormat:@"%@.", new];
    }
    self.text = new;
    NSLog(@"%@", new);
}
- (void)removeFromSuperview
{
    [self.timer invalidate];
}
@end
