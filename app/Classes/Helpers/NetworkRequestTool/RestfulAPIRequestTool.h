//
//  RestfulAPIRequestTool.h
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestfulAPIRequestTool : NSObject


/**
 *  根据传入的路由名称 在路由表中获得对应名称的路由信息模型，并且传入请求模型，已经模型中需要提交的参数，和成功、失败后的block
 *
 *  @param routeName    路由名称
 *  @param requestModel 请求模型
 *  @param keysArray    需要传入的参数数组
 *  @param success      成功后的回调
 *  @param failure      失败后的回调
 */
+(void)routeName:(NSString *)routeName requestModel:(id)requestModel useKeys:(NSArray *)keysArray success:(void (^)(id json))success failure:(void (^)(id errorJson))failure;

@end
