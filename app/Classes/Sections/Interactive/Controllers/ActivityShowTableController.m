//
//  ActivityShowTableController.m
//  app
//
//  Created by 张加胜 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ActivityShowTableController.h"
#import "OtherActivityShowCell.h"
#import "OtherSegmentButton.h"
#import "DetailActivityShowController.h"

@interface ActivityShowTableController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation ActivityShowTableController


static NSString * const ID = @"OtherActivityShowCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addActivitysShowTable];
    }
    return self;
}

/**
 *  添加活动展示table
 */
-(void)addActivitysShowTable{
    
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[OtherActivityShowCell class] forCellReuseIdentifier:ID];
    // 设置分割线样式
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView setFrame:self.view.frame];
//    [tableView setContentInset:UIEdgeInsetsMake(-64, 0, 20, 0)];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    OtherSegmentButton *btn = [OtherSegmentButton buttonWithType:UIButtonTypeCustom];
    // NSLog(@"%f--%f",btn.centerY,view.centerY);
    btn.y += (view.height - btn.height) / 2.0;
    btn.x += 8.0f;
    [btn setName:@"热门活动"];
    
    // NSLog(@"%@",NSStringFromCGRect(btn.frame));
    [view addSubview:btn];
    //    [self.view addSubview:view];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    //    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
    //        NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    //        make.right.equalTo(self.tableView.mas_right);
    //    }];
    // NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
    // Configure the cell...
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DetailActivityShowController *controller = [[DetailActivityShowController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}




@end
