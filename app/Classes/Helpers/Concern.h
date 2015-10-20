//
//  Concern.h
//  app
//
//  Created by tom on 15/10/19.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

// 当前用户的关注列表存储路径
#define ConcernsPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"concerns.archive"]

@interface Concern : NSObject

@property (nonatomic, strong)NSString* personId;
@property (nonatomic, strong)NSArray* concernIds;
+ (Concern*)initWithPersonId:(NSString*)pid AndConcernIds:(NSArray*)cids;
@end
