//
//  TeamHomePageController.m
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "GroupMemberController.h"
#import "Group.h"
#import "FMDBSQLiteManager.h"
#import "GuidePageViewController.h"
#import "ChatViewController.h"
#import "TeamInfomationViewController.h"
#import "InviteGroupMember.h"
#import "MenuCollectionViewCell.h"
#import <Masonry.h>
#import "FolderViewController.h"
#import "MessageViewController.h"
#import "VoteTableController.h"
#import "MenuCollectionController.h"
#import "GroupCardModel.h"
#import <Masonry.h>
#import "HelpTableViewController.h"
#import "DetailActivityShowController.h"
#import "Account.h"
#import "AccountTool.h"
#import "PollModel.h"
#import "UIImageView+DLGetWebImage.h"
#import "TeamHomePageController.h"
#import "TeamInfomationViewController.h"
#import "GroupDetileModel.h"
#import <UIImageView+WebCache.h>
#import "CurrentActivitysShowCell.h"
#import "OtherActivityShowCell.h"
#import "VoteTableViewCell.h"
#import "HelpTableViewCell.h"
#import "RestfulAPIRequestTool.h"
#import "TempCompany.h"
#import "CurrentActivitysShowCell.h"
#import "TeamInteractionViewController.h"
static NSString * reuseIdentifier = @"f,sepofjoisejf";

static NSString *ID = @"feasfsefse";
#define headViewHeight (DLMultipleHeight(256.0)) + 180

@interface TeamHomePageController ()<UITableViewDataSource,UITableViewDelegate, MenuCollectionControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, strong)UIView *setView;
//@property (nonatomic, strong)
/**
 *  记录scrollView上次偏移的Y距离
 */
@property (nonatomic, assign) CGFloat scrollY;
/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  导航栏背景
 */
@property (nonatomic, strong) UIView *naviView;

/**
 *  头部的View
 */
@property (nonatomic, strong) UIView *headView;

/**
 *  头部的imageView
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  设置按钮
 */
@property (nonatomic, strong) UIButton *settingBtn;

/**
 *  导航条上的文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  加入按钮
 */
@property (nonatomic, strong)UIButton *joinButton;
@property (nonatomic, strong)UIImage *headerImage;

/**
 *  所有的item的name集合
 */
@property (nonatomic, strong) NSArray *itemNames;
/**
 *  所有的icon的图片名集合
 */
@property (nonatomic, strong) NSArray *itemIcons;

@end

@implementation TeamHomePageController

///**
// *  活动cell
// */
//static NSString * const avtivityCellID = @"avtivityCellID";
///**
// *  投票cell
// */
//static NSString * const voteCellID = @"voteCellID";
///**
// *  求助cell
// */
//static NSString * const helpCellID = @"helpCellID";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化界面
    [self setupUI];
    
    [self setupNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 初始化导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.headerImage) {
        self.headImageView.image = self.headerImage;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *controller;
    switch (indexPath.row) {
        case 0: // 群组信息{
        {
            TeamInfomationViewController * mycontroller = [[TeamInfomationViewController alloc] init];
//            [(FolderViewController *)controller setJudgeEditState:YES];
            
            [mycontroller setMemberInfos:(NSMutableArray *)self.informationModel.member];
            
            //主页 --> 信息
            mycontroller.detilemodel = [[GroupDetileModel alloc]init];
            mycontroller.detilemodel = self.informationModel;
            
            [self.navigationController pushViewController:mycontroller animated:YES];
            
    }
    
            break;
        case 1: // 成员
//            controller = [[TeamHomePageController alloc]init];
            controller = [[GroupMemberController alloc]init];
            [(GroupMemberController *)controller setModelArray:(NSMutableArray *)self.informationModel.member];
            break;
        case 2:
            // 邀请
            //controller = [[FolderViewController alloc]init];
            //controller = [[UserMessageTableViewController alloc]init];/
        {
            for (NSDictionary *dic in self.informationModel.member)
            {
                if ([[AccountTool account].ID isEqualToString:dic[@"_id"]]) {
                    controller = [[InviteGroupMember alloc] init];
                    
                    [(InviteGroupMember *)controller setDetileModel:self.informationModel];
                    break;
                }
            }
            if (!controller) {
                
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"操作失败" message:@"您不是该群成员" delegate: nil cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                [al show];
            }
    }
            break;
        case 3: // 活动
            controller = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)controller setType:TeamInteractionActivity];
            [(TeamInteractionViewController*)controller setGroupCardModel:self.groupCardModel];
            break;
        case 4: // 投票
            controller = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)controller setType:TeamInteractionVote];
            [(TeamInteractionViewController*)controller setGroupCardModel:self.groupCardModel];
            break;
        case 5: // 求助
            controller = [[TeamInteractionViewController alloc]init];
            [(TeamInteractionViewController*)controller setType:TeamInteractionHelp];
            [(TeamInteractionViewController*)controller setGroupCardModel:self.groupCardModel];
            break;
        default:
            break;
    }
    
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


