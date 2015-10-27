//
//  HelpTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <Masonry.h>ƒ
#import "HelpTableViewCell.h"
#import "HelpInfoModel.h"
#import "RepeaterGroupController.h"
#import "UILabel+DLTimeLabel.h"
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
 *  来自
 */
@property (nonatomic, strong) UILabel *fromLabel;
/**
 *  投票配图
 */
@property (nonatomic, strong) UIImageView *helpImageView;
/**
 *  投票内容label
 */
@property (nonatomic, strong) UILabel *helpContentLabel;
/**
 *  添加答案
 */
@property (nonatomic, strong) UILabel *helpAnserLabel;

@property (nonatomic, strong) UIView *bottomTransmitBar;
@property (nonatomic, strong) UIButton *bottomTransmitBtn;
@property (nonatomic, strong) UIView* separater;

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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTemplate:(Boolean)isTemplate{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:RGB(235, 235, 235)];
        self.isTemplate = isTemplate;
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
    timeLabel.textColor = RGBACOLOR(155, 155, 155, 1);
    [helpContainer addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 配图
    UIImageView *helpImageView = [[UIImageView alloc]init];
    [helpImageView setContentMode:UIViewContentModeScaleAspectFit];
    helpImageView.backgroundColor = RGBACOLOR(206, 206, 206, 1);
    [helpContainer addSubview:helpImageView];
    self.helpImageView = helpImageView;
    //分割线
    UIView * separater = [UIView new];
    separater.height = 0.0f;
    separater.width = DLScreenWidth - 4* HelpCellBorderW;
    separater.x = (DLScreenWidth -separater.width)/2.0;
    [separater setBackgroundColor:RGB(0xe6, 0xe6, 0xe6)];
    [helpContainer addSubview:separater];
    self.separater = separater;

//    self.helpAnserLabel = [UILabel new];//initWithFrame:CGRectMake(DLScreenWidth - 80 , 458, 80, 20)];
//    self.helpAnserLabel.text = @"添加答案";
//    self.helpAnserLabel.userInteractionEnabled = YES;
////    self.helpAnserLabel.backgroundColor = [UIColor cyanColor];
//    self.helpAnserLabel.textAlignment = NSTextAlignmentCenter;
//    self.helpAnserLabel.font = [UIFont systemFontOfSize:15];
//    self.helpAnserLabel.textColor = RGBACOLOR(37, 18, 71, 1);
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAnsers:)];
//    [self.helpAnserLabel addGestureRecognizer:tapGesture];
//    
//    [helpContainer addSubview:self.helpAnserLabel];
    
    
    // 正文
    UILabel *helpContentLabel = [[UILabel alloc]init];
    helpContentLabel.font = HelpCellContentFont;
    [helpContentLabel setNumberOfLines:0];
    [helpContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [helpContentLabel setBackgroundColor:[UIColor clearColor]];
    [helpContainer addSubview:helpContentLabel];
    self.helpContentLabel = helpContentLabel;
    
    if (self.isTemplate) {
        UIView *bottomTransmitBar = [UIView new];
        [bottomTransmitBar setBackgroundColor:[UIColor whiteColor]];
        UIButton *bottomTransmitBtn = [UIButton new];
        [bottomTransmitBtn setBackgroundColor:RGB(0xfd, 0xb9, 0x0)];
        bottomTransmitBtn.titleLabel.font=[UIFont systemFontOfSize:18.0f];
        [bottomTransmitBtn setTitle:@"转发" forState:UIControlStateNormal];
        [bottomTransmitBar addSubview:bottomTransmitBtn];
        [helpContainer addSubview:bottomTransmitBar];
        self.bottomTransmitBar = bottomTransmitBar;
        self.bottomTransmitBtn = bottomTransmitBtn;
    }
    
    [self addSubview:helpContainer];
    self.helpContainer = helpContainer;
    
}

-(void)setHelpCellFrame:(HelpCellFrame *)helpCellFrame{
    
    _helpCellFrame = helpCellFrame;
    
    
    HelpInfoModel *model = helpCellFrame.helpInfoModel;
    [self.avatarImageView setFrame:helpCellFrame.avatarImageViewF];
    [self.avatarImageView dlGetRouteThumbnallWebImageWithString:model.avatarURL placeholderImage:nil withSize:self.avatarImageView.size];
    
    self.nameLabel.text = model.name;
    [self.nameLabel setFrame:helpCellFrame.nameLabelF];
    
    [self.timeLabel judgeTimeWithString:model.time];
    [self.timeLabel setFrame:helpCellFrame.timeLabelF];
    
    self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, -3, 80, 20)];
    self.fromLabel.font = [UIFont systemFontOfSize:10];
    self.fromLabel.textColor = RGBACOLOR(155, 155, 155, 1);
//    [self.fromLabel getCompanyNameFromCid:model.cid];
    self.fromLabel.text = model.companyName;
    [self.timeLabel addSubview:self.fromLabel];
    
    
    [self.helpImageView setFrame:helpCellFrame.helpImageViewF];
    if (model.helpImageURL) {
        [self.helpImageView dlGetRouteThumbnallWebImageWithString:model.helpImageURL placeholderImage:nil withSize:self.helpImageView.size];
        [self.helpImageView setAlpha:1];
    }else{
        [self.helpImageView setAlpha:0];
    }
    
    self.helpContentLabel.text = model.helpText;
    [self.helpContentLabel setFrame:helpCellFrame.helpContentLabelF];
    if (self.helpImageView.height == 0) {
        self.separater.height = 1.0f;
        self.separater.y = self.helpContentLabel.y-5;
    }else{
        self.separater.height = 0.0f;
    }
    if (self.isTemplate) {
        [self.bottomTransmitBar setFrame:helpCellFrame.bottomTransmitBarF];
        self.bottomTransmitBtn.width = self.bottomTransmitBar.width - 4.0 * HelpCellBorderW;
        self.bottomTransmitBtn.height= 33;
        self.bottomTransmitBtn.x = (self.bottomTransmitBar.width-self.bottomTransmitBtn.width)/2.0;
        self.bottomTransmitBtn.y = (self.bottomTransmitBar.height-self.bottomTransmitBtn.height)/2.0;
        [self.bottomTransmitBtn addTarget:self action:@selector(transmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.helpContainer setFrame:helpCellFrame.helpContainerF];
 
//    添加答案Label frame
//     [self.helpAnserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_equalTo(self.helpContentLabel.mas_top);
//        make.bottom.mas_equalTo(self.helpContentLabel.mas_bottom);
//        make.right.mas_equalTo(self.mas_right);
//        make.width.mas_equalTo(80);
//    }];

}

- (void)transmitClicked:(id)sender
{
    NSLog(@"transmit Clicked");
    RepeaterGroupController* transmit = [[RepeaterGroupController alloc] init];
    [transmit.view setBackgroundColor:[UIColor clearColor]];
    [transmit setType:RepeaterGroupTranimitTypeHelp];
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

@end
