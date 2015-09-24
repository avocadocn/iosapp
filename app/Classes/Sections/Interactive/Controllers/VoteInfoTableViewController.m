//
//  VoteInfoTableViewController.m
//  app
//
//  Created by 张加胜 on 15/8/13.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteInfoTableViewController.h"
#import <ReactiveCocoa.h>
#import "PollModel.h"
#import "VoteInfoTableViewModel.h"
#define kIconMargin 12
#define kIconCountPerLine 7
#import "UIImageView+DLGetWebImage.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"

@interface VoteInfoTableViewController ()
{
    CGFloat _itemWidthHeight;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) VoteInfoTableViewModel *infoModel;
@end

@implementation VoteInfoTableViewController
static NSString * const ID = @"VoteInfoTableViewCell";

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [@[]mutableCopy];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票";
    self.view.backgroundColor = GrayBackgroundColor;
    
    _itemWidthHeight = ( DLScreenWidth - (kIconCountPerLine + 1) * kIconMargin ) / kIconCountPerLine;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    for (NSDictionary *dic in self.model.option) {
        VoteInfoTableViewModel *model = [[VoteInfoTableViewModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    VoteInfoTableViewModel *model = self.dataArray[section];
    
    
//    return model.voters.count;
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    VoteInfoTableViewModel *model = self.dataArray[indexPath.section];
    self.infoModel = model;
    // 硬编码 假设第一组 2 个数据，第2组 20 个数据
   [self addSubImageViewWithCell:cell itemCount:model.voters.count];
    
    return cell;
}

-(void)addSubImageViewWithCell:(UITableViewCell *)cell itemCount:(NSUInteger)count{
    NSUInteger itemCount = count;
    CGFloat itemWidthHeight = _itemWidthHeight;
    
    for (NSInteger i = 0; i < itemCount; i++) {
     NSDictionary *dic = [self.infoModel.voters objectAtIndex:i];
        Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:[dic objectForKey:@"_id"]];
        // 此处为了简单演示，使用的是imageView，可根据实际项目需要改成自定义的button
        UIImageView *itemView = [[UIImageView alloc]init];
        
        [itemView dlGetRouteWebImageWithString:p.imageURL placeholderImage:[UIImage imageNamed:@"boy"]];
        itemView.x = i % kIconCountPerLine * (itemWidthHeight + kIconMargin) + kIconMargin;
        itemView.y = i / kIconCountPerLine * (itemWidthHeight + kIconMargin) + kIconMargin;
        itemView.width = itemWidthHeight;
        itemView.height = itemWidthHeight;
        itemView.userInteractionEnabled = YES;
        
        // 设置圆形头像
        [itemView.layer setCornerRadius:itemWidthHeight / 2];
        [itemView.layer setMasksToBounds:YES];
        
        [cell addSubview:itemView];
    }

    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    VoteInfoTableViewModel *model = self.dataArray[section];
    
    return [NSString stringWithFormat:@"%@",model.value];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     VoteInfoTableViewModel *model = self.dataArray[indexPath.section];
   
    
    // 硬编码 假设第一组 2 个数据，第2组 20 个数据
    NSUInteger lineCount = (indexPath.section == 0 ? model.voters.count / kIconCountPerLine : model.voters.count / kIconCountPerLine) + 1;
    return lineCount * (_itemWidthHeight + kIconMargin) +  kIconMargin;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

@end
