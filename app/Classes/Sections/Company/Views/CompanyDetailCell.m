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
#import "UIImageView+DLGetWebImage.h"
#import "SchoolTempModel.h"
@interface CompanyDetailCell ()
@property (nonatomic, strong)UIImageView *showView;

@end


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
    self.showView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(109.0), DLMultipleWidth(109.0))];
    CGFloat red = arc4random() % 100 / 100.0;
    CGFloat blue = arc4random() % 100 / 100.0;
    CGFloat green = arc4random() % 100 / 100.0;
    [self.showView setBackgroundColor:[UIColor colorWithRed:red green:blue blue:green alpha:1]];
    self.showView.contentMode = UIViewContentModeScaleAspectFill;
    self.showView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewTapAction:)];
    [self.showView addGestureRecognizer:tap];
    
    [self addSubview:self.showView];

}

- (void)reloadDetilCell:(SchoolTempModel *)model
{
//    [self.showView dlGetRouteWebImageWithString:model.photo placeholderImage:nil];
    [self.showView dlGetRouteThumbnallWebImageWithString:model.photo placeholderImage:nil withSize:CGSizeMake(200, 200)];
    
}


//通过 view 进行页面的跳转
- (void)ViewTapAction:(UITapGestureRecognizer *)tap
{
    
}
@end
