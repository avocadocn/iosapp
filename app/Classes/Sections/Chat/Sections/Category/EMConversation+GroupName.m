//
//  EMConversation+GroupName.m
//  app
//
//  Created by tom on 15/9/25.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "EMConversation+GroupName.h"

@implementation EMConversation (GroupName)
- (NSString*)groupName
{
    if (self.ext){
        return [self.ext objectForKey:@"groupSubject"];
    }
    return nil;
}
@end
