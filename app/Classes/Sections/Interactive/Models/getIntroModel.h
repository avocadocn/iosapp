//
//  getIntroModel.h
//  app
//
//  Created by 申家 on 15/8/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getIntroModel : NSObject

@property (nonatomic, copy)NSNumber *interactionType;

@property (nonatomic, copy)NSString *requestType;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *userId;

@property (nonatomic, copy)NSNumber *limit;

@property (nonatomic, assign)BOOL selectState;

@end
