//
//  HelpTableViewController.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "HelpTableViewController.h"
#import "HelpTableViewCell.h"
#import "HelpCellFrame.h"
#import "HelpInfoModel.h"
#import "CommentsViewController.h"
#import "Interaction.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"

#import "CommentViewCell.h"
#import "RestfulAPIRequestTool.h"
#import "CommentsModel.h"
#import "CustomKeyBoard.h"
#import <DGActivityIndicatorView.h>
#import <MJRefresh.h>
@interface HelpTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *helpFrames;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) CommentViewCell *defaultCell;
@property (nonatomic, strong) CustomKeyBoard *keyBoard;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation HelpTableViewController
static NSString * const ID = @"HelpTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
//    [GiFHUD setGifWithImageName:@"myGif.gif"];
//    [GiFHUD show];
    
    if (self.interaction) {
        [self netRequest];
    }
    
    self.title = @"求助";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight - 45)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:ID];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    
    
    [self loadhelpData];
    [self refressMJ];  // 刷新加载
    
//    注册评论cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentViewCell"];
    CommentViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentViewCell"];
    self.defaultCell = cell;
    [self setupKeyBoard]; // 设置自定义键盘
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commenting:) name:@"POSTTEXT"object:nil]; // 注册观察者 监测发送评论
   
    [self loadingImageView];
}
- (void)loadingImageView {
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeFiveDots tintColor:[UIColor yellowColor] size:40.0f];
    activityIndicatorView.frame = CGRectMake(DLScreenWidth / 2 - 40, DLScreenHeight / 2 - 40, 80.0f, 80.0f);
    activityIndicatorView.backgroundColor = RGBACOLOR(214, 214, 214, 0.5);
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView.layer setMasksToBounds:YES];
    [activityIndicatorView.layer setCornerRadius:10.0];
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadhelpData{
   Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:self.model.poster[@"_id"]];
//    if (!self.helpFrames) {
        self.helpFrames = [NSMutableArray array];
//    }
//    for (int i = 0; i < 10; i++) {
        HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
        helpInfoModel.name = p.name;
//        helpInfoModel.avatarURL = p.imageURL;
//        helpInfoModel.time = [self getParsedDateStringFromString:self.model.createTime];
        helpInfoModel.time = self.model.createTime;
        for (NSDictionary *dic in self.model.photos) {
            self.url = dic[@"uri"];
        }
        helpInfoModel.helpImageURL = self.url;
        helpInfoModel.helpText = self.model.content;
        helpInfoModel.avatarURL = p.imageURL;
        helpInfoModel.helpAnserText = @"添加答案";
        helpInfoModel.cid = self.model.cid;
        
        HelpCellFrame *f = [[HelpCellFrame alloc]init];
        [f setHelpInfoModel:helpInfoModel];
        
        [self.helpFrames addObject:f];
//    }
//    HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
//    helpInfoModel.name = [NSString stringWithFormat:@"杨同%zd",i];
//    helpInfoModel.time = [self getParsedDateStringFromString:self.model.createTime];
//    for (NSDictionary *dic in self.model.photos) {
//        self.url = dic[@"uri"];
//    }
//    helpInfoModel.helpImageURL = self.url;
//    helpInfoModel.helpText = self.model.content;
//    helpInfoModel.avatarURL = @"1";
//    
    [self getCommentsLists];
}


- (void)getCommentsLists { // 获取评论列表
    Interaction *model = [[Interaction alloc]init];
    [model setInteractionType:@3];
    [model setInteractionId:self.model.interactionId];
    [model setLimit:@5];
    [RestfulAPIRequestTool routeName:@"getCommentsLists" requestModel:model useKeys:@[@"interactionType",@"interactionId",@"limit"] success:^(id json) {
        NSLog(@"请求评论列表成功 %@",json);
        [self loadDataWithJson:json];
        self.keyBoard.inputView.text = nil;
        [self.activityIndicatorView removeFromSuperview];
    } failure:^(id errorJson) {
        NSLog(@"请求评论列表失败原因 %@",[errorJson objectForKey:@"msg"]);
        [self.activityIndicatorView removeFromSuperview];
    }];
    [self.tableView.header endRefreshing];
}

