//
//  PhotoPlayController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PhotoPlayController.h"
#import "PhotoShouCell.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface PhotoPlayController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation PhotoPlayController


// 初始化时赋array及要显示的图片的下标
- (instancetype)initWithPhotoArray:(NSArray *)array indexOfContentOffset:(NSInteger)num
{
    self = [super init];
    if (self) {
        self.showImageArray = (NSMutableArray *)array;
        self.num = num;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.showImageCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.showImageCollection.delegate = self;
    self.showImageCollection.dataSource = self;
    self.showImageCollection.pagingEnabled = YES;
            self.showImageCollection.contentOffset = CGPointMake(DLScreenWidth * self.num, 0);
    [self.showImageCollection registerClass:[PhotoShouCell class] forCellWithReuseIdentifier:@"photoShowCell"];
    [self.view addSubview:self.showImageCollection];
    
    self.titleView = [UIView new];
    [self.titleView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 20, 100, 30);
    [button setTitle:@"返回" forState: UIControlStateNormal];
    button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return [RACSignal empty];
    }];
    
    [self.titleView addSubview:button];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoShouCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoShowCell" forIndexPath:indexPath];
    NSString *image = [self.showImageArray objectAtIndex:indexPath.row];
    [cell settingUpImageViewWithImage:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
    [cell.showImageView addGestureRecognizer:tap];
    
    return cell;
}
- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    if (self.titleState == TitleLabelStateYes) { // 标题在显示, 让其消失
        [UIView animateWithDuration:.2 animations:^{
            self.titleView.center = CGPointMake(DLScreenWidth / 2.0, - 100);
        }];
        self.titleState = TitleLabelStateNo;
    } else  //让标题出来
    {
        self.titleView.center = CGPointMake(DLScreenWidth / 2.0, 25);
        self.titleState = TitleLabelStateYes;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.showImageArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DLScreenWidth, DLScreenHeight);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:.2 animations:^{
        self.titleView.center = CGPointMake(DLScreenWidth / 2.0, - 100);
    }];
    self.titleState = TitleLabelStateNo;
}

@end
