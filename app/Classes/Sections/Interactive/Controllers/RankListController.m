//
//  RankListController.m
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <Masonry.h>
#import "RestfulAPIRequestTool.h"
#import "AccountTool.h"
#import "Account.h"
#import "RankListController.h"
#import "RankController.h"
#import "RankItemTableViewcell.h"
#import "RankItemView.h"
#import "RankBottomShowView.h"
#import "RankDetileModel.h"
#import "RankListItemView.h"
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "UIImageView+DLGetWebImage.h"

static int selectNum = 1;

@interface RankListController ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;
@property (nonatomic,strong) RankBottomShowView *bottomShowView;
@property (nonatomic,assign) RankListType listType;
@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)NSMutableArray *manArray;
@property (nonatomic, strong)NSMutableArray *womanArray;
@property (nonatomic, strong)NSMutableArray *populArray;

@end

@implementation RankListController


static NSString * const ID =  @"RankItemTableViewcell";

-(instancetype)initWithRankListType:(RankListType)rankListType{
    self = [self init];
    self.listType = rankListType;
    
    // 设置标题栏
    [self setUpNavTitleWithRankListType:rankListType];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGiftTime];
    [self setUpUI];
}


- (void)reloadRankDataWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    
    NSArray *ranking = [json objectForKey:@"ranking"];
    
    NSInteger i = 0;
    for (NSDictionary *dic  in ranking) {
        RankDetileModel *model = [[RankDetileModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        [model setIndex:[NSString stringWithFormat:@"%ld", i + 1]];
        
        [self.modelArray addObject:model];
        i++;
    }
    NSLog(@"开始刷新");
    [self.carousel scrollToItemAtIndex:0 animated:YES];
    [self.carousel reloadData];
}

// 设置ui
-(void)setUpUI{
    self.view.backgroundColor = RGBACOLOR(238, 238, 240, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 100,DLScreenHeight - 64 * 2)];
    tableView.backgroundColor = RGBACOLOR(238, 238, 240, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"RankItemTableViewcell" bundle:[NSBundle mainBundle]];
    
    [tableView registerNib:nib forCellReuseIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // [tableView setSeparatorInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setScrollEnabled:NO];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
//    [self.tableView setBackgroundColor:[UIColor greenColor]];
    
    // 折叠
    iCarousel *carousel = [[iCarousel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame), tableView.y, DLScreenWidth - CGRectGetWidth(tableView.frame), tableView.height)];
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.vertical = YES;
    carousel.type = iCarouselTypeRotary;
    //默认先将当前索引置为-1
    carousel.currentItemIndex=-1;
    [self.view addSubview:carousel];
    self.carousel = carousel;
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RankBottomShowView"owner:self options:nil];
    
    UIView *bottomShowView = [nibs objectAtIndex:0];
    NSLog(@"%f",bottomShowView.height);
    // 设置frame;
    bottomShowView.x = 0;
    bottomShowView.y = DLScreenHeight - bottomShowView.height;
    bottomShowView.width = DLScreenWidth;
    [self.view addSubview:bottomShowView];
    self.bottomShowView = (RankBottomShowView*)bottomShowView;
    self.bottomShowView.selectNum = 3;
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.listType inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    RankItemTableViewcell *cell = (RankItemTableViewcell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self makeCellSelected:cell];
    self.lastIndexPath = indexPath;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel代理方法
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.modelArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        RankListItemView *cell = [[RankListItemView alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(217.0) , DLMultipleWidth((DLScreenHeight/2.0))>DLMultipleWidth(217.0)?DLMultipleWidth(217.0):DLMultipleWidth((DLScreenHeight/2.0)))];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        RankDetileModel *model = [self.modelArray objectAtIndex:index];
        [cell reloadRankCellWithRankModel:model andIndex:model.index];
        cell.layer.shadowRadius = 7;
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOpacity = .5;
        view = cell;
        
    }
    
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 5;
    
    return view;
}
// 送礼  点赞
- (void)voteActionWithId:(NSString *)userId
{
    Account *acc = [AccountTool account];
    
    NSNumber *num = [NSNumber numberWithInt:4];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:num forKey:@"giftIndex"];
    [dic setObject:userId forKey:@"receiverId"];
    
    [RestfulAPIRequestTool routeName:@"sendGifts" requestModel:dic useKeys:@[@"giftIndex"] success:^(id json) {
        NSLog(@"送礼成功  %@", json);
        [self requestNetWithType:[NSNumber numberWithInt:selectNum]];
    } failure:^(id errorJson) {
        NSLog(@"送礼失败   %@", errorJson);
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"投票失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle: @"取消" otherButtonTitles:nil, nil];
        
        [al show];
    }];
}


