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
#import "ChoosePhotoController.h"
#import "ChoosePhotoView.h"
#define WID ((DLScreenWidth - 20) / 4.0)

@interface ConditionController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
@implementation ConditionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    [self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    
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
        make.height.mas_equalTo(120);
    }];
    
    self.selectPhotoView = [ChoosePhotoView new];
    self.selectPhotoView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.selectPhotoView];
    self.selectPhotoView.view = self;
    [self.selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speakTextView.mas_bottom);
        make.left.mas_equalTo(self.speakTextView.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth - 20, WID + 20));
    }];
}
- (void)photoButtonAction:(UIButton *)sender
{
    ChoosePhotoController *photo = [ChoosePhotoController shareStateOfController];
    [self.navigationController pushViewController:photo animated:YES];
    
/*    调用系统相册
    //调用类方法判断当前设备是否存在图片库
    self.photoArray = [NSMutableArray array];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        imagePicker.delegate = self;
        //模态进去本地图片库
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"没有图片库");
    }
*/
    
}


// 跳转页面 选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // info 是存所选取的图片的信息的字典
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"选中");
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.photoArray addObject:image];
    
//    NSLog(@"%@", info);
    
}

// 选择点击返回键
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSInteger temp = [self.photoArray count];
    if (temp < 9)
    {
        
    }
    
    self.selectPhotoView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < temp; i++) {
        @autoreleasepool {
        UIImage *image = [self.photoArray objectAtIndex:i];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5 + i % 4 * WID, 5 + i / 4 * WID, WID - 5, WID - 5)];
        imageview.image = image;
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setBackgroundColor:[UIColor yellowColor]];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete-circular"] forState:UIControlStateNormal];
        [imageview addSubview:deleteButton];
            
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageview.mas_top);
            make.right.mas_equalTo(imageview).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
            deleteButton.tag = i;
            
        imageview.userInteractionEnabled = YES;
        [self.selectPhotoView addSubview:imageview];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)deleteButtonAction:(UIButton *)sender
{
    [self.photoArray removeObjectAtIndex:(sender.tag - 1)];
    self.selectPhotoView.frame = CGRectMake(10, self.speakTextView.frame.origin.y + self.speakTextView.frame.size.height, DLScreenWidth - 20, WID * [self.photoArray count]);
    
    for (UIImage *image in self.photoArray) {
        @autoreleasepool {
            
            
            
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
        textView.text = nil;
    }
    
}
@end
