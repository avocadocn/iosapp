//
//  HelpTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "HelpTableViewCell.h"
#import "HelpInfoModel.h"
#import "UIImageView+DLGetWebImage.h"
@interface HelpTableViewCell()
/**
 *  整体
 */
@property (nonatomic, strong) UIView *helpContainer;
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/**
 *  昵称
 */
@property (nonatomic, strong) UILabel  *nameLabel;
/**
 *  发表时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  投票配图
 */
@property (nonatomic, strong) UIImageView *helpImageView;
/**
 *  投票内容label
 */
@property (nonatomic, strong) UILabel *helpContentLabel;
@end

@implementation HelpTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:RGB(235, 235, 235)];
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    // 容器视图
    UIView *helpContainer = [[UIView alloc]init];
    [helpContainer setBackgroundColor:[UIColor whiteColor]];
    
    // 头像 设置圆角
    UIImageView *avatarImageView = [[UIImageView alloc]init];
    avatarImageView.layer.cornerRadius = 42.0f / 2;
    [avatarImageView.layer setMasksToBounds:YES];
    [helpContainer addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel setFont:HelpCellNameFont];
    [helpContainer addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 发表时间
    UILabel *timeLabel = [[UILabel alloc]init];
    [timeLabel setFont:HelpCellTimeFont];
    [helpContainer addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 配图
    UIImageView *helpImageView = [[UIImageView alloc]init];
    [helpImageView setContentMode:UIViewContentModeScaleAspectFit];
    helpImageView.backgroundColor = RGBACOLOR(206, 206, 206, 1);
    [helpContainer addSubview:helpImageView];
    self.helpImageView = helpImageView;
    
    // 正文
    UILabel *helpContentLabel = [[UILabel alloc]init];
    helpContentLabel.font = HelpCellContentFont;
    [helpContentLabel setNumberOfLines:0];
    [helpContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [helpContentLabel setBackgroundColor:[UIColor whiteColor]];
    [helpContainer addSubview:helpContentLabel];
    self.helpContentLabel = helpContentLabel;
    

    
    [self addSubview:helpContainer];
    self.helpContainer = helpContainer;
    
}

-(void)setHelpCellFrame:(HelpCellFrame *)helpCellFrame{
    
    _helpCellFrame = helpCellFrame;
    
    
    HelpInfoModel *model = helpCellFrame.helpInfoModel;
    [self.avatarImageView dlGetRouteWebImageWithString:model.avatarURL placeholderImage:[UIImage imageNamed:@"icon1"]];
    [self.avatarImageView setFrame:helpCellFrame.avatarImageViewF];
    
    
    self.nameLabel.text = model.name;
    [self.nameLabel setFrame:helpCellFrame.nameLabelF];
    
    self.timeLabel.text = model.time;
    [self.timeLabel setFrame:helpCellFrame.timeLabelF];
    
    
    [self.helpImageView setFrame:helpCellFrame.helpImageViewF];
    if (model.helpImageURL) {
        [self.helpImageView dlGetRouteWebImageWithString:model.helpImageURL placeholderImage:nil];
        [self.helpImageView setAlpha:1];
    }else{
        [self.helpImageView setAlpha:0];
    }
    
    self.helpContentLabel.text = model.helpText;
    [self.helpContentLabel setFrame:helpCellFrame.helpContentLabelF];
   
    
    [self.helpContainer setFrame:helpCellFrame.helpContainerF];
}


@end
