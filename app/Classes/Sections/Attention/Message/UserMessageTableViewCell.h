//
//  UserMessageTableViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMessageModel.h"

@interface UserMessageTableViewCell : UITableViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;

/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *text;

/**
 *  事件的背景（其实是容器）
 */
@property (weak, nonatomic) IBOutlet UIView *eventBackground;

/**
 *  事件图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *eventIcon;

/**
 *  事件状态
 */
@property (weak, nonatomic) IBOutlet UILabel *eventState;

/**
 *  事件描述
 */
@property (weak, nonatomic) IBOutlet UILabel *eventDesc;


/**
 *  转发的背景（其实是容器)
 */
@property (weak, nonatomic) IBOutlet UIView *retweedBackground;

/**
 *  转发事件的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *retweedText;

/**
 *  转发事件的图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *retweedEventIcon;

/**
 *  转发事件的状态
 */
@property (weak, nonatomic) IBOutlet UILabel *retweedEventState;

/**
 *  转发事件的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *retweedEventDesc;

/**
 *  来自
 */
@property (weak, nonatomic) IBOutlet UILabel *from;

/**
 *  分隔线
 */
@property (weak, nonatomic) IBOutlet UIView *sepratorLine;



/**
 *  回复按钮点击
 *
 *  @param sender 回复按钮
 */
- (IBAction)replyBtnClick:(id)sender;

/**
 *  text高度的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeightConstraint;

/**
 *  活动背景的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventBackgroundHeightConstraint;

/**
 *  转发背景高度的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweedBackgroundHeightConstraint;

/**
 *  转发内容高度的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweedTextHeightConstraint;



@property (nonatomic, strong) UserMessageModel *userMessageModel;

@end
