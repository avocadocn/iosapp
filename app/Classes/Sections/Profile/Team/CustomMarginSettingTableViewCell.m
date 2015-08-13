//
//  MyTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomMarginSettingTableViewCell.h"

@implementation CustomMarginSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.textLabel.y = 14;
    self.detailTextLabel.y = 37;
}

@end
