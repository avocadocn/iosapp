//
//  VoteTableViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteInfoModel.h"

#import "VoteCellFrame.h"

@interface VoteTableViewCell : UITableViewCell

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
