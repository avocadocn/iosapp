//
//  PasswordView.h
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassWordViewDelegate <NSObject>

- (void)sendPassword:(NSString *)password;

@end

@interface PasswordView : UIView

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)id <PassWordViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame textFieldNum:(CGFloat)num;


@end
