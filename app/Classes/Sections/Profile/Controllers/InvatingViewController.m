//
//  InvatingViewController.m
//  app
//
//  Created by burring on 15/8/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InvatingViewController.h"
#import <AddressBookUI/AddressBookUI.h>
@interface InvatingViewController ()

@end

@implementation InvatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请";
    self.view.backgroundColor = [UIColor whiteColor];
}
//-(void)ReadAllPeoples {
//    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
//    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
//    
//    for(id tmpPerson in tmpPeoples)
//        
//}
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
