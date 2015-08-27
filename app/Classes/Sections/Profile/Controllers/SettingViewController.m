//
//  SettingViewController.m
//  app
//
//  Created by burring on 15/8/26.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "ExitTableViewCell.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor]; //创建设置选项的tableView
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ExitTableViewCell"];
}
#pragma tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.contactLabel.text = @"关于我们";
        }
        return cell;
    } else {
        ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExitTableViewCell" forIndexPath:indexPath];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) { // 修改密码
        self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"为了您的账号安全请输入原密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[self.alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [self.alert show];
    } else if (indexPath.section == 0 && indexPath.row == 1) { // 关于我们
        
    } else {// 退出登录
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }
}
#pragma AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
          case 1:
            NSLog(@"确定");
            NSLog(@"%@",[self.alert textFieldAtIndex:0].text);
            break;
        default:
            break;
    }
}
#pragma ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"退出登录");
            break;
         case 1:
            NSLog(@"取消");
            break;
        default:
            break;
    }
    
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
