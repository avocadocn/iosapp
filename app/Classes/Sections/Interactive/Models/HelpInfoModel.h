//
//  HelpInfoModel.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpInfoModel : NSObject
/**
 *  发起互助人的姓名
 */
@property (nonatomic, copy) NSString *name;


/**
 *  发起互助的时间
 */
@property (nonatomic, copy) NSString *time;


/**
 *  头像Image的url
 */
@property (nonatomic, copy) NSString *avatarURL;


/**
 *  互助中图片的URL
 */
@property (nonatomic, copy) NSString *helpImageURL;


/**
 *  互助里的表述文字
 */
@property (nonatomic, copy) NSString *helpText;

@end
