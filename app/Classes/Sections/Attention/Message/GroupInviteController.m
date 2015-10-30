//
//  GroupInviteController.m
//  app
//
//  Created by 申家 on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//
#import "UIImageView+DLGetWebImage.h"
#import "GroupInviteController.h"
#import "InformationModel.h"
#import "Person.h"
#import "Group.h"
#import "FMDBSQLiteManager.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"

@interface GroupInviteController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *PersonPhoto;
@property (weak, nonatomic) IBOutlet UILabel *PersonName;
@property (weak, nonatomic) IBOutlet UIImageView *GroupLogo;
@property (weak, nonatomic) IBOutlet UILabel *GroupName;
@property (weak, nonatomic) IBOutlet UILabel *AgreeLabel;



@end

@implementation GroupInviteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.PersonPhoto.layer.masksToBounds = YES;
    self.PersonPhoto.layer.cornerRadius = 25;
    self.GroupLogo.clipsToBounds = YES;
    self.GroupLogo.contentMode = UIViewContentModeScaleAspectFill;
    
    Person *per = [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:self.model.sender];
    self.PersonName.text = per.nickName;
    [self.PersonPhoto dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:CGSizeMake(50, 50)];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.model.team forKey:@"groupId"];
    [RestfulAPIRequestTool routeName:@"getGroupInfor" requestModel:dic useKeys:@[@"groupId"] success:^(id json) {
        
        NSDictionary *group = [json objectForKey:@"group"];
            self.GroupName.text = group[@"name"];
            [self.GroupLogo dlGetRouteThumbnallWebImageWithString:group[@"logo"] placeholderImage:nil withSize:CGSizeMake(109, 157)];
        Account *acc = [AccountTool account];
        
        for (NSDictionary *mem in group[@"member"]) {
            NSString *ID = mem[@"_id"];
            if ([ID isEqualToString:acc.ID]) {
                self.AgreeLabel.text = [NSString stringWithFormat:@"已加入%@", group[@"name"]];
                self.AgreeLabel.userInteractionEnabled = NO;
                self.AgreeLabel.backgroundColor = RGBACOLOR(213, 213, 213, 1);
            }
        }
        
    } failure:^(id errorJson) {
        
    }];
    self.AgreeLabel.userInteractionEnabled = YES;
    [self.AgreeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinAction:)]];
    
}
- (void)joinAction:(UITapGestureRecognizer *)tap
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.model.team forKey:@"groupId"];
    [dic setObject:@1 forKey:@"accept"];
    
    [RestfulAPIRequestTool routeName:@"detailInvitationInfos" requestModel:dic useKeys:@[@"groupId", @"accept"] success:^(id json) {
        
        UIAlertView *alet =[[UIAlertView alloc] initWithTitle:@"成功" message:json[@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alet.delegate = self;
        [alet show];
        self.AgreeLabel.text = [NSString stringWithFormat:@"已加入%@", self.GroupName.text];
        self.AgreeLabel.userInteractionEnabled = NO;
        self.AgreeLabel.backgroundColor = RGBACOLOR(213, 213, 213, 1);
        
    } failure:^(id errorJson) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(InformationModel *)model
{
    _model = model;
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
