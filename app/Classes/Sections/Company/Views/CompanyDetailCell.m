//
//  CompanyDetailCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyDetailCell.h"
#import <ReactiveCocoa.h>
#import "ColleagueViewController.h"
#import "CompanyViewController.h"


@implementation CompanyDetailCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}
- (void)builtInterface
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2, 0, DLScreenWidth/3.5 - 5, DLScreenWidth / 3.5 - 5)];
    CGFloat red = arc4random() % 100 / 100.0;
    CGFloat blue = arc4random() % 100 / 100.0;
    CGFloat green = arc4random() % 100 / 100.0;
    [view setBackgroundColor:[UIColor colorWithRed:red green:blue blue:green alpha:1]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewTapAction:)];
    [view addGestureRecognizer:tap];
    
    [self addSubview:view];

}

//通过 view 进行页面的跳转
- (void)ViewTapAction:(UITapGestureRecognizer *)tap
{
    
    
    
}
@end
