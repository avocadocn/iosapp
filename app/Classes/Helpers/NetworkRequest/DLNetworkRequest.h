//
//  DLNetworkRequest.h
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

/*
 类的使用方法: 路由请求时
        参数  网址 (NSString) 输入要进行的网络请求在 RouteInfo.plist 文件里的 RouteName, 找到要请求的网址进行拼接
             请求类型 (NSString) POST  /   GET
              请求参数  POST: (NSDictionary)  key value 形式
                       GET: (NSArray)要使用的参数一一排列存进数组里
 
 RouteInfo.plist 文件的写法: POST 网址:http://192.168.2.109:3002/v2_0/users/login   存储/users/login 为routeURL
                            GET  网址:http://192.168.2.109:3002/v2_0/companies/53aa6fc011fd597b3e1be250
                                      存储/companies/parameter0  (把需要的参数按照 parameter(参数下标) 格式存进 routeURL 里)
 
 */

@protocol DLNetworkRequestDelegate <NSObject>

- (void)sendParsingWithDictionary:(NSDictionary *)dictionary;

@optional
- (void)sendErrorWithDictionary:(NSDictionary *)dictionary;


@end

@interface DLNetworkRequest : NSObject

@property (nonatomic, strong)NSDictionary *dictinary;

@property (nonatomic, assign)id <DLNetworkRequestDelegate>delegate;

@property (nonatomic, strong)NSArray *imageArray;

- (void)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters;

- (void)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters;

- (void)dlRouteNetWorkWithNetName:(NSString *)name andRequestType:(NSString *)type paramter:(id)paramter;


@end
