//
//  AccountTool.h
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account;
@interface AccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(Account *)account;



/**
 *  返回账号信息
 *
 *  @return 账号模型(如果账号过期，则返回nil)
 */
+(Account *)account;

@end
