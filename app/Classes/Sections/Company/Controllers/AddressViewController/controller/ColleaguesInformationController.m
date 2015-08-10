//
//  ColleaguesInformationController.m
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ColleaguesInformationController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "FolderViewController.h"
#import "PersonalDynamicController.h"

static NSInteger tagNum = 1;

@interface ColleaguesInformationController ()<UIScrollViewDelegate>

@end

@implementation ColleaguesInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    tagNum = 1;
    CGFloat num = DLScreenWidth / (320 / 55.0);
    
    [self builtScrollPhotoView];
    
    CGFloat height = DLScreenHeight / (568 / 400.0);
    
    [self builtInterfaceWithNameArray:@[@"资料", @"动态", @"关系"] imageArray:nil andrect:CGRectMake(0, 0, num, num * 1.85) andCenterY:height];
    [self builtInterfaceWithNameArray:@[@"聊天", @"关心"] imageArray: nil andrect:CGRectMake(0, 0, num, num * 1.85) andCenterY:height + num * 1.85];
    
}

- (void)builtScrollPhotoView
{
    CGFloat heightRote = DLScreenHeight / (667 / 368.00);
    UIScrollView *scrollPhotoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, heightRote)];
    [scrollPhotoView setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:scrollPhotoView];
    self.photoArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"114.png"],[UIImage imageNamed:@"2.jpg"], nil];
    NSInteger i = 0;
    
    for (UIImage *image in self.photoArray) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i * DLScreenWidth, 0, DLScreenWidth, scrollPhotoView.size.height)];
        imageview.image = image;
        [scrollPhotoView addSubview:imageview];
        i++;
    }
    scrollPhotoView.showsVerticalScrollIndicator = FALSE;
    scrollPhotoView.showsHorizontalScrollIndicator = FALSE;
    scrollPhotoView.pagingEnabled = YES;
    scrollPhotoView.delegate = self;
    scrollPhotoView.contentSize = CGSizeMake(DLScreenWidth * [self.photoArray count], 0);
    
    self.pag = [UIPageControl new];
    self.pag.backgroundColor = [UIColor colorWithWhite:.1 alpha:.2];
    self.pag.numberOfPages = [self.photoArray count];
    
    
    
    [self.view addSubview:self.pag];
    [self.pag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(scrollPhotoView.mas_bottom);
        make.left.mas_equalTo(scrollPhotoView.mas_left);
        make.right.mas_equalTo(scrollPhotoView.mas_right);
        make.height.mas_equalTo(DLScreenHeight / 15.159);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:@"＋关注" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.pag addSubview:button];
    
    button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"关注");
        return [RACSignal empty];
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.pag.mas_right);
        make.top.mas_equalTo(self.pag.mas_top);
        make.bottom.mas_equalTo(self.pag.mas_bottom);
        make.width.mas_equalTo(100);
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pag.currentPage = scrollView.contentOffset.x / DLScreenWidth;
}
- (void)builtInterfaceWithNameArray:(NSArray *)nameArray imageArray:(NSArray *)imageArray andrect:(CGRect)rect andCenterY:(NSInteger)num
{
    int i = 0;
    CGFloat rote = rect.size.width / 2.0333;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((DLScreenWidth - [nameArray count] * (rect.size.width + rote)) / 2.0, 0, [nameArray count] * (rect.size.width + rote), rect.size.height)];
//    view.centerX = self.view.centerX;
    view.centerY = num;
//    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    
    
    for (NSString *str in nameArray) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), 0, rect.size.width, rect.size.width)];
        imageview.image = [UIImage imageNamed:@"1"];
        [view addSubview:imageview];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = rect.size.width / 2.0;
        
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        imageview.tag = tagNum;
        tagNum ++;
        [imageview addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), rect.size.height - rote * 2, rect.size.width, rote * 2)];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        i++;
    }
}

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:{
            
            FolderViewController *folder = [[FolderViewController alloc]init];
            [self.navigationController pushViewController:folder animated:YES];
            
            break;
        }
        case 2:{
            // 个人动态页面
            PersonalDynamicController *dynamic = [[PersonalDynamicController alloc]init];
            [self.navigationController pushViewController:dynamic animated:YES];
            
            break;
        }
        case 3:
            NSLog(@"关系");
            break;
        case 4:
            NSLog(@"聊天");
            break;
        case 5:
            NSLog(@"关心");
            break;
        default:
            break;
    }
    
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
