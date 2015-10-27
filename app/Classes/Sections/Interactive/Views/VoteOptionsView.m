//
//  VoteOptionsView.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "RestfulAPIRequestTool.h"
#import "VoteOptionsView.h"
#import "VoteAnimatedOptionView.h"
#import "VoteOptionsInfoModel.h"
#import <ReactiveCocoa.h>
#import "VoteInfoModel.h"
#import "Account.h"
#import "AccountTool.h"

@interface VoteOptionsView()


@property (nonatomic, assign) NSInteger optionCount;

@end

@implementation VoteOptionsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    return self;
}

-(void)setOptions:(VoteInfoModel *)model{ // 搭建界面
    _modelArray =  model.options;
    self.optionCount = _modelArray.count;
    if (model.judgeVote == NO) { //没有点击过投票
        for (NSInteger i  = 0; i < self.optionCount ; i++) {
            VoteOptionsInfoModel *optionInfo = self.modelArray[i];
            optionInfo.index = [NSNumber numberWithInteger:i];
            VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]initWithFrame:CGRectMake(11, 0, DLScreenWidth- 2*11.0, 0)];
            optionView.voteViewColor = optionInfo.voteInfoColor;
            optionView.optionCount = optionInfo.optionCount;
            [optionView setOptionName:optionInfo.optionName];  //设置投票名字
            optionView.tag = 1 + i;
            optionView.x = 0;
            optionView.y = i * 44;  //optioninfo  的坐标
            
//            [optionView.button addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            optionView.button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"绘制");  //点击以后绘制
                optionView.userInteractionEnabled = NO;
                NSNumber *tempNum = [NSNumber numberWithInteger:[self.voteCount integerValue] + 1];  //选择的总数
                optionView.optionCount = [NSNumber numberWithInteger:[optionView.optionCount integerValue] + 1];
                NSLog(@"选择了%@",optionInfo.optionName);
                [self requestNetWithInterId:optionInfo];;
                
                for (NSInteger i  = 0; i < self.optionCount ; i++) {
                    @autoreleasepool {
                        NSLog(@"%ld", (long)i);
                        VoteOptionsInfoModel *optionInfo = self.modelArray[i];
                        VoteAnimatedOptionView *opti = (VoteAnimatedOptionView *)[self viewWithTag:(i + 1)];
                        opti.voteViewColor = optionInfo.voteInfoColor;
//                        opti.optionCount = optionInfo.optionCount;  // 选项的选择人数
                        opti.optionPercentage = tempNum;  //选项的总人数
                    }
                }
                optionView.button.userInteractionEnabled = NO;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Vote" object:nil userInfo:nil];
                
                return [RACSignal empty];
            }];
            if (self.isAnimationFiltered) {
                optionView.button.userInteractionEnabled = NO;
            }else {
                optionView.button.userInteractionEnabled = YES;
            }
            if (self.isBorderEnable) {
                [optionView.layer setBorderColor:[RGB(0xf4, 0xf5, 0xf5) CGColor]];
                [optionView.layer setBorderWidth:0.5f];
            }
            [self addSubview:optionView];
        }
    }
    else {
        
        [self builtInterface];
    }
}

- (void)builtInterface{//  已经投票过的绘制投票
    
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        
        VoteOptionsInfoModel *optionInfo = self.modelArray[i];
        VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]init];
        optionView.optionPercentage = self.voteCount;
        optionView.voteViewColor = optionInfo.voteInfoColor;
        
        [optionView setOptionName:optionInfo.optionName];  //设置投票名字
        optionView.tag = 1 + i;
        optionView.x = 0;
        optionView.y = i * 44;  //optioninfo  的坐标
        [optionView builtInterfaceWithInter:optionInfo.optionCount voteCount:self.voteCount];
        
        [self addSubview:optionView];
    }
}

- (void)setupView{  //添加 voteanimationview 只需要有一次
    
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        VoteOptionsInfoModel *optionInfo = self.modelArray[i];
        VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]init];
        optionView.voteViewColor = optionInfo.voteInfoColor;
        [optionView setOptionName:optionInfo.optionName];  //设置投票名字
        optionView.tag = 1 + i;
        optionView.x = 0;
        optionView.y = i * 44;  //optioninfo  的坐标
        
        [optionView.button addTarget:self action:@selector(judgeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionView];
    }
}
- (void)judgeView:(UIButton *)tap
{
    NSLog(@"点击");
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        @autoreleasepool {
            
            VoteOptionsInfoModel *optionInfo = self.modelArray[i];
            VoteAnimatedOptionView *opti = (VoteAnimatedOptionView *)[self viewWithTag:(i + 1)];
            opti.voteViewColor = optionInfo.voteInfoColor;
            opti.optionPercentage = optionInfo.optionCount;}
    }
}

- (void)voteAction:(UIButton *)sender
{
    VoteAnimatedOptionView *optionView = (VoteAnimatedOptionView *)sender.superview;
                VoteOptionsInfoModel *optionInfo = self.modelArray[optionView.tag - 1];
    NSLog(@"绘制");  //点击以后绘制
    NSNumber *tempNum = [NSNumber numberWithInteger:[optionView.optionPercentage integerValue] + 1];  //选择的总数
    optionView.optionCount = [NSNumber numberWithInteger:[optionView.optionCount integerValue] + 1];
    
    [self requestNetWithInterId:optionInfo];;
    
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        @autoreleasepool {
            NSLog(@"%ld", (long)i);
            VoteOptionsInfoModel *aOptionInfo = self.modelArray[i];
            VoteAnimatedOptionView *opti = (VoteAnimatedOptionView *)[self viewWithTag:(i + 1)];
            opti.voteViewColor = aOptionInfo.voteInfoColor;
            opti.optionCount = self.voteCount;
            opti.optionPercentage = tempNum;
        }
    }
//    model.judgeVote = YES;
    optionView.button.userInteractionEnabled = NO;
}

- (void)requestNetWithInterId:(VoteOptionsInfoModel *)interId
{
    Account *acc = [AccountTool account];
    interId.userId = acc.ID;
    [RestfulAPIRequestTool routeName:@"voteForUser" requestModel:interId useKeys:@[@"interactionId", @"userId", @"index"] success:^(id json) {
        NSLog(@"投票成功 %@", json);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGESTATE" object:nil];
    } failure:^(id errorJson) {
        NSLog(@"投票失败 %@", errorJson);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[errorJson objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"嗯嗯.知道了" otherButtonTitles:nil, nil];
        [alertV show];
    }];
}

@end
