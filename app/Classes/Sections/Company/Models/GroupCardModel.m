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

- (void)save:(NSString *)group
{
    NSString *filePathStr = [NSString stringWithFormat:@"%@/DLLibraryCache/%@-groupFile", DLLibraryPath, group];  //文件夹 位置 groupfile
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL judge = [manger fileExistsAtPath:filePathStr];
    
    NSString *dataPathStr = [NSString stringWithFormat:@"%@/%@", filePathStr, self.groupId];
    if (judge) {
        BOOL small = [manger fileExistsAtPath:dataPathStr];
        if (!small) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
            [data writeToFile:dataPathStr atomically:YES];
            NSLog(@"存储成功");
        }
        
    } else
    {
        NSError *error = nil;
        [manger createDirectoryAtPath:filePathStr withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (!error) {
            NSLog(@"文件夹创建成功");
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
            [data writeToFile:dataPathStr atomically:YES];
            NSLog(@"存储成功");
        }
    }
}




- (instancetype)initWithString:(NSString *)IDStr andType:(NSString *)type
{
    self = [super init];
    if (self) {
        NSString *str = [NSString stringWithFormat:@"%@/DLLibraryCache/%@-groupFile/%@", DLLibraryPath, type, IDStr];
        
        NSData *data = [NSData dataWithContentsOfFile:str];
        self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    return  self;
}

@end