- (void)reloadRankViewWithModel:(RankDetileModel *)model
{
    NSLog(@"现在的 %@, %@", model.ID, model.index);
    FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
    Person* p = [fmdb selectPersonWithUserId:model.ID];
    if (p) {
        self.bottomShowView.nameLabel.text = p.name;
        [self.bottomShowView.avatar dlGetRouteThumbnallWebImageWithString:p.imageURL placeholderImage:nil withSize:CGSizeMake(50.0, 50.0)] ;
    }
    self.bottomShowView.rankLabel.text = [NSString stringWithFormat:@"目前排名: %@", model.index];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    RankDetileModel *model = [self.modelArray objectAtIndex:carousel.currentItemIndex];
    [self reloadRankViewWithModel:model];
    
//    HMShopCell *cell = (HMShopCell *)[carousel.subviews objectAtIndex:carousel.currentItemIndex];
//    cell.personLike.text = [NSString stringWithFormat:@"%ld", [cell.personLike.text integerValue] + 1];
//    NSLog(@"子视图有  %@", cell);
    if(index==carousel.currentItemIndex){
        [self voteActionWithId:model.ID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    RankDetileModel *model = [self.modelArray objectAtIndex:carousel.currentItemIndex];
    [self reloadRankViewWithModel:model];
}



- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    switch (option)
//    {
//        //当为NO时，可以添加占位视图
//        case iCarouselOptionWrap:
//        {
//            return NO;
//        }
//        case iCarouselOptionArc:
//        {
//            return  value;
//        }
//        //可以设置两个items的距离（我的理解）
//        case iCarouselOptionRadius:
//        {
////            return 250;
//            return DLScreenHeight * 0.3;
//        }
//      
//        case iCarouselOptionVisibleItems:{
//            return value;
//        }
//            
//        case iCarouselOptionSpacing:{
//            return value*1.05f;
//        }
//            
//        case iCarouselOptionFadeMin:
//        {
//            return .5;
//        }
//        case iCarouselOptionFadeMax:{
//            return .5;
//        }
//            
//        case iCarouselOptionFadeMinAlpha:{
//            return 1;
//            
//        }
//        
//        default:
//        {
//            return value;
//        }
//    }
//}
//当添加占位视图时，返回占位视图的数量
- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}
//返回占位视图
- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.0f, 0.0f)];
        
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    
    return view;
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
    RankDetileModel *model = [self.modelArray objectAtIndex:carousel.currentItemIndex];
    [self reloadRankViewWithModel:model];
}
#pragma mark - tableView 代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankItemTableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.backgroundColor = [UIColor clearColor];
    
   
    if (indexPath.row == RankListTypeMenGod){
        [cell.itemLabel setText:@"男神"];
    }else if (indexPath.row == RankListTypeWomenGod){
        [cell.itemLabel setText:@"女神"];
    }else if (indexPath.row == RankListTypePopularity){
        [cell.itemLabel setText:@"社团"];
    }else{
        [cell.itemLabel setText:@""];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < RankListTypeMenGod || indexPath.row > RankListTypePopularity) {
        return;
    }
    
    // 设置标题栏title
    [self setUpNavTitleWithRankListType:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    // 判断是否是同一个item
    if ([self.lastIndexPath isEqual:indexPath]) {
        return;
    }
    
    RankItemTableViewcell *lastCell = (RankItemTableViewcell *)[tableView cellForRowAtIndexPath:self.lastIndexPath];
    [self makeCellNormal:lastCell];
    
    RankItemTableViewcell *cell = (RankItemTableViewcell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.itemImageView setImage:[UIImage imageNamed:@"rankListItem-selected"]];
//    cell.itemLabel.textColor = [UIColor redColor];
    [self makeCellSelected:cell];
    
    self.lastIndexPath = indexPath;
    
    
}

#pragma mark - 设置cell状态的方法
-(void)makeCellSelected:(RankItemTableViewcell *)cell{
    [cell.itemImageView setImage:[UIImage imageNamed:@"rankListItem-selected"]];
    cell.itemLabel.textColor = [UIColor orangeColor];
}

-(void)makeCellNormal:(RankItemTableViewcell *)cell{
    [cell.itemImageView setImage:[UIImage imageNamed:@"rankListItem-normal"]];
    cell.itemLabel.textColor = [UIColor blackColor];
}

