//
//  RepeaterGroupController.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;
@interface RepeaterGroupController : UIViewController

@property (nonatomic, strong)UICollectionView *groupListCollection;

@property (nonatomic, strong)Interaction* model;
@property (nonatomic, strong)UINavigationController* context;

@property (nonatomic, strong)NSMutableArray *modelArray;

@end
