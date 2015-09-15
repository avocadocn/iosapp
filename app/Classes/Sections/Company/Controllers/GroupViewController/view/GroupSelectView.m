//
//  GroupSelectView.m
//  app
//
//  Created by 申家 on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupSelectView.h"



@implementation GroupSelectView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title requite:(NSString *)requite
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterfaceAndTitle:(NSString *)title requite:(NSString *)requite];
    }
    return self;
    
}
- (void)builtInterfaceAndTitle:(NSString *)title requite:(NSString *)requite
{
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat num = self.frame.size.height - 20;
    
    self.tilteLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, num / 2.0)];
    self.tilteLabel.text = title;
    self.tilteLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.tilteLabel];
    
    
    self.requitLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 ,10 + num / 2.0, 200 ,num / 2.0)];
    self.requitLabel.text = requite;
    self.requitLabel.font = [UIFont systemFontOfSize:13];
    self.requitLabel.textColor = RGBACOLOR(155, 155, 155, 1);
    [self addSubview:self.requitLabel];
    
    self.switchLabel = [[UISwitch alloc]initWithFrame:CGRectMake(self.frame.size.width - 32 - 30, (self.frame.size.height - 20) / 2, 32, 20)];
    [self addSubview:self.switchLabel];
    
}








@end
