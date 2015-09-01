//
//  VoteOptionsView.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteOptionsView.h"
#import "VoteAnimatedOptionView.h"
#import "VoteOptionsInfoModel.h"
#import <ReactiveCocoa.h>
#import "VoteInfoModel.h"


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
            VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]init];
            optionView.voteViewColor = optionInfo.voteInfoColor;
            
            [optionView setOptionName:optionInfo.optionName];  //设置投票名字
            optionView.tag = 1 + i;
            optionView.x = 0;
            optionView.y = i * 44;  //optioninfo  的坐标
            
            optionView.button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"绘制");  //点击以后绘制
                for (NSInteger i  = 0; i < self.optionCount ; i++) {
                    @autoreleasepool {
                        
                        VoteOptionsInfoModel *optionInfo = self.modelArray[i];
                        VoteAnimatedOptionView *opti = (VoteAnimatedOptionView *)[self viewWithTag:(i + 1)];
                        opti.voteViewColor = optionInfo.voteInfoColor;
                        opti.optionPercentage = optionInfo.optionCount;
                        opti.optionCount = self.voteCount;
                    }
                    
                }
                model.judgeVote = YES;
                optionView.button.enabled = NO;
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"Vote" object:nil userInfo:nil];
                
                return [RACSignal empty];
            }];
            [self addSubview:optionView];
        }
        
    }
    else {
        
        [self builtInterface];
    }
}

- (void)builtInterface{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"Vote" object:nil userInfo:nil];
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        VoteOptionsInfoModel *optionInfo = self.modelArray[i];
        VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]init];
        optionView.voteViewColor = optionInfo.voteInfoColor;
        
        [optionView setOptionName:optionInfo.optionName];  //设置投票名字
        optionView.tag = 1 + i;
        optionView.x = 0;
        optionView.y = i * 44;  //optioninfo  的坐标
        [optionView builtInterfaceWithInter:optionInfo.optionCount];
        
//        [optionView.button addTarget:self action:@selector(judgeView:) forControlEvents:UIControlEventTouchUpInside];
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


@end
