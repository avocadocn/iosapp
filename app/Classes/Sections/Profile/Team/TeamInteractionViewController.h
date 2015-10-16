//
//  TeamInteractionViewController.h
//  app
//
//  Created by tom on 15/10/13.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupCardModel;
typedef enum {
    TeamInteractionActivity=1,
    TeamInteractionVote,
    TeamInteractionHelp
}TeamInteraction;

@interface TeamInteractionViewController : UITableViewController
@property TeamInteraction type;
@property (nonatomic, strong)GroupCardModel *groupCardModel;

@property (nonatomic , strong)NSNumber *requestType;

@property (nonatomic, copy)NSString *team;

@property (nonatomic, copy)NSNumber *interactionType;

@end
