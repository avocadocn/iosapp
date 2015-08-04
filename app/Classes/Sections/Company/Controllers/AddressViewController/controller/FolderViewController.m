//
//  FolderViewController.m
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FolderViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface FolderViewController ()

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DLSBackgroundColor;
    self.title = @"个人资料";
    
    [self builtTitleView];
}

- (void)builtTitleView // 照片和选择照片
{
    CGFloat width = DLScreenWidth / 375.0 / 150.0;
    self.folderPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake((DLScreenWidth - width) / 2, 50, width, width)];
    self.folderPhotoImage.layer.cornerRadius = width / 2.0;
    
    [self.view addSubview:self.folderPhotoImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
