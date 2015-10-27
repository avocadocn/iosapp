//
//  VoteTableController.h
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteTableController : UIViewController

/**
 *  投票的Frames
 */
@property (nonatomic, strong) NSMutableArray *voteArray;
@property (nonatomic, copy)NSString *interactionType;
@property (nonatomic, copy)NSString *interaction;

+(UINavigationController *)shareNavigation;


@end