-(void)setupUI{
    
    
    self.itemNames = @[@"社团信息",@"成员",@"邀请",@"活动",@"投票",@"求助"];
    
    self.itemIcons = @[@"我的信息111@2X",@"社团111@2X",@"消息111@2X",@"活动111@2X",@"投票111@2X",@"求助111@2x"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView  = [[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"OtherActivityShowCell" bundle:nil] forCellReuseIdentifier:avtivityCellID];
//    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:voteCellID];
//    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:helpCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentActivitysShowCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
//    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, headViewHeight + 180)];
    
    
    self.headView = [[UIView alloc]init];
    [self.headView setFrame:CGRectMake(0, 0, DLScreenWidth, headViewHeight)];
    

    
    
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, headViewHeight - 180)];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.masksToBounds = YES;
    [self.headView addSubview:self.headImageView];
    
    
    UIView *temp = [UIView new];
    temp.backgroundColor = [UIColor lightGrayColor];
    [self.headView addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_bottom);
        make.height.mas_equalTo(180.0);
        make.left.mas_equalTo(self.headView.mas_left);
        make.right.mas_equalTo(self.headView.mas_right);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collec = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 180) collectionViewLayout:layout];
    [collec registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    collec.backgroundColor = [UIColor whiteColor];
    [collec registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"fkslfksnfjenf"];
    collec.delegate = self;
    collec.dataSource = self;
    [temp addSubview:collec];
    
    /*  加胜写的
    MenuCollectionController *menuController = [[MenuCollectionController alloc]init];
    menuController.view.y += 180;
    [menuController setDelegate:self];
    [self.headView addSubview:menuController.view];
*/
    
//    [bigView addSubview:self.headView];
//    [bigView addSubview:temp];
    
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.joinButton];
    [self.joinButton setTitle:@"申请加入" forState: UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.joinButton.layer.masksToBounds = YES;
    self.joinButton.layer.cornerRadius = 20;
    
    self.joinButton.backgroundColor = RGBACOLOR(251, 172, 9, 1);
    [self.view addSubview:self.joinButton];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-3);
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self builtJoinButton];
    if (self.groupCardModel) {
        [self requestNet];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAlbumPhoto:) name:@"ChangeGroupAlbumPhoto" object:nil];
    
}

