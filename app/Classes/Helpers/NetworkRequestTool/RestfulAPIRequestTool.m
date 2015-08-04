//
//  RestfulAPIRequestTool.m
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RestfulAPIRequestTool.h"
#import "RouteManager.h"
#import "RouteInfoModel.h"
#import <AFNetworking.h>
#import "AccountTool.h"
#import "Account.h"
#import <MJExtension.h>
#import "FixTemplateRouteTool.h"

typedef enum : NSUInteger {
    RequsetMethodTypeGET = 0 ,
    RequsetMethodTypePOST,
    RequsetMethodTypePUT,
    RequsetMethodTypeDELETE
} RequsetMethodType;



@interface RestfulAPIRequestTool()


@end
@implementation RestfulAPIRequestTool


/**
 *  路由管理者
 */
static RouteManager *_routeManager;

/**
 *  请求管理者
 */
static AFHTTPSessionManager *_mgr;


/**
 *  类加载时对静态属性的配置
 */
+(void)load{
    _routeManager = [RouteManager sharedManager];
    _mgr = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    _mgr.responseSerializer  = [AFHTTPResponseSerializer serializer];
    if ([AccountTool account].token) {
        [_mgr.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];
    }
}



+(void)routeName:(NSString *)routeName requestModel:(id)requestModel useKeys:(NSArray *)keysArray success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    
    
    __block BOOL uploadFlag = NO;
    
    NSDictionary *paramsDict = [requestModel keyValuesWithKeys:keysArray];
    [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)obj;
            for (id innerObj in arr) {
                if ([innerObj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *subDict = (NSDictionary *)innerObj;
                    [subDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        if ([obj isKindOfClass:[NSData class]]) {
                            
                            uploadFlag = YES;
                        }
                    }];
                }
            }
        }
    }];
    
    // 获得该路由名称的路由信息模型
    RouteInfoModel *routeInfoModel = [_routeManager getModelWithRouteName:routeName];
    
    // 请求方法类型
    RequsetMethodType type;
    if ([routeInfoModel.routeMethod.lowercaseString isEqualToString:@"get"]) {
        type = RequsetMethodTypeGET;
    }else if ([routeInfoModel.routeMethod.lowercaseString isEqualToString:@"post"]){
        type = RequsetMethodTypePOST;
    }else if ([routeInfoModel.routeMethod.lowercaseString isEqualToString:@"put"]){
        type = RequsetMethodTypePUT;
    }else if ([routeInfoModel.routeMethod.lowercaseString isEqualToString:@"delete"]){
        type = RequsetMethodTypeDELETE;
    }
    
    
    // 排除在url中出现的请求参数
    NSMutableDictionary *mutableParamsDict = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
    NSString *routeUrl = [FixTemplateRouteTool routeWithTemplate:routeInfoModel.routeURL parameterModel:requestModel];
    
    NSDictionary *pathParams = [FixTemplateRouteTool routeParamsDictionaryWithTemplate:routeInfoModel.routeURL parameterModel:requestModel];
    [mutableParamsDict addEntriesFromDictionary:pathParams];
    [pathParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [mutableParamsDict removeObjectForKey:key];
    }];
    
    
    
    switch (type) {
        case RequsetMethodTypeGET:
            [self get:routeUrl params:mutableParamsDict success:success failure:failure];
            break;
        
        case RequsetMethodTypePOST:
            
            if (uploadFlag == YES) {
                [self upload:routeUrl params:mutableParamsDict success:success failure:failure];
            }else{
                [self post:routeUrl params:mutableParamsDict success:success failure:failure];
            }
            break;
        case RequsetMethodTypeDELETE:
            [self delete:routeUrl params:mutableParamsDict success:success failure:failure];
            break;
        case RequsetMethodTypePUT:
            [self put:routeUrl params:mutableParamsDict success:success failure:failure];
            break;
        default:
            break;
    }
}



+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure
{
    

    // 发送get请求
    [_mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
     
        if (success) {
            success([self dataToJsonObject:responseObject]);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if (failure) {
            failure([self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]]);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure
{
    
    // 发送post请求
    [_mgr POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure([self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]]);
        }
    }];
}



+ (void)upload:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    // 发送post 请求
    [_mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"%@ - ----- -- -%@",key,obj);
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *fileArray = (NSArray *)obj;
                NSInteger *index = 0;
                for (NSDictionary *dataDict in fileArray) {
                        [formData appendPartWithFileData:[dataDict objectForKey:@"data"] name:[dataDict objectForKey:@"name"] fileName:[NSString stringWithFormat:@"DonlerImage %zd", index] mimeType:@"image/jpeg"];
                        
                    index++;

                }
            }
        }];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure([self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]]);
        }
    }];
}

+ (void)put:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure
{
    
   // 发送put请求
    [_mgr PUT:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure([self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]]);
        }
    }];
}

+ (void)delete:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    
    // 发送delete请求
    [_mgr DELETE:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure([self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]]);
        }
    }];
}


/**
 *  data转jsonObject
 *
 *  @param responseObject data
 *
 *  @return JsonObject
 */
+(id)dataToJsonObject:(id)responseObject{
    NSData *data = [NSData dataWithData:responseObject];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return json;
}

@end
