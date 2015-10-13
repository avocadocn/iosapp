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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InformationModel *)model
{
    Person *per= [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:model.sender];
    [self.projectPicture dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:CGSizeMake(100, 100)];
    self.titleLabel.text = per.name;
    self.contentLabel.text = model.content;

}

@end
