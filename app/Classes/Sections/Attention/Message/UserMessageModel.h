//
//  UserMessageModel.h
//  app
//
//  Created by 张加胜 on 15/8/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessageModel : NSObject

/**
 *  消息内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  text的高度
 */
@property (nonatomic, assign) CGFloat textHeight;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  转发后的黑色背景（只在转发model中该属性才有值）
 */
@property (nonatomic, assign) CGFloat textBackgroundHeight;

/**
 *  转发消息
 */
@property (nonatomic, strong) UserMessageModel *retweedMessage;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *interaction;



@end
