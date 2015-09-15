//
//  HelpCellFrame.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "HelpCellFrame.h"
#import "HelpInfoModel.h"
#import "UIImageView+DLGetWebImage.h"
@implementation HelpCellFrame


-(void)setHelpInfoModel:(HelpInfoModel *)helpInfoModel{
    _helpInfoModel = helpInfoModel;
    
    // 头像
    CGFloat avatarImageViewWH = 42.0f;
    CGRect avatarImageViewF = CGRectMake(HelpCellBorderW, HelpCellBorderW, avatarImageViewWH, avatarImageViewWH);
    self.avatarImageViewF = avatarImageViewF;
    
    // 昵称
    NSString *name = helpInfoModel.name;
    CGFloat nameLabelX = CGRectGetMaxX(self.avatarImageViewF) + HelpCellBorderW;
    CGFloat nameLabelY = 17;
    CGSize maxNameLabelSize = CGSizeMake(DLScreenWidth, 16);
    NSDictionary *nameLabelAttr = @{NSFontAttributeName:HelpCellNameFont};
    CGSize nameLabelSize = [name boundingRectWithSize:maxNameLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:nameLabelAttr context:nil].size;
    self.nameLabelF = CGRectMake(nameLabelX, nameLabelY,nameLabelSize.width, nameLabelSize.height);
    
    // 发表时间
    NSString *time = helpInfoModel.time;
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(self.nameLabelF) + 7;
    CGSize maxTimeLabelSize = CGSizeMake(DLScreenWidth, 10);
    NSDictionary *timeLabelAttr = @{NSFontAttributeName:HelpCellTimeFont};
    CGSize timeLabelSize = [time boundingRectWithSize:maxTimeLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:timeLabelAttr context:nil].size;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelSize.width, timeLabelSize.height);
    
    
    CGFloat helpContentLabelX = HelpCellBorderW;
    CGFloat helpContentLabelY = CGRectGetMaxY(self.avatarImageViewF) + 15;
    // 判断是否存在图片
    if (helpInfoModel.helpImageURL) {
        // 存在图片
        CGFloat helpImageViewX = 0;
        CGFloat helpImageViewY = helpContentLabelY;
        self.helpImageViewF = CGRectMake(helpImageViewX, helpImageViewY, DLScreenWidth, DLScreenWidth);
        helpContentLabelY += CGRectGetHeight(self.helpImageViewF) + 14;
    }else{
        // 不存在图片
        self.helpImageViewF = CGRectZero;
    }
    
    
    // 正文
    NSString *helpContent = helpInfoModel.helpText;
    CGSize maxHelpContentLabelSize = CGSizeMake(DLScreenWidth - 2 *HelpCellBorderW, MAXFLOAT);
    NSDictionary *helpContentLabelAttr = @{NSFontAttributeName:HelpCellContentFont};
    CGSize helpContentLabelSize = [helpContent boundingRectWithSize:maxHelpContentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:helpContentLabelAttr context:nil].size;
    self.helpContentLabelF = CGRectMake(helpContentLabelX, helpContentLabelY, helpContentLabelSize.width, helpContentLabelSize.height);
    
    // 整个容器的frame
    self.helpContainerF = CGRectMake(0, HelpCellMargin, DLScreenWidth, CGRectGetMaxY(self.helpContentLabelF) + 15);
    
    self.cellHeight = CGRectGetMaxY(self.helpContainerF);

}

@end
