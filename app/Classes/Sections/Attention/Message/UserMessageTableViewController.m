//
//  UserMessageTableViewController.m
//  app
//
//  Created by 张加胜 on 15/8/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "UserMessageTableViewController.h"
#import "UserMessageTableViewCell.h"
#import "MessageTableViewCell.h"

@interface UserMessageTableViewController ()

@property (nonatomic, strong) UserMessageTableViewCell *templateMessageCell;

@property (nonatomic, strong) NSMutableArray *userMessages;

@end

@implementation UserMessageTableViewController

static NSString * const messageCellID = @"UserMessageTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFakeData];
    
    self.title = @"用户消息";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // 去掉自带的分割线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserMessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellID];
    
    self.templateMessageCell = [self.tableView dequeueReusableCellWithIdentifier:messageCellID];
    
    
    // 根据模型计算所需数据
    for (NSInteger i = 0; i <self.userMessages.count; i++) {
        [self calculateByModel:self.userMessages[i]];
    }
}

-(void)loadFakeData{
    if (!self.userMessages) {
        self.userMessages = [NSMutableArray array];
    }
    for (NSInteger i = 0; i < 10; i++) {
        UserMessageModel *model = [[UserMessageModel alloc]init];
        model.text = @"我是正文的文字内容，我的高度可以动态改变，而且我可以是attributeString。ing。。。。";
        
        if (i % 2 == 0) {
            UserMessageModel *retweedModel = [[UserMessageModel alloc]init];
            retweedModel.text = @"我是转发的文字内容，我的高度可以动态改变，而且我可以是attributeString。。。。我ng。。。。";
            
            [model setRetweedMessage:retweedModel];
        }
        
        [self.userMessages addObject:model];
    }
 
}

-(void)calculateByModel:(UserMessageModel *)messageModel{
    
    
    // 暂存三个原始的高度
    CGFloat originTextHeight = self.templateMessageCell.text.height;
    CGFloat originRetweedTextHeight = self.templateMessageCell.retweedText.height;
    CGFloat originRetweedBackgroundHeight = self.templateMessageCell.retweedBackground.height;
    
    
       // 计算text的高度
    UIFont *textFont = self.templateMessageCell.text.font;
    NSDictionary *textAttr = @{NSFontAttributeName : textFont};

    CGSize maxTextSize = CGSizeMake(self.templateMessageCell.text.width, MAXFLOAT);
    CGSize textSize = [messageModel.text boundingRectWithSize:maxTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttr context:nil].size;
    messageModel.textHeight = textSize.height;
    
    
    if (messageModel.retweedMessage) {
        // 计算转发text的高度
        UIFont *retweedTextFont = self.templateMessageCell.retweedText.font;
        NSDictionary *retweedTextAttr = @{NSFontAttributeName : retweedTextFont};
        CGSize maxRetweedTextSize = CGSizeMake(self.templateMessageCell.retweedText.width, MAXFLOAT);
        CGSize retweedTextSize = [messageModel.retweedMessage.text boundingRectWithSize:maxRetweedTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:retweedTextAttr context:nil].size;
        messageModel.retweedMessage.textHeight = retweedTextSize.height +5;
        
        // 计算转发背景的高度
        messageModel.retweedMessage.textBackgroundHeight = originRetweedBackgroundHeight + messageModel.retweedMessage.textHeight - originRetweedTextHeight;
        
    }
    
    if (messageModel.retweedMessage) {
        // 如果有转发
        messageModel.cellHeight = CGRectGetMaxY(self.templateMessageCell.sepratorLine.frame) + messageModel.retweedMessage.textBackgroundHeight - originRetweedBackgroundHeight + messageModel.textHeight - originTextHeight - CGRectGetHeight(self.templateMessageCell.eventBackground.frame);
    }else{
        // 没有转发
        messageModel.cellHeight = CGRectGetMaxY(self.templateMessageCell.sepratorLine.frame) - CGRectGetHeight(self.templateMessageCell.retweedBackground.frame) + messageModel.textHeight - originTextHeight;

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellID forIndexPath:indexPath];
    
    cell.retweedBackground.hidden = YES;
    
    UserMessageModel *model = self.userMessages[indexPath.row];
    [cell.text setText:model.text];
    cell.textHeightConstraint.constant = model.textHeight;
    
    if (model.retweedMessage) {
        // 如果有转发
        cell.eventBackgroundHeightConstraint.constant = 0;
        cell.eventBackground.hidden = YES;
        
        
        cell.retweedText.text = model.retweedMessage.text;
        cell.retweedTextHeightConstraint.constant = model.retweedMessage.textHeight;
        cell.retweedBackgroundHeightConstraint.constant = model.retweedMessage.textBackgroundHeight;
        cell.retweedBackground.hidden = NO;
        
        
    }else{
        // 如果没有转发
        cell.eventBackground.hidden = NO;
        cell.eventBackgroundHeightConstraint.constant = self.templateMessageCell.eventBackground.height;
        
        cell.retweedTextHeightConstraint.constant = 0;
        cell.retweedBackgroundHeightConstraint.constant = 0;
        cell.retweedBackground.hidden = YES;
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserMessageModel *model = self.userMessages[indexPath.row];
    
    return model.cellHeight ;
}


@end
