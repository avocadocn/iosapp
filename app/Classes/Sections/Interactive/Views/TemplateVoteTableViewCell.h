//
//  TemplateTableViewCell.h
//  app
//
//  Created by tom on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteCellFrame.h"
@interface TemplateVoteTableViewCell : UITableViewCell

/**
 *
 * 投票人的总数量
 */
@property (nonatomic, assign)NSNumber * voteNum;

/**
 *  投票的尺寸
 */
@property (nonatomic, strong) VoteCellFrame *voteCellFrame;

/**
 * 投票状态 button
 */

@property (nonatomic, strong)UIButton *voteInfosBtn;

@end
