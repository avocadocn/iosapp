//
//  MenuCollectionController.h
//  app
//
//  Created by 张加胜 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuCollectionController;

@protocol MenuCollectionControllerDelegate <NSObject>

-(void)collectionController:(MenuCollectionController *)collectionController didSelectedItemAtIndex:(NSInteger)index;

@end

@interface MenuCollectionController : UICollectionViewController

@property (nonatomic, weak) id<MenuCollectionControllerDelegate> delegate;

@end
