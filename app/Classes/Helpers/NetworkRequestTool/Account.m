//
//  Accout.m
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Account.h"

@implementation Account

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}

+(instancetype)accountWithDict:(NSDictionary *)dict{
    Account *account = [[Account alloc]init];
    return [account setKeyValues:dict];
}

// 归档的实现
MJCodingImplementation
@end
