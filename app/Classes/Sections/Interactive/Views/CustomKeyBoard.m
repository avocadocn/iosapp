//
//  CustomKeyBoard.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomKeyBoard.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"
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
    return YES;
}

- (IBAction)emojiClick:(id)sender {
    NSLog(@"点击表情。。。");
    self.inputView.keyboardType = UIKeyboardAnimationCurveUserInfoKey;
    
}

- (IBAction)sendBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POSTTEXT" object:nil userInfo:@{@"name":@"text"}];
    [self.inputView resignFirstResponder];
}


@end
