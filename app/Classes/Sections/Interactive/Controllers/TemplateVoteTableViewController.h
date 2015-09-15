//
//  TemplateVoteTableViewController.h
//  app
//
//  Created by tom on 15/9/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateVoteTableViewController : UITableViewController

/**
 *  投票的Frames
 */
@property (nonatomic, strong) NSMutableArray *voteArray;

@property (nonatomic, strong) NSMutableArray *voteData;
+(UINavigationController *)shareNavigation;

@end
