//
//  CheckViewController.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckViewController : UIViewController

@property (nonatomic, weak)NSString *mailURL;

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)UITableView *companyTableView;

@end
