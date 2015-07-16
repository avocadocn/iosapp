//
//  InteractiveViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "InteractiveViewController.h"
#import "AcitvitysShowView.h"
@interface InteractiveViewController ()

@property (nonatomic ,strong) UICollectionView *avatarCV;
@end

@implementation InteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AcitvitysShowView *asv = [[AcitvitysShowView alloc]init];
    asv.y += 64;
    [self.view addSubview:asv];
    
    UITableView *tableView = [[UITableView alloc]init];
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
