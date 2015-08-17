//
//  ConditionController.h
//  app
//
//  Created by 申家 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoosePhotoView;

@interface ConditionController : UIViewController
@property (nonatomic, strong)UITextView *speakTextView;

@property (nonatomic, strong)NSMutableArray *photoArray;//  存从相册选取的照片

@property (nonatomic, strong)ChoosePhotoView *selectPhotoView;  // 选取图片的 view

@property (nonatomic, strong)UIButton *addButton;

@property (nonatomic, strong)UICollectionView *collectionView;



@end
