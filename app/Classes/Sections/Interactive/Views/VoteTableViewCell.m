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
#import "VoteBottomToolBar.h"
#import <ReactiveCocoa.h>
#import "VoteInfoTableViewController.h"
#import "VoteTableController.h"
#import "TeamSettingViewController.h"
#import "CommentsViewController.h"
#import "UIImageView+DLGetWebImage.h"
#import "Interaction.h"

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

@property (nonatomic, copy) NSString *interactionId;

@property (nonatomic, strong)VoteInfoModel *infoModel;
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
    //    [voteContainer setBackgroundColor:[UIColor yellowColor]];
    
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
    [voteContentLabel setBackgroundColor:[UIColor clearColor]];
    [voteContainer addSubview:voteContentLabel];
    self.voteContentLabel = voteContentLabel;
    
    
    // 选项
    VoteOptionsView *optionsView = [[VoteOptionsView alloc]init];
    optionsView.voteCount = self.voteNum;
    [voteContainer addSubview:optionsView];
    //    optionsView.backgroundColor = [UIColor redColor];
    self.optionsView = optionsView;
    
    // 从六个背景条颜色的所有种排序中选出一个
    // 某处应设置取色的二维数组。
    // 直接取发布时间中的秒数，取除10的余数，余数取数组中的数据
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    int getColorSet = floor(fmod(floor(time),9));
    NSLog(@"余数:%i", getColorSet);
    // 接下来每个选项都可以从获取的数据中取到相对固定的颜色。
    
    // 添加已投票btn
    self.voteInfosBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.voteInfosBtn setTitle:@"投票" forState:UIControlStateNormal];
    self.voteInfosBtn.x = 12;
    self.voteInfosBtn.y = 0;
    self.voteInfosBtn.width = 60;
    self.voteInfosBtn.height = 44;
    
    // 此处使用rac 监听按钮的点击事件
    RACSignal *voteInfosSignal = [self.voteInfosBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [voteInfosSignal subscribeNext:^(id x) {
        
        
        VoteInfoTableViewController *controller = [[VoteInfoTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.model = self.infoModel.model;
        // **********************************************
        // 此处由于代理 以及 通知的使用均不合适，所以在这边我采用了cell所处的viewController的类方法 \
        返回一个单例的navigationController， 这样方便在cell的任何子控件调用，已推出新的viewcontroller
        // **********************************************
        [[VoteTableController shareNavigation] pushViewController:controller animated:YES];
    }];
    
    // 添加转发btn
    UIButton *retweedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retweedBtn setTitle:@"" forState:UIControlStateNormal];
    retweedBtn.x = DLScreenWidth - 80;
    retweedBtn.y = 0;
    retweedBtn.width = 40;
    retweedBtn.height = 44;
    
    // 添加评论btn
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.x = DLScreenWidth - 40;
    commentBtn.y = 0;
    commentBtn.width = 40;
    commentBtn.height = 44;
    
    RACSignal *commentBtnSignal = [commentBtn rac_signalForControlEvents:UIControlEventTouchDown];
    [commentBtnSignal subscribeNext:^(id x) {
        
        CommentsViewController *controller = [[CommentsViewController alloc]init];
        controller.interactionType = @2;
        controller.inteactionId = self.interactionId;
        [[VoteTableController shareNavigation] pushViewController:controller animated:YES];
    }];
    
    // 工具条
    UIView *bottomToolBar = [[UIView alloc]init];
    [bottomToolBar setBackgroundColor:[UIColor whiteColor]];
    [bottomToolBar addSubview:self.voteInfosBtn];
    [bottomToolBar addSubview:retweedBtn];
    [bottomToolBar addSubview:commentBtn];
    [voteContainer addSubview:bottomToolBar];
    self.bottomToolBar = bottomToolBar;
    
    [self addSubview:voteContainer];
    self.voteContainer = voteContainer;
    
}


-(void)setVoteCellFrame:(VoteCellFrame *)voteCellFrame{
    self.voteNum = voteCellFrame.voteNum;
    self.optionsView.voteCount = self.voteNum;
    
    _voteCellFrame = voteCellFrame;
    
    VoteInfoModel *model = voteCellFrame.voteInfoModel;
    self.infoModel = voteCellFrame.voteInfoModel; //***********************
    self.interactionId = model.interactionId;
    [self.avatarImageView dlGetRouteWebImageWithString:model.avatarURL placeholderImage:[UIImage imageNamed:@"icon1"]];
    [self.avatarImageView setFrame:voteCellFrame.avatarImageViewF];
    
    self.nameLabel.text = model.name;
    [self.nameLabel setFrame:voteCellFrame.nameLabelF];
    
    self.timeLabel.text = model.time;
    [self.timeLabel setFrame:voteCellFrame.timeLabelF];
    //    self.timeLabel.backgroundColor = [UIColor redColor];
    [self.voteImageView setFrame:voteCellFrame.voteImageViewF];
    if (model.voteImageURL) {
        [self.voteImageView dlGetRouteWebImageWithString:model.voteImageURL placeholderImage:[UIImage imageNamed:@"108"]];
        [self.voteImageView setAlpha:1];
    }else{
        [self.voteImageView setAlpha:0];
    }
    
    self.voteContentLabel.text = model.voteText;
    [self.voteContentLabel setFrame:voteCellFrame.voteContentLabelF];
    
    // 选项
    [self.optionsView setFrame:voteCellFrame.optionsViewF];
    
    NSArray *array = [self.optionsView subviews];
    
    for (id view in array) {
        [view removeFromSuperview];
    }
    
    [self.optionsView setOptions:model];  //添加动画 view 只要有一次
    
    [self.bottomToolBar setFrame:voteCellFrame.bottomToolBarF];
    
    [self.voteContainer setFrame:voteCellFrame.voteContainerF];
    
    if (voteCellFrame.voteInfoModel.judgeVote == YES) {
        [self.voteInfosBtn setTitle:@"已投票" forState: UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setVoteTitle) name:@"Vote" object:nil];  //  接受跳转通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setVoteTitle) name:@"CHANGESTATE" object:nil];
}

- (void)setVoteTitle
{
    [self.voteInfosBtn setTitle:@"已投票" forState: UIControlStateNormal];
}

@end
