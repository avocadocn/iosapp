//
//  CricleDetailViewController.h
//  app
//
//  Created by 申家 on 15/9/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleContextModel;

@protocol CricleDetailViewControllerDelegate <NSObject>

- (void)reloadData:(NSIndexPath *)index;

- (void)deleteIndexPath:(NSIndexPath *)index;

@end

@interface CricleDetailViewController : UIViewController



@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, strong)CircleContextModel *tempModel;
@property (nonatomic, assign)id <CricleDetailViewControllerDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSIndexPath *index;

@end
