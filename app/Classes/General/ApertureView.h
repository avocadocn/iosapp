//
//  ApertureView.h
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApertureView : UIView

@property (nonatomic, strong)UIImageView *picImageView;

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image withBorderColor:(UIColor *)color;



@end
