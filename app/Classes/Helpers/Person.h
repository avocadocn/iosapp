//
//  Person.h
//  app
//
//  Created by burring on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy)NSString *name, *imageURL, *userId;
+(id)personWithName:(NSString *)name
           imageURL:(NSString *)imageURL
             userId:(NSString *)userId;
@end
