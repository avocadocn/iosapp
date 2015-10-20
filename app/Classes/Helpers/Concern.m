//
//  Concern.m
//  app
//
//  Created by tom on 15/10/19.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "Concern.h"

@implementation Concern
+ (Concern *)initWithPersonId:(NSString *)pid AndConcernIds:(NSArray *)cids
{
    Concern* c = [Concern new];
    c.personId = pid;
    c.concernIds = [NSArray arrayWithArray:cids];
    return c;
}
MJCodingImplementation
@end
