//
//  AddressBookModel.m
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AddressBookModel.h"

#define path [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]

@implementation AddressBookModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.realname forKey:@"realname"];
    [aCoder encodeObject:self.department forKey:@"department"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.bloodType forKey:@"bloodType"];
    [aCoder encodeObject:self.introduce forKey:@"introduce"];
    [aCoder encodeObject:self.registerDate forKey:@"registerDate"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.tids forKey:@"tids"];
    [aCoder encodeObject:self.lastCommentTime forKey:@"lastCommentTime"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.companyId forKey:@"companyId"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.originPassword forKey:@"originPassword"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.latestContentDate forKey:@"latestContentDate"];
    [aCoder encodeObject:self.lastContentDate forKey:@"lastContentDate"];
    [aCoder encodeObject:self.company_official_name forKey:@"company_official_name"];
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.photo = [aDecoder decodeObjectForKey:@"photo"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.department = [aDecoder decodeObjectForKey:@"department"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.bloodType = [aDecoder decodeObjectForKey:@"bloodType"];
        self.introduce = [aDecoder decodeObjectForKey:@"introduce"];
        self.registerDate = [aDecoder decodeObjectForKey:@"registerDate"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.company = [aDecoder decodeObjectForKey:@"company"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.tids = [aDecoder decodeObjectForKey:@"tids"];
        self.lastCommentTime = [aDecoder decodeObjectForKey:@"lastCommentTime"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.companyId = [aDecoder decodeObjectForKey:@"companyId"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.originPassword = [aDecoder decodeObjectForKey:@"originPassword"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.latestContentDate = [aDecoder decodeObjectForKey:@"latestContentDate"];
        self.lastContentDate = [aDecoder decodeObjectForKey:@"lastContentDate"];
        self.company_official_name = [aDecoder decodeObjectForKey:@"company_official_name"];
        
    }
    return self;
    
}


//创建图片


- (void)save
{
    NSString *filePathStr = [NSString stringWithFormat:@"%@/address", path];
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



@end
