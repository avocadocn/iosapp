//
//  PersonalDynamicController.h
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableHeaderView;
@class AddressBookModel;

@interface PersonalDynamicController : UIViewController

@property (nonatomic, strong)UITableView *dynamicTableView;

@property (nonatomic, strong)TableHeaderView *header;

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)AddressBookModel *userModel;



@end
