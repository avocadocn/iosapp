//
//  TeamInfomationViewController.h
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupDetileModel;

@interface TeamInfomationViewController : UITableViewController

@property (nonatomic, strong) NSArray *memberInfos;

@property (nonatomic, strong)GroupDetileModel *detilemodel;


@end
