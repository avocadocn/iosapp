//
//  LaunchEventController.h
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchEventController : UIViewController

@property (nonatomic, strong)UIView *superView;

@property (nonatomic, strong)UIView *detailsView;

@property (nonatomic, strong)UIScrollView *eventScroll;

@property (nonatomic, strong)UITextView *eventDetailTextView;  //活动简介

@property (nonatomic, strong)NSMutableArray *remindTitleArray;

@property (nonatomic, strong)UITableView *remindTimeTableView;  //没有提醒

@property (nonatomic, strong)UIView *remindView;

@property (nonatomic, strong)UIButton *chooseButton;

@end
