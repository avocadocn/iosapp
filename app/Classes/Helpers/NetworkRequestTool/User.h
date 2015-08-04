//
//  User.h
//  app
//
//  Created by 张加胜 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *responseKey;

@property (nonatomic,copy) NSArray *photoArray;
@property (nonatomic,copy) NSDate *start;

@end
