//
//  ConditionController.m
//  app
//
//  Created by 申家 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "DLTimerLabel.h"
#import <DGActivityIndicatorView.h>

#import "ConditionController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChoosePhotoView.h"
#import "DLNetworkRequest.h"
#import "RestfulAPIRequestTool.h"
#import "CircleContextModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "ColleagueViewController.h"
#import "XHMessageTextView.h"
#define WID ((DLScreenWidth - 20) / 4.0)

@interface ConditionController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoosePhotoViewDelegate>

@property(nonatomic, strong)DGActivityIndicatorView *activityIndicatorView;
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
    [completeButton addTarget:self action:@selector(nextStepTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    
    self.speakTextView = [XHMessageTextView new];
    self.speakTextView.font = [UIFont systemFontOfSize:17];
    //    [self.speakTextView setBackgroundColor:[UIColor greenColor]];
    self.speakTextView.delegate = self;
    self.speakTextView.allowsEditingTextAttributes = YES;
    self.speakTextView.placeHolder = @"这一刻的想法...";
    [self.view addSubview:self.speakTextView];
    
    [self.speakTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
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
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth, DLScreenHeight - 150));
//        make.width.mas_equalTo(DLScreenWidth)
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 150 + 20 + WID, DLScreenWidth, DLScreenHeight - 150 - WID - 20)];
    view.backgroundColor = RGB(239, 239, 239);
    view.tag = 1001;
    [self.view addSubview:view];
    
    if (self.photoArray) {
        [self.selectPhotoView arrangeStartWithArray:self.photoArray];
        self.selectPhotoView.imagePhotoArray = self.photoArray;
        
            CGFloat width = DLScreenWidth / 4.0;
        NSInteger tempNum = self.photoArray.count;
        if (tempNum != 9) {
            tempNum += 1;
        }
        
        NSInteger num = (tempNum - 1) / 4 + 1;
        
        view.frame = CGRectMake(0, 150 + num * width + 20, DLScreenWidth, 600);
    }
}



- (void)nextStepTap:(UIButton *)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __block UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, DLScreenWidth, 20)];
    statusBarView.backgroundColor = [UIColor clearColor];
    statusBarView.opaque = YES;
    
    DLTimerLabel *label = [[DLTimerLabel alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"正在发送";
    [label reload];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 100;
    label.textColor = [UIColor whiteColor];
    [statusBarView addSubview:label];
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    statusBarView.tag = 10;
    self.view.backgroundColor = [UIColor greenColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    [self loadingImageView];
    [self.navigationController popViewControllerAnimated:YES];
    CircleContextModel *model = [[CircleContextModel alloc]init];
    model.photo = [NSMutableArray array];
    
    NSLog(@"存取的照片有:  %@", self.selectPhotoView.imagePhotoArray);
    
    for (UIImage *image  in self.selectPhotoView.imagePhotoArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"photo" forKey:@"name"];
        NSData *data = UIImagePNGRepresentation(image);
        [dic setObject:data forKey:@"data"];
        [model.photo addObject:dic];
    }
    
    Account *acc = [AccountTool account];
    NSLog(@"账号的token值为 %@", acc.token);
    
    [model setContent:self.speakTextView.text];
    
    
    [RestfulAPIRequestTool routeName:@"cirleContent" requestModel:model useKeys:@[@"content", @"photo"] success:^(id json) {
        NSLog(@"%@", json);
        [label removeFromSuperview];
        [self.activityIndicatorView removeFromSuperview];
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [array lastObject];
        path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
        
        NSMutableArray *IDArray = [NSMutableArray arrayWithContentsOfFile:path];
        
        CircleContextModel *saveModel = [[CircleContextModel alloc]init];
        NSDictionary *circleContent = [json objectForKey:@"circleContent"];
        [saveModel setValuesForKeysWithDictionary:circleContent];
        [IDArray insertObject:saveModel.ID atIndex:0];
        
        NSFileManager *manger = [[NSFileManager alloc]init];
        [manger removeItemAtPath:path error:nil];
        [IDArray writeToFile:path atomically:YES];
        
        [saveModel save];
        
        [self.delegate sendSingerCircle:json];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *view = (UIView *)[self.navigationController.navigationBar viewWithTag:10];
        
        DLTimerLabel *label = (DLTimerLabel *)[view viewWithTag:100];
        
        [UIView animateWithDuration:.4 animations:^{
            label.text = @"发送完成";
            statusBarView.frame = CGRectMake(0, -40, DLScreenWidth, 20);
        }completion:^(BOOL finished) {
            
            [statusBarView removeFromSuperview];
            window.windowLevel = UIWindowLevelNormal;
        }];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
        [self.activityIndicatorView removeFromSuperview];
        UIView *view = (UIView *)[self.navigationController.navigationBar viewWithTag:10];
        DLTimerLabel *label = (DLTimerLabel *)[view viewWithTag:100];
        
        [UIView animateWithDuration:.4 animations:^{
            label.text = @"发送失败";
            statusBarView.frame = CGRectMake(0, -40, DLScreenWidth, 20);
        }completion:^(BOOL finished) {
            
            [statusBarView removeFromSuperview];
            window.windowLevel = UIWindowLevelNormal;
        }];

        [label removeFromSuperview];
    }];
    
}

- (void)ChoosePhotoView:(ChoosePhotoView *)chooseView withFrame:(CGRect)frame
{
    
//    [self.selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(frame.size.height);
//    }];
    UIView *view = (UIView *)[self.view viewWithTag:1001];
    view.frame = CGRectMake(0, 150 + frame.size.height + 20, DLScreenWidth, 400);
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
//        textView.text = nil;
//    }
}
- (void)loadingImageView {
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeFiveDots tintColor:[UIColor yellowColor] size:40.0f];
    activityIndicatorView.frame = CGRectMake(DLScreenWidth / 2 - 40, DLScreenHeight / 2 - 40, 80.0f, 80.0f);
    activityIndicatorView.backgroundColor = RGBACOLOR(214, 214, 214, 0.5);
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView.layer setMasksToBounds:YES];
    [activityIndicatorView.layer setCornerRadius:10.0];
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
}

@end
