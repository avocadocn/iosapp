//
//  ColleaguesInformationController.m
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Account.h"
#import "AccountTool.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "ColleaguesInformationController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "FolderViewController.h"
#import "PersonalDynamicController.h"
#import "AddressBookModel.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "RestfulAPIRequestTool.h"
#import "AttentionViewController.h"
#import "UIImageView+DLGetWebImage.h"

static NSInteger tagNum = 1;

@interface ColleaguesInformationController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIView *naviView;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIButton *settingBtn;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIScrollView *scrollPhotoView;
@property (nonatomic, strong)UIScrollView *bigScroll;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;

@end

@implementation ColleaguesInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(238, 238, 240, 1);
    tagNum = 1;
    
    self.bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    
    self.bigScroll.contentSize = CGSizeMake(0, 700);
    [self.view addSubview:self.bigScroll];
    [self builtImageView];
    
    self.title = @"个人资料";
    NSArray *nameArray = @[@"Profile@2x", @"Oval 2@2x", @"chat@2x"];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *str in nameArray) {
        UIImage *image = [UIImage imageNamed:str];
        [imageArray addObject:image];
    }
    
    CGFloat centerY = self.imageView.frame.size.height + 65 + 35 + 24 + 35; //DLMultipleHeight((600.0 - 64.0));
    
    CGFloat num = DLMultipleWidth(70.0);
    NSArray *titleNameArray;
    titleNameArray = @[@"资料", @"动态", @"聊天"];
    Account *acc = [AccountTool account];
    if ([acc.ID isEqualToString:self.model.ID]) {
        titleNameArray = @[@"资料", @"动态"];
    }
    
    [self builtInterfaceWithNameArray:titleNameArray imageArray:imageArray andrect:CGRectMake(0, 0, num, num * 1.85) andCenterY: centerY];
}
- (void)setModel:(AddressBookModel *)model
{
    _model = model;
}

