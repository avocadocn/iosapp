//
//  PhotoShouCell.h
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhotoShowCellDelegate <NSObject>

- (void)photoShowSuperControllerDismiss;

@end
@interface PhotoShouCell : UICollectionViewCell




@property (nonatomic, strong)UIImageView *showImageView;
@property (nonatomic, assign)id <PhotoShowCellDelegate>delegate;
- (void)settingUpImageViewWithImage:(id)image;

@end
