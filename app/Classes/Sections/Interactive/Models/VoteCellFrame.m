//
//  VoteCellFrame.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteCellFrame.h"
#import "VoteInfoModel.h"

@interface VoteCellFrame()



@end

@implementation VoteCellFrame




-(void)setVoteInfoModel:(VoteInfoModel *)voteInfoModel{
    _voteInfoModel = voteInfoModel;
    
    // 头像
    CGFloat avatarImageViewWH = 42.0f;
    CGRect avatarImageViewF = CGRectMake(VoteCellBorderW, VoteCellBorderW, avatarImageViewWH, avatarImageViewWH);
    self.avatarImageViewF = avatarImageViewF;
    
    // 昵称
    NSString *name = voteInfoModel.name;
    CGFloat nameLabelX = CGRectGetMaxX(self.avatarImageViewF) + VoteCellBorderW;
    CGFloat nameLabelY = 17;
    CGSize maxNameLabelSize = CGSizeMake(DLScreenWidth, 16);
    NSDictionary *nameLabelAttr = @{NSFontAttributeName:VoteCellNameFont};
    CGSize nameLabelSize = [name boundingRectWithSize:maxNameLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:nameLabelAttr context:nil].size;
    self.nameLabelF = CGRectMake(nameLabelX, nameLabelY,nameLabelSize.width, nameLabelSize.height);
    
    // 发表时间
    NSString *time = voteInfoModel.time;
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(self.nameLabelF) + 7;
    CGSize maxTimeLabelSize = CGSizeMake(DLScreenWidth, 10);
    NSDictionary *timeLabelAttr = @{NSFontAttributeName:VoteCellTimeFont};
    CGSize timeLabelSize = [time boundingRectWithSize:maxTimeLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:timeLabelAttr context:nil].size;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelSize.width, timeLabelSize.height);
    
    
    CGFloat voteContentLabelX = VoteCellBorderW;
    CGFloat voteContentLabelY = CGRectGetMaxY(self.avatarImageViewF) + 15;
    // 判断是否存在图片
    if (voteInfoModel.voteImageURL) {
        // 存在图片
        CGFloat voteImageViewX = 0;
        CGFloat voteImageViewY = voteContentLabelY;
        self.voteImageViewF = CGRectMake(voteImageViewX, voteImageViewY, DLScreenWidth, DLScreenWidth);
        voteContentLabelY += CGRectGetHeight(self.voteImageViewF) + 14;
    }else{
        // 不存在图片
        self.voteImageViewF = CGRectZero;
    }
    
    
    // 正文
    NSString *voteContent = voteInfoModel.voteText;
    CGSize maxVoteContentLabelSize = CGSizeMake(DLScreenWidth - 2 *VoteCellBorderW, MAXFLOAT);
    NSDictionary *voteContentLabelAttr = @{NSFontAttributeName:VoteCellContentFont};
    CGSize voteContentLabelSize = [voteContent boundingRectWithSize:maxVoteContentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:voteContentLabelAttr context:nil].size;
    self.voteContentLabelF = CGRectMake(voteContentLabelX, voteContentLabelY, voteContentLabelSize.width, voteContentLabelSize.height);
    
    // 选项
    NSInteger count = voteInfoModel.options.count;
    CGFloat optionsViewX = 0;
    CGFloat optionsViewY = CGRectGetMaxY(self.voteContentLabelF) + 14;
    CGFloat optionsViewHeight = 44 * count;
    CGFloat optionsViewWidth = DLScreenWidth;
    self.optionsViewF = CGRectMake(optionsViewX, optionsViewY, optionsViewWidth, optionsViewHeight);
    
    // 工具条
    CGFloat bottomToolBarX = 0;
    CGFloat bottomToolBarY = CGRectGetMaxY(self.optionsViewF);
    CGFloat bottomToolBarWidth = DLScreenWidth;
    CGFloat bottomToolBarHeight = 44;
    self.bottomToolBarF = CGRectMake(bottomToolBarX, bottomToolBarY, bottomToolBarWidth, bottomToolBarHeight);
    
    
    // 整个容器的frame
    self.voteContainerF = CGRectMake(0, VoteCellMargin, DLScreenWidth, CGRectGetMaxY(self.bottomToolBarF));
    
    self.cellHeight = CGRectGetMaxY(self.voteContainerF);
}

@end