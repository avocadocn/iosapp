//
//  CustomSettingAvatarTableCell.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomSettingAvatarTableCell.h"
#import "GroupDetileModel.h"
#import "UIImageView+DLGetWebImage.h"
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "GroupDetileModel.h"

@interface CustomSettingAvatarTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;


@end
@implementation CustomSettingAvatarTableCell

- (void)awakeFromNib {
    
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    [self.avatar.layer setMasksToBounds:YES];

}

- (void)reloadCellWithModel:(GroupDetileModel *)model
{
    
        self.identity.text = @"群主";
    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:model.leader];
    self.name.text = per.nickName;
    [self.avatar dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:self.avatar.size];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
