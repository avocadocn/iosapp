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
    
    [self loadData];
}

-(void)loadData{
    if (!self.comments) {
        self.comments = [NSMutableArray array];
    }
    
    
    for (NSInteger i = 0 ; i<5;i++) {
        CommentsModel *model = [[CommentsModel alloc]init];
        model.name = @"杨彤";
        model.avatarUrl = @"1";
        model.comment = @"你猜猜看这是哪里？猜到了我就告诉你。我就是不告诉你，你咬我啊？哈哈哈哈哈哈哈哈哈哈哈，什么买什么什么什么吗";
        
        [self.comments addObject:model];
    }
    
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    [cell setCommentModel:self.comments[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentsModel *model = self.comments[indexPath.row];
    
    
    CGFloat currentWidth = self.defaultCell.comment.width;
    
    CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:self.defaultCell.comment.font};
    CGSize commentLabelSize = [model.comment boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
   
    return self.defaultCell.comment.y + commentLabelSize.height + 12;
}



@end
