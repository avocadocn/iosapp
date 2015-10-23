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

@optional

- (void)dismiss;

@end

@interface DLDatePickerView : UIView

@property (nonatomic, strong)UIDatePicker *picker;

@property (nonatomic, assign)id <DLDatePickerViewDelegate> delegate;

@property (nonatomic, copy)NSString *seleteDateString;  //用户选择的时间;

@property (nonatomic, assign)NSInteger tempTag;

@property (nonatomic, copy)NSDate *maxDate;

@property (nonatomic, copy)NSDate *minDate;

- (void)show;
/**
 *
 * 自定义 datepickerview, 写在 show 前面
 */
- (void)reloadWithMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate dateMode:(UIDatePickerMode)mode;
@end
