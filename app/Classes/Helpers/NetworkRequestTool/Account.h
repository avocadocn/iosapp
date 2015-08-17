//
//  Accout.h
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject


/**
 *  邮箱
 */
@property(nonatomic,copy) NSString *email;

/**
 *  密码
 */
@property(nonatomic,copy) NSString *password;


/**
 *  公司id
 */
@property(nonatomic,copy) NSString *cid;

/**
 *  用户id
 */
@property(nonatomic,copy) NSString *ID;

/**
 *  用户角色
 */
@property(nonatomic,copy) NSString *role;

/**
 *  登陆成功获得的token
 */
@property(nonatomic,copy) NSString *token;



+(instancetype)accountWithDict:(NSDictionary *)dict;
@end