//
//  ZSDSetPasswordView.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ZSDSetPasswordView.h"

#define kFieldSize CGSizeMake(210.0f,45.0f)
#define kDotSize CGSizeMake (10.0f,10.0f)
#define kDotCount 4
#define kLineCount (kDotCount - 1)
#define kLineMarginTop 5.0f

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSInteger num = 1;


@interface ZSDSetPasswordView ()<UITextFieldDelegate>
{
    NSMutableArray *passwordIndicatorArrary;
}

@end

@implementation ZSDSetPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            
            if ([note.object isEqual:_passwordTextField])
            {
                NSLog(@"_password 文字为 %@", _passwordTextField.text);

                [self setDotWithCount:_passwordTextField.text.length andString:[self getLastString:_passwordTextField.text]];
                
                if (_passwordTextField.text.length == kDotCount)
                {
                    if ([_delegate respondsToSelector:@selector(passwordView:inputPassword:)]) {
                        
                        [_delegate passwordView:self inputPassword:_passwordTextField.text];
                    }
                }
            }
            
        }];
        
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {    
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            
            if ([note.object isEqual:_passwordTextField])
            {
                NSLog(@"password 文字为 %@", _passwordTextField.text);
                [self setDotWithCount:_passwordTextField.text.length andString:[self getLastString:_passwordTextField.text]];
                
                if (_passwordTextField.text.length == 6)
                {
                    if ([_delegate respondsToSelector:@selector(passwordView:inputPassword:)])
                    {
                        [_delegate passwordView:self inputPassword:_passwordTextField.text];
                    }
                }
            }
        }];
        
        [self initView];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)fieldBecomeFirstResponder
{
    [_passwordTextField becomeFirstResponder];
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    passwordIndicatorArrary = [[NSMutableArray alloc] init];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kFieldSize.width, kFieldSize.height)];
    _passwordTextField.hidden = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_passwordTextField];
    
    CGFloat width = self.bounds.size.width / kDotCount;
    for (int i = 0; i < kLineCount; i++)//线
    {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * width, kLineMarginTop, 1.0f, self.bounds.size.height - 2 * kLineMarginTop)];
        lineImageView.backgroundColor = UIColorFromRGB(0xEEEEEE);
//        lineImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:lineImageView];
    }
    
    for (int i = 0; i < kDotCount; i++)
    {
        UILabel *dotImageView = [[UILabel alloc]initWithFrame:CGRectMake((width - kDotSize.width) / 2.18f + i * width, (self.bounds.size.height - kDotSize.height) / 2.5f, kDotSize.width * 2, kDotSize.height * 2)];
        
        [self addSubview:dotImageView];
        
        [passwordIndicatorArrary addObject:dotImageView];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", string);
    if([string isEqualToString:@"\n"])
    {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount)
    {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)setDotWithCount:(NSInteger)count andString:(NSString *)str
{
    
    NSLog(@"绘制 %ld", count);
    if (count == num) { //从零开始
        ((UILabel*)[passwordIndicatorArrary objectAtIndex:(count - 1)]).text = [NSString stringWithFormat:@"%@", str];
        num ++;
    } else
    {
        ((UILabel*)[passwordIndicatorArrary objectAtIndex:(num - 2)]).text = nil;
        num --;
    }
    
    
}

- (void)clearUpPassword
{
    NSLog(@"清除");
    _passwordTextField.text = @"";
    NSLog(@"password 的 text 是 %@", _passwordTextField.text);
    [self setDotWithCount:_passwordTextField.text.length andString:[self getLastString:_passwordTextField.text]];
}
- (NSString *)getLastString:(NSString *)str
{
    NSInteger num = str.length;
    NSString *getStr = [str substringWithRange:NSMakeRange(num - 1, 1)];
    return getStr;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_passwordTextField becomeFirstResponder];
}



@end
