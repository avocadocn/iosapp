//
//  MessageTableViewCell.m
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "UIImageView+DLGetWebImage.h"
#import "MessageTableViewCell.h"
#import "InformationModel.h"
@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.projectPicture;
//    self.titleLabel;
//    self.contentLabel;
    self.projectPicture.layer.masksToBounds = YES;
    self.projectPicture.layer.cornerRadius = 25;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InformationModel *)model
{
    Person *per= [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:model.sender];
    [self.projectPicture dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:CGSizeMake(100, 100)];
    self.titleLabel.text = per.nickName;
    self.contentLabel.text = model.content;
    
    NSInteger num = [model.examine integerValue];
    switch (num) {
        case 0:
        {
            self.backgroundColor = [UIColor whiteColor];
            self.userInteractionEnabled = YES;
            
            NSLog(@"未读 背景为白色");
        }
            break;
        case 1:
        {
            self.backgroundColor = RGBACOLOR(238, 238, 238, 1);
//            self.userInteractionEnabled = NO;
            NSLog(@"未读 背景为黑色");
        }
        default:
            break;
    }
    
}

@end
