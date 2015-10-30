//
//  PublishSeekHelp.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PublishSeekHelp.h"
#import "DNImagePickerController.h"
#import "EMTextView.h"
#import <Masonry.h>
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AccountTool.h"
#import "Account.h"
#import "RestfulAPIRequestTool.h"
#include "Interaction.h"
#import "XHMessageTextView.h"
#import <DGActivityIndicatorView.h>
//#import "UITextView+PlaceHolder.h"
@interface PublishSeekHelp ()<DNImagePickerControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation PublishSeekHelp


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationItem];
    [self setSeekContent];
    if (self.model) {
        [self addTemplate:self.model];
    }
}

- (void)loadingImageView {
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeFiveDots tintColor:RGBACOLOR(253, 185, 0, 1) size:40.0f];
    activityIndicatorView.frame = CGRectMake(DLScreenWidth / 2 - 40, DLScreenHeight / 2 - 40, 80.0f, 80.0f);
    activityIndicatorView.backgroundColor = RGBACOLOR(132, 123, 123, 0.52);
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView.layer setMasksToBounds:YES];
    [activityIndicatorView.layer setCornerRadius:10.0];
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
}


- (void)setSeekContent
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenHeight)];
    [self.view addSubview:bigView];

    self.seekHelpContent = [[XHMessageTextView alloc]initWithFrame:CGRectMake(0, -64, DLScreenWidth, DLMultipleHeight(280))];
    self.seekHelpContent.placeHolder = @"请输入求助的内容";
    self.seekHelpContent.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 10);
//    [self.seekHelpContent placeHolderWithString:@"请输入求助内容"];
    self.seekHelpContent.font = [UIFont systemFontOfSize:17];
//    [self.seekHelpContent setBackgroundColor:[UIColor greenColor]];
    self.seekHelpContent.textAlignment = NSTextAlignmentJustified;
    self.seekHelpContent.contentOffset = CGPointMake(0, 0);
    self.seekHelpContent.scrollEnabled = NO;
    [bigView addSubview:self.seekHelpContent];
    
    
    
//    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(200.0))];
//    
//    textField.placeholder = @"请输入求助内容";
//    [textField placeholder];
//    [bigView addSubview:textField];
    
    
    self.selectPhoto = [UIImageView new];
    self.selectPhoto.userInteractionEnabled = YES;
    //    self.selectPhoto.contentMod = UIViewContentModeCenter;
    self.selectPhoto.image = [UIImage imageNamed:@"vote-camera"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhotoAction:)];
    [self.selectPhoto addGestureRecognizer:tap];
    [bigView addSubview:self.selectPhoto];
    
    [self.selectPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seekHelpContent.mas_bottom).offset(DLMultipleHeight(50.0));
        make.left.mas_equalTo(bigView.mas_left).offset(DLMultipleWidth(15.0));
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(60.0), DLMultipleWidth(45.0)));
    }];
    
    UIView *lastLineView = [UIView new];
    [lastLineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [bigView addSubview:lastLineView];
    
    [lastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.selectPhoto.mas_top);
        make.left.mas_equalTo(self.selectPhoto.mas_left);
        make.right.mas_equalTo(bigView.mas_right).offset(-15);
        make.height.mas_equalTo(.5);
    }];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [bigView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectPhoto.mas_bottom);
        make.left.mas_equalTo(self.selectPhoto.mas_left);
        make.right.mas_equalTo(bigView.mas_right).offset(-15);
        make.height.mas_equalTo(.5);
    }];
    
}

- (void)selectPhotoAction:(UITapGestureRecognizer *)tap
{
    DNImagePickerController *choose = [[DNImagePickerController alloc]init];
    
    choose.allowSelectNum = 1;
    choose.imagePickerDelegate = self;
    [self.navigationController presentViewController:choose animated:YES completion:nil];
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
//    DNAsset *dnasser = [imageAssets firstObject];
//    ALAssetsLibrary *library = [ALAssetsLibrary new];
//    [library assetForURL:dnasser.url resultBlock:^(ALAsset *asset) {
    self.selectPhoto.image = imageAssets[0];//[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//    } failureBlock:^(NSError *error) {
//        
//    }];
}


- (void)setNavigationItem
{
    self.title = @"发布求助";
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 0, 60, 20);
    [cancelButton setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.frame = CGRectMake(0, 0, 60, 20);
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishButton];
    
}

- (void)publishAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.seekHelpContent.text.length != 0) {
        [self loadingImageView];
        [self marchingPublish];
    } else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"求助内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertV show];
    }
}
- (void)marchingPublish {
    NSData *data = UIImagePNGRepresentation(self.selectPhoto.image);
    NSDictionary *Dic = [NSDictionary dictionaryWithObjects:@[data, @"photo"] forKeys:@[@"data", @"name"]];
    
    Interaction *inter = [[Interaction alloc]init];
    Account *acc = [AccountTool account];
    [inter setTarget:acc.cid];
    [inter setTargetType:@3];
    [inter setType:@3];
    [inter setLocation:@"上海"];
    [inter setContent:self.seekHelpContent.text];
    [inter setPhoto:@[Dic]];
    [inter setTheme:@"求助"];
    
    [RestfulAPIRequestTool routeName:@"sendInteraction" requestModel:inter useKeys:@[@"type", @"target", @"relatedTeam", @"targetType", @"templateId", @"inviters",@"photo", @"theme", @"content", @"endTime", @"startTime", @"deadline", @"remindTime", @"activityMold", @"location", @"latitude", @"longitude", @"memberMax", @"memberMin", @"option", @"tags"] success:^(id json) {
        NSLog(@"发布求助成功 %@", json);
        [self.activityIndicatorView removeFromSuperview];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布成功"message:@"少年郎,你的求助已经发布成功了,好好准备吧..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertV show];
    } failure:^(id errorJson) {
        NSLog(@"发布求助失败 %@", errorJson);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"再试一次", nil];
        [self.activityIndicatorView removeFromSuperview];
        [alertV show];
        
    }];
}
#pragma UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KPOSTNAME" object:nil userInfo:@{@"name":@"家豪"}];
    }
    
}


- (void)cancelButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTemplate:(Interaction *)templateData
{
    self.seekHelpContent.text = templateData.theme;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.activityIndicatorView removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
