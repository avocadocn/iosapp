//
//  ProfileViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//
#import "GroupViewController.h"
#import "TeamInteractionViewController.h"
#import "ProfileViewController.h"
#import "Test1ViewController.h"
#import "MenuCollectionController.h"
#import "ProfileTableViewCell.h"
#import "FolderViewController.h"
#import "VoteTableController.h"
#import "HelpTableViewController.h"
#import "TeamHomePageController.h"
#import "UserMessageTableViewController.h"
#import "TwoDimensionCodeViewController.h"
#import "SettingViewController.h"
#import "InvatingViewController.h"
#import "MessageViewController.h"
#import "AccountTool.h"
#import "Account.h"
#import "FMDBSQLiteManager.h"
@interface ProfileViewController () <UITableViewDataSource,UITableViewDelegate,MenuCollectionControllerDelegate>


@property (nonatomic, strong) MenuCollectionController *menuController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;



@end

@implementation ProfileViewController

static NSString * const ID = @"ProfileTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildlowView];
//    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    
    // 初始化顶部的CollectionView
    [self setupMenuCollectionController];
    
    // 初始化菜单选项
    [self setupMenuTableView];
}
- (void) buildlowView {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, DLScreenWidth, DLScreenHeight + 64)];
    self.scrollView.contentSize = CGSizeMake(DLScreenWidth, DLScreenHeight);
    self.scrollView.backgroundColor = RGBACOLOR(238, 239, 240, 1);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:self.scrollView atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.view setBackgroundColor:GrayBackgroundColor];
}

-(void)setupMenuCollectionController{
    MenuCollectionController *menuController = [[MenuCollectionController alloc]init];
    menuController.view.y += 64;
    [menuController setDelegate:self];
    
    [self.scrollView addSubview:menuController.view];
    self.menuController = menuController;
}

-(void)setupMenuTableView{
    UITableView *tableView = [[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.menuController.view.frame) - 3, DLScreenWidth, 4 * 50 + 15)];
    [tableView setBackgroundColor:RGBACOLOR(238, 239, 240, 1)];
    [tableView setBounces:NO];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [tableView setScrollEnabled:NO];
    
    [self.scrollView addSubview:tableView];
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
//        cell.menuCellIconWidth.constant = 0;
        [cell.menuCellIcon setImage:[UIImage imageNamed:@"表情icon copy"]];
        cell.menuCellName.text = @"喜欢的话就给我们评价吧";
    }else if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.menuCellName.text = @"邀请";
                [cell.menuCellIcon setImage:[UIImage imageNamed:@"Shape Copy 2 + Line + Line Copy 6"]];
                break;
            case 1:
                cell.menuCellName.text = @"二维码";
                 [cell.menuCellIcon setImage:[UIImage imageNamed:@"Group"]];
                break;
            case 2:
                cell.menuCellName.text = @"设置";
                 [cell.menuCellIcon setImage:[UIImage imageNamed:@"gear"]];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {// 邀请
        InvatingViewController *invatingVC = [[InvatingViewController alloc] init];
        [self.navigationController pushViewController:invatingVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1) {// 二维码
        TwoDimensionCodeViewController *twoDCViewController = [[TwoDimensionCodeViewController alloc] init];
        [self.navigationController pushViewController:twoDCViewController animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 2) {// 设置
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    } else {// 评价
        NSString * URLString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/dong-li/id916162839?mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

#pragma mark - MenuCollectionController代理方法
-(void)collectionController:(MenuCollectionController *)collectionController didSelectedItemAtIndex:(NSInteger)index{
    UIViewController *controller;
    switch (index) {
        case 0: // 我的信息
            controller = [[FolderViewController alloc] init];
            [(FolderViewController *)controller setJudgeEditState:YES];
            break;
        case 1: // 群组
        {
            GroupViewController *group = [[GroupViewController alloc]init];
            [group setGroupType:GroupTypeSingle];
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
        case 2: // 消息
            controller = [[MessageViewController alloc] init];
            break;
        case 3: // 活动
        {
            //使用指定的frame大小初始化viewcontroller,高度增加64是因为后续会减掉64
            TeamInteractionViewController * team = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)team setType:TeamInteractionActivity];
            
            team.interactionType = [NSNumber numberWithInteger:1];
            team.team = [NSString stringWithFormat:@"0"];
            team.requestType = [NSNumber numberWithInteger:0];
            [self.navigationController pushViewController:team animated:YES];
        }
            break;
        case 4: // 投票
        {
            TeamInteractionViewController * team = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)team setType:TeamInteractionVote];
                        team.interactionType = [NSNumber numberWithInteger:2];
            team.team = [NSString stringWithFormat:@"0"];
            team.requestType = [NSNumber numberWithInteger:0];
            [self.navigationController pushViewController:team animated:YES];
    }
            break;
        case 5: // 求助
        {
            TeamInteractionViewController * team = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)team setType:TeamInteractionHelp];

            team.interactionType = [NSNumber numberWithInteger:3];
            team.team = [NSString stringWithFormat:@"0"];
            team.requestType = [NSNumber numberWithInteger:0];
            [self.navigationController pushViewController:team animated:YES];
        }
            break;
        default:
            break;
    }
    
    if (controller) {
         [self.navigationController pushViewController:controller animated:YES];
    }
}



@end
