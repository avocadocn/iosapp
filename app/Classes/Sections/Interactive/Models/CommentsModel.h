//
//  VoteCommentsModel.h
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject


/**
 *  昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatarUrl;
/**
 *  评论
 */
@property (nonatomic, copy) NSString *content;


@property (nonatomic, copy) NSString *posterId; // 评论者id

@property (nonatomic, copy) NSString *posterCid;

@property (nonatomic, copy) NSString *approveCount;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *_id; // 评论内容id

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, strong) NSNumber *interactionType;

@property (nonatomic, copy) NSString *interactionId;

@property (nonatomic, copy) NSString *userId;

@end
