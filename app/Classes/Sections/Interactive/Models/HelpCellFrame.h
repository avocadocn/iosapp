//
//  HelpCellFrame.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define HelpCellNameFont [UIFont systemFontOfSize:16]
// 时间字体
#define HelpCellTimeFont [UIFont systemFontOfSize:10]

// 正文字体
#define HelpCellContentFont [UIFont systemFontOfSize:15]



// cell之间的间距
#define HelpCellMargin 10

// cell的边框宽度
#define HelpCellBorderW 12

@class HelpInfoModel;

@interface HelpCellFrame : NSObject


/**
 *  整体
 */
@property (nonatomic, assign) CGRect helpContainerF;
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
 *  互助配图
 */
@property (nonatomic, assign) CGRect helpImageViewF;
/**
 *  互助内容label
 */
@property (nonatomic, assign) CGRect helpContentLabelF;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  互助model
 */
@property (nonatomic, strong) HelpInfoModel *helpInfoModel;

@property (nonatomic, assign) CGRect bottomTransmitBarF;

-(void)setTemplateHelpInfoModel:(HelpInfoModel *)helpInfoModel;
@end
