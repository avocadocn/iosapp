//
//  CustomButton.h
//  DWBubbleMenuButtonExample
//
//  Created by 申家 on 15/8/21.
//  Copyright (c) 2015年 Derrick Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (nonatomic, strong)UILabel *myLabel;

@property (nonatomic, strong)UIImageView *coriusImage;

- (void)reloarWithString:(NSString *)str andImage:(UIImage *)image;

@end
