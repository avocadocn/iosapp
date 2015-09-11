//
//  InvatingModel.h
//  app
//
//  Created by burring on 15/9/1.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvatingModel : NSObject
@property (nonatomic, strong)NSArray *phones; // 本地通讯录

@property (nonatomic, copy)NSNumber *interactionType;

@property (nonatomic, copy)NSNumber *requestType;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *userId;

@property (nonatomic, copy)NSString *limit;
@end
