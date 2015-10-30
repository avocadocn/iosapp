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
#import <DGActivityIndicatorView.h>
#import "GroupCardModel.h"
#import "TeamHomePageController.h"
#import "AddressBookModel.h"
#import "ColleaguesInformationController.h"
static int selectNum = 1;
static Boolean wrap = NO;
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
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGiftTime];
    [self setUpUI];
    // 设置标题栏
    [self setUpNavTitleWithRankListType:self.listType];
}

- (void)reloadRankDataWithJson:(id)json AndType:(PARSE_TYPE)type
{
    self.modelArray = [NSMutableArray array];
    NSArray *ranking;
    if (type==PARSE_TYPE_MEN||type==PARSE_TYPE_WOMEN) {
        ranking = [json objectForKey:@"ranking"];
    }else if(type==PARSE_TYPE_TEAM){
        ranking = json;
    }
    NSInteger i = 0;
    for (NSDictionary *dic  in ranking) {
        RankDetileModel *model = [[RankDetileModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        if (type!=PARSE_TYPE_TEAM) {
            [model setLogo:[dic objectForKey:@"photo"]];
            [model setName:[dic objectForKey:@"nickname"]];
        }
        [model setIndex:[NSString stringWithFormat:@"%ld", i + 1]];
        [model setType:type];

        [self.modelArray addObject:model];
        i++;
    }
    if (i>2) {
        wrap=YES;
    }else{
        wrap=NO;
    }
    NSLog(@"开始刷新");
    //设置底部信息栏
    RankDetileModel *model = [self.modelArray firstObject];
    [self reloadRankViewWithModel:model];
    [UIView beginAnimations:nil context:nil];
    [self.carousel scrollToItemAtIndex:0 animated:YES];
    [self.carousel reloadData];
    [UIView commitAnimations];
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
    [super viewWillAppear:animated];
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
//        RankListItemView *cell = [[RankListItemView alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(217.0) , DLMultipleWidth(DLScreenHeight/2.0))];
        RankListItemView *cell = [[RankListItemView alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(217.0) , DLMultipleWidth(257.0))];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.backgroundColor = [UIColor greenColor];
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.delegate=self;
        cell.layer.shadowRadius = 7;
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOpacity = .5;
        view = cell;
        
    }
    RankDetileModel *model = [self.modelArray objectAtIndex:index];
    [(RankListItemView*)view reloadRankCellWithRankModel:model andIndex:model.index];
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
        //尝试获取状态更新
        [self getGiftTime];
    } failure:^(id errorJson) {
        NSLog(@"送礼失败   %@", errorJson);
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"投票失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle: @"取消" otherButtonTitles:nil, nil];
        
        [al show];
    }];
}


