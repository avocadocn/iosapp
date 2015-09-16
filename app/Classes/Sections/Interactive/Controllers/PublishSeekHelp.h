//
//  PublishSeekHelp.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;

@interface PublishSeekHelp : UIViewController

@property (nonatomic, strong)UITextView *seekHelpContent;

@property (nonatomic, strong)UIImageView *selectPhoto;

//加载模板数据
@property (nonatomic, strong)Interaction* model;
@end
