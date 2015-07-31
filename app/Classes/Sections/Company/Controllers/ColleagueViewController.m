//
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ColleagueViewController.h"
#import "ColleagueViewCell.h"
#import "ConditionController.h"

#import <Masonry.h>
@interface ColleagueViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    [self makeFalse];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(stateAction)];
    
    self.ColleagueCollection = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.ColleagueCollection.delegate = self;
    self.ColleagueCollection.dataSource = self;
    [self.ColleagueCollection setBackgroundColor:[UIColor colorWithWhite:.93 alpha:1]];
    self.title = @"同事圈";
    [self.ColleagueCollection registerClass:[ColleagueViewCell class] forCellReuseIdentifier:@"tableCell"];
    self.ColleagueCollection.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:self.ColleagueCollection];
    
}
- (void)stateAction
{
    // 及时状态 页面
    ConditionController *state = [[ConditionController alloc]init];
    [self.navigationController pushViewController:state animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColleagueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    NSString *str = [NSString stringWithFormat:@"%ld",cell.num];
    [self.modelArray insertObject:str atIndex:indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.modelArray objectAtIndex:indexPath.row];
    NSInteger num = [str integerValue];
    NSInteger a = (num +2 )/ 3;
//    NSLog(@"%ld     %ld", num, a);
    return 120 + a * (DLScreenWidth / 5 + 10);  // 根据图片的高度返回行数
}
- (void)makeFalse
{
    self.modelArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {  //制造假数据
        @autoreleasepool {
        int d = arc4random() % 10;
        
        NSString *str = [NSString stringWithFormat:@"%d", d];
        [self.modelArray addObject:str];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
