//
//  MenuCollectionViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    
    [self.menuCollectionCellIcon.layer setCornerRadius:self.menuCollectionCellIcon.width / 2];
    [self.menuCollectionCellIcon.layer setMasksToBounds:YES];
}

@end
