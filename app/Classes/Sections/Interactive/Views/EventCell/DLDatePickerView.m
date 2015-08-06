//
//  DLDatePickerView.m
//  PickerView 使用
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 申家. All rights reserved.
//

#import "DLDatePickerView.h"
#import <Masonry.h>

@interface DLDatePickerView ()

@end

@implementation DLDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)builtInterface
{
    self.frame = CGRectMake(0, DLScreenHeight, DLScreenWidth, DLScreenHeight);
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear:)];
    [self addGestureRecognizer:tap];
    
    self.seleteDateString = [[NSString alloc]init];
    
    self.picker = [UIDatePicker new];
    
    [self.picker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.picker.locale = locale;
    
    NSDate *localDate = [NSDate date];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *off = [[NSDateComponents alloc]init];
    
    [off setMonth:12];
    [off setDay:0];
    [off setHour:0];
    [off setHour:0];
    
    NSDate *maxDate = [gregorian dateByAddingComponents:off toDate:localDate options:0];
    NSDate *adate = [NSDate date];
    
    self.picker.minimumDate = adate;
    self.picker.maximumDate = maxDate;
    
    
    [self.picker setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    
}

- (void)show  //出现
{
    [UIView animateWithDuration:.4 animations:^{
        self.centerY = DLScreenHeight / 2.0;
    }];
}

- (void)disappear:(UITapGestureRecognizer *)tap   //消失
{
    NSLog(@"消失");
    [UIView animateWithDuration:.4 animations:^{
        self.centerY = DLScreenHeight + (self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        NSDate *pickerdate = [self.picker date];
        NSDateFormatter *pickerFoematter = [[NSDateFormatter alloc]init];
        
        [pickerFoematter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *dateStr = [pickerFoematter stringFromDate:pickerdate];

        [self.delegate outPutStringOfSelectDate:dateStr withTag:self.tag];
    }];
}




@end
