//
//  PhotoShouCell.h
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoShouCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *showImageView;

- (void)settingUpImageViewWithImage:(UIImage *)image;

@end
