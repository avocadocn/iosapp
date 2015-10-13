//
//  CustomKeyBoard.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "DXFaceView.h"
#import "CustomKeyBoard.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"

typedef NS_ENUM(NSInteger, DLKeyBoardType) {
    DLKeyBoardTypeNormal,
    DLKeyBoardTypeFace
};

@interface CustomKeyBoard ()<DXFaceDelegate>
@property (nonatomic, assign)DLKeyBoardType keyBoard;
@end
@implementation CustomKeyBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSString *str = textField.text;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POSTTEXT" object:nil userInfo:@{@"name":@"text"}];
    [self.inputView resignFirstResponder];
    self.inputView.text = nil;
    return YES;
}

- (IBAction)emojiClick:(id)sender {
//    NSLog(@"点击表情。。。");
//    self.inputView.keyboardType = UIKeyboardAnimationCurveUserInfoKey;
    switch (self.keyBoard) {
        case DLKeyBoardTypeNormal:
        {
            DXFaceView *face = [[DXFaceView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 200)];
            face.backgroundColor = RGBACOLOR(238, 238, 245, 1);
            face.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            self.inputView.inputView = face;
            
            face.delegate = self;
            [self.inputView reloadInputViews];
            self.keyBoard = DLKeyBoardTypeFace;
        }
            break;
        case DLKeyBoardTypeFace:
        {
            self.inputView.inputView = UIInputViewStyleDefault;
            [self.inputView reloadInputViews];
            self.keyBoard = DLKeyBoardTypeNormal;
        }
            break;
        default:
            break;
    }
    
    
}

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
    {
        NSLog(@" 选中的表情为%@  %d", str, isDelete);
        NSMutableString *mustr = [NSMutableString stringWithFormat:@"%@", self.inputView.text];
        if (isDelete && mustr.length) {
            NSString *lastStr;
            if (mustr.length == 1) {
                lastStr = [mustr substringFromIndex:mustr.length - 1];
            } else
            {
                lastStr = [mustr substringFromIndex:mustr.length - 2];
            }
            BOOL judge = [self stringContainsEmoji:lastStr];
            NSLog(@"%d   %@", judge, lastStr);
            if (judge) {
                NSLog(@"是表情");
                [mustr deleteCharactersInRange:NSMakeRange(mustr.length - 2, 2)];
            } else
            {
                [mustr deleteCharactersInRange:NSMakeRange(mustr.length - 1, 1)];
                NSLog(@"不是表情");
            }
            
            self.inputView.text = mustr;
        } else if (!isDelete) {
            self.inputView.text = [NSString stringWithFormat:@"%@%@",self.inputView.text, str];
        }
    
}
- (void)sendFace
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POSTTEXT" object:nil userInfo:@{@"name":@"text"}];
    self.inputView.text = nil;
    [self.inputView resignFirstResponder];
}


- (IBAction)sendBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POSTTEXT" object:nil userInfo:@{@"name":@"text"}];
    self.inputView.text = nil;
    [self.inputView resignFirstResponder];
}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