-(void)loadDataWithJson:(id)json{ // 
    self.comments = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        CommentsModel *model = [[CommentsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.comments addObject:model];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0) {
//        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 1;
    } else {

        return self.comments.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.helpCellFrame = self.helpFrames[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else {
        CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentViewCell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setModel:self.comments[indexPath.row]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ((HelpCellFrame *)self.helpFrames[indexPath.row]).cellHeight;
    } else {
        CommentsModel *model = self.comments[indexPath.row];
        
        CGFloat currentWidth = self.defaultCell.comment.width;
        
        CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
        NSDictionary *attr = @{NSFontAttributeName:self.defaultCell.comment.font};
        CGSize commentLabelSize = [model.content boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
        
        return self.defaultCell.comment.y + commentLabelSize.height + 12;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
}

-(void)setupKeyBoard{  // 设置自定义键盘

    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CustomKeyBoard" owner:self
                                               options:nil];
    CustomKeyBoard *keyBoard = nibs.firstObject;
    keyBoard.width = DLScreenWidth;
    keyBoard.x = 0;
    keyBoard.y = self.view.height - keyBoard.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.keyBoard = keyBoard;
    

    [self.view addSubview:keyBoard];
    
    
}
-(void)keyBoardWasShown:(id)sender{
    NSNotification *ntf = (NSNotification *)sender;
    NSDictionary *userInfo = ntf.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.keyBoard.y = keyboardF.origin.y - self.keyBoard.height ;
    }];
    
}


- (void)commenting:(NSNotification *)notice {
  
    // 进行评论
    if (self.keyBoard.inputView.text.length != 0) {
        [self marchingComments];
        [self loadingImageView];
    }else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空"delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
    
    }
    
    
}

- (void)marchingComments { // 进行评论
    Interaction *model = [[Interaction alloc]init];
    [model setInteractionType:@3];
    //    NSLog(@"__-%@",self.model.interactionType);
    [model setContent:self.keyBoard.inputView.text];
    [model setInteractionId:self.model.interactionId];
    [RestfulAPIRequestTool routeName:@"marchingComments" requestModel:model useKeys:@[@"interactionType",@"interactionId",@"content"] success:^(id json) {
        NSLog(@"发送评论成功 %@",json);
        [self getCommentsLists];
        
    } failure:^(id errorJson) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"评论失败" message:[errorJson objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
        NSLog(@"发送评论失败的原因 %@",[errorJson objectForKey:@"msg"]);
    
        
    }];
}
// 设置tableView 的分割线顶到屏幕边框
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [self.keyBoard.inputView resignFirstResponder];

}

// 上拉加载 下拉刷新
- (void)refressMJ {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommentsLists)];
    self.tableView.header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [footer setTitle:@"加载更多" forState: MJRefreshStateIdle];
    self.tableView.footer = footer;
    
}
- (void)refreshAction { // 上拉加载事件
    CommentsModel *cmodel = [self.comments lastObject];
    Interaction *model = [[Interaction alloc]init];
    [model setInteractionType:@3];
    [model setInteractionId:self.model.interactionId];
    [model setCreateTime:cmodel.createTime];
    [model setLimit:@5];
    [RestfulAPIRequestTool routeName:@"getCommentsLists" requestModel:model useKeys:@[@"interactionType",@"interactionId",@"limit",@"createTime"] success:^(id json) {
        NSLog(@"请求评论列表成功 %@",json);
        [self detalNewDataWithJson:json];
 
    } failure:^(id errorJson) {
        NSLog(@"请求评论列表失败原因 %@",[errorJson objectForKey:@"msg"]);

    }];
    [self.tableView.footer endRefreshing];
    
}
- (void)detalNewDataWithJson:(id)json {
    for (NSDictionary *dic in json) {
        CommentsModel *model = [[CommentsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.comments addObject:model];
    }
    
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.activityIndicatorView removeFromSuperview];
}

- (void)netRequest
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.interaction forKey:@"interactionId"];
    [dic setObject:self.interactionType forKey:@"interactionType"];
    
    [RestfulAPIRequestTool routeName:@"getInterDetails" requestModel:dic useKeys:@[@"interactionType", @"interactionId"] success:^(id json) {
        NSLog(@" 获得的求助详情为 %@", json);

        self.model = [[Interaction alloc]init];
        [self.model setValuesForKeysWithDictionary:json];
        [self loadhelpData];
        [self.tableView reloadData];
        
    } failure:^(id errorJson) {
        NSLog(@"获取求朱详情失败 %@",errorJson);
    }];
}


@end
