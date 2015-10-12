//
//  GroupCardViewTransmitCell.h
//  app
//
//  Created by tom on 15/10/12.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupCardModel;

@interface GroupCardViewTransmitCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *groupImageView;

@property (nonatomic, strong)UIView *colorView;

@property (nonatomic, strong)UILabel *groupIntroLabel;

@property (nonatomic, strong)UIButton *createButton;

- (void)cellReconsitutionWithModel:(GroupCardModel *)model;

@end
