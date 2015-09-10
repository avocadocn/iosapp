//
//  Singleton.h
//  app
//
//  Created by burring on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (Singleton *)shareSingleton;

@property (nonatomic, strong)UINavigationController *navigationC;
@end
