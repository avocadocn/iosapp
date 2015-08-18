//
//  PasswordView.h
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordView : UIView

@property (nonatomic, copy)NSString *password;

- (instancetype)initWithFrame:(CGRect)frame textFieldNum:(CGFloat)num;

@end
