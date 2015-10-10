//
//  GroupCardModel.h
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupCardModel : NSObject<NSCoding>

@property (nonatomic, copy)NSString *brief;  // 简介
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, assign)BOOL isMember;  // 是否为群成员

@property (nonatomic, assign)BOOL allInfo;






@end
