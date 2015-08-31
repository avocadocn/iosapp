//
//  GroupCardViewCell.h
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupCardModel;

@interface GroupCardViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *groupImageView;

@property (nonatomic, strong)UIView *colorView;

@property (nonatomic, strong)UILabel *groupIntroLabel;

@property (nonatomic, strong)UIButton *createButton;

- (void)cellReconsitutionWithModel:(GroupCardModel *)model;

@end
