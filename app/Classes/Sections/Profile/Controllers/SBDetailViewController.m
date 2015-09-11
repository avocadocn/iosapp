//
//  SBDetailViewController.m
//  app
//
//  Created by burring on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "SBDetailViewController.h"
#import "SBDetailActivityView.h"
#import "Interaction.h"
@interface SBDetailViewController ()

@end

@implementation SBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.view setBackgroundColor:RGB(235.0, 234.0, 236.0)];
    SBDetailActivityView *detailView = [[SBDetailActivityView alloc]initWithModel:self.model];
    [self.view addSubview:detailView];

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
