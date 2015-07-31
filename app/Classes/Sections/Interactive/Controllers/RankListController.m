//
//  RankListController.m
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankListController.h"
#import "RankController.h"
#import "RankItemTableViewcell.h"
#import "RankItemView.h"
#import "RankBottomShowView.h"

@interface RankListController ()

@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;
@property (nonatomic,strong) UIView *bottomShowView;
@property (nonatomic,assign) RankListType listType;
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
        for (NSInteger i = 0; i < 10; i++) {
            [self.items addObject:[NSNumber numberWithInteger:i]];
            }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

// 设置ui
-(void)setUpUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 100,DLScreenHeight - 64 * 2)];
    tableView.backgroundColor = GrayBackgroundColor;
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
    
    
    iCarousel *carousel = [[iCarousel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame), tableView.y, DLScreenWidth - CGRectGetWidth(tableView.frame), tableView.height)];
    carousel.backgroundColor = GrayBackgroundColor;
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.vertical = YES;
    carousel.type = iCarouselTypeRotary;
    carousel.clipsToBounds = YES;
    
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
    self.bottomShowView = bottomShowView;
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
    return self.items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RankItemView" owner:self options:nil];
        view = [nibs objectAtIndex:0];
        RankItemView *itemView = (RankItemView *)view;
        if (index % 2 == 0) {
            [itemView.avatar setImage:[UIImage imageNamed:@"120"]];
        }else{
            [itemView.avatar  setImage:[UIImage imageNamed:@"200*200_testImage"]];
        }
        
        [itemView.nameLabel setText:[NSString stringWithFormat:@"杨彤%zd",index]];
        
        
    }
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
//    RankBottomShowView *bottomView = (RankBottomShowView *)self.bottomShowView;
   
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionFadeMax:
        {
            return value;
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI;
        }
        case iCarouselOptionRadius:
        {
//            return 250;
            return DLScreenHeight * 0.3;
        }
        case iCarouselOptionSpacing:
        {
            return 0.462524;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39;
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
    cell.itemLabel.textColor = [UIColor redColor];
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
            break;
        case RankListTypeWomenGod:
            title = @"女神榜";
            break;
        case RankListTypePopularity:
            title = @"人气榜";
            break;
        default:
            break;
    }
    self.title = title;
}


@end
