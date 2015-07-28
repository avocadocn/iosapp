//
//  DLNetworkRequest.h
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

@interface DLNetworkRequest : NSObject

@property (nonatomic, strong)NSDictionary *dictinary;

- (NSDictionary *)dlPOSTNetRequestWithString:(NSString *)str andParameters:(id)parameters;

- (NSDictionary *)dlGETNetRequestWithString:(NSString *)str andParameters:(id)parameters;

@end
