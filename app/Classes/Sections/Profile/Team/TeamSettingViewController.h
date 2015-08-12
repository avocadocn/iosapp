//
//  TeamSettingViewController.h
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTeamIdentityMaster, // 群主
    kTeamIdentityMember, // 成员
} kTeamIdentity;

@interface TeamSettingViewController : UITableViewController

-(instancetype)initWithIdentity:(kTeamIdentity)identity;

@end
