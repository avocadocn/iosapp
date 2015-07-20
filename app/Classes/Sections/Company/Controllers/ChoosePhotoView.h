//
//  ChoosePhotoView.h
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePhotoView : UIView

@property (nonatomic, strong)UIButton *insertButton;  //添加图片按钮

@property (nonatomic, strong)UIButton *deleteButton;  //删除

@property (nonatomic, strong)NSMutableArray *componentArray;   //元件库

@property (nonatomic, strong)UIViewController *view;

@end
