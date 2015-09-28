//
//  DLNetworkRequest.m
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DLNetworkRequest.h"
#import "RouteManager.h"
#import "RouteInfoModel.h"
#import <ReactiveCocoa.h>
#import "UserDataTon.h"

/*
 类的使用方法: 路由请求时
        参数   网址 (NSString) 输入要进行的网络请求在 RouteInfo.plist 文件里的 RouteName, 找到要请求的网址进行拼接
              请求类型 (NSString) POST  /   GET
              请求参数  POST: (NSDictionary)  key value 形式
                       GET: (NSArray)要使用的参数一一排列存进数组里
 
 RouteInfo.plist 文件的写法: POST 网址:http://192.168.2.109:3002/v2_0/users/login   存储/users/login 为routeURL
                            GET  网址:http://192.168.2.109:3002/v2_0/companies/53aa6fc011fd597b3e1be250
                                      存储/companies/parameter0  (把需要的参数按照 parameter(参数下标) 格式存进 routeURL 里)
 */

@implementation DLNetworkRequest

// 路由请求 需要一个请求的网址 网络请求的类型 请求的参数
- (void)dlRouteNetWorkWithNetName:(NSString *)name andRequestType:(NSString *)type paramter:(id)paramter
{
    self.dictinary = [NSDictionary dictionary];
    
    RouteManager *route = [RouteManager sharedManager];
    RouteInfoModel *model = [route getModelWithRouteName:name];
    NSString *str = [NSString stringWithFormat:@"%@%@", BaseUrl, model.routeURL];
    
    NSLog(@"请求的网址为: %@", str);
    NSLog(@"请求的数据为: %@", paramter);
    
    if ([paramter objectForKey:@"imageArray"]) {  //存在照片的话
        self.imageArray = [paramter objectForKey:@"imageArray"];
        
        [self dlPOSTUploadingWithString:str andParamters:paramter];
    } else {
        
//        if ([type isEqualToString:@"POST"]) {
            [self dlPOSTNetRequestWithString:str andParameters:paramter];
//        }
    }
    
    
    if ([type isEqualToString:@"GET"])
    {
        NSInteger i = 0;
        NSMutableString *mutableString = [[NSMutableString alloc]init];
        for (NSString *para in paramter) {
            mutableString = (NSMutableString *)[str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"parameter%ld", i] withString:para];
            NSLog(@"GET 请求的网址为:%@", mutableString);
            i++;
        }
        
        [self dlGETNetRequestWithString:mutableString andParameters:nil];
    }
    
    
    //     写了一个plist文件,用单例读取这个plist文件,把plist文件里的小字典转成model,把model放进route的routeDict字典里, key值为model的routeName值
    
}

// Post 请求
- (void)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UserDataTon *use = [UserDataTon shareState];
    if (use.user_token) {
        [manger.requestSerializer setValue:use.user_token forHTTPHeaderField:@"x-access-token"];
    }
    [manger POST:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate sendParsingWithDictionary:dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //        NSDictionary *arrarDic = error.userInfo;
        
        // 看错误代码
        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        NSData *errordata = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errordata) {
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errordata options:kNilOptions error:nil];
            [self.delegate sendErrorWithDictionary:serializedData];
        }
        
    }];
    
}

// GET 请求
- (void)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserDataTon *use = [UserDataTon shareState];
    if (use.user_token) {
        [manger.requestSerializer setValue:use.user_token forHTTPHeaderField:@"x-access-token"];
    }
    
    [manger GET:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate sendParsingWithDictionary:dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
        NSData *errordata = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errordata options:kNilOptions error:nil];
        [self.delegate sendErrorWithDictionary:serializedData];
    }];
}

- (void)dlPOSTUploadingWithString:(NSString *)str andParamters:(id)paramters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserDataTon *use = [UserDataTon shareState];
    if (use.user_token) {
        [manger.requestSerializer setValue:use.user_token forHTTPHeaderField:@"x-access-token"];
    }
    
    [manger POST:str parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.imageArray){
            NSInteger i = 0;
            for (NSDictionary *dic in self.imageArray) {
                [formData appendPartWithFileData:[dic objectForKey:@"data"] name:[dic objectForKey:@"name"] fileName:[NSString stringWithFormat:@"DonlerImage %ld", i] mimeType:@"image/jpeg"];
                
                i++;
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate sendParsingWithDictionary:dic];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
        //                [self judgeNetWorkConnection];
    }];
    
}

// 判断网络
- (void)judgeNetWorkConnection
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    __block UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
                
                NSLog(@"无网络");
                alert.title = @"亲爱的\n您的网络数据已断开~";
                [alert show];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                NSLog(@"WiFi网络");
                alert.title = @"网络已连接";
                [alert show];
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
                NSLog(@"无线网络");
                alert.title = @"无线网络";
                [alert show];
                break;
                
            }
                
            default:
                
                break;
                
        }
        
    }];
}


@end
