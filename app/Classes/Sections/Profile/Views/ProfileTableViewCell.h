//
//  ProfileTableViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuCellIcon;
@property (weak, nonatomic) IBOutlet UILabel *menuCellName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuCellIconWidth;

@end
