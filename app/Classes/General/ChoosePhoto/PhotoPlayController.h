//
//  PhotoPlayController.h
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TitleLabelState){
    TitleLabelStateYes,
    TitleLabelStateNo
};

@interface PhotoPlayController : UIViewController

@property (nonatomic, strong)UIView *titleView;

@property (nonatomic, strong)NSMutableArray *showImageArray;  // 用来存放展示图片的 array

@property (nonatomic, strong)UICollectionView *showImageCollection;

@property (nonatomic)NSInteger num;  // 用来计算偏移量的下标

@property (nonatomic, assign)TitleLabelState titleState;

- (instancetype)initWithPhotoArray:(NSArray *)array indexOfContentOffset:(NSInteger)num;

@end
