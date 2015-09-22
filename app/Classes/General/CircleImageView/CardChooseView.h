//
//  CardChooseView.h
//  app
//
//  Created by 申家 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 用法:
 1.使用一个由字符串组成的数组来对其进行初始化,数组里每个字符串将生成一个 cell\
 2.父视图先添加其为子视图,再调用 show 方法令其显示
 3.遵循 CardChooseViewDelegate 协议来设置小卡片的点击事件,点击事件由 button 的tag 值确定
 */

@protocol CardChooseViewDelegate <NSObject>

- (void)cardActionWithButton:(UIButton *)sender;
// set smallCell's tap action...

- (void)CardDissmiss;

@end

@interface CardChooseView : UIView


- (instancetype)initWithTitleArray:(NSArray *)array;

@property (nonatomic, assign)id<CardChooseViewDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *titleArray;
/*   The array to save munber's name of CardChooseView's subviews;
 */
@property (nonatomic, assign)CGFloat appearTime;
/*  CardChooseView's appear time,the default is 0.5s;
 */
@property (nonatomic, strong)UIButton *cancelButton;
/* cancelButton
 */
@property (nonatomic, assign)NSInteger cardFontNum;

@property (nonatomic, strong)UIView *maskView;

- (void)show;
/* CardChooseView's show
 */
- (void)disappear;
/* CardChooseView's disappear
 */
@end
