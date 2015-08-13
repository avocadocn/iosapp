//
//  AddressBookSqliteTool.h
//  app
//
//  Created by 张加胜 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface AddressBookSqliteTool : NSObject

/**
 *  根据请求参数去沙盒中加载缓存的微博数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params;

/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的微博数据
 */
+ (void)saveStatuses:(NSArray *)statuses;

@end
