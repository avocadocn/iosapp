//
//  DetailActivityShowView.h
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interaction;


@protocol DetailActivityShowViewDelegate <NSObject>

- (void)DetailActivityShowViewDismiss;

- (void)sendRemindTime:(NSDate *)remindTime Theme:(NSString *)theme;

- (void)DeleteCellWithIndex:(NSIndexPath *)index;

@end


@interface DetailActivityShowView : UIView

@property (nonatomic, strong)Interaction *model;

@property (nonatomic)BOOL orCreatBtn;

@property (nonatomic, assign)BOOL deleteButtonState;

@property (nonatomic, assign)id <DetailActivityShowViewDelegate> delegate;

- (instancetype)initWithModel:(Interaction *)model andButtonState:(BOOL)state;

+ (void)cancelLocalNotificationWithKey:(NSString *)key;

@end
