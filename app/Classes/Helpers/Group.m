//
//  Group.m
//  app
//
//  Created by tom on 15/9/23.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "Group.h"

@implementation Group

+ (id)groupWithName:(NSString *)name brief:(NSString *)brief iconURL:(NSString *)iconURL groupID:(NSString *)groupID easemobID:(NSString *)easemobID open:(Boolean)open
{
    Group* g = [Group new];
    g.name = name;
    g.brief = brief;
    g.iconURL = iconURL;
    g.groupID = groupID;
    g.easemobID = easemobID;
    g.open = open;
    return g;
}
@end
