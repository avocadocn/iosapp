//
//  TeamSettingViewController.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TeamSettingViewController.h"
#import "CustomSettingAvatarTableCell.h"

@interface TeamSettingViewController ()

@property (assign, nonatomic) kTeamIdentity identity;

@end

@implementation TeamSettingViewController


static NSString * const avatarCellID = @"avatarCellID";
static NSString * const defaultCellID = @"defaultCellID";

-(instancetype)initWithIdentity:(kTeamIdentity)identity{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _identity = identity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群组设置";
    self.view.backgroundColor = GrayBackgroundColor;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomSettingAvatarTableCell" bundle:nil] forCellReuseIdentifier:avatarCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.identity == kTeamIdentityMaster ? 3 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.identity == kTeamIdentityMaster ? (section == 1 ? 3 : 1) : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CustomSettingAvatarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:avatarCellID forIndexPath:indexPath];
        
        [cell.identity setText:self.identity == kTeamIdentityMaster ? @"群主" : @"成员"];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setText:self.identity == kTeamIdentityMaster ? (indexPath.section == 1 ? (indexPath.row == 0 ? @"群组名称设置" : (indexPath.row == 1 ? @"群组封面设置" : @"群组成员管理")) : @"删除此群") : @"退出此群" ];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 64.0f : 50.f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 17;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.identity == kTeamIdentityMaster ? (section == 1 ? @"群组信息管理" : (section == 2? @"删除" : @"")) : (section == 1 ? @"退出" : @"");
}

@end
