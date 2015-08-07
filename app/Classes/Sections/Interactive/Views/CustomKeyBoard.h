//
//  CustomKeyBoard.h
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomKeyBoard : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet UIButton *emotion;

@end