- (void)builtImageView  //唯一的图片页
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(380.0))];
    Person *person = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:self.model.ID];
    
    //加载指定大小的图片
    [self.imageView dlGetRouteThumbnallWebImageWithString:person.imageURL placeholderImage:nil withSize:self.imageView.size];
    
    [self.bigScroll addSubview:self.imageView];
    [self builtButton];
}
//- (void)builtScrollPhotoView
//{
//    self.scrollPhotoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(420.0))];
//    
//    [self.view addSubview:self.scrollPhotoView];
//    self.photoArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"114.png"],[UIImage imageNamed:@"2.jpg"], nil];
//    NSInteger i = 0;
//    
//    for (UIImage *image in self.photoArray) {
//        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i * DLScreenWidth, 0, DLScreenWidth, self.scrollPhotoView.size.height)];
//        imageview.image = image;
//        [self.scrollPhotoView addSubview:imageview];
//        i++;
//    }
//    self.scrollPhotoView.showsVerticalScrollIndicator = FALSE;
//    self.scrollPhotoView.showsHorizontalScrollIndicator = FALSE;
//    self.scrollPhotoView.pagingEnabled = YES;
//    self.scrollPhotoView.delegate = self;
//    self.scrollPhotoView.contentSize = CGSizeMake(DLScreenWidth * [self.photoArray count], 0);
//    
//    self.pag = [UIPageControl new];
//    self.pag.backgroundColor = [UIColor colorWithWhite:.1 alpha:.2];
//    self.pag.numberOfPages = [self.photoArray count];
//    self.pag.userInteractionEnabled = NO;
//    
//    
//    [self.view addSubview:self.pag];
//    [self.pag mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.scrollPhotoView.mas_bottom);
//        make.left.mas_equalTo(self.scrollPhotoView.mas_left);
//        make.right.mas_equalTo(self.scrollPhotoView.mas_right);
//        make.height.mas_equalTo(DLScreenHeight / 15.159);
//    }];
//    
//    [self builtButton];
//}
//
- (void)builtButton
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.bigScroll addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.left.mas_equalTo(self.imageView.mas_left);
        make.right.mas_equalTo(self.imageView.mas_right);
        make.height.mas_equalTo(65);
    }];
    Account *acc = [AccountTool account];

        
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        self.attentionButton.backgroundColor = [UIColor whiteColor];
        self.attentionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.attentionButton.layer.borderWidth = 1;
        self.attentionButton.layer.cornerRadius = 5;
        self.attentionButton.layer.masksToBounds = YES;
        if (self.model.attentState) {
            
            [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else
        {
            [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        
        self.attentionButton.font = [UIFont systemFontOfSize:16];
        [self.attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:self.attentionButton];
        
        self.attentionButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            self.model.userId = self.model.ID;
            AttentionViewController *att  =[AttentionViewController shareInsten];
            if ([[self.attentionButton currentTitle] isEqualToString:@"关注"]) {
                NSLog(@"关注");
                
                [self.model setUserId:self.model.ID];
                [RestfulAPIRequestTool routeName:@"addConcern" requestModel:self.model useKeys:@[@"userId"] success:^(id json) {
                    NSLog(@"关注成功  %@", json);
                    [att requestNet];
                    [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                    
                } failure:^(id errorJson) {
                    NSLog(@"关注失败 %@", errorJson);
                }];
                
            } else
            {
                [RestfulAPIRequestTool routeName:@"deleteConcern" requestModel:self.model useKeys:@[@"userId"] success:^(id json) {
                    NSLog(@"取消关注成功  %@", json);
                    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
                    
                    [att requestNet];
                } failure:^(id errorJson) {
                    NSLog(@"取消关注失败  %@", errorJson);
                }];
                NSLog(@"取消关注");
            }
            
            return [RACSignal empty];
        }];
        
        [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).offset(-12);
            make.top.mas_equalTo(view.mas_top).offset(11);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(89);
        }];
    
    if ([acc.ID isEqualToString:self.model.ID]) {
        [self.attentionButton removeFromSuperview];
    }
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, DLScreenWidth - 115, 60)];
    
    self.nameLabel.font = [UIFont systemFontOfSize:21];
    Person *per = [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:self.model.ID];
    self.nameLabel.text = per.nickName;
    [view addSubview:self.nameLabel];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pag.currentPage = scrollView.contentOffset.x / DLScreenWidth;
}
- (void)builtInterfaceWithNameArray:(NSArray *)nameArray imageArray:(NSArray *)imageArray andrect:(CGRect)rect andCenterY:(NSInteger)num
{
    int i = 0;
    CGFloat rote = rect.size.width / 2.0333;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((DLScreenWidth - [nameArray count] * (rect.size.width + rote)) / 2.0, 0, [nameArray count] * (rect.size.width + rote), rect.size.height)];
    
    view.centerY = num;
    
    [self.bigScroll addSubview:view];
    
    
    for (NSString *str in nameArray) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), 0, rect.size.width, rect.size.width)];
        imageview.image = [imageArray objectAtIndex:i];
        imageview.backgroundColor = [UIColor whiteColor];
        [view addSubview:imageview];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = rect.size.width / 2.0;
        imageview.layer.shadowColor = [UIColor blackColor].CGColor;
        imageview.layer.shadowRadius = 7;
        imageview.layer.shadowOpacity = .51;
        
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        imageview.tag = tagNum;
        tagNum ++;
        [imageview addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), rect.size.height - rote * 2, rect.size.width, rote * 2)];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        //        label.backgroundColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        i++;
    }
}

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:{
            
            FolderViewController *folder = [[FolderViewController alloc]init];
            [self.model setUserId:self.model.ID];
            [folder netRequstWithModel:self.model];
            [self.navigationController pushViewController:folder animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
        }
        case 2:{
            // 个人动态页面
            PersonalDynamicController *dynamic = [[PersonalDynamicController alloc]init];
            dynamic.userModel = [[AddressBookModel alloc] init];
            dynamic.userModel = self.model;
            [self.navigationController pushViewController:dynamic animated:YES];

            break;
        }
            
        case 4:
            NSLog(@"关系");
            break;
        case 3:{
            // 新建一个对话  跳到对话页面  聊天页面刷新界面
            EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.model.ID conversationType:eConversationTypeChat];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter conversationType:conversation.conversationType];
            if (self.model.realname) {
                chatVC.title = self.model.realname;
            } else
            {
                chatVC.title = self.model.nickname;
            }
            [self.navigationController pushViewController:chatVC animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            ChatListViewController *chat = [ChatListViewController shareInstan];
            [chat.dataSource addObject:conversation];
            [chat.tableView reloadData];
            
            NSLog(@"聊天");
            break;
        }
        case 5:
            NSLog(@"关心");
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

-(void)viewWillAppear:(BOOL)animated{
    // 初始化导航条
    //    [self setupNavigationBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setupNavigationBar{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, 64)];
    self.naviView.backgroundColor = [UIColor blackColor];
    self.naviView.alpha = 0.1f;
    [self.view addSubview:self.naviView];
    //添加返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(12, 30, 12, 20);
    [self.backBtn setImage:[UIImage imageNamed:@"new_navigation_back@2x"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //按钮
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(DLScreenWidth - 36, 34, 19, 19);
    [self.settingBtn setImage:[UIImage imageNamed:@"new_navigation_back_helight@2x"] forState:UIControlStateHighlighted];
    
    [self.settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingBtn];
    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.size = CGSizeMake(200, 18);
    self.titleLabel.centerX = DLScreenWidth / 2;
    self.titleLabel.y = 64 - self.titleLabel.size.height - 13;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    
    if (self.model.realname) {
        self.titleLabel.text = self.model.realname;
    } else
    {
        self.titleLabel.text = self.model.nickname;
    }
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
}
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}

- (void)settingBtnClicked:(UIButton *)sender
{
    
}
@end
