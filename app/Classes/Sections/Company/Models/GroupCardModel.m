//
//  GroupCardModel.m
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupCardModel.h"

@implementation GroupCardModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.groupId = value;
    }
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.brief forKey:@"brief"];
    [aCoder encodeObject:self.logo forKey:@"logo"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.groupId forKey:@"groupId"];
}





- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.groupId = [aDecoder decodeObjectForKey:@"groupId"];
        self.logo = [aDecoder decodeObjectForKey:@"logo"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.brief = [aDecoder decodeObjectForKey:@"brief"];
    }
    return self;
    
}

- (void)save
{
    
}


- (instancetype)initWithString:(NSString *)IDStr
{
    self = [super init];
    if (self) {
        
    }
    return  self;
}

@end
