//
//  CompanyEmailComplete.m
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyEmailComplete.h"
#import "RegisterViewController.h"


@interface CompanyEmailComplete ()

@end

@implementation CompanyEmailComplete

//- (instancetype)initWithString:(NSString *)str
//{
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)completeButtonAction:(id)sender {
    RegisterViewController *regi = [[RegisterViewController alloc]init];
    
    regi.comMail = self.comEmail;
    regi.invite = self.inviteKey;
    
    [self.navigationController pushViewController:regi animated:YES];
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
