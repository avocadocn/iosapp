//
//  AboutAsViewController.m
//  app
//
//  Created by burring on 15/11/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AboutAsViewController.h"

@interface AboutAsViewController ()<UIWebViewDelegate>

@end

@implementation AboutAsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(251, 233, 109, 1);
    // Do any additional setup after loading the view from its nib.
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
