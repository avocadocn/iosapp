//
//  ConditionController.m
//  app
//
//  Created by 申家 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ConditionController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChoosePhotoView.h"
#define WID ((DLScreenWidth - 20) / 4.0)

@interface ConditionController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoosePhotoViewDelegate>

@end
@implementation ConditionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    [self.view setBackgroundColor:[UIColor colorWithWhite:.95 alpha:1]];
    
    //标题
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [cancelButton setBackgroundColor:[UIColor greenColor]];
    UILabel *cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    cancelLabel.text = @"取消";
    cancelLabel.textColor = [UIColor colorWithWhite:.5 alpha:.8];
    [cancelButton addSubview:cancelLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    cancelButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return [RACSignal empty];
    }];
    
    UIButton *completeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [completeButton setBackgroundColor:[UIColor greenColor]];
    UILabel *completeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    completeLabel.text = @"完成";
    completeLabel.textAlignment = NSTextAlignmentRight;
    [completeButton addSubview:completeLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    
    self.speakTextView = [UITextView new];
    self.speakTextView.font = [UIFont systemFontOfSize:17];
//    [self.speakTextView setBackgroundColor:[UIColor greenColor]];
    self.speakTextView.delegate = self;
    self.speakTextView.allowsEditingTextAttributes = YES;
    self.speakTextView.text = @"这一刻的想法...";
    [self.view addSubview:self.speakTextView];
    
    [self.speakTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view).with.offset(10);
        make.right.mas_equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(150);
    }];
    
    self.selectPhotoView = [ChoosePhotoView new];
//    self.selectPhotoView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.selectPhotoView];
    self.selectPhotoView.view = self;
    self.selectPhotoView.delegate = self;
    self.selectPhotoView.backgroundColor = [UIColor whiteColor];
    [self.selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speakTextView.mas_bottom);
        make.left.mas_equalTo(self.speakTextView.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth - 20, WID * 3 + 20));
    }];
    
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.selectPhotoView.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.selectPhotoView.mas_left);
        make.right.mas_equalTo(self.selectPhotoView.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
}

- (void)ChoosePhotoView:(ChoosePhotoView *)chooseView withFrame:(CGRect)frame
{
    [UIView animateWithDuration:.5 animations:^{
        
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
        textView.text = nil;
    }
    
}
@end