- (void)changeAlbumPhoto:(NSNotification *)userInfo
{
    NSDictionary *Dic = userInfo.userInfo;
    
    UIImage *image = [Dic objectForKey:@"image"];
    
    self.headerImage = image;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = DLScreenWidth / 3.0;
    return CGSizeMake(width, 90);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.menuCollectionCellName.text = self.itemNames[indexPath.row];
    [cell.menuCollectionCellIcon setImage:[UIImage imageNamed:self.itemIcons[indexPath.row]]];
    cell.layer.borderColor = RGBACOLOR(247, 247, 247, 1).CGColor;
    cell.layer.borderWidth = 1;
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fkslfksnfjenf" forIndexPath:indexPath];
//    cell.layer.borderWidth = .5;
//    cell.layer.borderColor = RGBACOLOR(247, 247, 247, 1).CGColor;
//    cell.layer.backgroundColor = [UIColor greenColor].CGColor;
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    switch ([inter.type integerValue]) {
        case 1:{  // 活动详情
            DetailActivityShowController * activityController = [[DetailActivityShowController alloc]init];
            activityController.orTrue = YES;
            activityController.model = inter;
            [self.navigationController pushViewController:activityController animated:YES];
            break;
        }
        case 2:{  // 投票详情
            VoteTableController *voteController = [[VoteTableController alloc]init];  /// 投票
            
            voteController.voteArray = [NSMutableArray array];
            [voteController.voteArray addObject:inter];
            [self.navigationController pushViewController:voteController animated:YES];
            
            break;
        }
        case 3:  // 求助详情
        {
            HelpTableViewController *helpController = [[HelpTableViewController alloc]init];  // 求助
            helpController.model = inter;
            [self.navigationController pushViewController:helpController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)requestNet
{
    
    //    getIntroModel *model = [[getIntroModel alloc]init];
    //    [model setUserId:acc.ID];
    //
    
    Account *acc = [AccountTool account];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"team"];
    [dic setObject:self.groupCardModel.groupId forKey:@"teamId"];
    [dic setObject:@2 forKey:@"requestType"];
    [dic setObject:@4 forKey:@"interactionType"];
    [dic setObject:@10 forKey:@"limit"];
    [dic setObject:acc.ID forKey:@"userId"];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:dic useKeys:@[@"interactionType", @"requestType", @"limit", @"userId", @"teamId", @"team"] success:^(id json) {
//        NSLog(@"获取互动数据成功   %@", json);
        [self analyDataWithJson:json];
        
    } failure:^(id errorJson) {
        NSLog(@"获取失败  %@", errorJson);
        
        NSString *str = [errorJson objectForKey:@"msg"];
        if ([str isEqualToString:@"您没有登录或者登录超时，请重新登录"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"身份信息过期" message:@"您没有登录或者登录超时，请重新登录" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.tag = 100;
            alert.delegate = self;
            [alert show];
            
        }
        
    }];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        GuidePageViewController *login = [[GuidePageViewController alloc]init];
        Account *acc = [AccountTool account];
        acc.token = nil;
        [AccountTool saveAccount:acc];
        [self.navigationController pushViewController:login animated:YES];
        
    }
    
}

- (void)analyDataWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    
    for (NSDictionary *dic  in json) {
        Interaction *inter = [[Interaction alloc]init];
        [inter setValuesForKeysWithDictionary:dic];
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if ([str isEqualToString:[NSString stringWithFormat:@"%d", 2]])  //只有投票
        {
            PollModel *poll = [[PollModel alloc]init];
            [poll setValuesForKeysWithDictionary:[dic objectForKey:@"poll"]];
            [inter setPoll:poll];
        }
        [self.modelArray addObject:inter];
    }
    [self.tableView reloadData];
}

-(void)setupNavigationBar{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, 64)];
    self.naviView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    [self.view addSubview:self.naviView];
    //添加返回按钮
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    backView.backgroundColor = [UIColor clearColor];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(12, 30, 12, 20);
//    [self.backBtn setImage:[UIImage imageNamed:@"setting white@2x"] forState:UIControlStateNormal];
    
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.backBtn];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked:)]];
    [self.view addSubview:backView];
    
    self.setView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth - 100, 0, 100, 64)];
    self.setView.backgroundColor = [UIColor clearColor];
    //按钮
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.settingBtn.frame = CGRectMake(100 - 36, 30, 20, 20);
//    [self.settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    
    [self.settingBtn setBackgroundImage:[UIImage imageNamed:@"chat_white"] forState:UIControlStateNormal];
//    self.backBtn.backgroundColor = [UIColor redColor];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"ReturnWhite"] forState:UIControlStateNormal];
    
    [self.setView addSubview:self.settingBtn];
    self.setView.userInteractionEnabled = YES;
    [self.setView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnClicked:)]];
    [self.view addSubview:self.setView];
    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.size = CGSizeMake(200, 18);
    self.titleLabel.centerX = DLScreenWidth / 2;
    self.titleLabel.y = 64 - self.titleLabel.size.height - 13;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.titleLabel.text = @"小队主页";
    
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    
    [self.settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = self.informationModel.name;
    [self.headImageView dlGetRouteThumbnallWebImageWithString:self.informationModel.logo placeholderImage:nil withSize:self.headImageView.size];    
    
    FMDBSQLiteManager *manger = [FMDBSQLiteManager shareSQLiteManager];
    
    Group *group = [manger selectGroupWithGroupId:self.groupCardModel.groupId];
    if (!group) {
        self.setView.userInteractionEnabled = NO;
        self.settingBtn.alpha = 0;
    }
}



#pragma mark - 按钮监听方法
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


// 聊天
-(void)settingBtnClicked:(id)sender{
    NSLog(@"点击聊天");
    
    FMDBSQLiteManager * manger = [FMDBSQLiteManager shareSQLiteManager];
    Group *group = [manger selectGroupWithGroupId:self.groupCardModel.groupId];
    
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:group.easemobID conversationType:eConversationTypeGroupChat];
    [self.navigationController pushViewController:chatVC animated:YES];
    
