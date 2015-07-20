//
//  ChoosePhotoView.m
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ChoosePhotoView.h"
#import <ReactiveCocoa.h>
#import "ChoosePhotoController.h"
#import <Masonry.h>
@interface ChoosePhotoView ()<ArrangeState>

@end

@implementation ChoosePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}


- (void)builtInterface
{
    if (!self.componentArray){
        self.componentArray = [NSMutableArray array];
    }
    
    self.insertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.insertButton setBackgroundImage:[UIImage imageNamed:@"insert"] forState:UIControlStateNormal];
    self.insertButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        //跳转页面
        
        ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];
        choose.delegate = self;
        
        [self.view.navigationController pushViewController:choose animated:YES];
        
        return [RACSignal empty];
    }];
    [self addSubview:self.insertButton];
    [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(self.mas_left);
    }];
    [self.componentArray insertObject:self.insertButton atIndex:0];  //把 Button放在第0个元素

}

- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    NSLog(@"开始排序");
}

@end
