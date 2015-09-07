//
//  ColleagueViewController.h
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColleagueViewController : UIViewController
@property (nonatomic, strong)UITableView *colleagueTable; //同事大collectionView

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)UIView *interactionView;  // 用户交互 view cell

@property (nonatomic, strong)NSMutableArray *userInterArray;

+ (ColleagueViewController *)shareState;

- (void)netRequest;

@end
