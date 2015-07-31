//
//  UserDataTon.h
//  app
//
//  Created by 申家 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataTon : NSObject

@property (nonatomic, copy)NSString *company_cid;
@property (nonatomic, copy)NSString *company_uid;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *user_token;


+ (UserDataTon *)shareState;

@end
