//
//  CircleCommentModel.h
//  app
//
//  Created by 申家 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleCommentModel : NSObject


@property (nonatomic, copy)NSString *_id; //(string): 评论id ,
@property (nonatomic, copy)NSString * kind;// (string): 类型 ,
@property (nonatomic, copy)NSString *content;// (string, optional): 评论内容 ,
@property (nonatomic, copy)NSString *isOnlyToContent;// (boolean): 回复对象 ,
@property (nonatomic, copy)NSString * targetContentId;// (string): 评论目标消息的id ,
@property (nonatomic, copy)NSString * targetUserId;// (string): 评论目标用户的id ,
@property (nonatomic, copy)NSString * postUserCid;// (string): 发评论或赞的用户的公司id ,
@property (nonatomic, copy)NSString * postUserId;// (string): 发评论或赞的用户的id ,
@property (nonatomic, copy)NSString * postDate;// (string): 发评论时间 ,
@property (nonatomic, copy)NSString * status;// (string): 消息状态

@end
