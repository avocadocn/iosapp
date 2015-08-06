//
//  VoteOptionsView.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteOptionsView : UIView


/**
 *  选项模型数组
 */
@property (nonatomic, strong) NSArray *options;
/**
 *  参与投票的总人数
 */
@property (nonatomic, assign) NSInteger voteCount;

@end
