//
//  CompanyViewController.h
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CompanyViewController : UIViewController

@property (nonatomic, strong)UICollectionView *BigCollection;

@property (nonatomic, strong)NSMutableArray *modelArray;



@end
