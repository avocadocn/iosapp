//
//  TeamInfomationViewController.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupViewController.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "AddressBookModel.h"
#import "TeamInfomationViewController.h"
#import "CustomMarginSettingTableViewCell.h"
#import "CustomMemberTableViewCell.h"
#import "TeamSettingViewController.h"
#import "GroupDetileModel.h"
#import "ColleaguesInformationController.h"
#import "FMDBSQLiteManager.h"
#import "Group.h"
#import "ChatListViewController.h"
typedef NS_ENUM(NSInteger, GroupIdentity) {
    /**
     *是群主
     */
    GroupIdentityFlock,  //群主
    /**
     *是群众
     */
    GroupIdentityFigurant   //群众
};


// 每一行item的个数
#define ItemCountPerLine 8
// 每个item的间距
#define cellSpacing 4.0
// 行距
#define lineSpacing 4.0

@interface TeamInfomationViewController ()

/**
 *是否为群主
*/
@property (nonatomic, assign)GroupIdentity state;


@property (nonatomic, strong) CustomMemberTableViewCell *defaultMemberCell;

/**
 *  每个item的宽高，通过对当前屏幕的宽度计算得到
 */
@property (assign,nonatomic)CGFloat itemWH;

/**
 *  cell的高度
 */
@property (assign,nonatomic)CGFloat cellHeight;

/**
 *  collectionView的高度
 */
@property (assign,nonatomic)CGFloat collectionHeight;



@end

@implementation TeamInfomationViewController




static NSString * const settingCell = @"settingCell";
static NSString * const memberCell = @"memberCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:GrayBackgroundColor];
    
    self.title = @"群组信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomMemberTableViewCell" bundle:nil] forCellReuseIdentifier:memberCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:settingCell];
    Account *acc = [AccountTool account];
    if (![self.detilemodel.leader isEqualToString:acc.ID]) {  //非群主
        self.state = GroupIdentityFigurant;
    }
    
    CustomMemberTableViewCell *defaultMemberCell = [self.tableView dequeueReusableCellWithIdentifier:memberCell];
    self.defaultMemberCell = defaultMemberCell;
    
    [self setupCollectionViewUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpAction:) name:@"JumpToFolderController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableview:) name:@"ReloadMemberTableView" object:nil];
}

- (void)jumpAction:(NSNotification *)userInfo
{
    
    ColleaguesInformationController *folder= [[ColleaguesInformationController alloc]init];
    AddressBookModel *model =[[AddressBookModel alloc]init];
    [model setValuesForKeysWithDictionary:userInfo.userInfo];
    
    folder.model = model;
    
    [self.navigationController pushViewController:folder animated:YES];
    
}



