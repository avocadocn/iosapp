//
//  InteractionView.h
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;


@property (nonatomic, strong)UINavigationController *navigationController;

@end
