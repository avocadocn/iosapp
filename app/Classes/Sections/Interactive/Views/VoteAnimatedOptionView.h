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
 *  选项条上的按钮
 */
@property (nonatomic, strong) UIButton *button;


/**
 *  选择百分比  0~100
 */
@property (nonatomic, assign) NSNumber *optionPercentage;

/**
 *  选项名称
 */
@property (nonatomic, copy) NSString *optionName;
/**
 * votecolor
 */
@property (nonatomic, copy)UIColor *voteViewColor;
/**
 *  选择的人数
 */
@property (nonatomic, assign)NSNumber *optionCount;

/**
 *点击过投票的搭建页面
 */
- (void)builtInterfaceWithInter:(NSNumber *)num;


@end
