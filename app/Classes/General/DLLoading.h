//
//  DLLoading.h
//  app
//
//  Created by 申家 on 15/10/21.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLLoading : NSObject

@property (nonatomic, copy)void(^overTime)(id);
- (void)loading;
+ (void)dismisss;
@end
