//
//  VoteTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteTableViewCell.h"
#import "VoteOptionsView.h"
#import "VoteInfoModel.h"

@interface VoteTableViewCell()

/**
 *  整体
 */
@property (nonatomic, strong) UIView *voteContainer;
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
@property (nonatomic, strong) UIImageView *voteImageView;
/**
 *  投票内容label
 */
@property (nonatomic, strong) UILabel *voteContentLabel;
/**
 *  选项
 */
@property (nonatomic, strong) VoteOptionsView *optionsView;

/**
 *  底部工具条
 */
@property (nonatomic, strong) UIView *bottomToolBar;
@end

@implementation VoteTableViewCell

- (void)awakeFromNib {
   
}

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
    UIView *voteContainer = [[UIView alloc]init];
    [voteContainer setBackgroundColor:[UIColor whiteColor]];
    
    // 头像 设置圆角
    UIImageView *avatarImageView = [[UIImageView alloc]init];
    avatarImageView.layer.cornerRadius = 42.0f / 2;
    [avatarImageView.layer setMasksToBounds:YES];
    [voteContainer addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel setFont:VoteCellNameFont];
    [voteContainer addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 发表时间
    UILabel *timeLabel = [[UILabel alloc]init];
    [timeLabel setFont:VoteCellTimeFont];
    [voteContainer addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 配图
    UIImageView *voteImageView = [[UIImageView alloc]init];
    [voteImageView setContentMode:UIViewContentModeScaleAspectFit];
    [voteContainer addSubview:voteImageView];
    self.voteImageView = voteImageView;
    
    // 正文
    UILabel *voteContentLabel = [[UILabel alloc]init];
    voteContentLabel.font = VoteCellContentFont;
    [voteContentLabel setNumberOfLines:0];
    [voteContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [voteContentLabel setBackgroundColor:[UIColor yellowColor]];
    [voteContainer addSubview:voteContentLabel];
    self.voteContentLabel = voteContentLabel;
    
    
    // 选项
    VoteOptionsView *optionsView = [[VoteOptionsView alloc]init];
    [voteContainer addSubview:optionsView];
    self.optionsView = optionsView;
    
    // 工具条
    UIView *bottomToolBar = [[UIView alloc]init];
    [bottomToolBar setBackgroundColor:[UIColor blueColor]];
    [voteContainer addSubview:bottomToolBar];
    self.bottomToolBar = bottomToolBar;
    
    
    
   [self addSubview:voteContainer];
    self.voteContainer = voteContainer;
    
}
-(void)setVoteCellFrame:(VoteCellFrame *)voteCellFrame{
    
    _voteCellFrame = voteCellFrame;
    
    
    VoteInfoModel *model = voteCellFrame.voteInfoModel;
    [self.avatarImageView setImage:[UIImage imageNamed:model.avatarURL]];
    [self.avatarImageView setFrame:voteCellFrame.avatarImageViewF];
    
    
    self.nameLabel.text = model.name;
    [self.nameLabel setFrame:voteCellFrame.nameLabelF];

    self.timeLabel.text = model.time;
    [self.timeLabel setFrame:voteCellFrame.timeLabelF];
    
    
    [self.voteImageView setFrame:voteCellFrame.voteImageViewF];
    if (model.voteImageURL) {
        [self.voteImageView setImage:[UIImage imageNamed:model.voteImageURL]];
        [self.voteImageView setAlpha:1];
    }else{
        [self.voteImageView setAlpha:0];
    }
    
    self.voteContentLabel.text = model.voteText;
    [self.voteContentLabel setFrame:voteCellFrame.voteContentLabelF];
    
    // 选项
    [self.optionsView setFrame:voteCellFrame.optionsViewF];
    [self.optionsView setOptions:model.options];
    
    [self.bottomToolBar setFrame:voteCellFrame.bottomToolBarF];
  
    [self.voteContainer setFrame:voteCellFrame.voteContainerF];
}



@end
