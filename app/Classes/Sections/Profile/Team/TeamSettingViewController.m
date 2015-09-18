//
//  TeamSettingViewController.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupCoverSetting.h"
#import "AmendGroupName.h"
#import "RestfulAPIRequestTool.h"
#import "TeamSettingViewController.h"
#import "CustomSettingAvatarTableCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "GroupMemberSetting.h"
#import "GroupDetileModel.h"
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    /*
                    NSLog(@"群组名称设置");
                    AmendGroupName *amend = [[AmendGroupName alloc]initWithNibName:@"AmendGroupName" bundle:nil];
                    [self.navigationController pushViewController:amend animated:YES];
                    amend.name = [NSString stringWithFormat:@"%@", self.detileModel.name];
                    amend.detileModel = self.detileModel;
                    NSLog(@"群组封面设置");
                    */
                    GroupCoverSetting *set = [[GroupCoverSetting alloc]initWithNibName:@"GroupCoverSetting" bundle:nil];
                    set.detileModel = self.detileModel;
                    [self.navigationController pushViewController:set animated:YES];
                    
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"群组成员管理");
                    
                    GroupMemberSetting *setting = [[GroupMemberSetting alloc]init];
                    setting.detileModel = self.detileModel;
                    [self.navigationController pushViewController:setting animated:YES];
                }
                    break;
                default:
                    break;
            }
            

            
            
        }
            break;
            case 2:
        {
            NSLog(@"删除此群");
        }
        default:
            break;
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.identity == kTeamIdentityMaster ? 3 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.identity == kTeamIdentityMaster ? (section == 1 ? 2 : 1) : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CustomSettingAvatarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:avatarCellID forIndexPath:indexPath];
        
        [cell reloadCellWithModel:self.detileModel];
        
//        [cell.identity setText:self.identity == kTeamIdentityMaster ? @"群主" : @"成员"];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        [cell.textLabel setText:self.identity == kTeamIdentityMaster ? (indexPath.section == 1 ? (indexPath.row == 0 ? @"群组名称封面设置" : @"群组成员管理") : @"删除此群") : @"退出此群" ];
        return cell;
    }
}

/*
 (indexPath.row == 1 ? @"群组封面设置" : @"群组成员管理")
 */

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
