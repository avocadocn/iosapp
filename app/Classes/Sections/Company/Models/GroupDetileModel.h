//
//  GroupDetileModel.h
//  app
//
//  Created by 申家 on 15/9/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupDetileModel : NSObject

@property (nonatomic, assign)BOOL applyStatus;
@property (nonatomic, assign)BOOL active;
@property (nonatomic, assign)BOOL companyActive;
@property (nonatomic, assign)BOOL open;
@property (nonatomic, strong)NSArray *inviteMember;
@property (nonatomic, assign)BOOL __v;
@property (nonatomic, copy)NSString * cname;//上海大学;
@property (nonatomic, copy)NSString *ID;//55fa2d60d088b78466564f51;
@property (nonatomic, assign)BOOL hasValidate;
@property (nonatomic, strong)NSArray * member;
@property (nonatomic , strong)NSDictionary *score;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *cid;
@property (nonatomic, strong)NSArray *photoAlbumList;
@property (nonatomic, strong)NSNumber *leave;
@property (nonatomic, strong)NSArray *administrators;
@property (nonatomic, copy)NSString *leader;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, strong)NSArray *applyMember;
@property (nonatomic, copy)NSString *easemobld;

@end
