//
//  FMDBSQLiteManager.h
//  app
//
//  Created by burring on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
@interface FMDBSQLiteManager : NSObject

+ (FMDBSQLiteManager *)shareSQLiteManager;

- (void)createTable;
//增
-(void)insertPerson:(Person *)p;
//删
-(void)deletePersonWithName:(NSString *)name;
//查
-(Person *)selectPersonWithUserId:(NSString *)userId;


@end
