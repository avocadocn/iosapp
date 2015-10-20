//
//  RankListController.h
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
@class RankDetileModel;

typedef enum : NSUInteger {
    RankListTypeMenGod = 7, // 男神
    RankListTypeWomenGod , // 女神
    RankListTypePopularity , // 人气榜
} RankListType;

typedef enum {
    PARSE_TYPE_MEN,
    PARSE_TYPE_WOMEN,
    PARSE_TYPE_TEAM,
}PARSE_TYPE;

@protocol RankListControllerDelegate <NSObject>
@optional
- (void)voteForPeople;
@end

@interface RankListController : UIViewController <iCarouselDataSource,iCarouselDelegate,UITableViewDataSource,UITableViewDelegate,RankListControllerDelegate>

-(instancetype)initWithRankListType:(RankListType)rankListType;

@end
