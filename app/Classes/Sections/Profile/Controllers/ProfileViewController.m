//
//  ProfileViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "ProfileViewController.h"
#import "Test1ViewController.h"
#import "MenuCollectionController.h"
#import "ProfileTableViewCell.h"
#import "FolderViewController.h"
#import "ActivityShowTableController.h"
#import "VoteTableController.h"
#import "HelpTableViewController.h"
#import "TeamHomePageController.h"
#import "UserMessageTableViewController.h"


@interface ProfileViewController () <UITableViewDataSource,UITableViewDelegate,MenuCollectionControllerDelegate>


@property (nonatomic, strong) MenuCollectionController *menuController;

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation ProfileViewController

static NSString * const ID = @"ProfileTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view.
    
    // 初始化顶部的CollectionView
    [self setupMenuCollectionController];
    
    // 初始化菜单选项
    [self setupMenuTableView];
}

-(void)viewWillAppear:(BOOL)animated{
     [self.view setBackgroundColor:GrayBackgroundColor];
}



-(void)setupMenuCollectionController{
    MenuCollectionController *menuController = [[MenuCollectionController alloc]init];
    menuController.view.y += 64;
    [menuController setDelegate:self];
    [self.view addSubview:menuController.view];
    self.menuController = menuController;
}

-(void)setupMenuTableView{
    UITableView *tableView = [[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.menuController.view.frame) + 25, DLScreenWidth, 4 * 50 + 15)];
    [tableView setBackgroundColor:GrayBackgroundColor];
    [tableView setBounces:NO];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [tableView setScrollEnabled:NO];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.menuCellIconWidth.constant = 0;
        cell.menuCellName.text = @"喜欢的话就给我们评价吧";
    }else if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.menuCellName.text = @"邀请";
                [cell.menuCellIcon setImage:[UIImage imageNamed:@"profile_menu_invite"]];
                break;
            case 1:
                cell.menuCellName.text = @"二维码";
                 [cell.menuCellIcon setImage:[UIImage imageNamed:@"profile_menu_qrcode"]];
                break;
            case 2:
                cell.menuCellName.text = @"设置";
                 [cell.menuCellIcon setImage:[UIImage imageNamed:@"profile_menu_setting"]];
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 15;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString * URLString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/dong-li/id916162839?mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

#pragma mark - MenuCollectionController代理方法
-(void)collectionController:(MenuCollectionController *)collectionController didSelectedItemAtIndex:(NSInteger)index{
    UIViewController *controller;
    switch (index) {
        case 0: // 我的信息
            controller = [[FolderViewController alloc]init];
            break;
        case 1: // 群组
             controller = [[TeamHomePageController alloc]init];
            break;
        case 2: // 礼物
            //controller = [[FolderViewController alloc]init];
            controller = [[UserMessageTableViewController alloc]init];
            break;
        case 3: // 活动
            controller = [[ActivityShowTableController alloc]init];
            break;
        case 4: // 投票
            controller = [[VoteTableController alloc]init];
            break;
        case 5: // 求助
            controller = [[HelpTableViewController alloc]init];
            break;
        default:
            break;
    }
    
    if (controller) {
         [self.navigationController pushViewController:controller animated:YES];
    }
    
}


@end