//    TeamInfomationViewController *infomationController = [[TeamInfomationViewController alloc]initWithStyle:UITableViewStyleGrouped];
//    
//    // 数组为测试数据，与内容无关，至于数组的count有关，这边的count数目决定了里面用户头像的个数，界面内容会根据count的大小自动排版
//    [infomationController setMemberInfos:self.informationModel.member];
//    
//    //主页 --> 信息
//    infomationController.detilemodel = [[GroupDetileModel alloc]init];
//    infomationController.detilemodel = self.informationModel;
//    
//    [self.navigationController pushViewController:infomationController animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:avtivityCellID forIndexPath:indexPath];
    CurrentActivitysShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    Interaction *inter = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell reloadCellWithModel:inter];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149 ;
}
/*
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
 
 //    TempCompany *company = [[TempCompany alloc]init];
 //    [company setName:@"动力哈"];
 //    [company setPassword:@"asdfasd"];
 //    [company setEmail:@"asdfa@qq.com"];
 //
 //    [RestfulAPIRequestTool routeName:@"companyQuickRegister" requestModel:company useKeys:@[@"name",@"email",@"password"] success:^(id json) {
 //        NSLog(@"%@",json);
 //    } failure:^(id errorJson) {
 //        NSLog(@"%@",errorJson);
 //    }];
 }
 
 //-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 //    return 290 * DLScreenWidth / 375;
 //}
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // NSLog(@"%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y <= 100 && scrollView.contentOffset.y >= 0) {
        
        CGFloat num = scrollView.contentOffset.y / 100.0f;
        self.naviView.backgroundColor = [UIColor colorWithWhite:num alpha:num];
    }
    if (scrollView.contentOffset.y >= 60) {
        self.titleLabel.textColor = [UIColor blackColor];
        [self.settingBtn setBackgroundImage:[UIImage imageNamed:@"chat_black"] forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"Back Arrow black@2x"] forState:UIControlStateNormal];
    } else // if (scrollView.contentOffset.y < 60)
    {
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"ReturnWhite"] forState:UIControlStateNormal];
        self.naviView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        [self.settingBtn setBackgroundImage:[UIImage imageNamed:@"chat_white"] forState:UIControlStateNormal];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat factorWidth = DLScreenWidth / headViewHeight * (headViewHeight - offsetY);
        self.headView.frame = CGRectMake(0, offsetY, DLScreenWidth, headViewHeight - offsetY);
//        self.headImageView.frame = CGRectMake(-(factorWidth - DLScreenWidth) / 2, offsetY, factorWidth, headViewHeight - offsetY);
    }
}

- (void)setGroupCardModel:(GroupCardModel *)groupCardModel
{
    _groupCardModel = groupCardModel;
//    BOOL a = [self judgeMember];
//    
//    if (!a) {
//        groupCardModel.allInfo = YES;
//    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithObject:@"groupId"];
    if (groupCardModel.isMember.integerValue == 1) {
        [tempArray addObject:@"allInfo"];
    }
    
    [RestfulAPIRequestTool routeName:@"getGroupInfor" requestModel:groupCardModel useKeys:tempArray success:^(id json) {
        
        NSLog(@"获取到的小队信息为 %@", json);
        
        NSDictionary *dic = [json objectForKey:@"group"];
        
        GroupDetileModel *model = [[GroupDetileModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        self.informationModel = model;
        [self builtJoinButton];
        [self.settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.text = self.informationModel.name;
        [self.headImageView dlGetRouteThumbnallWebImageWithString:self.informationModel.logo placeholderImage:nil withSize:self.headImageView.size];
//        [self requestNet];
        
    } failure:^(id errorJson) {
        NSLog(@"获取小队信息失败的原因为 %@", errorJson);
    }];
}

- (void)builtJoinButton
{
    BOOL a = [self judgeMember];
    if (a) {
        [self.joinButton removeFromSuperview];
    }
}

- (void)joinAction:(UIButton *)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.groupCardModel.groupId forKey:@"groupId"];
    [RestfulAPIRequestTool routeName:@"joinGroups" requestModel:dic useKeys:@[@"groupId"] success:^(id json) {
        NSLog(@"请求发送成功  %@", json);
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[json objectForKey:@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        if ([json[@"msg"] isEqualToString:@"加入群组成功"]) {
            [self.joinButton removeFromSuperview];
        } else {
            
            self.joinButton.backgroundColor = RGB(236, 236, 236);
            self.joinButton.userInteractionEnabled = NO;
        }
        
        [al show];
        
    } failure:^(id errorJson) {
        
        NSLog(@"请求发送失败   %@", errorJson);
    }];
}






- (BOOL)judgeMember
{
    
    Account *acc = [AccountTool account];
    NSArray *array  = self.informationModel.member;
    
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"_id"] isEqualToString:acc.ID]) {
            return YES;
        }
    }
    return NO;
}



@end
