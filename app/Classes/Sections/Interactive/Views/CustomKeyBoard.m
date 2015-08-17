//
//  CustomKeyBoard.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomKeyBoard.h"

@implementation CustomKeyBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [self.inputView resignFirstResponder];
    return YES;
}


- (IBAction)sendBtnClicked:(id)sender {
    [self.inputView resignFirstResponder];
}


@end