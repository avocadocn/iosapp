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
 *  该选项的投票人数
 */
@property (nonatomic, assign) NSNumber* optionCount;

/**
 *  是否投过票
 */
@property (nonatomic, assign,getter=hasVoted) BOOL voted;

/**
 * model 中的 color
 */
@property (nonatomic, copy)UIColor *voteInfoColor;


/**
 *  投票Id
 */
@property (nonatomic, copy)NSString *interactionId;

/**
 * 用户 id
 */
@property (nonatomic, copy)NSString *userId;

/**
 * 投票用的 body
 */
@property (nonatomic, strong)NSNumber *index;

@end
