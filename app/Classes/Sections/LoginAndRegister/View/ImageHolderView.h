//
//  ImageHolderView.h
//  app
//
//  Created by 申家 on 15/8/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHolderView : UIView

@property (nonatomic, strong)UITextField *textfield;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceHolder:(NSString *)placeHolder;

@end
