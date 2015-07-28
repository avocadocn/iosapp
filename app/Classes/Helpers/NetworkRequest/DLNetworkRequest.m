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

@implementation DLNetworkRequest

// Post 请求
- (NSDictionary *)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        self.dictinary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [self judgeNetWorkConnection];
    }];
    
    return self.dictinary;
}

- (NSDictionary *)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger GET:str parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        
        self.dictinary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [self judgeNetWorkConnection];
    }];
    return self.dictinary;
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
