//
//  Test1ViewController.m
//  app
//
//  Created by 张加胜 on 15/7/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Test1ViewController.h"
#import "RestfulAPIRequestTool.h"
#import "CompanyModel.h"
#import "TeamHomePageController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    TeamHomePageController *teamHomePage = [[TeamHomePageController alloc]init];
    [self.navigationController pushViewController:teamHomePage animated:YES];
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
