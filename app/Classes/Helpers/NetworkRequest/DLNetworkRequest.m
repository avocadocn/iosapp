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

@implementation DLNetworkRequest

// 路由请求 需要一个请求的网址 网络请求的类型 请求的参数
- (void)dlRouteNetWorkWithNetName:(NSString *)name andRequestType:(NSString *)type paramter:(id)paramter
{
    self.dictinary = [NSDictionary dictionary];
    
    RouteManager *route = [RouteManager sharedManager];
    RouteInfoModel *model = [route getModelWithNetName:name];
    NSString *str = model.routeURL;
    
    if ([type isEqualToString:@"POST"]) {
        [self dlPOSTNetRequestWithString:str andParameters:paramter];
    }
    else if ([type isEqualToString:@"GET"])
    {
        [self dlGETNetRequestWithString:str andParameters:paramter];
    }
     //写了一个plist文件,用单例读取这个plist文件,把plist文件里的小字典转成model,把model放进route的routeDict字典里, key值为model的routeName值
    
}


// Post 请求
- (void)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate sendParsingWithDictionary:dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
//        [self judgeNetWorkConnection];
    }];
}

// GET 请求
- (void)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger GET:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate sendParsingWithDictionary:dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
//        [self judgeNetWorkConnection];
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
