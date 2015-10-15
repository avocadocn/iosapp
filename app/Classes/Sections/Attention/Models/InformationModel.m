//
//  InformationModel.m
//  app
//
//  Created by 申家 on 15/10/13.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InformationModel.h"
#import "Account.h"
#import "AccountTool.h"
@implementation InformationModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.noticeType forKey:@"noticeType"];
    [aCoder encodeObject:self.action forKey:@"action"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.receiver forKey:@"receiver"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.__v forKey:@"__v"];
    [aCoder encodeObject:self.team forKey:@"team"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.interaction forKey:@"interaction"];
    [aCoder encodeObject:self.interactionType forKey:@"interactionType"];
    [aCoder encodeObject:self.relativeCount forKey:@"relativeCount"];
    [aCoder encodeObject:self.examine forKey:@"examine"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.noticeType = [aDecoder decodeObjectForKey:@"noticeType"];
        self.sender = [aDecoder decodeObjectForKey:@"sender"];
        self.action = [aDecoder decodeObjectForKey:@"action"];
        self.receiver = [aDecoder decodeObjectForKey:@"receiver"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.__v = [aDecoder decodeObjectForKey:@"__v"];
        self.team = [aDecoder decodeObjectForKey:@"team"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.interaction = [aDecoder decodeObjectForKey:@"interaction"];
        self.interactionType = [aDecoder decodeObjectForKey:@"interactionType"];
        self.relativeCount = [aDecoder decodeObjectForKey:@"relativeCount"];
        self.examine = [aDecoder decodeObjectForKey:@"examine"];
        
    }
    return self;
}

- (instancetype)initWithInforString:(NSString *)inforType andIDString:(NSString *)string
{
    self = [super init];
    if (self) {
        Account *acc = [AccountTool account];
        NSString *newPath = [NSString stringWithFormat:@"%@/%@-%@/%@", DLLibraryPath, acc.ID,inforType ,string];
        NSData *data = [NSData dataWithContentsOfFile:newPath];
        self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

- (void)save:(NSString *)inforType
{
    Account *acc = [AccountTool account];
    
    NSString *filePathStr = [NSString stringWithFormat:@"%@/%@-%@", DLLibraryPath, acc.ID,inforType];
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL judge = [manger fileExistsAtPath:filePathStr];
    
    NSString *dataPathStr = [NSString stringWithFormat:@"%@/%@", filePathStr, self.ID];
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

- (void)deleteSelf:(NSString *)inforType
{
    Account *acc = [AccountTool account];
    
    NSFileManager *maner = [NSFileManager defaultManager];
    [maner removeItemAtPath:[NSString stringWithFormat:@"%@/%@-%@/%@", DLLibraryPath, acc.ID, inforType , self.ID] error:nil];
}

@end
