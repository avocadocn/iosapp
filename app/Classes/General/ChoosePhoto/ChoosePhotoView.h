//
//  ChoosePhotoView.h
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChoosePhotoView;

@protocol ChoosePhotoViewDelegate <NSObject>

@optional

- (void)ChoosePhotoView:(ChoosePhotoView *)chooseView withFrame:(CGRect)frame;

@end

@interface ChoosePhotoView : UIView

@property (nonatomic, strong)UIButton *insertButton;  //添加图片按钮

@property (nonatomic, strong)UIButton *deleteButton;  //删除

@property (nonatomic, strong)NSMutableArray *componentArray;   //元件库

@property (nonatomic, strong)UIViewController *view;

@property (nonatomic, strong)NSMutableArray *imagePhotoArray;  //存放已经添加的 image 图片 ,防止浪费内存

@property (nonatomic, assign)id <ChoosePhotoViewDelegate>delegate;

@end
