//
//  DLNavBar.h
//  app
//
//  Created by 张加胜 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLNavBar : UIView


/**
 *  显示在导航条上的title集合
 */
@property (nonatomic, strong) NSArray *titles;

/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) void (^didChangedIndex)(NSInteger index);

/**
 *  外部设置滑动页面的距离
 */
@property (nonatomic, assign) CGPoint contentOffset;
@end
