//
//  VoteCommentsViewController.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentViewCell.h"

#import "CommentsModel.h"
#import "CustomKeyBoard.h"
#import "CircleCommentModel.h"
#import "AddressBookModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
@interface CommentsViewController ()

@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, strong) CommentViewCell *defaultCell;

@property (nonatomic, strong) CustomKeyBoard *keyBoard;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CommentsViewController

static NSString * const ID = @"VoteCommentViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [FMDBSQLiteManager shareSQLiteManager];
    //    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //    NSLog(@"************->%@",filePath);
    self.title = @"评论";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:self.tableView];
    
    CommentViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    self.defaultCell = cell;
    
    [self setupKeyBoard];
    
    //    [self loadData];
    [self netWorkRequest];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commenting:) name:@"POSTTEXT"object:nil]; // 注册观察者 监测发送评论
    
    
}
- (void)commenting:(NSNotification *)notice {

     // 进行评论
    if (self.keyBoard.inputView.text.length != 0) {
        [self marchingComments];
    }else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空"delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
    }
    
}
- (void)netWorkRequest { // 获取评论列表
    self.model = [[Interaction alloc]init];
    [self.model setInteractionType:self.interactionType];
    [self.model setInteractionId:self.inteactionId];
    [RestfulAPIRequestTool routeName:@"getCommentsLists" requestModel:self.model useKeys:@[@"interactionType",@"interactionId"] success:^(id json) {
        NSLog(@"请求评论列表成功 %@",json);
        [self loadDataWithJson:json];

    } failure:^(id errorJson) {
        NSLog(@"请求评论列表失败原因 %@",[errorJson objectForKey:@"msg"]);

    }];
}

- (void)marchingComments {
    self.model = [[Interaction alloc]init];
    [self.model setInteractionType:self.interactionType];
    //    NSLog(@"__-%@",self.model.interactionType);
    [self.model setContent:self.keyBoard.inputView.text];
    [self.model setInteractionId:self.inteactionId];
    [RestfulAPIRequestTool routeName:@"marchingComments" requestModel:self.model useKeys:@[@"interactionType",@"interactionId",@"content"] success:^(id json) {
        NSLog(@"发送评论成功 %@",json);
        [self netWorkRequest];
    } failure:^(id errorJson) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"评论失败" message:[errorJson objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
        NSLog(@"发送评论失败的原因 %@",[errorJson objectForKey:@"msg"]);
        NSLog(@"%@",self.interactionType);

        
    }];
}
-(void)loadDataWithJson:(id)json{
    self.comments = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        CommentsModel *model = [[CommentsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.comments addObject:model];
    }
    CommentsModel *model = [self.comments firstObject];
    
    [self.tableView reloadData];
    //    for (NSInteger i = 0 ; i<5;i++) {
    //        CommentsModel *model = [[CommentsModel alloc]init];
    //        model.name = @"杨彤";
    //        model.avatarUrl = @"1";
    //        model.comment = @"你猜猜看么什的低洼低洼的吾问无为谓哇哇哇哇么吗吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无问无为谓吾问无为谓哇哇哇哇哇哇哇哇";
    //
    //        [self.comments addObject:model];
    //    }
    
}

-(void)setupKeyBoard{
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


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.comments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    //    CircleCommentModel *model = [[CircleCommentModel alloc]init];
    
    [cell setModel:self.comments[indexPath.row]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentsModel *model = self.comments[indexPath.row];
    
    
    CGFloat currentWidth = self.defaultCell.comment.width;
    
    CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:self.defaultCell.comment.font};
    CGSize commentLabelSize = [model.content boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    return self.defaultCell.comment.y + commentLabelSize.height + 12;
}
- (void) didEditingCell {
    [self.tableView setEditing:YES animated:YES];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
/*
 _id = 55f6b5b31cc34f3c7f944c9f,
	content = 事实上事实上,
	posterId = 55dc110314a37c242b6486d0,
	posterCid = 55d44d2219d8c913768fce8c,
	__v = 0,
	status = 1,
	interactionId = 55f63823b00f52024155b8c1,
	createTime = 2015-09-14T11:55:31.809Z,
	approveCount = 0
 */


//  删除评论
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        CommentsModel *model = self.comments[indexPath.row];
//        [model setInteractionType:@3];
//        [model setInteractionId:self.model.interactionId];
//        [model setCommentId:model._id];
//        
//        [RestfulAPIRequestTool routeName:@"deleteComments" requestModel:model useKeys:@[@"interactionType",@"interactionId",@"commentId"] success:^(id json) {
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            NSLog(@"删除成功 %@",json);
//        } failure:^(id errorJson) {
//            NSLog(@"删除评论失败原因 %@",[errorJson objectForKey:@"msg"]);
//        }];
//        
//        
//        
//        
//    }
//}

@end
