//
//  RankListController.h
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>

typedef enum : NSUInteger {
    RankListTypeMenGod = 7, // 男神
    RankListTypeWomenGod , // 女神
    RankListTypePopularity , // 人气榜
} RankListType;

@interface RankListController : UIViewController <iCarouselDataSource,iCarouselDelegate,UITableViewDataSource,UITableViewDelegate>

-(instancetype)initWithRankListType:(RankListType)rankListType;

@end
