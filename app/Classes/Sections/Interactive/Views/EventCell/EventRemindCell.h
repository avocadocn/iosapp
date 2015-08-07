//
//  EventRemindCell.h
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexpathButton;
@interface EventRemindCell : UITableViewCell

@property (nonatomic, strong)IndexpathButton *selectButton;

@property (nonatomic, strong)UILabel *remindTimeLabel;

@property (nonatomic, strong)NSIndexPath *indexpath;

- (void)builtInterfaceWithArray:(NSMutableArray *)array andIndexpath:(NSIndexPath *)indexpath;


@end
