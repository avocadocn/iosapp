//
//  VoteAnimatedOptionView.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoteOptionsInfoModel;

@interface VoteAnimatedOptionView : UIView

/**
 *  选择百分比  0~100
 */
@property (nonatomic, assign) NSInteger optionPercentage;

/**
 *  选项名称
 */
@property (nonatomic, strong) NSString *optionName;

@end
