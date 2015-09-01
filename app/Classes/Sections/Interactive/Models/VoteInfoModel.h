//
//  VoteInfoModel.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteInfoModel : NSObject

/**
 *  发起投票人的姓名
 */
@property (nonatomic, copy) NSString *name;


/**
 *  发起投票的时间
 */
@property (nonatomic, copy) NSString *time;


/**
 *  头像Image的url
 */
@property (nonatomic, copy) NSString *avatarURL;


/**
 *  投票中图片的URL
 */
@property (nonatomic, copy) NSString *voteImageURL;


/**
 *  投票里的表述文字
 */
@property (nonatomic, copy) NSString *voteText;


/**
 *  存放VoteOptionsInfoModel
 */
@property (nonatomic, strong) NSMutableArray *options;


/**
 *  参与投票的总人数
 */
@property (nonatomic, assign) NSInteger voteCount;

/**
 *是否点击过投票
 */
@property (nonatomic, assign)BOOL judgeVote;

@end
