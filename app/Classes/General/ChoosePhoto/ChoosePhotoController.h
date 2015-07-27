//
//  ChoosePhotoController.h
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 用法:
 1: 使用单例的方法对其进行初始化
 2:设置要选取的照片的数量
 3:遵循 ArrangeState 协议,执行arrangeStartWithArray:方法来对取得的图片的数组进行操作
 */


@protocol ArrangeState <NSObject>

- (void)arrangeStartWithArray:(NSMutableArray *)array;

@end

@interface ChoosePhotoController : UIViewController

@property (nonatomic, strong)UICollectionView *photoCollection;  

@property (nonatomic, strong)NSMutableArray *photoArray;  //  存放读取过的相册

@property (nonatomic, strong)UIView *selectView;  // 下方选择图片个数的view

@property (nonatomic, strong)UILabel *selectNumLabel;

@property (nonatomic, strong)id<ArrangeState>delegate;

@property (nonatomic, strong)NSMutableArray *selectArray;  //传递选择图片的数组

@property (nonatomic, assign)NSInteger allowSelectNum;  //允许选择的数量

+ (ChoosePhotoController *)shareStateOfController;

- (void)popViewController;// 当选择数量为1时,选取返回;

@end
