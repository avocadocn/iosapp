//
//  AcitvitysShowView.h
//  app
//
//  Created by 张加胜 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivitysShowView;
@protocol ActivitysShowViewDelegate <NSObject>

-(void)activitysShowView:(ActivitysShowView *)activitysShowView btnClickedByIndex:(NSInteger)index;

@end

@interface ActivitysShowView : UIView

@property(weak,nonatomic)id<ActivitysShowViewDelegate> delegate;

@end
