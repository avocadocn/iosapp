//
//  AttentionViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionViewCell.h"


@interface AttentionViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFalseValue];
    [self builtInterface];
    
}
- (void)makeFalseValue
{
    self.modelArray = [NSMutableArray array];
    
    for (int i = 0; i < 18; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[UIImage imageNamed:@"1"] forKey:@"image"];
        [dic setObject:@"杨彤彤" forKey:@"name"];
        [dic setObject:@"专注 滑板鞋" forKey:@"work"];
        [self.modelArray addObject:dic];
    }

}

- (void)builtInterface{
    
    self.attentionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    self.attentionTableView.delegate = self;
    self.attentionTableView.dataSource = self;
    
//    [self.attentionTableView registerClass:[AttentionViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.attentionTableView registerNib:[UINib nibWithNibName:@"AttentionViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    
    [self.view addSubview:self.attentionTableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell cellBuiltWithModel:dic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.modelArray count];
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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

@end
