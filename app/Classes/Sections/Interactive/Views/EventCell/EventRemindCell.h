//
//  EventRemindCell.h
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRemindCell : UITableViewCell

@property (nonatomic, strong)UIButton *selectButton;

@property (nonatomic, strong)UILabel *remindTimeLabel;




- (void)builtInterfaceWithArray:(NSMutableArray *)array andIndexpath:(NSIndexPath *)indexpath;


@end
