//
//  InformationModel.h
//  app
//
//  Created by 申家 on 15/10/13.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject<NSCoding>

/**
 *通知类型 1: 互动 2: 通知(礼物、入群、系统)
 */
@property (nonatomic, strong)NSNumber *noticeType;

@property (nonatomic, copy)NSString *ID;

/**
 * 1: 活动有人参加了、投票有人参与了、求助有人回答了
 * 2: 被邀请参加活动、投票、求助
 * 3: 求助的回答被采纳了
 * 4: 评论有回复
 * 5: 评论被赞了
 * 6: 被邀请进小队
 * 7: 入群申请被通过
 * 8: XX申请入X群，待处理(群主)
 * 9: XX申请入X群，已被其它管理员处理
 */
@property (nonatomic, copy)NSNumber *action;
@property (nonatomic, copy)NSString *sender;
@property (nonatomic, copy)NSString *receiver;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *__v;
@property (nonatomic, copy)NSString *team;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *interaction;
/**
 * 互动(包括评论)才有的属性 1: 活动 2: 投票 3: 求助
 */
@property (nonatomic, copy)NSString *interactionType;
/**
 * 相关人数,可能很多人回答、参加 (action为1、5、8)
 */
@property (nonatomic, copy)NSString *relativeCount;
/**
 * 是否查看
 */
@property (nonatomic, strong)NSNumber *examine;

- (void)deleteSelf:(NSString *)inforType;
- (void)save:(NSString *)inforType;
- (instancetype)initWithInforString:(NSString *)inforType andIDString:(NSString *)string;

@end
