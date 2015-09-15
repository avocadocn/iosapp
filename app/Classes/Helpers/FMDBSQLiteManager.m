//
//  FMDBSQLiteManager.m
//  app
//
//  Created by burring on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FMDBSQLiteManager.h"
#import <FMDB.h>
#import "Person.h"
@interface FMDBSQLiteManager ()
@property (nonatomic, strong)FMDatabaseQueue *queue;

@end
@implementation FMDBSQLiteManager

+ (FMDBSQLiteManager *)shareSQLiteManager {
    static FMDBSQLiteManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[FMDBSQLiteManager alloc] init];
    });
    return manger;
}

- (id) init {
    self = [super init];
    if (self) {
        NSString *sandBoxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"mydatabase.sqlite"];
        //        文件管理类NSFileManager是个单例
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:sandBoxPath]) {
            //           文件存在
        } else {
            //           文件不存在
            BOOL b = [manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"mydatabase" ofType:@"sqlite"] toPath:sandBoxPath error:nil];
            b ? NSLog(@"T") : NSLog(@"F");
        }
        //        根据SQLite文件路径创建SQLite数据管理对象
        self.queue = [FMDatabaseQueue databaseQueueWithPath:sandBoxPath];
    }
    return self;
}
/*
-(void)insertPerson:(Person *)p {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];//打开数据库
        BOOL b = [db executeUpdate:@"insert into PersonTable(name,imageURL) values(?,?)",p.name,p.imageURL];//存数据
        [db close];
        b ? NSLog(@"插入成功") : NSLog(@"插入失败");
    }];
}
-(void)deletePersonWithName:(NSString *)name {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        BOOL b = [db executeUpdate:@"delete from PersonTable where name = ?",name];
        [db close];
        b ? NSLog(@"删除成功") : NSLog(@"删除失败");
    }];
    
}
-(void)updatePersonName:(NSString *)name whereAge:(NSString *)age {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        BOOL b = [db executeUpdate:@"update PersonTable set name = ? where age = ?",name,age];
        [db close];
        b ? NSLog(@"修改成功") : NSLog(@"修改失败");
    }];
}
 */
-(NSArray *)selectPersonWithUserId:(NSString *)userId {
    NSMutableArray *array = [NSMutableArray arrayWithArray:0];
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *set = [db executeQuery:@"select *from PersonTable where userId = ?",userId];
        while ([set next]) {
            //         stringForColumn提取对应字段中的数据
            Person *p = [Person personWithName:[set stringForColumn:@"name"] imageURL:[set stringForColumn:@"imageURL"] userId:[set stringForColumn:@"userId"]];
            [array addObject:p];
        }
        [db close];
    }];
    return [NSArray arrayWithArray:array];
}

@end
