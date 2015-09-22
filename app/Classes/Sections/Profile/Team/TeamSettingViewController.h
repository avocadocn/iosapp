//
//  TeamSettingViewController.h
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupDetileModel;
typedef enum : NSUInteger {
    kTeamIdentityMaster, // 群主
    kTeamIdentityMember, // 成员
} kTeamIdentity;

@interface TeamSettingViewController : UITableViewController

@property (nonatomic, strong)GroupDetileModel *detileModel;


-(instancetype)initWithIdentity:(kTeamIdentity)identity;

@end
