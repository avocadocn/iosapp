//
//  VoteOptionsView.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoteInfoModel;


@interface VoteOptionsView : UIView


/**
 *  选项模型数组
 */
@property (nonatomic, strong) NSArray *modelArray;
/**
 *  参与投票的总人数
 */
@property (nonatomic, assign) NSNumber *voteCount;

-(void)setOptions:(VoteInfoModel *)model;
//是否过滤动画效果
@property (nonatomic) Boolean isAnimationFiltered;
@end
