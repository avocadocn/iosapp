//
//  TemplateTableViewCell.m
//  app
//
//  Created by tom on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteOptionsView.h"
#import "VoteInfoModel.h"
#import "VoteBottomToolBar.h"
#import <ReactiveCocoa.h>
#import "VoteInfoTableViewController.h"
#import "VoteTableController.h"
#import "TeamSettingViewController.h"
#import "CommentsViewController.h"
#import "TemplateVoteTableViewCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "UILabel+DLTimeLabel.h"
#import "RepeaterGroupController.h"
@interface TemplateVoteTableViewCell()

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

@property (nonatomic, strong) UIView* voteContentView;
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

@property (nonatomic, strong) UIButton* bottomTransmitBtn;
@property (nonatomic, strong) UIView *bottomTransmitBar;
@end

@implementation TemplateVoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
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
    [voteContentLabel setBackgroundColor:[UIColor clearColor]];
    self.voteContentLabel = voteContentLabel;
    
    UIView *voteContentView = [[UIView alloc] init];
    [voteContentView setBackgroundColor:[UIColor greenColor]];
    [voteContentView addSubview:voteContentLabel];
    [voteContainer addSubview:voteContentView];
    self.voteContentView = voteContentView;
    // 选项
    VoteOptionsView *optionsView = [[VoteOptionsView alloc]init];
    optionsView.voteCount = self.voteNum;
    optionsView.isAnimationFiltered =true;
    optionsView.isBorderEnable = true;
    [voteContainer addSubview:optionsView];
    optionsView.backgroundColor = [UIColor whiteColor];
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
        
        // **********************************************
        // 此处由于代理 以及 通知的使用均不合适，所以在这边我采用了cell所处的viewController的类方法 \
        返回一个单例的navigationController， 这样方便在cell的任何子控件调用，已推出新的viewcontroller
        // **********************************************
        [[VoteTableController shareNavigation] pushViewController:controller animated:YES];
    }];
    
    // 添加转发btn
    UIButton *retweedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retweedBtn setTitle:@"转发" forState:UIControlStateNormal];
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
        [[VoteTableController shareNavigation] pushViewController:controller animated:YES];
    }];
    
//    // 工具条
//    UIView *bottomToolBar = [[UIView alloc]init];
//    [bottomToolBar setBackgroundColor:[UIColor whiteColor]];
//    [bottomToolBar addSubview:self.voteInfosBtn];
//    [bottomToolBar addSubview:retweedBtn];
//    [bottomToolBar addSubview:commentBtn];
//    [voteContainer addSubview:bottomToolBar];
//    self.bottomToolBar = bottomToolBar;
    
    UIView *bottomTransmitBar = [UIView new];
    [bottomTransmitBar setBackgroundColor:[UIColor whiteColor]];
    UIButton *bottomTransmitBtn = [UIButton new];
    [bottomTransmitBtn setBackgroundColor:RGB(0xfd, 0xb9, 0x0)];
    bottomTransmitBtn.font=[UIFont systemFontOfSize:18.0f];
    [bottomTransmitBtn setTitle:@"转发" forState:UIControlStateNormal];
    [bottomTransmitBar addSubview:bottomTransmitBtn];
    [voteContainer addSubview:bottomTransmitBar];
    self.bottomTransmitBar = bottomTransmitBar;
    self.bottomTransmitBtn = bottomTransmitBtn;
    
    [self addSubview:voteContainer];
    self.voteContainer = voteContainer;
    
}

-(void)setVoteCellFrame:(VoteCellFrame *)voteCellFrame{
    self.voteNum = voteCellFrame.voteNum;
    self.optionsView.voteCount = self.voteNum;
    
    _voteCellFrame = voteCellFrame;
    
    VoteInfoModel *model = voteCellFrame.voteInfoModel;
    [self.avatarImageView setImage:[UIImage imageNamed:model.avatarURL]];
    [self.avatarImageView setFrame:voteCellFrame.avatarImageViewF];
    
    self.nameLabel.text = model.name;
    [self.nameLabel setFrame:voteCellFrame.nameLabelF];
    
//    self.timeLabel.text = model.time;
    [self.timeLabel judgeTimeWithString:model.time];
    [self.timeLabel setFrame:voteCellFrame.timeLabelF];
    //    self.timeLabel.backgroundColor = [UIColor redColor];
    [self.voteImageView setFrame:voteCellFrame.voteImageViewF];
    if (model.voteImageURL) {
        [self.voteImageView dlGetRouteWebImageWithString:model.voteImageURL placeholderImage:nil];
        [self.voteImageView setAlpha:1];
    }else{
        [self.voteImageView setAlpha:0];
    }
    
    [self.voteContentView setFrame:voteCellFrame.voteContentViewF];
    [self.voteContentView setBackgroundColor:[UIColor whiteColor]];
    [self.voteContentView.layer setBorderColor:[RGB(0xf4, 0xf5, 0xf5) CGColor]];
    [self.voteContentView.layer setBorderWidth:1.0f];
    self.voteContentLabel.text = model.voteText;
    [self.voteContentLabel setFrame:voteCellFrame.voteContentLabelF];
    
    // 选项
    [self.optionsView setFrame:voteCellFrame.optionsViewF];
    
    NSArray *array = [self.optionsView subviews];
    
    for (id view in array) {
        [view removeFromSuperview];
    }
    
    [self.optionsView setOptions:model];  //添加动画 view 只要有一次
    
//    [self.bottomToolBar setFrame:voteCellFrame.bottomToolBarF];
    
    [self.voteContainer setFrame:voteCellFrame.voteContainerF];
    
    if (voteCellFrame.voteInfoModel.judgeVote == YES) {
        [self.voteInfosBtn setTitle:@"已投票" forState: UIControlStateNormal];
    }
    
    //底部转发
    [self.bottomTransmitBar setFrame:voteCellFrame.bottomTransmitBarF];
    self.bottomTransmitBtn.width = self.bottomTransmitBar.width - 4.0 * VoteCellBorderW;
    self.bottomTransmitBtn.height= 33;
    self.bottomTransmitBtn.x = (self.bottomTransmitBar.width-self.bottomTransmitBtn.width)/2.0;
    self.bottomTransmitBtn.y = (self.bottomTransmitBar.height-self.bottomTransmitBtn.height)/2.0;
    [self.bottomTransmitBtn addTarget:self action:@selector(transmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setVoteTitle) name:@"Vote" object:nil];  //  接受跳转通知
}

- (void)setVoteTitle
{
    [self.voteInfosBtn setTitle:@"已投票" forState: UIControlStateNormal];
}
- (void)transmitClicked:(id)sender
{
    NSLog(@"transmit Clicked");
    RepeaterGroupController* transmit = [[RepeaterGroupController alloc] init];
    [transmit.view setBackgroundColor:[UIColor clearColor]];
    [transmit setType:RepeaterGroupTranimitTypeVote];
    [transmit setModel:self.model];
    [transmit setContext:self.context.navigationController];
    //根据系统版本，进行半透明展示
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        transmit.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        transmit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //        [appdelegate.mainController presentViewController:transmit animated:YES completion:nil];
        [self.context presentViewController:transmit animated:YES completion:nil];
    } else {
        self.context.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.context presentViewController:transmit animated:YES completion:nil];
        
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
