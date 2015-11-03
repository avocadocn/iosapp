//
//  LaunchEventController.h
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;
@class XHMessageTextView;

@interface LaunchEventController : UIViewController

@property (nonatomic, strong)UIView *superView;

@property (nonatomic, strong)UIView *detailsView;

@property (nonatomic, strong)UIScrollView *eventScroll;

@property (nonatomic, strong)XHMessageTextView *eventDetailTextView;  //活动简介

@property (nonatomic, strong)NSMutableArray *remindTitleArray;

@property (nonatomic, strong)UITableView *remindTimeTableView;  //没有提醒

@property (nonatomic, strong)UIView *remindView;

@property (nonatomic, strong)UIImageView *chooseButton;

@property (nonatomic, strong)NSIndexPath *indexPathController;

@property (nonatomic, strong)UIView *tableView;

//加载模板数据
@property (nonatomic, strong)Interaction* model;
@property (nonatomic) Boolean isTemplate;
@end
