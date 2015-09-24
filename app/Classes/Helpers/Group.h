//
//  Group.h
//  app
//
//  Created by tom on 15/9/23.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (nonatomic, strong) NSString* groupID;
@property (nonatomic, strong) NSString* easemobID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* brief;
@property (nonatomic, strong) NSString* iconURL;
@property (nonatomic) Boolean open;
+ (id)groupWithName:(NSString *)name
              brief:(NSString*)brief
            iconURL:(NSString *)iconURL
              groupID:(NSString *)groupID
          easemobID:(NSString*)easemobID
               open:(Boolean)open;
@end
