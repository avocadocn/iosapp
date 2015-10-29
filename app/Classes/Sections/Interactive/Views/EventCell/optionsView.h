//
//  optionsView.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface optionsView : UIView<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *optionTextField;

@property (nonatomic, strong)UILabel *optionTagLabel;

- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag;

- (void)builtInterfaceWithTag:(NSInteger)tag;

@end
