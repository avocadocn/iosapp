//
//  getIntroModel.h
//  app
//
//  Created by 申家 on 15/8/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getIntroModel : NSObject

@property (nonatomic, copy)NSNumber *interactionType;

@property (nonatomic, copy)NSString *requestType;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *userId;

@property (nonatomic, copy)NSNumber *limit;

@property (nonatomic, copy)NSString *noticeType; // 消息类型

@property (nonatomic, copy)NSNumber *action;

@property (nonatomic, copy)NSNumber *interaction;

@property (nonatomic, assign)BOOL selectState;

@property (nonatomic, copy)NSString *noticeType;

@end
