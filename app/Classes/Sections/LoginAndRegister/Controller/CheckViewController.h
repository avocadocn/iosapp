//
//  CheckViewController.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageHolderView;



@interface CheckViewController : UIViewController

@property (nonatomic, copy)NSString *mailURL;

@property (nonatomic, strong)UITableView *companyTableView;

@property (nonatomic, strong)ImageHolderView *school;

@property (nonatomic, strong)ImageHolderView *time;

@property (nonatomic, strong)UITableView *searchTableView;

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, copy)NSString *schoolID;

//- (void)requestNetWithSuffix:(NSString *)str;

@end
