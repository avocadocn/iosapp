//
//  ChangePassWordViewController.m
//  app
//
//  Created by burring on 15/8/27.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "ChangePassWordTableViewCell.h"
#import "ExitTableViewCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "AddressBookModel.h"
#import "RestfulAPIRequestTool.h"
@interface ChangePassWordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ChangePassWordTableViewCell *cell;
@end
@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangePassWordTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChangePassWordTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ExitTableViewCell"];
    
}
#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ChangePassWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangePassWordTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.changePassWordLabel.text = @"确认密码：";
            cell.tag = 1002;
        }else {
            cell.tag = 1001;
        }
        cell.changePassWord.secureTextEntry = YES;
        cell.changePassWord.clearButtonMode = YES;
        return cell;
    } else {
        ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExitTableViewCell" forIndexPath:indexPath];
        cell.exitLabel.text = @"完成";
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangePassWordTableViewCell *cellNewPass = (ChangePassWordTableViewCell *)[self.view viewWithTag:1001];
    ChangePassWordTableViewCell *cellSurePass = (ChangePassWordTableViewCell *)[self.view viewWithTag:1002];
    Account *account = [AccountTool account];
    AddressBookModel *model = [[AddressBookModel alloc] init];
    [model setOriginPassword:account.password];// 原密码
    [model setUserId:account.ID];
    if (indexPath.section == 1) {
        if ([cellNewPass.changePassWord.text isEqualToString:cellSurePass.changePassWord.text] && cellSurePass.changePassWord.text.length >= 6) {
            [model setPassword:cellSurePass.changePassWord.text]; // 新密码
           [RestfulAPIRequestTool routeName:@"modifyUserInfo" requestModel:model useKeys:@[@"userId",@"password",@"originPassword"] success:^(id json) {
               account.password = cellSurePass.changePassWord.text;// 将修改成功的密码存入accout
               [AccountTool saveAccount:account]; // 保存密码到本地
               NSLog(@"%@",account.password);
           } failure:^(id errorJson) {
               NSLog(@"修改失败 %@",errorJson);
           }];
        } else {
            if (cellSurePass.changePassWord.text.length <= 6) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注意密码长度至少要6位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"嗯嗯 知道了", nil];
                [alertV show];
            } else {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码输入不一致 请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"嗯嗯 知道了", nil];
                [alertV show];
            }
        }
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
