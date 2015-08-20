//
//  VoteOptionsInfoModel.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteOptionsInfoModel : NSObject

/**
 *  选项名称
 */
@property (nonatomic, copy) NSString *optionName;

/**
 *  该选项的投票数
 */
@property (nonatomic, assign) NSInteger optionCount;

/**
 *  是否投过票
 */
@property (nonatomic, assign,getter=hasVoted) BOOL voted;

/**
 * model 中的 color
 */
@property (nonatomic, copy)UIColor *voteInfoColor;

@end