#pragma mark - 设置标题栏
-(void)setUpNavTitleWithRankListType:(RankListType)rankListType{
    
//    [self getGiftTime];
    
    // 设置标题栏
    NSString *title;
    switch (rankListType) {
        case RankListTypeMenGod:
            title = @"男神榜";
            selectNum = 1;
            if (!self.manArray) {
                self.bottomShowView.aMaskView.frame = CGRectMake(0, 0, 0, 0);
                [self requestNetWithType:@1];
            } else
            {
                [self loadWithArray:self.manArray];
            }
            
            break;
        case RankListTypeWomenGod:
            title = @"女神榜";
            selectNum = 2;
                self.bottomShowView.aMaskView.frame = CGRectMake(0, 0, 0, 0);
            if (!self.womanArray) {
                [self requestNetWithType:@2];
            } else
            {
                [self loadWithArray:self.womanArray];
            }
            break;
        case RankListTypePopularity:
            title = @"社团榜";
                self.bottomShowView.aMaskView.frame = CGRectMake(DLScreenWidth - 150 , 0, 150, 60);
            //[self.bottomShowView.aMaskView setBackgroundColor:[UIColor redColor]];
            if (!self.populArray) {
                [self requestNetWithType:@0];
            }else
            {
                [self loadWithArray:self.populArray];
            }
            break;
 
        default:
            break;
    }
    self.title = title;
}


- (void)loadWithArray:(NSArray *)array
{
    self.modelArray = [NSMutableArray arrayWithArray:array];
    [self.carousel reloadData];
}
- (void)requestNetWithType:(NSNumber *)num
{
    
    
    Account *acc = [AccountTool account];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:acc.cid forKey:@"cid"];
    [dic setObject:num forKey:@"type"];
    [dic setObject:@1 forKey:@"page"];
    [dic setObject:@20 forKey:@"limit"];
    
    [RestfulAPIRequestTool routeName:@"getCompaniesFavoriteRank" requestModel:dic useKeys:@[@"cid", @"type", @"page", @"limit",@"vote"] success:^(id json) {
        NSLog(@"获取排行榜成功  %@", json);
        
        [self reloadRankDataWithJson:json];
        
    } failure:^(id errorJson) {
        NSLog(@"获取排行榜失败  %@", errorJson);
    }];
}

- (void)getJson
{
    NSMutableArray *ranking = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"1556487445412112454" forKey:@"_id"];
        [dic setObject:[NSString stringWithFormat:@"%d", 1245 - i * 3] forKey:@"vote"];
        [dic setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"index"];
        [ranking addObject:dic];
    }
    NSDictionary *bigDic = [NSDictionary dictionaryWithObject:ranking forKey:@"ranking"];
    [self reloadRankDataWithJson:bigDic];
}
- (void)getGiftTime
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"heart" forKey:@"content"];
    
    [RestfulAPIRequestTool routeName:@"getGiftsNum" requestModel:dic useKeys:@[@"content"] success:^(id json) {
        NSLog(@"获取礼物数据成功 %@", json);
        [self reloadViewWithJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取礼物失败   %@", errorJson);
    }];
}

- (void)reloadViewWithJson:(id)json
{
    NSDictionary *dic = [json objectForKey:@"heart"];
    
    NSNumber *num = [dic objectForKey:@"remainGift"];
    NSString *timeNum = [dic objectForKey:@"remainTime"];
    
    NSInteger timeInt = [self judgeRemainTime:[timeNum integerValue]];
    
    [self reloadHeartTime:[num integerValue] andLastImageIndex:[NSString stringWithFormat:@"RankLoveHeart_gray%ld@2x", (long)timeInt]];
}

- (void)reloadHeartTime:(NSInteger)num andLastImageIndex:(NSString *)lastStr
{
    self.bottomShowView.selectNum = num;
    switch (self.bottomShowView.selectNum) {
            
        case 2:{
            self.bottomShowView.love3.image = [UIImage imageNamed:lastStr];
            break;
        }
        case 1 :{
            self.bottomShowView.love3.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            self.bottomShowView.love2.image = [UIImage imageNamed:lastStr];
            break;
        }
        case 0:{
            self.bottomShowView.love3.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            self.bottomShowView.love2.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            self.bottomShowView.love1.image = [UIImage imageNamed:lastStr];
            break;
        }
    }
}

- (NSInteger)judgeRemainTime:(NSInteger)timeNumber
{
    NSInteger num = timeNumber / (60 * 60 * 1000 / 2);
    
    return num;
}


@end





