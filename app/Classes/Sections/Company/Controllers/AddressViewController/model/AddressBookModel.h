//
//  AddressBookModel.h
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CompanyModel;


@interface AddressBookModel : NSObject<NSCoding>
@property (nonatomic, assign)BOOL attentState;
@property (nonatomic, copy)NSString *ID;// (string): 用户id ,
@property (nonatomic, copy)NSString *email;// (string, optional): 用户邮箱 ,
@property (nonatomic, copy)NSString *nickname;// (string): 昵称 ,
@property (nonatomic, copy)NSString *photo;// (string): 头像url ,
@property (nonatomic, copy)NSString *realname;// (string, optional): 真实姓名 ,
@property (nonatomic, strong)NSDictionary *department;// (Inline Model 1, optional): 部门 ,       _id   name
@property (nonatomic, copy)NSString *sex;// (string, optional): 性别 = ['男', '女'],
@property (nonatomic, copy)NSString *birthday;// (string, optional): 生日 ,
@property (nonatomic, copy)NSString *bloodType;// (string, optional): 血型 ,
@property (nonatomic, copy)NSString *introduce;// (string, optional): 简介 ,
@property (nonatomic, copy)NSString *registerDate;// (string, optional): 注册时间 ,
@property (nonatomic, copy)NSString *phone;// (string, optional): 电话号码 ,
@property (nonatomic, copy)NSString *qq;// (string, optional): QQ ,
@property (nonatomic, strong)CompanyModel *company;// (Inline Model 2, optional): 公司 ,     _id name  briefName
@property (nonatomic, copy)NSString *score;// (number, optional): 积分 ,
@property (nonatomic, strong)NSArray *tids;// (Array[string], optional): 小队id数组 ,
@property (nonatomic, copy)NSString *lastCommentTime;// (string, optional): 上次发表评论的时间 ,
@property (nonatomic, strong)NSArray *tags;// (Array[string], optional): 个人标签
@property (nonatomic, strong)NSString *companyId;
@property (nonatomic, copy)NSString *userId;// 个人资料
@property (nonatomic, copy)NSString *originPassword;  // 原始密码
@property (nonatomic, copy)NSString *password; // 修改过后的密码
@property (nonatomic, copy)NSString *gender; //
@property (nonatomic, strong)NSArray *phoneNumber;// 邀请人的电话号码
@property (nonatomic, copy)NSDate *latestContentDate;
@property (nonatomic, copy)NSDate *lastContentDate;
@property (nonatomic)float limit;
@property (nonatomic, assign)BOOL selectState;
@property (nonatomic, copy)NSString *company_official_name;


- (void)save;
- (instancetype)initWithString:(NSString *)string;
@end
