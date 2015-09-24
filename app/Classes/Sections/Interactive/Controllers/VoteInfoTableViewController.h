//
//  VoteInfoTableViewController.h
//  app
//
//  Created by 张加胜 on 15/8/13.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PollModel;
@interface VoteInfoTableViewController : UITableViewController

@property (nonatomic, strong)PollModel *model;

@end
