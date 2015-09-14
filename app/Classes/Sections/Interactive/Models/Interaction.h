//
//  Interaction.h
//  app
//
//  Created by 申家 on 15/8/25.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PollModel;


@interface Interaction : NSObject

@property (nonatomic, copy)NSNumber *type; //互动类型 1:'活动',2:'投票',3:'求助'
@property (nonatomic, copy)NSString *target;  // 目标的 id
@property (nonatomic, copy)NSString *relatedTeam;  //发起小队的 id
@property (nonatomic, copy)NSNumber *targetType;  // 目标类型 1:'个人',2:'群',3:'公司
@property (nonatomic, copy)NSString *templateId;  // 模板 id
@property (nonatomic, copy)NSString *inviters; // 邀请人列表
@property (nonatomic, strong)NSArray *photo;  // 照片f
@property (nonatomic, copy)NSString *theme; //主题
@property (nonatomic, copy)NSString *content;   //内容
@property (nonatomic, copy)NSString *endTime;  //结束时间
@property (nonatomic, copy)NSString *startTime; //开始时间
@property (nonatomic, copy)NSString *deadline;  //截止时间
@property (nonatomic, copy)NSString *remindTime; // 提醒时间
@property (nonatomic, copy)NSString *activityMold; // 活动必须?
@property (nonatomic, copy)NSString *location; // 地点
@property (nonatomic, copy)NSString *latitude;  // 维度
@property (nonatomic, copy)NSString *longitude;// 经度
@property (nonatomic, copy)NSString *memberMax; //最大人数
@property (nonatomic, copy)NSString *menberMin;  //最少人数
@property (nonatomic, strong)NSArray *option;  // 选项
@property (nonatomic, strong)NSArray *tag; //标签
@property (nonatomic, strong)NSDictionary *activity;
@property (nonatomic, copy)NSString *cid;
@property (nonatomic, copy)NSString * poster;
@property (nonatomic, strong)NSArray *photos;  // 取到的图片数组
@property (nonatomic, copy)NSString *createTime;  // 创建时间
@property (nonatomic, strong)NSArray *members;
@property (nonatomic, strong)PollModel *poll;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *interactionId; // 活动Id
@property (nonatomic, copy)NSString *userId; //
@property (nonatomic)NSNumber *interactionType;// 活动类型
@property (nonatomic, copy)NSString *commentId; // 评论id

@end
