//
//  DLNavBar.m
//  app
//
//  Created by 张加胜 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DLNavBar.h"
#import <HMSegmentedControl.h>

@interface DLNavBar()
@property (strong,nonatomic)HMSegmentedControl *control;

@end

@implementation DLNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSegmentedControl];
    }
    return self;
}


-(void)setupSegmentedControl{
    HMSegmentedControl *control = [[HMSegmentedControl alloc]initWithFrame:self.frame];
    control.sectionTitles = @[@"热门", @"活动", @"投票", @"求助"];
    control.selectedSegmentIndex = 1;
    control.backgroundColor = [UIColor clearColor];
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    control.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor] , NSFontAttributeName : font};
    
    //[control setSelectionIndicatorEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [control setSelectionIndicatorEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    control.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    control.selectionIndicatorColor = [UIColor orangeColor];
    control.selectionIndicatorHeight = 2.5;
    control.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    control.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [control setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"index change");
    }];
    [self addSubview:control];
    
    self.control = control;
    
}

@end
