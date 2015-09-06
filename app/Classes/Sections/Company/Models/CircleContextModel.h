//
//  CircleContextModel.h
//  app
//
//  Created by 申家 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleContextModel : NSObject


// 朋友圈单个消息

@property (nonatomic, copy)NSString *ID;  //消息 id

@property (nonatomic, copy)NSString *cid; //公司 id

@property (nonatomic, copy)NSString *content;  // 消息内容

@property (nonatomic, strong)NSMutableArray *photos;  //消息图片

@property (nonatomic, copy)NSString *postUserId; //消息发布者id

@property (nonatomic, copy)NSString *postDate;  // 消息时间

@property (nonatomic, copy)NSString *status; //消息状态

@property (nonatomic, copy)NSArray *commentUsers;  //参与过评论的用户的id

//@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *__v;

@property (nonatomic, copy)NSString *latestCommentDate;

@property (nonatomic, strong)NSMutableArray *relativeCids;

@property (nonatomic, strong)NSMutableArray *comments;

@property (nonatomic, strong)NSMutableArray *photo;

@end
