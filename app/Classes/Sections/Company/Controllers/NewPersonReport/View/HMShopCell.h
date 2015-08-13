//
//  HMShopCell.h
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMShop;
@interface HMShopCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;// 图片
@property (nonatomic, strong)UILabel *personName;   // 华珊
@property (nonatomic, strong)UILabel *personMajor;  // 平面设计专业
@property (nonatomic, strong)UILabel *personLike;  // 喜欢

@property (nonatomic, strong) HMShop *shop;

@property (nonatomic, strong)NSIndexPath *indexpath;

@property (nonatomic, strong)UIImageView *likeImage;

- (void)reloadCellWithModel:(id)model;


@end
