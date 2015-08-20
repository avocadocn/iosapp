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

@interface PasswordView ()<UITextFieldDelegate>

@end


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
        textField.delegate = self;
        [textField.rac_textSignal subscribeNext:^(NSString *str) {
            if (str.length == 1 && (i != num -1)) {
                
                EnumTextField *respTextField = (EnumTextField *)[self viewWithTag:(i + 2)];
                [respTextField becomeFirstResponder];
                textField.keyBorad = KeyBoardStateYes;
            }
            if (str.length == 1 && i == num - 1)
            {
                NSArray *array = self.subviews;
                NSMutableString *mutableStr = [NSMutableString string];
                for (EnumTextField *text in array) {
                    [mutableStr appendString:text.text];
                }
                [self.delegate sendPassword:mutableStr];
            }
        }];
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = i + 1;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = .3;
        textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    textview 改变字体的行间距
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textField.attributedText = [[NSAttributedString alloc]initWithString:textField.text attributes:attributes];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"点击");
    
    EnumTextField *enumtextfield = (EnumTextField *)[self viewWithTag:textField.tag];
    
    if (range.location >= 1)
        
        return NO;
    if (range.location == 0 && enumtextfield.keyBorad == KeyBoardStateYes) {
        EnumTextField *myTextField = (EnumTextField *)[self viewWithTag:textField.tag - 1];
        [myTextField becomeFirstResponder];
    }
    
    return YES;
    
}

@end
