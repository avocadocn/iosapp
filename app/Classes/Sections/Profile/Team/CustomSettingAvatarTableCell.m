//
//  CustomSettingAvatarTableCell.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomSettingAvatarTableCell.h"


@interface CustomSettingAvatarTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;


@end
@implementation CustomSettingAvatarTableCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    [self.avatar.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
