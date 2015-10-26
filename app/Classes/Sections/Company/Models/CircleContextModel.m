//
//  CircleContextModel.m
//  app
//
//  Created by 申家 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CircleContextModel.h"

@interface CircleContextModel ()

@end

@implementation CircleContextModel



#define path [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"_id"]) {
        self.ID = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.__v forKey:@"__v"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.kind forKey:@"kind"];
    [aCoder encodeObject:self.content forKey:@"content"];
    //    [aCoder encodeObject:self.isOnlyToContent forKey:@"isOnlyToContent"];
    [aCoder encodeObject:self.targetContentId forKey:@"targetContentId"];
    [aCoder encodeObject:self.targetUserId forKey:@"targetUserId"];
    [aCoder encodeObject:self.postUserCid forKey:@"postUserCid"];
    [aCoder encodeObject:self.postUserId forKey:@"postUserId"];
    [aCoder encodeObject:self.postDate forKey:@"postDate"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.contentId forKey:@"contentId"];
    [aCoder encodeObject:self.commentId forKey:@"commentId"];
    [aCoder encodeObject:self.cid forKey:@"cid"];
    [aCoder encodeObject:self.target forKey:@"target"];
    [aCoder encodeObject:self.poster forKey:@"poster"];
    [aCoder encodeObject:self.latestCommentDate forKey:@"latestCommentDate"];
    [aCoder encodeObject:self.photos forKey:@"photos"];
    [aCoder encodeObject:self.relativeCids forKey:@"relativeCids"];
    [aCoder encodeObject:self.commentUsers forKey:@"commentUsers"];
    [aCoder encodeObject:self.isOnlyToContent forKey:@"isOnlyToContent"];
    [aCoder encodeObject:self.comments forKey:@"comments"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.__v = [aDecoder decodeObjectForKey:@"__v"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.kind = [aDecoder decodeObjectForKey:@"kind"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.targetContentId = [aDecoder decodeObjectForKey:@"targetContentId"];
        self.targetUserId = [aDecoder decodeObjectForKey:@"targetUserId"];
        self.postUserCid = [aDecoder decodeObjectForKey:@"postUserCid"];
        self.postUserId = [aDecoder decodeObjectForKey:@"postUserId"];
        self.postDate = [aDecoder decodeObjectForKey:@"postDate"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.contentId = [aDecoder decodeObjectForKey:@"contentId"];
        self.commentId = [aDecoder decodeObjectForKey:@"commentId"];
        self.cid = [aDecoder decodeObjectForKey:@"cid"];
        self.target = [aDecoder decodeObjectForKey:@"target"];
        self.poster = [aDecoder decodeObjectForKey:@"poster"];
        self.latestCommentDate = [aDecoder decodeObjectForKey:@"latestCommentDate"];
        self.photos = [aDecoder decodeObjectForKey:@"photos"];
        self.relativeCids = [aDecoder decodeObjectForKey:@"relativeCids"];
        //        self.isOnlyToContent = [aDecoder decodeObjectForKey:@"isOnlyToContent"];
        self.commentUsers = [aDecoder decodeObjectForKey:@"commentUsers"];
        self.isOnlyToContent = [aDecoder decodeObjectForKey:@"isOnlyToContent"];
        self.comments = [aDecoder decodeObjectForKey:@"comments"];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        NSString *newPath = [NSString stringWithFormat:@"%@/%@", path, string];
        NSData *data = [NSData dataWithContentsOfFile:newPath];
        self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

- (void)save
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *newPath = [NSString stringWithFormat:@"%@/%@", path, self.ID];
    BOOL judge = [manger fileExistsAtPath:newPath];
    
    if (judge) {
        NSError *error = nil;
        [manger removeItemAtPath:newPath error:&error];
        if (!error) {
            NSLog(@"删除成功");
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
            [data writeToFile:newPath atomically:YES];
            NSLog(@"复存成功");
        }
    } else {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        [data writeToFile:newPath atomically:YES];
        NSLog(@"存储成功");
    }
    
}





@end
