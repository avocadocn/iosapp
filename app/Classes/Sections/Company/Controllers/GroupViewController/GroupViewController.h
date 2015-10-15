//
//  GroupViewController.h
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GroupType)
{
    GroupTypeCompany,
    GroupTypeSingle
};

@interface GroupViewController : UIViewController


@property (nonatomic, strong)UICollectionView *groupListCollection;

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, assign)GroupType groupType;

@end
