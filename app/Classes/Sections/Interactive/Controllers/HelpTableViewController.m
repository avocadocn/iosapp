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

@interface HelpTableViewController ()

@property (nonatomic, strong) NSMutableArray *helpFrames;

@end

@implementation HelpTableViewController
static NSString * const ID = @"HelpTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"求助";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:ID];
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self loadhelpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadhelpData{
    if (!self.helpFrames) {
        self.helpFrames = [NSMutableArray array];
    }
    for (int i = 0; i < 10; i++) {
        HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
        helpInfoModel.name = [NSString stringWithFormat:@"杨同%zd",i];
        helpInfoModel.time = @"7分钟前 来自 动梨基地";
        helpInfoModel.helpImageURL = @"callBg";
        helpInfoModel.helpText = @"杨彤美么";
        helpInfoModel.avatarURL = @"1";
        
       
        

        HelpCellFrame *f = [[HelpCellFrame alloc]init];
        [f setHelpInfoModel:helpInfoModel];
        
        [self.helpFrames addObject:f];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.helpCellFrame = self.helpFrames[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((HelpCellFrame *)self.helpFrames[indexPath.row]).cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsViewController *commentsController = [[CommentsViewController alloc]init];
    [self.navigationController pushViewController:commentsController animated:YES];
}






@end
