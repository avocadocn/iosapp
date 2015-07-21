//
//  ChoosePhotoController.m
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ChoosePhotoController.h"
#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Masonry.h>
#import "photoHeader.h"
#import <ReactiveCocoa.h>



@interface ChoosePhotoController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)ALAssetsLibrary *library;

@end
static ChoosePhotoController *choose = nil;
@implementation ChoosePhotoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self builtInterface];
}

+ (ChoosePhotoController *)shareStateOfController
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!choose) {
            choose = [[ChoosePhotoController alloc]init];
        }
    });
    
    return choose;
}
- (void)selectPicture  //从相册选取图片
{
    
    NSMutableArray * mutableArray =[NSMutableArray array];
    self.library = [[ALAssetsLibrary alloc] init];
    
    __block NSMutableArray *array = [NSMutableArray array];  //存照片的数组
    
    __block NSInteger big = 0;  //找group的执行次数
    __block NSInteger sm = 0;   //每个group的执行次数
    __block NSInteger second = 0;  // 总的相片数
    __block NSInteger thred = 0;  //总的执行次数
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        NSString *type = [group valueForProperty:ALAssetsGroupPropertyName];
        
        NSInteger inte = [group numberOfAssets];
//        NSLog(@"inte == %ld", inte);
        big ++;
//        NSLog(@"big == %ld", big);
        
        thred += inte;
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            sm++;
//            NSLog(@"sm ==%ld",sm);
            
            NSURL *url = [result valueForProperty:ALAssetPropertyAssetURL];
            if (result) {
                [mutableArray addObject:type];
            }
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                
                [self.library assetForURL:url resultBlock:^(ALAsset *asset) {  //通过url找图片,这一步是必须的
                    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    
                    if (image) {
                        [array addObject:image];
                    }
                    second ++;
//                    NSLog(@"%ld", second);
                    
                    if (second == thred) {
//                        NSLog(@"扫描完成");
                        [self reloadCollectionWithArray:array mutableArray:mutableArray];
                        
                    }
                    
                    
                } failureBlock:^(NSError *error) {
                    //                    NSLog(@"%@", error);
                }];
            }
            
        }];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)reloadCollectionWithArray:(NSMutableArray *)array mutableArray:(NSMutableArray *)mutableArray
{
    if (!self.photoArray) {
        self.photoArray = [NSMutableArray array];
    }
    
    int i = 0;
    NSMutableArray *smArray = [NSMutableArray array]; //  存图片
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableString *name = [mutableArray objectAtIndex:i];  //group名字
    
    for (NSString *str in mutableArray) {
        if ([name isEqualToString:str]) {
            [dic setObject:name forKey:@"name"];
            if (i < ([array count] - 1)) {
                
                if ([array objectAtIndex:i] ) {
                    [smArray addObject:[array objectAtIndex:i]];
                    
                }}
            
            if (i == [array count] - 1) {
                [dic setObject:smArray forKey:@"array"];
                [self.photoArray addObject:dic];
            }
        }
        if (![name isEqualToString:str]) {
            name = [NSMutableString stringWithFormat:@"%@", str];
            [dic setObject:smArray forKey:@"array"];
            
            [self.photoArray addObject:dic];
            dic = [NSMutableDictionary dictionary];
            smArray = [NSMutableArray array];
        }
        
        i++;
    }
    
    // 走到这一步读取完所有相册
    NSLog(@"%@", self.photoArray);
    
    [self.photoCollection reloadData];
}

- (void)builtInterface
{
    [self selectPicture];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 30);
    self.photoCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.photoCollection.dataSource = self;
    self.photoCollection.delegate = self;
    [self.photoCollection setBackgroundColor:[UIColor whiteColor]];
    [self.photoCollection registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self.photoCollection registerClass:[photoHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [self.view addSubview:self.photoCollection];
    
    
    self.selectView = [UIView new];
    [self.selectView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.selectView];
    
    if (!self.photoArray) {
        self.photoArray = [NSMutableArray array];
    }
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark"]];
    [self.selectView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectView).with.offset(5);
        make.right.mas_equalTo(self.selectView).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    
    self.selectNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 2, 30, 23)];
    self.selectNumLabel.textColor = [UIColor whiteColor];
    self.selectNumLabel.text = @"0";
    [imageview addSubview:self.selectNumLabel];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnButton setTintColor:[UIColor lightGrayColor]];
    [returnButton setTitle:@"返回" forState: UIControlStateNormal];
    returnButton.frame = CGRectMake(0, 0, 45, 25);
    returnButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        // 铺照片界面
        [self.delegate arrangeStartWithArray:self.photoArray];
        
        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:returnButton];
    
}
// 要显示的 section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.photoArray count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DLScreenWidth / 4 - 8, DLScreenWidth / 4 - 8);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor blueColor]];
    NSDictionary *dic = [self.photoArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"array"];
    
    
    cell.imageView.image = [array objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    photoHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.photoArray objectAtIndex:indexPath.section];
    NSString *str = [dic objectForKey:@"name"];
    header.label.text = str;
    
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.photoArray objectAtIndex:section];
    
    NSArray *array = [dic objectForKey:@"array"];
    return [array count];
}

@end
