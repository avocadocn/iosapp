//
//  RankController.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankController.h"
#import "RankShowViewCell.h"
#import "LineLayout.h"
#import "RankItemLayoutAttr.h"

#import "RankItemCell.h"

@interface RankController ()

@property(strong,nonatomic) LineLayout *layout;


@end

@implementation RankController

static NSString * const reuseIdentifier = @"Cell";
-(instancetype)initWithFrame:(CGRect)frame{
    LineLayout *layout = [[LineLayout alloc]init];
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        
        [self.collectionView setFrame:frame];
        self.layout = layout;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange:) name:kLineLayoutAttrChange object:nil];
        // NSLog(@"%@",self.layout);
    }
    return self;
}

//-(void)loadView{
//    LineLayout *layout = [[LineLayout alloc]init];
//    
//    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
//    
//    self.layout = layout;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange:) name:kLineLayoutAttrChange object:nil];
//}


-(void)viewDidLayoutSubviews{
    
    [self.layout layoutAttributesForElementsInRect:self.view.bounds];
}

-(void)valueChange:(NSNotification *)sender{
    
    RankItemLayoutAttr *attr = sender.object;
    RankItemCell *cell = (RankItemCell *)[self.collectionView cellForItemAtIndexPath:attr.indexPath];
    cell.coverView.alpha = attr.equivocation;

    // [self.layout shouldInvalidateLayoutForBoundsChange:CGRectZero];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[RankItemCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setBackgroundColor:[UIColor redColor]];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RankItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // NSLog(@"---%@",[self.layout layoutAttributesForItemAtIndexPath:indexPath]);
    // Configure the cell
    
    
    return cell;
}






#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
