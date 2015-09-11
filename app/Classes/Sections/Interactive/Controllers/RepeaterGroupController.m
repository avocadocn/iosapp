//
//  RepeaterGroupController.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RepeaterGroupController.h"
#import "GroupCardViewCell.h"
#import "photoSectionHeader.h"
#import "DWBubbleMenuButton.h"

@interface RepeaterGroupController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation RepeaterGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFalseData];
    [self builtInterface];
}

- (void)makeFalseData
{
    self.modelArray = [NSMutableArray array];
    NSArray *array = @[@"已经转发的小队"];
    for (NSString *str in array) {
        
        NSDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:str forKey:@"title"];
        NSMutableArray *tempArray = [NSMutableArray array];
        NSInteger inte = arc4random() % 15+5;
        for (int i = 0; i < inte; i++) {
            [tempArray addObject:@"动梨基地"];
        }
        [dic setValue:tempArray forKey:@"array"];
        [self.modelArray addObject:dic];
    }
}

- (void)builtInterface
{
    //添加高斯模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, DLScreenWidth, DLScreenHeight);
    [self.view addSubview:effectview];
    //添加标题label
    UILabel* titleLabel = [UILabel new];
    NSString* titleStr =  @"选择转发的小队";
    UIFont* titleFont = [UIFont systemFontOfSize:18.0f];
    titleLabel.text = titleStr;
    [titleLabel setTextColor:RGB(0xfd, 0xb9, 0x0)];
    CGSize maxTitleLabelSize = CGSizeMake(DLScreenWidth, 30);
    CGSize trueTitleLabelSize = [titleStr sizeWithFont:titleFont constrainedToSize:maxTitleLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    titleLabel.size = trueTitleLabelSize;
    titleLabel.x = (DLScreenWidth-titleLabel.width)/2.0;
    titleLabel.y = 57;
    
    [titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    //添加分割线
    UIView* separater = [UIView new];
    separater.backgroundColor = [UIColor whiteColor];
    separater.x = 10;
    separater.y = CGRectGetMaxY(titleLabel.frame) + 40;
    separater.width = DLScreenWidth-DLMultipleWidth(11)*2;
    separater.height= 1;

    //添加collectionview
    NSInteger interval = 10;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(interval, interval , interval, interval);
    //添加一个头
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 30);
    CGRect frame = CGRectMake(0, CGRectGetMaxY(separater.frame)+10, DLScreenWidth, (DLScreenHeight-CGRectGetMaxY(separater.frame)-10)/3.0*2);
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    //进行模态窗口时，需要设置背景色的透明度
    [self.groupListCollection setBackgroundColor:[UIColor clearColor]];
    [self.groupListCollection registerClass:[GroupCardViewCell class] forCellWithReuseIdentifier:@"groupCardCell"];
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    
//    [self.groupListCollection registerClass:[photoSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section"];
    //添加关闭按钮
    UIButton* closeBtn = [UIButton new];
    NSInteger closeBtnRadius = DLMultipleWidth(20);
    [closeBtn setBackgroundColor:RGB(0xfd, 0xb9, 0)];
    closeBtn.width = closeBtnRadius*2;
    closeBtn.height = closeBtnRadius*2;
    closeBtn.x = DLScreenWidth/2-closeBtnRadius;
    closeBtn.y =CGRectGetMaxY(self.groupListCollection.frame)+(DLScreenHeight-CGRectGetMaxY(self.groupListCollection.frame))/2-closeBtnRadius;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleLabel];
    [self.view addSubview:separater];
    [self.view addSubview:self.groupListCollection];
    [self.view addSubview:closeBtn];
    
}

#pragma mark UICollectionViewController delegate data source
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    photoSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section" forIndexPath:indexPath];
//    [header setBackgroundColor:[UIColor clearColor]];
//    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
//    NSString *str = [dic objectForKey:@"title"];
//    header.label.text = str;
//    header.label.textColor = [UIColor orangeColor];
//    return header;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger interval = DLMultipleWidth(10);
    NSInteger width = (DLScreenWidth - 4 * interval)/3.0;
    return CGSizeMake(width, DLMultipleHeight(126.0));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.modelArray objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"array"];
    
    return [array count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}

- (void)closeBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
