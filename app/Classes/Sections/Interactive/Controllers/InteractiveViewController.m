//
//  InteractiveViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "InteractiveViewController.h"
#import "ActivitysShowView.h"
#import "ActivitysTableController.h"
#import "OtherViewController.h"
@interface InteractiveViewController ()<ActivitysShowViewDelegate>

@property (nonatomic ,strong) UICollectionView *avatarCV;
@end

@implementation InteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ActivitysShowView *asv = [[ActivitysShowView alloc]init];
    asv.y += 64;
    
    // 设置代理
    [asv setDelegate:self];
    [self.view addSubview:asv];
    
    ActivitysTableController *atc = [[ActivitysTableController alloc]init];
    atc.view.y = CGRectGetMaxY(asv.frame);
    
    
    [self.view addSubview:atc.view];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)activitysShowView:(ActivitysShowView *)activitysShowView btnClickedByIndex:(NSInteger)index{
    switch (index) {
        case 0: // 男神
            break;
        case 1: // 女神
           
            break;
        case 2: // 人气
            
            break;
        case 3: // 什么活动
        {
            OtherViewController *controller = [[OtherViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }

           
            break;
            
        
        default:
            break;
    }
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
