//
//  DSNavigationBar.h
//  DSTranparentNavigationBar
//
//  Created by Diego Serrano on 10/13/14.
//  Copyright (c) 2014 Diego Serrano. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DSNavigationBar : UINavigationBar

@property (strong, nonatomic) IBInspectable UIColor *color;

-(void)setNavigationBarWithColor:(UIColor *)color;
-(void)setNavigationBarWithColors:(NSArray *)colours;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
