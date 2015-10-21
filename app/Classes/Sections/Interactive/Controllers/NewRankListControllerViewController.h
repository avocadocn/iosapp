//
//  NewRankListControllerViewController.h
//  app
//
//  Created by tom on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    NewRankListTypeMenGod = 1, // 男神
    NewRankListTypeWomenGod , // 女神
    NewRankListTypePopularity , // 人气榜
} NewRankListType;


@interface NewRankListControllerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NewRankListType listType;
@end
