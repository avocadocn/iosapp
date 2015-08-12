//
//  ColleagueViewCell.h
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleImageView;

@class CriticWordView;

@interface ColleagueViewCell : UITableViewCell



@property (strong, nonatomic)  UIImageView *ColleaguePhoto;
@property (strong, nonatomic)  UILabel *ColleagueNick; // 同事名字
@property (strong, nonatomic)  UILabel *timeLabel;  // 事件时间
@property (strong, nonatomic)  UILabel *ColleagueWord;  // 话语

@property (strong, nonatomic)  CriticWordView *praiseButton;  // 点赞按钮
@property (strong, nonatomic)  CriticWordView *commondButton;  // 评论按钮

@property (nonatomic , strong)NSArray *array;
@property (nonatomic, assign)NSIndexPath *indexPath;  //用来对应的取数组的 indexPath   已经 撤销
@property (nonatomic, copy)NSString *name;  // 存放假的数据
@property (nonatomic, assign)NSInteger num;

@property (nonatomic, strong)UILabel *wordFrom;  // 来自动梨基地

@property (nonatomic, strong)CircleImageView *circleImage;  // touxiang

@property (nonatomic, strong)UIView *commendView;



@end
