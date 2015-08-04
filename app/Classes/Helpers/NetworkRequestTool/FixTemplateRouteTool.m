//
//  FixTemplateRouteTool.m
//  app
//
//  Created by 张加胜 on 15/7/31.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FixTemplateRouteTool.h"
#import <SOCKit.h>


@implementation FixTemplateRouteTool

/**
 *  传入一个模板routeUrl和一个模板参数的dict
 *
 *  @param templateRoute 模板url
 *  @param params        参数dict
 *
 *  @return 替换模板中参数后的urlstring
 */
+(NSString *)routeWithTemplate:(NSString *)templateRoute parameters:(NSDictionary *)params{
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:templateRoute];
    NSDictionary *ranges = [self makeAllPlaceHoldersRangeWithString:templateRoute];
    [ranges enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSValue *obj, BOOL *stop) {
        NSRange range = [obj rangeValue];
        
        if ([params.allKeys indexOfObject:key] == NSNotFound) {
            NSException *exception = [NSException exceptionWithName:@"ParamsNoMatchException" reason:[NSString stringWithFormat:@"route模板%@中未找到key(%@)，请检查传入参数是否匹配",templateRoute,key] userInfo:nil];
            @throw exception;
        }
        
        NSString *paraValue = [params valueForKey:key];
        if ([[params valueForKey:key] isKindOfClass:[NSNumber class]]) {
            paraValue = [NSString stringWithFormat:@"%zd",[(NSNumber *)([params valueForKey:key]) integerValue] ];
        }
        [mutableStr replaceCharactersInRange:range withString:[params valueForKey:key]];
    }];
    return mutableStr;
}



+(NSString *)routeWithTemplate:(NSString *)templateRoute parameterModel:(id)modelObject{
    SOCPattern *pattern = [SOCPattern patternWithString:templateRoute];
    return [pattern stringFromObject:modelObject];;
}


+(NSDictionary *)routeParamsDictionaryWithTemplate:(NSString *)templateRoute parameterModel:(id)modelObject{
    SOCPattern *pattern = [SOCPattern patternWithString:templateRoute];
    NSString *sourceString = [pattern stringFromObject:modelObject];
    return [pattern parameterDictionaryFromSourceString:sourceString];
    
}



/**
 *  根据一个带有placeholder的urlstring 返回其中参数的range
 *
 *  @param urlString placeholder字符串
 *
 *  @return range字典
 */
+(NSDictionary *)makeAllPlaceHoldersRangeWithString:(NSString *)urlString{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSString *temp = nil;
    int startIndex = 0;
    for(int i =0; i < [urlString length]; i++)
    {
        temp = [urlString substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"{"]) {
            startIndex = i;
        }else if ([temp isEqualToString:@"}"]) {
            NSRange range = NSMakeRange(startIndex , i - startIndex + 1);
            NSString *str = [urlString substringWithRange:range];
            [tempDict setObject:[NSValue valueWithRange:range] forKey:[str substringWithRange:NSMakeRange(1, str.length - 2)]];
        }else{
            continue;
        }
    }
    
    
    return tempDict;
}

@end
