//
//  FMDBSQLiteManager.h
//  app
//
//  Created by burring on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
@class Group;
@class Concern;
@interface FMDBSQLiteManager : NSObject

+ (FMDBSQLiteManager *)shareSQLiteManager;

//Person
//- (void)createTable;
//增
-(void)insertPerson:(Person *)p;
//删
//-(void)deletePersonWithName:(NSString *)name;
//查
-(Person *)selectPersonWithUserId:(NSString *)userId;
//清空用户表
- (void)dropPerson;

//Group
- (void)insertGroup:(Group*)g;
-(void)deleteGroupWithGroupId:(NSString *)groupID;
- (Group*)selectGroupWithGroupId:(NSString*)groupId;
- (Group*)selectGroupWithEasemobId:(NSString*)easemobId;
//清空群组表
- (void)dropGroup;

//Concerns
- (void)saveConcerns:(Concern*)c;
- (Concern*)getConcerns;
- (Boolean)containConcernWithId:(NSString*)cid;
- (void)dropConcerns;
@end
