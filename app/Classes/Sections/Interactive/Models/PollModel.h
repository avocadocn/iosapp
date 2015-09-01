//
//  PollModel.h
//  app
//
//  Created by 申家 on 15/9/1.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PollModel : NSObject

@property (nonatomic, copy)NSString *ID;

@property (nonatomic, copy)NSString *vesion;

@property (nonatomic, strong)NSArray *option;

@end
