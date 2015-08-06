//
//  DLDatePickerView.h
//  PickerView 使用
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 申家. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLDatePickerViewDelegate <NSObject>

- (void)outPutStringOfSelectDate:(NSString *)str withTag:(NSInteger)tag;

@end

@interface DLDatePickerView : UIView

@property (nonatomic, strong)UIDatePicker *picker;

@property (nonatomic, assign)id <DLDatePickerViewDelegate> delegate;

@property (nonatomic, copy)NSString *seleteDateString;  //用户选择的时间;

@property (nonatomic, assign)NSInteger tempTag;

- (void)show;


@end
