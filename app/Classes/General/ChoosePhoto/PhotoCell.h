//
//  PhotoCell.h
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIButton *insertButton;

@property (nonatomic, assign)NSInteger selectNum;

@end
