//
//  TeamHomePageController.h
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupDetileModel;
@class GroupCardModel;


@interface TeamHomePageController : UIViewController
@property (nonatomic, strong)GroupDetileModel *informationModel;
@property (nonatomic, strong)GroupCardModel *groupCardModel;

@end
