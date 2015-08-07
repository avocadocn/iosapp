//
//  PublishVoteController.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishVoteController : UIViewController


/**
 *投票题目
 */
@property (nonatomic, strong)UITextField *voteTitle;


@property (nonatomic, strong)UIButton *insertOptionButton;

/**
 *放所有小 view 的大 view
 */
@property (nonatomic, strong)UIView *bigView;

/**
 *insertbutton 上面的 line
 */
@property (nonatomic, strong)UIView *buttonLineView;
/**
 *选取图片
 */
@property (nonatomic, strong)UIImageView *selectPhoto;


@end
