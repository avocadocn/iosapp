//
//  ChoosePhotoController.h
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArrangeState <NSObject>

- (void)arrangeStartWithArray:(NSMutableArray *)array;

@end

@interface ChoosePhotoController : UIViewController

@property (nonatomic, strong)UICollectionView *photoCollection;  

@property (nonatomic, strong)NSMutableArray *photoArray;  //  存放读取过的相册

@property (nonatomic, strong)UIView *selectView;  // 下方选择图片个数的view

@property (nonatomic, strong)UILabel *selectNumLabel;

@property (nonatomic, strong)id<ArrangeState>delegate;

+ (ChoosePhotoController *)shareStateOfController;
@end
