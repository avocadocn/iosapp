//
//  CustomSettingAvatarTableCell.h
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupDetileModel;

@interface CustomSettingAvatarTableCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *identity;

- (void)reloadCellWithModel:(GroupDetileModel *)model;


@end
