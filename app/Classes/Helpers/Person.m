//
//  Person.m
//  app
//
//  Created by burring on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Person.h"

@implementation Person
+(id)personWithName:(NSString *)name imageURL:(NSString *)imageURL userId:(NSString *)userId companyName:(NSString *)companyName {
    Person *p = [[Person alloc] init];
    p.name = name;
    p.imageURL = imageURL;
    p.userId = userId;
    p.companyName = companyName;
    return p;
}
@end
