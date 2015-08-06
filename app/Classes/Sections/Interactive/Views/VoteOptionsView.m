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

-(void)setOptions:(NSArray *)options{
    _options =  options;
    self.optionCount = options.count;
    [self setupView];
}

- (void)setupView{
    
    for (NSInteger i  = 0; i < self.optionCount ; i++) {
        VoteOptionsInfoModel *optionInfo = self.options[i];
        VoteAnimatedOptionView *optionView = [[VoteAnimatedOptionView alloc]init];
        [optionView setOptionName:optionInfo.optionName];
        [optionView setOptionPercentage:optionInfo.optionCount];
        optionView.tag = 100 + i;
        optionView.x = 0;
        optionView.y = i * 44;
        
        [self addSubview:optionView];
    }
}

@end
