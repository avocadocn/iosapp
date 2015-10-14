
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
+ (void)load{
    _routeManager = [RouteManager sharedManager];
    
    /*
     ****************************************************************************************************
     baseUrl 使用细则
     ****************************************************************************************************
         NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
        [NSURL URLWithString:@"foo" relativeToURL:baseURL];                  // http://example.com/v1/foo
        [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];          // http://example.com/v1/foo?bar=baz
        [NSURL URLWithString:@"/foo" relativeToURL:baseURL];                 // http://example.com/foo
        [NSURL URLWithString:@"foo/" relativeToURL:baseURL];                 // http://example.com/v1/foo
        [NSURL URLWithString:@"/foo/" relativeToURL:baseURL];                // http://example.com/foo/
        [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL]; // http://example2.com/
     ****************************************************************************************************
     */
    
    NSURL *baseUrl = [NSURL URLWithString:BaseUrl];
    _mgr = [[AFHTTPSessionManager alloc]initWithBaseURL:baseUrl];
//    _mgr = [[AFHTTPSessionManager alloc]init];
    _mgr.responseSerializer  = [AFHTTPResponseSerializer serializer];
    if ([AccountTool account].token) {
        [_mgr.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];
    }
    
    
}


+ (void)routeName:(NSString *)routeName requestModel:(id)requestModel useKeys:(NSArray *)keysArray success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    
    [self load];
    
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

    NSString *amendStr = [NSString stringWithFormat:@"%@%@", BaseUrl, routeUrl];
    
    NSLog(@"请求的网址为   %@", amendStr);
    NSLog(@"请求的body为 %@", mutableParamsDict);
    
    switch (type) {
        case RequsetMethodTypeGET:
            [self get:amendStr params:mutableParamsDict success:success failure:failure];
            break;
        
        case RequsetMethodTypePOST:
            if (uploadFlag == YES) {
                [self upload:amendStr params:mutableParamsDict success:success failure:failure];
            }else{
                [self post:amendStr params:mutableParamsDict success:success failure:failure];
            }
            break;
        case RequsetMethodTypeDELETE:
            [self delete:amendStr params:mutableParamsDict success:success failure:failure];
            break;
        case RequsetMethodTypePUT:
            if (uploadFlag == NO) {
                [self put:amendStr params:mutableParamsDict success:success failure:failure];
            } else
            {
                [self putUpload:amendStr params:mutableParamsDict success:success failure:failure];
            }
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
            failure([self resolveFailureWith:error]);
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
        
        
        NSLog(@"%@",error);
        if (failure) {
            failure([self resolveFailureWith:error]);
        }
    }];
}



+ (void)upload:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    // 发送post 请求
    __block NSMutableArray *fileArray = [NSMutableArray array];
    __block NSMutableArray *keyArray = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]] && [key isEqualToString:@"photo"]) {
            [keyArray addObject:key];
            fileArray = (NSMutableArray *)obj;
        }
    }];
    [params removeObjectsForKeys:keyArray];
    
    
    [_mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSInteger index = 0;
        
        for (NSDictionary *dataDict in fileArray) {
            [formData appendPartWithFileData:[dataDict objectForKey:@"data"] name:[dataDict objectForKey:@"name"] fileName:[NSString stringWithFormat:@"DonlerImage %zd", index] mimeType:@"image/jpeg"];
            index++;
            
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if (failure) {
            failure([self resolveFailureWith:error]);
        }
    }];
}

+ (void)put:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure
{
    
   // 发送put请求

    
//    [manger.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];

    
    [_mgr PUT:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if (failure) {
            failure([self resolveFailureWith:error]);
        }
    }];
}

+ (void)putUpload:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure
{
        __block NSMutableArray *fileArray = [NSMutableArray array];
        __block NSMutableArray *keyArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]] &&
                ([key isEqualToString:@"photo"] || [key isEqualToString:@"uploadPhoto"])) {
                [keyArray addObject:key];
                fileArray = (NSMutableArray *)obj;
            }
        }];
    __block NSData *data = [NSData data];
    for (NSDictionary *dataDict in fileArray) {
        
        data = [dataDict objectForKey:@"data"];
    }
    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc]init];
    if ([AccountTool account].token) {
        [manger.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];
    }
    
        [params removeObjectsForKeys:keyArray];
    
        NSMutableURLRequest *request = [manger.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"photo" fileName:@"highlight_image.jpg" mimeType:@"image/jpeg"];
        }];
    
    
        AFHTTPRequestOperation *requestOperation = [manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (success) {
                success([self dataToJsonObject:responseObject]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure([self resolveFailureWith:error]);
            }
        }];
        
        [requestOperation start];
        

}


+ (void)delete:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(id errorJson))failure{
    
    // 发送delete请求
    [_mgr DELETE:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success([self dataToJsonObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if (failure) {
            failure([self resolveFailureWith:error]);
        }
    }];
}


+ (id)resolveFailureWith:(NSError *)error{
   id errorJson =  [self dataToJsonObject:error.userInfo[@"com.alamofire.serialization.response.error.data"]];
    if (!errorJson) {
        TTAlert(@"服务器连接失败");
    }
    return errorJson;
}

/**
 *  data转jsonObject
 *
 *  @param responseObject data
 *
 *  @return JsonObject
 */

+ (id)dataToJsonObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSData *data = [NSData dataWithData:responseObject];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return json;
        
    } else {
        return responseObject;
    }
}

@end
