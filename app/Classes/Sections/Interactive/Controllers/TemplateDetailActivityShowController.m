//
//  TemplateDetailActivityShowController.m
//  app
//
//  Created by tom on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TemplateDetailActivityShowController.h"
#import "TemplateDetailActivityShowView.h"
@implementation TemplateDetailActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.view setBackgroundColor:RGB(235.0, 234.0, 236.0)];
    
    UIBarButtonItem *rightShareButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                         target:self
                                         action:@selector(myAction)];
    self.navigationItem.rightBarButtonItem = rightShareButton;
    [self.navigationController.navigationBar setTintColor:RGB(0x9b, 0x9b, 0x9b)];
    TemplateDetailActivityShowView *detailView = [[TemplateDetailActivityShowView alloc]initWithModel:self.model];
    [self.view addSubview:detailView];
}

- (void)myAction
{
    NSLog(@"clicked !");
}

@end
