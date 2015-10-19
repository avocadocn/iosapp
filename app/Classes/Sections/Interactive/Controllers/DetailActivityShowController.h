//
//  DetailActivityShowController.h
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;


@interface DetailActivityShowController : UIViewController

@property (nonatomic, strong)Interaction *model;
@property (nonatomic)BOOL orTrue;

@property (nonatomic, copy)NSString *interactionType;
@property (nonatomic, copy)NSString *interaction;
@property (nonatomic, assign)BOOL quitState;


@end
