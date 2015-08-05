//
//  CompanyModel.h
//  app
//
//  Created by 申家 on 15/7/31.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic, copy)NSString *ID;  //公司 ID
@property (nonatomic, copy)NSString *address;  //详细地址
@property (nonatomic, copy)NSString *city; //城市
@property (nonatomic, copy)NSString *cover; //
@property (nonatomic, copy)NSString *district;   // 区
@property (nonatomic, copy)NSString *intro;    // 未知
@property (nonatomic, copy)NSString *logo;   // logo
@property (nonatomic, copy)NSString *memberNumber;   //公司成员数量
@property (nonatomic, copy)NSString *name;    //公司名称
@property (nonatomic, copy)NSString *province;   //省份
@property (nonatomic, copy)NSString *shortName;  //公司简称
@property (nonatomic, copy)NSString *sttaffInviteCode;  //给该公司用户的邀请码
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong)NSMutableArray *imageArray;

@property (nonatomic, copy)NSString *cid;


@end
