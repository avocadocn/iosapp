//
//  ProfileViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "ProfileViewController.h"
#import "Test1ViewController.h"
#import "ProfileButton.h"

@interface ProfileViewController ()


/**
 *  顶部按钮容器
 */
@property (nonatomic, strong) UIView *container;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupProfileButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(btnClicked:) name:kProfileButtonClicked object:nil];
}

-(void)btnClicked:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
}

-(void)setupProfileButton{
    NSArray *btnsName = @[@"我的信息",@"群组",@"礼物",@"互动",@"投票",@"求助"];
    
    UIView *container = [[UIView alloc]init];
    [container setFrame:CGRectMake(0, 64, DLScreenWidth, 180 / 375 * DLScreenWidth)];
    
    for (NSInteger i = 0; i<btnsName.count; i++) {
        
        ProfileButton *btn = [[ProfileButton alloc]init];
        [container addSubview:btn];
        [btn.descriptionLabel setText:btnsName[i]];
        
    }
    
    
    [self.view addSubview:container];
    
    self.container = container;

}

-(void)viewWillLayoutSubviews{
    NSArray *subViews = self.container.subviews;
    NSInteger itemCountPerLine = 3;
    CGFloat itemWidth = DLScreenWidth / 3;
    CGFloat itemHeight = 90.0 / 125.0 * itemWidth ;
    
    for (NSInteger i = 0; i < subViews.count; i++) {
        UIButton *btn = subViews[i];
        btn.x = i % itemCountPerLine * itemWidth;
        btn.y = i / itemCountPerLine * itemHeight;
        btn.width = itemWidth;
        btn.height = itemHeight;
    }
}


@end