-(void)setupCollectionViewUI{
    
    NSInteger lineCount = self.memberInfos.count / ItemCountPerLine + 1;
    UICollectionViewFlowLayout *layout =  (UICollectionViewFlowLayout *)self.defaultMemberCell.iconCollectionView.collectionViewLayout;
    
    // NSLog(@"%f",self.defaultMemberCell.iconCollectionView.width);
    self.itemWH = (self.defaultMemberCell.iconCollectionView.width - (ItemCountPerLine - 1) * cellSpacing) / 8.0;
    layout.itemSize = CGSizeMake(self.itemWH, self.itemWH);
    layout.minimumInteritemSpacing = cellSpacing;
    layout.minimumLineSpacing = lineSpacing;

    CGFloat collectionHeight = lineCount * self.itemWH + (lineCount - 1) * lineSpacing;
    self.collectionHeight = collectionHeight;
    self.defaultMemberCell.iconCollectionView.height = collectionHeight;
    self.cellHeight = CGRectGetMaxY(self.defaultMemberCell.iconCollectionView.frame) + 20;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (void)reloadTableview:(NSNotification *)userinfo
{
    NSDictionary *dic = userinfo.userInfo;
    
    NSString *ID = [dic objectForKey:@"userId"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSMutableDictionary *tempDic in self.memberInfos) {
        if ([[tempDic objectForKey:@"_id"] isEqualToString:ID]) { //存在
            
            [array addObject:tempDic];
        }
    }
    if (array.count) {
        [self.memberInfos removeObjectsInArray:array];
    } else
    {
        NSDictionary *aDic = [NSDictionary dictionaryWithObject:[dic objectForKey:@"userId"] forKey:@"_id"];
        
        [self.memberInfos addObject:aDic];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    switch (self.state) {
        case GroupIdentityFlock:
        {
            if (indexPath.section == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:settingCell];
//                if (!cell) {
                    cell =  [[CustomMarginSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingCell];
                    [cell.textLabel setText:@"设置"];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.detailTextLabel setText:@"群主"];
                    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                }
            } else if (indexPath.section == 1){
                cell = [tableView dequeueReusableCellWithIdentifier:memberCell forIndexPath:indexPath];
                [(CustomMemberTableViewCell *)cell setMemberInfos:self.memberInfos];
                ((CustomMemberTableViewCell *)cell).collectionHeight.constant = self.collectionHeight;
                
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) ((CustomMemberTableViewCell *)cell).iconCollectionView.collectionViewLayout;
                // NSLog(@"%f",self.defaultMemberCell.iconCollectionView.width);
                self.itemWH = (self.defaultMemberCell.iconCollectionView.width - (ItemCountPerLine - 1) * cellSpacing) / 8.0;
                layout.itemSize = CGSizeMake(self.itemWH, self.itemWH);
                layout.minimumInteritemSpacing = cellSpacing;
                layout.minimumLineSpacing = lineSpacing;
                
                // 第二行的选中状态消除
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
            break;
        case GroupIdentityFigurant:
        {
            if (indexPath.section == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:settingCell];
//                if (!cell) {
                
                    /*
                    cell =  [[CustomMarginSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingCell];
                    [cell.textLabel setText:@"退出此群"];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
//                    [cell.detailTextLabel setText:@"群主"];
//                    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
//                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                     */
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
                    [cell.textLabel setText:@"退出此群"];
                    
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    return cell;
//                }
            } else if (indexPath.section == 0){
                cell = [tableView dequeueReusableCellWithIdentifier:memberCell forIndexPath:indexPath];
                [(CustomMemberTableViewCell *)cell setMemberInfos:self.memberInfos];
                ((CustomMemberTableViewCell *)cell).collectionHeight.constant = self.collectionHeight;
                
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) ((CustomMemberTableViewCell *)cell).iconCollectionView.collectionViewLayout;
                // NSLog(@"%f",self.defaultMemberCell.iconCollectionView.width);
                self.itemWH = (self.defaultMemberCell.iconCollectionView.width - (ItemCountPerLine - 1) * cellSpacing) / 8.0;
                layout.itemSize = CGSizeMake(self.itemWH, self.itemWH);
                layout.minimumInteritemSpacing = cellSpacing;
                layout.minimumLineSpacing = lineSpacing;
                
                // 第二行的选中状态消除
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }

        }
        default:
            break;
    }
    

    [cell setHighlighted:NO];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.state) {
        case GroupIdentityFlock:{
            if (indexPath.section == 0) {
                return 64;
            }else if (indexPath.section == 1){
                return self.cellHeight;
            }
        }
            break;
         case GroupIdentityFigurant:
        {
            if (indexPath.section == 1) {
                return 50;
            }else if (indexPath.section == 0){
                return self.cellHeight;
            }
        }
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (self.state) {
        case GroupIdentityFlock:
        {
            if (indexPath.section == 0) {
                TeamSettingViewController *settingController = [[TeamSettingViewController alloc]initWithIdentity:kTeamIdentityMaster];
                // 信息 --> 设置
                settingController.detileModel = [[GroupDetileModel alloc]init];
                settingController.detileModel = self.detilemodel;
                [self.navigationController pushViewController:settingController animated:YES];
            }
        }
            break;
        case GroupIdentityFigurant:
        {
            if (indexPath.section == 1) {
                
                NSDictionary *Dic = [NSDictionary dictionaryWithObject:self.detilemodel.ID forKey:@"groupId"];

                GroupViewController *group = [[GroupViewController alloc]init];
                [self.navigationController pushViewController:group animated:YES];
//                NSArray *array = self.navigationController.viewControllers;
//                [self.navigationController popToViewController:group animated:NO];
                
//                NSLog(@"子视图都有   %@", array);
                [RestfulAPIRequestTool routeName:@"exitGroups" requestModel:Dic useKeys:@[@"groupId"] success:^(id json) {
                    
                    NSLog(@"退群成功  %@", json);
                    //主动推出群
                    FMDBSQLiteManager* fmdb=[FMDBSQLiteManager shareSQLiteManager];
                    Group* g = [fmdb selectGroupWithGroupId:self.detilemodel.ID];
                    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:g.easemobID];
                    //去掉聊天会话中得会话
                    ChatListViewController *chat = [ChatListViewController shareInstan];
                    [chat removeConversion:g.easemobID];
                    //清空本地消息
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:g.easemobID
                                                                         deleteMessages:YES
                                                                            append2Chat:YES];
                } failure:^(id errorJson) {
                    
                    NSLog(@"退群失败   %@", errorJson);
                }];
                
            }
            break;
        }
        default:
            break;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - setter方法
-(void)setMemberInfos:(NSArray *)memberInfos{
    _memberInfos = memberInfos;
 
}

@end
