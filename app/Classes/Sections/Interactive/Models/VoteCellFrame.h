//
//  VoteCellFrame.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>
// 昵称字体
#define VoteCellNameFont [UIFont systemFontOfSize:16]
// 时间字体
#define VoteCellTimeFont [UIFont systemFontOfSize:10]

// 正文字体
#define VoteCellContentFont [UIFont systemFontOfSize:15]



// cell之间的间距
#define VoteCellMargin 10

// cell的边框宽度
#define VoteCellBorderW 12


@class VoteInfoModel;
@interface VoteCellFrame : NSObject



/**
 *  整体
 */
@property (nonatomic, assign) CGRect voteContainerF;
/**
 *  头像
 */
@property (nonatomic, assign) CGRect avatarImageViewF;
/**
 *  昵称
 */
@property (nonatomic, assign) CGRect nameLabelF;
/**
 *  发表时间
 */
@property (nonatomic, assign) CGRect timeLabelF;
/**
 *  投票配图
 */
@property (nonatomic, assign) CGRect voteImageViewF;
/**
 *  投票内容label
 */
@property (nonatomic, assign) CGRect voteContentLabelF;
/**
 *  选项
 */
@property (nonatomic, assign) CGRect optionsViewF;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  底部工具条
 */
@property (nonatomic, assign) CGRect bottomToolBarF;
/**
 *  vote模型
 */
@property (nonatomic, strong) VoteInfoModel *voteInfoModel;
/**
 *Judge builtInterface
 */
@property (nonatomic, assign)BOOL interfaceState;
/**
 *
 * 投票人的总数
 */
@property (nonatomic, assign)NSNumber *voteNum;

@property (nonatomic, assign) CGRect bottomTransmitBarF;
/**
 *计算模板参数的frames
 */
-(void)setTemplateVoteInfoModel:(VoteInfoModel *)voteInfoModel;

@end
