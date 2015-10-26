//
//  AttentionViewController.h
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionViewController : UIViewController

@property (nonatomic, strong)UITableView *attentionTableView;

@property (nonatomic, strong)NSMutableArray *modelArray;

- (void)requestNet;

+ (AttentionViewController *)shareInsten;

@end
