//
//  RankListController.m
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "CriticWordView.h"
#import <Masonry.h>
#import "HMShopCell.h"
#import "RestfulAPIRequestTool.h"
#import "AccountTool.h"
#import "Account.h"
#import "RankListController.h"
#import "RankController.h"
#import "RankItemTableViewcell.h"
#import "RankItemView.h"
#import "RankBottomShowView.h"

#import "RankDetileModel.h"


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

-(instancetype)init{
    self = [super init];
    if (self) {
        if (!self.items) {
            self.items = [NSMutableArray array];
        }
        for (NSInteger i = 0; i < 20; i++) {
            [self.items addObject:[NSNumber numberWithInteger:i]];
            }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}


- (void)reloadRankDataWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    
    NSArray *ranking = [json objectForKey:@"ranking"];
    
    for (NSDictionary *dic  in ranking) {
        RankDetileModel *model = [[RankDetileModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:model];
    }
    NSLog(@"开始刷新");
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
    
    // 折叠
    iCarousel *carousel = [[iCarousel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame), tableView.y, DLScreenWidth - CGRectGetWidth(tableView.frame), tableView.height)];
//    iCarousel *carousel = [iCarousel new];
    
    carousel.clipsToBounds = NO;
//    carousel.backgroundColor = RGBACOLOR(238, 238, 240, 1);
//    carousel.layer.shadowRadius = 15;
//    carousel.layer.shadowColor = [UIColor blackColor].CGColor;
//    carousel.layer.shadowOpacity = .5;

    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.vertical = YES;
    carousel.type = iCarouselTypeRotary;
    carousel.clipsToBounds = YES;
    NSLog(@"%f",carousel.offsetMultiplier);
    
    [self.view addSubview:carousel];
    
    self.carousel = carousel;
    
//    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(tableView.mas_top);
//        make.bottom.mas_equalTo(tableView.mas_bottom);
//        make.left.mas_equalTo(tableView.mas_right);
//        make.right.mas_equalTo(self.view.mas_right);
//    }];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RankBottomShowView"owner:self options:nil];
    
    UIView *bottomShowView = [nibs objectAtIndex:0];
    NSLog(@"%f",bottomShowView.height);
    // 设置frame;
    bottomShowView.x = 0;
    bottomShowView.y = DLScreenHeight - bottomShowView.height;
    bottomShowView.width = DLScreenWidth;
    [self.view addSubview:bottomShowView];
    self.bottomShowView = bottomShowView;
    self.bottomShowView.selectNum = 3;
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.listType inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
        /*
//        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RankItemView" owner:self options:nil];
        
//        view = [nibs objectAtIndex:0];
//        RankItemView *itemView = (RankItemView *)view;
        */  //原来的不正确的item
        
        HMShopCell *cell = [[HMShopCell alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(217.0) , DLMultipleWidth(245.0))];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        RankDetileModel *model = [self.modelArray objectAtIndex:index];
        [cell reloadRankCellWithRankModel:model andIndex:model.index];
        cell.layer.shadowRadius = 10;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOpacity = .5;
        view = cell;
        
//        [cell.parseButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteAction:)]];
    }
    
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 5;
    
    return view;
}

- (void)voteAction//:(UITapGestureRecognizer *)tap
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"4" forKey:@"giftIndex"];
    [dic setObject:@"55dc110314a37c242b6486d1" forKey:@"receiverId"];
    
    [RestfulAPIRequestTool routeName:@"sendGifts" requestModel:dic useKeys:@[@"giftIndex"] success:^(id json) {
        NSLog(@"送礼成功  %@", json);
        
    } failure:^(id errorJson) {
        NSLog(@"送礼失败   %@", errorJson);
    }];
}


- (void)reloadRankViewWithModel:(RankDetileModel *)model
{
    NSLog(@"现在的 %@, %@", model.ID, model.index);
    self.bottomShowView.nameLabel.text = model.ID;
    self.bottomShowView.rankLabel.text = [NSString stringWithFormat:@"目前排名: %@", model.index];
    self.bottomShowView.avatar.image = [UIImage imageNamed:@"2"];
    
    self.bottomShowView.selectNum -= 1;
    switch (self.bottomShowView.selectNum) {
        case 2:{
        self.bottomShowView.love3.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            break;
        }
        case 1 :{
            self.bottomShowView.love2.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            break;
        }
        case 0:{
            self.bottomShowView.love1.image = [UIImage imageNamed:@"RankLoveHeart_gray.png"];
            break;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    RankDetileModel *model = [self.modelArray objectAtIndex:carousel.currentItemIndex];
    [self reloadRankViewWithModel:model];
    
    [self voteAction];
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


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 20;
}




- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    
    
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionArc:
        {
            return  2 * M_PI;
        }
        case iCarouselOptionRadius:
        {
//            return 250;
            return DLScreenHeight * 0.3;
        }
      
        case iCarouselOptionVisibleItems:{
            return self.modelArray.count;
        }
            
        case iCarouselOptionSpacing:{
            return 10;
        }
            
        case iCarouselOptionFadeMin:
        {
            return .5;
        }
        case iCarouselOptionFadeMax:{
            return .5;
        }
            
        case iCarouselOptionFadeMinAlpha:{
            return 1;
        }
        
        default:
        {
            return value;
        }
    }
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
        [cell.itemLabel setText:@"人气"];
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
    // 设置标题栏
    NSString *title;
    switch (rankListType) {
        case RankListTypeMenGod:
            title = @"男神榜";
            if (!self.manArray) {
                [self requestNetWithType:@1];
            } else
            {
                [self loadWithArray:self.manArray];
            }
            
            break;
        case RankListTypeWomenGod:
            title = @"女神榜";
            if (!self.womanArray) {
                [self requestNetWithType:@2];
            } else
            {
                [self loadWithArray:self.womanArray];
            }
            break;
        case RankListTypePopularity:
            title = @"人气榜";
            if (!self.populArray) {
                [self requestNetWithType:@0];
            }
            [self loadWithArray:self.populArray];
            break;
        default:
            break;
    }
    self.title = title;
}


/*
- (void)netRequestWithRankType:(RankListType)rankListType
{
    switch (rankListType) {
        case RankListTypeMenGod:
//            title = @"男神榜";
            if (!self.manArray) {
                [self requestNetWithType:@1];
            }
            break;
        case RankListTypeWomenGod:
            if (!self.womanArray) {
                [self requestNetWithType:@2];
            }
//            title = @"女神榜";
            break;
        case RankListTypePopularity:
//            title = @"人气榜";
            [self requestNetWithType:@0];
            break;
        default:
            break;
    }

}
*/


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
        NSLog(@"获取成功  %@", json);
        
        
        [self getJson];
        
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
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






@end





