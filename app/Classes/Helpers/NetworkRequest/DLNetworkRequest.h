//
//  DLNetworkRequest.h
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>


@protocol DLNetworkRequestDelegate <NSObject>

- (void)sendParsingWithDictionary:(NSDictionary *)dictionary;

@end

@interface DLNetworkRequest : NSObject

@property (nonatomic, strong)NSDictionary *dictinary;

@property (nonatomic, assign)id <DLNetworkRequestDelegate>delegate;

- (void)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters;

- (void)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters;

- (void)dlRouteNetWorkWithNetName:(NSString *)name andRequestType:(NSString *)type paramter:(id)paramter;


@end
