//
//  GroupMemberController.m
//  app
//
//  Created by 申家 on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//
#import "ColleaguesInformationController.h"
#import "AddressBookModel.h"
#import "GroupMemberController.h"
#import "GroupMemberCell.h"
@interface GroupMemberController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;


@end
static NSString *GroupI = @"vdsjfgsejrfsenjfnj";

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    self.title = @"社团成员";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) collectionViewLayout:layout];
//    self.collectionView.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[GroupMemberCell class] forCellWithReuseIdentifier:GroupI];
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GroupI forIndexPath:indexPath];
    NSDictionary *dic= [self.modelArray objectAtIndex:indexPath.row];
    NSString *str = [dic objectForKey:@"_id"];
    cell.userId = str;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (DLScreenWidth - 3) / 4.0;
    CGFloat height = 1.3 * width;
    return CGSizeMake(width, height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColleaguesInformationController *folder= [[ColleaguesInformationController alloc]init];
    AddressBookModel *model =[[AddressBookModel alloc]init];
    NSDictionary *dic= self.modelArray[indexPath.row];
    
    model.ID = [dic objectForKey:@"_id"];
    
    folder.model = model;
    
    [self.navigationController pushViewController:folder animated:YES];
    
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

- (void)setModelArray:(NSMutableArray *)modelArray{
    _modelArray = modelArray;
    
}

@end
