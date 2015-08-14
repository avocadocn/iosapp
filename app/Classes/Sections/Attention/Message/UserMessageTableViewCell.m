//
//  UserMessageTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UserMessageTableViewCell.h"

@implementation UserMessageTableViewCell

- (void)awakeFromNib {
   
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    [self.avatar.layer setMasksToBounds:YES];
    
    
}


#pragma mark - setter method

/**
 *  可以在此处设置界面的文字。
 *
 *  @param userMessageModel 用户信息模型
 */
-(void)setUserMessageModel:(UserMessageModel *)userMessageModel{
    _userMessageModel = userMessageModel;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyBtnClick:(id)sender {
}


@end
