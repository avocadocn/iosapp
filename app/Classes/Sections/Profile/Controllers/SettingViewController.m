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
#import "Account.h"
#import "AccountTool.h"
#import "ChangePassWordViewController.h"
#import "AddressBookModel.h"
#import "RestfulAPIRequestTool.h"
#import "LoginViewController.h"
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
        self.alert = [[UIAlertView alloc] initWithTitle:@"密码验证" message:@"为了您的账号安全修改密码前 请输入原密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[self.alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [self.alert textFieldAtIndex:0].secureTextEntry = YES;
        [self.alert textFieldAtIndex:0].clearButtonMode = YES;
        [self.alert show];
    } else if (indexPath.section == 0 && indexPath.row == 1) { // 关于我们
        
    } else {// 退出登录
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }
}
#pragma AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ChangePassWordViewController *changeVC = [[ChangePassWordViewController alloc] init];
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"输入有误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"嗯，知道了", nil];
     Account *account = [AccountTool account];
    switch (buttonIndex) {
        case 0: // 取消修改密码
            break;
          case 1: // 确定修改过密码
            if ([[self.alert textFieldAtIndex:0].text isEqualToString:account.password]) {
                [self.navigationController pushViewController:changeVC animated:YES];
            } else {
                [alertV show];
            }
            break;
        default:
            break;
    }
}
#pragma ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    Account *accout = [AccountTool account];
    AddressBookModel *model = [[AddressBookModel alloc] init];
    [model setUserId:accout.ID];
    if (buttonIndex == 0) { // 退出登录
    [RestfulAPIRequestTool routeName:@"userLogOut" requestModel:model useKeys:@[@"msg"] success:^(id json) {
        [self presentViewController:loginVC animated:YES completion:nil];
        NSLog(@"退出成功");
    } failure:^(id errorJson) {
        NSLog(@"退出失败原因 %@",errorJson);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你都没有登录你瞎退出啥呢？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"嗯嗯，知道了", nil];
        [alertView show];
    }];
    } else { // 取消
        
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
