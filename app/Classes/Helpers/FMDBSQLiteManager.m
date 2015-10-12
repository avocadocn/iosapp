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
#import "Group.h"

@interface FMDBSQLiteManager ()
@property (nonatomic, strong)FMDatabaseQueue *queue;
@property (nonatomic, strong)FMDatabase* db;
@property (nonatomic, strong)Person *per;
@property (nonatomic, strong)Group* gro;
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
        NSString *sandBoxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mydatabase.sqlite"];
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
        [self.queue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT)",@"GroupTable",@"name",@"brief",@"groupID",@"easemobID",@"open",@"iconURL"];
                BOOL res = [db executeUpdate:sqlCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"success to creating db table");
                }  
                [db close];
            }
        }];
    }
    return self;
}

-(void)insertPerson:(Person *)p { // 插入数据
    //如果数据已存在就进行更新
    Person* person = [self selectPersonWithUserId:p.userId];
    if (person!=nil) {
        [self updatePerson:p];
        return;
    }
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];//打开数据库
        BOOL b = [db executeUpdate:@"insert into PersonTable(name,userId,imageURL) values(?,?,?)",p.name,p.userId,p.imageURL];//存数据
        [db close];
        b ? NSLog(@"插入成功") : NSLog(@"插入失败");
    }];
}

//更新群组信息
- (void)updatePerson:(Person*)p
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];//打开数据库
        BOOL b = FALSE;
        NSString* sql = [NSString stringWithFormat:@"update PersonTable set name = '%@',imageURL = '%@' where userId = '%@'",p.name,p.imageURL,p.userId];
        b= [db executeUpdate:sql];//更新数据
        [db close];
        b ? NSLog(@"更新成功") : NSLog(@"更新失败");
    }];
}
/*
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



-(Person *)selectPersonWithUserId:(NSString *)userId { // 查找数据
 
    self.per = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *set = [db executeQuery:@"select *from PersonTable where userId = ?",userId];
        while ([set next]) {
            //         stringForColumn提取对应字段中的数据
            self.per = [Person personWithName:[set stringForColumn:@"name"] imageURL:[set stringForColumn:@"imageURL"] userId:[set stringForColumn:@"userId"]];
            
        }
        [db close];
    }];
    return self.per;
}

//插入群组
- (void)insertGroup:(Group *)g
{
    Group* t= [self selectGroupWithGroupId:g.groupID];
    if (t!=nil){
        [self updateGroup:g];
        return;
    }
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];//打开数据库
        BOOL b = FALSE;
        b= [db executeUpdate:@"insert into GroupTable(groupID,easemobID,name,brief,open,iconURL) values(?,?,?,?,?,?)",g.groupID,g.easemobID,g.name,g.brief,g.open?@"1":@"0",g.iconURL];//存数据
        //        b= [db executeUpdate:@"insert into GroupTable (name,brief,groupID,easemobID,open,iconURL) values(?,?,?,?,?,?)",@"123",@"456",@"789",@"abc",@"def",@"jkl"];//存数据
        [db close];
        b ? NSLog(@"插入成功") : NSLog(@"插入失败");
    }];
}
//更新群组信息
- (void)updateGroup:(Group*)g
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];//打开数据库
        BOOL b = FALSE;
        NSString* sql = [NSString stringWithFormat:@"update GroupTable set easemobID = '%@',name = '%@',brief = '%@',open = '%@',iconURL = '%@' where groupID = '%@'",g.easemobID,g.name,g.brief,g.open?@"1":@"0",g.iconURL,g.groupID];
        b= [db executeUpdate:sql];//更新数据
        [db close];
        b ? NSLog(@"更新成功") : NSLog(@"更新失败");
    }];
}
//根据warm的群组id进行查找
- (Group*)selectGroupWithGroupId:(NSString *)groupId
{
    self.gro = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString* sql = [NSString stringWithFormat:@"select groupID,easemobID,name,brief,open,iconURL from GroupTable where groupID = '%@'",groupId];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            //         stringForColumn提取对应字段中的数据
            self.gro = [Group groupWithName:[set stringForColumn:@"name"] brief:[set stringForColumn:@"brief"] iconURL:[set stringForColumn:@"iconURL"] groupID:[set stringForColumn:@"groupID"] easemobID:[set stringForColumn:@"easemobID"] open:[set boolForColumn:@"open"]];
            
        }
        [db close];
    }];
    return self.gro;
}
//根据环信得群组id进行查找
- (Group*)selectGroupWithEasemobId:(NSString *)easemobId
{
    self.gro = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *set = [db executeQuery:@"select * from GroupTable where easemobID = ?",easemobId];
        while ([set next]) {
            //         stringForColumn提取对应字段中的数据
            self.gro = [Group groupWithName:[set stringForColumn:@"name"] brief:[set stringForColumn:@"brief"] iconURL:[set stringForColumn:@"iconURL"] groupID:[set stringForColumn:@"groupID"] easemobID:[set stringForColumn:@"easemobID"] open:[set boolForColumn:@"open"]];
            
        }
        [db close];
    }];
    return self.gro;
}
//清空群组表
- (void)dropGroup
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        Boolean isDrop = [db executeUpdate:@"delete from GroupTable"];
        if (isDrop) {
            NSLog(@"the group table is dropped!success");
        }else{
            NSLog(@"the group table is dropped!failed");
        }
        [db close];
    }];
}
//清空用户表
- (void)dropPerson
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
        Boolean isDrop = [db executeUpdate:@"delete from PersonTable"];
        if (isDrop) {
            NSLog(@"the person table is dropped!success");
        }else{
            NSLog(@"the person table is dropped!failed");
        }
        [db close];
    }];
}
@end
