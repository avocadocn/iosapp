//
//  DetailActivityShowView.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DetailActivityShowView.h"



@interface DetailActivityShowView()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *superView;
@property (strong,nonatomic) UIImageView *pictureView;
@property (assign,nonatomic) CGFloat imageViewWidth;
@property (assign,nonatomic) CGFloat imageViewHeight;
@end
@implementation DetailActivityShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
        
        [self buildInterface];
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateImg];
}


- (void)updateImg {
    CGFloat yOffset   = self.superView.contentOffset.y + 64;
    // NSLog(@"%f",yOffset);
    if (yOffset < 0) {
        
        CGFloat factor = ((ABS(yOffset)+self.imageViewHeight)*self.imageViewWidth)/self.imageViewHeight;
        CGRect f = CGRectMake(-(factor-self.imageViewWidth)/2, 0, factor, self.imageViewHeight+ABS(yOffset));
        self.pictureView.frame = f;
        self.pictureView.y += yOffset;
    }
}


-(void)buildInterface{
    
    UIScrollView *superView = [[UIScrollView alloc]init];
    [superView setDelegate:self];
    [superView setFrame:self.frame];
    [superView setBounces:YES];
    
    // 顶部带有图片的视图
    UIView *topPictureView = [[UIView alloc]init];
    [topPictureView setBackgroundColor:[UIColor whiteColor]];
   
    // 添加活动图片
    UIImageView *pictureView = [UIImageView new];
    CGFloat imageViewWidth = DLScreenWidth;
    CGFloat imageViewHeight = imageViewWidth * 4 / 5;
    self.imageViewWidth = imageViewWidth;
    self.imageViewHeight = imageViewHeight;
    [pictureView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    [pictureView setBackgroundColor:[UIColor redColor]];
    UIImage *img = [UIImage imageNamed:@"2.jpg"];
    [pictureView setClipsToBounds:YES];
    [pictureView setImage:img];
    [pictureView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.pictureView = pictureView;
    // 活动名称label
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    UILabel *name = [[UILabel alloc]init];
    name.textColor = [UIColor blackColor];
    [name setFont:font];
    NSString *nameText = @"林肯公园演唱会";
//    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
//    // CGSize size = [nameText sizeWithAttributes:attr];
//    NSLog(@"%@",NSStringFromCGSize(size));
    [name setText:nameText];
    [name setSize:CGSizeMake(DLScreenWidth, 14)];
    [name setTextAlignment:NSTextAlignmentCenter];
    name.centerX = DLScreenWidth / 2;
    name.y = CGRectGetMaxY(pictureView.frame) + 13;
    
    
    
    // 添加感兴趣按钮，需要根据图片自定义
    UIButton *interest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [interest setTitle:@"感兴趣" forState:UIControlStateNormal];
    [interest setSize:CGSizeMake(100, 25)];
    interest.centerX = DLScreenWidth / 2;
    interest.y = CGRectGetMaxY(name.frame) + 13;
    
    [topPictureView addSubview:pictureView];
    [topPictureView addSubview:name];
    [topPictureView addSubview:interest];
    
    // 设置顶部pic view的frame
    topPictureView.height = CGRectGetMaxY(interest.frame) + 13;
    topPictureView.width = DLScreenWidth;
    [topPictureView setOrigin:CGPointZero];
    
    [superView addSubview:topPictureView];
    
    // 添加中部时间地址view
    UIView *middleView = [[UIView alloc]init];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    
    // 添加时间label
    UILabel *timeLabel = [[UILabel alloc]init];
    NSString *timeString = [NSString stringWithFormat:@"时间:  \%@",@"2015.07.23--2015.07.30"];
    
    NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    [timeLabel setAttributedText:mutableAttrStr];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    
    // 设置label的frame
    [timeLabel setFrame:CGRectMake(10, 15, DLScreenWidth, 30)];
    
    // 添加分割线
    UIView *divisionLine = [[UIView alloc]init];
    [divisionLine setBackgroundColor:[UIColor lightGrayColor]];
    [divisionLine setAlpha:0.3f];
    divisionLine.width = DLScreenWidth - 2 * 9;
    divisionLine.height = 1;
    divisionLine.x = 9;
    divisionLine.y = CGRectGetMaxY(timeLabel.frame);
    
    // 添加地址label
    UIFont *addressFont = [UIFont systemFontOfSize:13.0f];
    CGSize TintLabelSize = CGSizeMake(DLScreenWidth, MAXFLOAT);
    
    UILabel *addressTintLabel = [[UILabel alloc]init];
    NSString *addressTintStr = @"地址: ";
    CGSize addressTintLabelSize = [addressTintStr sizeWithFont:addressFont constrainedToSize:TintLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressTintLabel setText:addressTintStr];
    [addressTintLabel setFont:addressFont];
    [addressTintLabel setTextColor:[UIColor grayColor]];
    // tintLabel的frame
    addressTintLabel.size = addressTintLabelSize;
    addressTintLabel.x = 10;
    addressTintLabel.y = CGRectGetMaxY(divisionLine.frame) + 12;
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.lineBreakMode = UILineBreakModeWordWrap;
    addressLabel.numberOfLines = 0;
    // TODO
    CGSize maxLabelSize = CGSizeMake(DLScreenWidth - 2 * 10 - addressTintLabelSize.width, MAXFLOAT);
    NSString *addressText = [NSString stringWithFormat:@"%@",@"上海话剧阿斯顿发送到发送到发送到发送到发士大夫撒飞洒的"];
    
    CGSize trueLabelSize = [addressText sizeWithFont:addressFont constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressLabel setFont:addressFont];
    NSMutableAttributedString *addressMAS = [[NSMutableAttributedString alloc]initWithString:addressText];
   
    [addressLabel setAttributedText:addressMAS];
    
    // 设置地址label的frame
    addressLabel.size = trueLabelSize;
    addressLabel.x = CGRectGetMaxX(addressTintLabel.frame);
    addressLabel.y = CGRectGetMaxY(divisionLine.frame) + 12;
    
    
  
    
    
    // 地图view
    UIImage *mapImg = [UIImage imageNamed:@"map"];
    UIImageView *mapView = [[UIImageView alloc]initWithImage:mapImg];
    [mapView setContentMode:UIViewContentModeScaleAspectFill];
    [mapView setClipsToBounds:YES];
    
    // mapView frame
    mapView.width = DLScreenWidth;
    mapView.height = DLScreenWidth * 2 / 4;
    mapView.x = 0;
    mapView.y = CGRectGetMaxY(addressLabel.frame) + 10;
    
    UILabel *personCountLabel = [[UILabel alloc]init];
    UIFont *personCountLabelFont = [UIFont systemFontOfSize:13.0f];
    [personCountLabel setFrame:CGRectMake(10, CGRectGetMaxY(mapView.frame) + 15, DLScreenWidth - 2 * 10, 20)];
    [personCountLabel setFont:personCountLabelFont];
    NSInteger personCount = 18;
    NSString *personCountLabelText = [NSString stringWithFormat:@"报名人数:  %zd人",personCount];
    NSMutableAttributedString *personMAS = [[NSMutableAttributedString alloc]initWithString:personCountLabelText];
    [personMAS addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    [personCountLabel setAttributedText:personMAS];
    
    
    
    // 设置中部view的frame
    middleView.y = CGRectGetMaxY(topPictureView.frame) + 12;
    middleView.x = 0;
    middleView.width = DLScreenWidth;
    middleView.height = CGRectGetMaxY(personCountLabel.frame) + 14;
    
    [middleView addSubview:timeLabel];
    [middleView addSubview:divisionLine];
    [middleView addSubview:addressTintLabel];
    [middleView addSubview:addressLabel];
    [middleView addSubview:mapView];
    [middleView addSubview:personCountLabel];
    [superView addSubview:middleView];
    
    // 添加第三栏的活动介绍view
    UIView *introduceView = [[UIView alloc]init];
    [introduceView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *activityIntroduceTV = [[UILabel alloc]init];
        UIFont *aITVFont = [UIFont systemFontOfSize:13.0f];
    [activityIntroduceTV setTextColor:[UIColor blackColor]];
    NSString *IntroduceText = @"Pixel Winch is a screen measurement app with a unique approach. Rather than overlaying complicated controls on top of your existing workflow, it combines aspects of a traditional image editor with the quick access of a modal interface (similar to OS X's Launchpad or Dashboard).Select a region on the screen to load it inside of Pixel Winch. The captured region will automatically magnify and center on your display. Take measurements using any combination of the included tools. When finished, simply press escape to dismiss Pixel Winch.Need to look up previous measurements? No problem  use the history list to revisit past images. Worried about images clogging up your hard drive? Pixel Winch can be configured to automatically delete them.";
    NSString *aITVText = [NSString stringWithFormat:@"活动介绍\n%@",IntroduceText];
    // TODO
    [activityIntroduceTV setText:aITVText];
    CGSize maxAITVSize = CGSizeMake(DLScreenWidth - 2 * 10, MAXFLOAT);
    [activityIntroduceTV setFont:aITVFont];
    CGSize aITVSize = [aITVText sizeWithFont:aITVFont constrainedToSize:maxAITVSize lineBreakMode:NSLineBreakByWordWrapping];
    //  AITV的frame
    activityIntroduceTV.size = aITVSize;
    activityIntroduceTV.x = 10;
    activityIntroduceTV.y = 6;
    activityIntroduceTV.lineBreakMode = UILineBreakModeWordWrap;
    activityIntroduceTV.numberOfLines = 0;
    
    introduceView.width = DLScreenWidth;
    introduceView.height = activityIntroduceTV.height + 16;
    introduceView.x = 0;
    introduceView.y = CGRectGetMaxY(middleView.frame) + 12;
    
    // 添加到根view中
    [introduceView addSubview:activityIntroduceTV];
    [superView addSubview:introduceView];
    
    // 设置contentoffset
    [superView setContentSize:CGSizeMake(DLScreenWidth, CGRectGetMaxY(introduceView.frame) + 44)];
    
    
    
    [self addSubview:superView];
    
    UIView *sighUpView = [[UIView alloc]init];
    [sighUpView setBackgroundColor:[UIColor redColor]];
    
    // 设置报名view的frame
    sighUpView.size = CGSizeMake(DLScreenWidth, 44);
    sighUpView.x = 0;
    sighUpView.y = DLScreenHeight - 44;
    
    UIButton *sighUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sighUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    sighUpBtn.width = DLScreenWidth - 2 * 10;
    sighUpBtn.height = 28;
    sighUpBtn.x = 10;
    sighUpBtn.y = sighUpView.height / 2 - sighUpBtn.height / 2;
    [sighUpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // btn添加到view中
    [sighUpView addSubview:sighUpBtn];
    [self addSubview:sighUpView];

    
    self.superView = superView;
    
   
}

-(void)btnClick:(id)sender{
    NSLog(@"btn Clicked");
}



@end
