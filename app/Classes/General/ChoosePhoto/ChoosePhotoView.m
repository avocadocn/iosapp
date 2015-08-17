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
#import "PhotoPlayController.h"
#import "DNImagePickerController.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNPhotoBrowser.h"

#define WID ((DLScreenWidth - 20) / 4.0)

typedef NS_ENUM(NSInteger, EnumOfViewSubclass)
{
    EnumOfViewSubclassNo,
    EnumOfViewSubclassYes
};

@interface ChoosePhotoView ()<DNImagePickerControllerDelegate>
@property (nonatomic, assign)EnumOfViewSubclass state;
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
    self.imagePhotoArray = [NSMutableArray array];
    
    
    if (!self.componentArray){
        self.componentArray = [NSMutableArray array];
    }
    
    self.insertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.insertButton setBackgroundImage:[UIImage imageNamed:@"insert"] forState:UIControlStateNormal];
    self.insertButton.backgroundColor = [UIColor whiteColor];
    self.insertButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        //跳转页面
        
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate = self;
        [self.view presentViewController:imagePicker animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    CGFloat width = (DLScreenWidth - 20) / 4.0;
    
    self.insertButton.frame = CGRectMake(0, 0, width - 1.5, width - 1.5);
    [self addSubview:self.insertButton];
    [self.componentArray insertObject:self.insertButton atIndex:0];  //把 Button放在第0个元素
    self.backgroundColor = [UIColor whiteColor];
}

- (void)arrangeStartWithArray:(NSMutableArray *)array  //对取得的照片进行排序
{
    
    NSLog(@"开始排序");
    
    NSLog(@"%@", array);
    CGFloat width = self.frame.size.width / 4.0;
    
    NSInteger count = [array count];
    
    //间隙
    CGFloat gap = 3.0;
    
    //排序

    // 排序之前首先确认是否需要重复排序
    if (self.state == EnumOfViewSubclassYes) { // 已经添加过子视图,再次添加删掉子视图
        NSArray *array = self.subviews;
        for (id a in array) {
            if (![a isKindOfClass:[UIButton class]]) {
                [a removeFromSuperview];
            }
        }
//        id a = [array objectAtIndex:i];
    }
    int i = 0;
    for (UIImage *image in array) {
        @autoreleasepool {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(gap / 2.0 +i % 4 * width, i / 4 * width, width - gap, width - gap)];
            imageView.image = image;
            [self addSubview:imageView];
            imageView.tag = i + 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            i++;
        }
    }
    
    if (count == 9) {
        //  移除 button
        self.insertButton.frame = CGRectMake(0, 0, 0, 0);
    }
    else  //button 放在最后面
    {
        self.insertButton.frame = CGRectMake(gap / 2.0 +i % 4 * width, i / 4 * width, width - gap, width - gap);
    }
    self.state = EnumOfViewSubclassYes;  //已经添加过子视图,再次添加删掉子视图
    CGPoint point = self.frame.origin;
    
    CGRect rect = CGRectMake(point.x, point.y, DLScreenWidth - 20, 300);
    
    [self.delegate ChoosePhotoView:self withFrame:rect];
}

- (void)imageViewTapAction:(UITapGestureRecognizer *)tap
{
    /*
    DNPhotoBrowser *browsert = [[DNPhotoBrowser alloc]initWithPhotos:self.imagePhotoArray currentIndex:tap.view.tag fullImage:YES];
    browsert.delegate = self;
    browsert.hidesBottomBarWhenPushed = YES;
    
    [self.view.navigationController pushViewController:browsert animated:YES];
*/
    PhotoPlayController *browser = [[PhotoPlayController alloc]initWithPhotoArray:self.imagePhotoArray indexOfContentOffset:tap.view.tag - 1];
    [self.view.navigationController pushViewController:browser animated:YES];
    
}


- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    self.imagePhotoArray = [NSMutableArray array];
    
    for (int i = 0; i < imageAssets.count; i++) {
        
        DNAsset *dnasset = [imageAssets objectAtIndex:i];
        
        ALAssetsLibrary *lib = [ALAssetsLibrary new];
        
        [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset) {
            
            UIImage *aImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            NSLog(@"正在选择");
            [self.imagePhotoArray addObject:aImage];
            if (i == [imageAssets count] - 1) {
                [self arrangeStartWithArray:self.imagePhotoArray];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}





@end
