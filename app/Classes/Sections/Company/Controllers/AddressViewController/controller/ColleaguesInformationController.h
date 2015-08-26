//
//  ColleaguesInformationController.h
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;
@interface ColleaguesInformationController : UIViewController

@property (nonatomic, strong)NSArray *photoArray;

@property (nonatomic, strong)UIPageControl *pag;

@property (nonatomic, strong)UIButton *attentionButton;

@property (nonatomic, strong)AddressBookModel *model;

@end
