//
//  FixTemplateRouteTool.h
//  app
//
//  Created by 张加胜 on 15/7/31.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
/**
 *  该类的作用的替换restful api 中的占位符,默认使用同名的参数
 */
#import <Foundation/Foundation.h>

@interface FixTemplateRouteTool : NSObject


/**
 *  根据传入的模板urlString 跟model urlString中需要的参数从model中取出来，然后拼接urlString
 *
 *  @param templateRoute 模板urlString
 *  @param modelObject   模型数据
 *
 *  @return 拼接完成后的urlString
 */
+(NSString *)routeWithTemplate:(NSString *)templateRoute parameterModel:(id)modelObject;

/**
 *  根据模板urlString 和model 获得该请求中所有的请求参数的键值对
 *
 *  @param templateRoute 模板urlString
 *  @param modelObject   模型数据
 *
 *  @return 参数字典
 */
+(NSDictionary *)routeParamsDictionaryWithTemplate:(NSString *)templateRoute parameterModel:(id)modelObject;
@end
