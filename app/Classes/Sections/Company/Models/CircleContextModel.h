//
//  CircleContextModel.h
//  app
//
//  Created by 申家 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AddressBookModel;

@interface CircleContextModel : NSObject

// 朋友圈单个消息

@property (nonatomic, copy)NSString *ID;  //消息 id

@property (nonatomic, copy)NSString *cid; //公司 id

@property (nonatomic, copy)NSString *content;  // 消息内容

@property (nonatomic, strong)NSMutableArray *photos;  //消息图片

@property (nonatomic, copy)NSString *postUserId; //消息发布者id

@property (nonatomic, copy)NSString *postDate;  // 消息时间

@property (nonatomic, copy)NSString *status; //消息状态

@property (nonatomic, strong)NSMutableArray *commentUsers;  //参与过评论的用户的id

//@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *kind;

@property (nonatomic, copy)NSString *__v;

@property (nonatomic, copy)NSString *latestCommentDate;

@property (nonatomic, strong)NSMutableArray *relativeCids;

@property (nonatomic, copy)NSString *targetContentId;

@property (nonatomic, strong)NSMutableArray *comments;

@property (nonatomic, strong)NSMutableArray *photo;

@property (nonatomic, strong)AddressBookModel *poster;

@property (nonatomic, strong)NSMutableDictionary *body;

@property (nonatomic, copy)NSString *contentId;

@property (nonatomic, strong)UIView *detileView;

@property (nonatomic, strong)AddressBookModel *target;


@property (nonatomic, copy)NSString *targetUserId;

@property (nonatomic, copy)NSString *postUserCid;

@property (nonatomic, copy)NSString *commentId;

@property (nonatomic, strong)NSNumber *isOnlyToContent;

@property (nonatomic, copy)NSString *posterId;

- (void)save;

- (instancetype)initWithString:(NSString *)string;

@end
