//
//  AddressViewController.h
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMSearchBar;

@class GroupDetileModel;


//通讯录

@interface AddressViewController : UIViewController

@property (nonatomic, strong)UITableView *myTableView;

@property (nonatomic, strong)UISearchBar *searchColleague;

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)EMSearchBar *addressSearch;

@property (nonatomic, strong)NSMutableDictionary *wordDic;

@property (nonatomic, strong)EMSearchBar *searchBar;

@property (nonatomic, strong)GroupDetileModel *detileModel;

/**
 * 是否为选择状态
 */
@property (nonatomic, assign)BOOL selectState;

@end
