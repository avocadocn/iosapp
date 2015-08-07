//
//  AttentionViewCell.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AttentionViewCell.h"

@implementation AttentionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)cellBuiltWithModel:(id)model
{
    self.AttentionPhoto.layer.masksToBounds = YES;
    self.AttentionPhoto.layer.cornerRadius = 20.0;
    self.AttentionPhoto.image = [model objectForKey:@"image"];
    self.AttentionName.text = [model objectForKey:@"name"];
    self.AttentionWork.text = [model objectForKey:@"work"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
