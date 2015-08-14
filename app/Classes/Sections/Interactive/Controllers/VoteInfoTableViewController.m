//
//  VoteInfoTableViewController.m
//  app
//
//  Created by 张加胜 on 15/8/13.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteInfoTableViewController.h"
#import <ReactiveCocoa.h>

#define kIconMargin 12
#define kIconCountPerLine 7

@interface VoteInfoTableViewController ()
{
    CGFloat _itemWidthHeight;
}

@end

@implementation VoteInfoTableViewController
static NSString * const ID = @"VoteInfoTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票";
    self.view.backgroundColor = GrayBackgroundColor;
    
    _itemWidthHeight = ( DLScreenWidth - (kIconCountPerLine + 1) * kIconMargin ) / kIconCountPerLine;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // 硬编码 假设第一组 2 个数据，第2组 20 个数据
   indexPath.section == 0 ? [self addSubImageViewWithCell:cell itemCount:2] : [self addSubImageViewWithCell:cell itemCount:10];
    
    return cell;
}

-(void)addSubImageViewWithCell:(UITableViewCell *)cell itemCount:(NSUInteger)count{
    
    NSUInteger itemCount = count;
    CGFloat itemWidthHeight = _itemWidthHeight;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        
        
        // 此处为了简单演示，使用的是imageView，可根据实际项目需要改成自定义的button
        UIImageView *itemView = [[UIImageView alloc]init];
        
        [itemView setImage:[UIImage imageNamed:@"1"]];
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
    return section == 0 ? @"好帅(2)" : @"一点也不帅(20)";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 硬编码 假设第一组 2 个数据，第2组 20 个数据
    NSUInteger lineCount = (indexPath.section == 0 ? 2 / kIconCountPerLine : 10 / kIconCountPerLine) + 1;
    return lineCount * (_itemWidthHeight + kIconMargin) +  kIconMargin;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

@end
