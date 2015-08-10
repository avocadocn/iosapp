//
//  ProfileButton.h
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ProfileButton : UIView

/**
 *  按钮的图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/**
 *  按钮的描述文字
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