- (void)reloadRankViewWithModel:(RankDetileModel *)model
{
    NSLog(@"现在的 %@, %@", model.ID, model.index);
    self.bottomShowView.nameLabel.text = @"";
    self.bottomShowView.avatar.image = nil;
    
    self.bottomShowView.nameLabel.text = model.name;
    [self.bottomShowView.avatar dlGetRouteThumbnallWebImageWithString:model.logo placeholderImage:nil withSize:CGSizeMake(50.0, 50.0)] ;
    [self.bottomShowView.nameLabel fitContentWithMaxSize:CGSizeMake(160, 90)];
    [self.bottomShowView bringSubviewToFront:self.bottomShowView.nameLabel];
    self.bottomShowView.rankLabel.text = [NSString stringWithFormat:@"目前排名: %@", model.index];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    RankDetileModel *model = [self.modelArray objectAtIndex:carousel.currentItemIndex];
    [self reloadRankViewWithModel:model];
    
//    HMShopCell *cell = (HMShopCell *)[carousel.subviews objectAtIndex:carousel.currentItemIndex];
//    cell.personLike.text = [NSString stringWithFormat:@"%ld", [cell.personLike.text integerValue] + 1];
//    NSLog(@"子视图有  %@", cell);
    if(index==carousel.currentItemIndex){
        //[self voteActionWithId:model.ID];
        if (self.listType == RankListTypePopularity) {
            //跳转到群组详情
            [self jumpToTeamWithID:model.ID];
        }else{
            //跳转到个人详情
            [self jumpToPeopleWithID:model.ID];
        }
    }
}
- (void)jumpToTeamWithID:(NSString*)groupId
{
    [RestfulAPIRequestTool routeName:@"getGroupInfor" requestModel:[NSDictionary dictionaryWithObjects:@[groupId]  forKeys:@[@"groupId"]] useKeys:@[@"groupId"] success:^(id json) {
        
        GroupCardModel *model = [GroupCardModel new];
        NSDictionary* d = [json objectForKey:@"group"];
        if (![[NSNull null] isEqual:d]) {
            [model setName:[d objectForKey:@"name"]];
            [model setLogo:[d objectForKey:@"logo"]];
            [model setGroupId:[d objectForKey:@"_id"]];
            [model setAllInfo:YES];
            TeamHomePageController *groupDetile = [[TeamHomePageController alloc]init];
            groupDetile.groupCardModel = model;
            [self.navigationController pushViewController:groupDetile animated:YES];
        }
    } failure:^(id errorJson) {
        
    }];
    
    
}
- (void)jumpToPeopleWithID:(NSString*)peopleId
{
    FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
    Boolean attentState = [fmdb containConcernWithId:peopleId];
    [RestfulAPIRequestTool routeName:@"getUserInfo" requestModel:[NSDictionary dictionaryWithObjects:@[peopleId]  forKeys:@[@"userId"]] useKeys:@[@"userId"] success:^(id json) {
        
        AddressBookModel* model = [AddressBookModel new];
        [model setValuesForKeysWithDictionary:json];
        [model setAttentState:attentState];
        ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
        coll.model = [[AddressBookModel alloc]init];
        coll.model = model;
        coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.navigationController pushViewController:coll animated:YES];
    } failure:^(id errorJson) {
    }];
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
            return wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * .5;//* 1.05f;
        }
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
        case iCarouselOptionRadius:
        {
//            return DLScreenHeight * 0.5;
            return value ;
        }
        case iCarouselOptionArc:
        {
            return  2 * M_PI ;
        }
        case iCarouselOptionFadeMin:
        {
            return -.5;
        }
        case iCarouselOptionFadeMax:
        {
            return .5;
        }
        case iCarouselOptionFadeMinAlpha:
        {
            return value;
        }
        case iCarouselOptionFadeRange:
        {
            return 2;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionAngle:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        
        case iCarouselOptionOffsetMultiplier:
        
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
//            return wrap;
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
//            return 5;
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
    self.listType=indexPath.row;
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
    [dic setObject:@1 forKey:@"page"];
    [dic setObject:@20 forKey:@"limit"];
    if ([num compare:[NSNumber numberWithInt:0]]!=NSOrderedSame) {
        [dic setObject:acc.cid forKey:@"cid"];
        [dic setObject:num forKey:@"type"];
        [RestfulAPIRequestTool routeName:@"getCompaniesFavoriteRank" requestModel:dic useKeys:@[@"cid", @"type", @"page", @"limit",@"vote"] success:^(id json) {
            NSLog(@"获取排行榜成功  %@", json);
            [self reloadRankDataWithJson:json AndType:[num isEqual:@1]?PARSE_TYPE_MEN:PARSE_TYPE_WOMEN];
            
        } failure:^(id errorJson) {
            NSLog(@"获取排行榜失败  %@", errorJson);
        }];
    }else{
        [RestfulAPIRequestTool routeName:@"getTeamsFavoriteRank" requestModel:dic useKeys:@[@"page", @"limit",@"vote"] success:^(id json) {
            NSLog(@"获取排行榜成功  %@", json);
            [self reloadRankDataWithJson:json AndType:PARSE_TYPE_TEAM];
            
        } failure:^(id errorJson) {
            NSLog(@"获取排行榜失败  %@", errorJson);
        }];
    }
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
//    [self reloadRankDataWithJson:bigDic];
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
- (void)updateHeartTime:(NSInteger)num
{
    if (self.bottomShowView.selectNum>0) {
        self.bottomShowView.selectNum-=1;
    }
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

- (void)voteForPeople
{
    RankDetileModel* model = [self.modelArray objectAtIndex:self.carousel.currentItemIndex];
    NSNumber *num = [NSNumber numberWithInt:4];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:num forKey:@"giftIndex"];
    [dic setObject:model.ID forKey:@"receiverId"];
    
    [RestfulAPIRequestTool routeName:@"sendGifts" requestModel:dic useKeys:@[@"giftIndex"] success:^(id json) {
        NSLog(@"送礼成功  %@", json);
        [self requestNetWithType:[NSNumber numberWithInt:selectNum]];
        //尝试获取状态更新
        [self getGiftTime];
    } failure:^(id errorJson) {
        NSLog(@"送礼失败   %@", errorJson);
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"投票失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle: @"取消" otherButtonTitles:nil, nil];
        
        [al show];
    }];
}

@end





