//
//  VoteCommentsViewController.h
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interaction;
@interface CommentsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)Interaction *model;

@end
