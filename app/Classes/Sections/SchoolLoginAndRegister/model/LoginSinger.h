//
//  LoginSinger.h
//  app
//
//  Created by 申家 on 15/8/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginSinger : NSObject

@property (nonatomic, copy)NSString *cid;  //学校 id

@property (nonatomic, copy)NSString *phone;  //手机号码

@property (nonatomic, copy)NSString *password;  //密码

@property (nonatomic, copy)NSString *name;  //姓名

@property (nonatomic, copy)NSNumber *gender;  //性别

@property (nonatomic, copy)NSString *enrollment;  //入学年份

@property (nonatomic, strong)UIImage *photo;   // 头像

+ (LoginSinger *)shareState;

@end
