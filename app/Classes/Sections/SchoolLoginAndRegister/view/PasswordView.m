//
//  PasswordView.m
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PasswordView.h"
#import <ReactiveCocoa.h>
#import "EnumTextField.h"


@implementation PasswordView

- (instancetype)initWithFrame:(CGRect)frame textFieldNum:(CGFloat)num
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterfaceWithNum:num];
    }
    return self;
}

- (void)builtInterfaceWithNum:(CGFloat)num
{
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat width = self.frame.size.width / num;
    CGFloat hetght = self.frame.size.height;
    
    for (int i = 0; i < num; i++) {
        EnumTextField *textField = [[EnumTextField alloc]initWithFrame:CGRectMake(i * width, 0, width, hetght)];
        [textField.rac_textSignal subscribeNext:^(NSString *str) {
            if (str.length == 1) {
                
                EnumTextField *respTextField = (EnumTextField *)[self viewWithTag:(i + 2)];
                [respTextField becomeFirstResponder];
                textField.keyBorad = KeyBoardStateYes;
            }
//            if (str.length == 0 && textField.keyBorad == KeyBoardStateYes) {
//                EnumTextField *respTextField = (EnumTextField *)[self viewWithTag:i];
//                [respTextField becomeFirstResponder];
//            }
        }];
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = i + 1;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = .3;
        textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textField];
        
    }
}



@end
