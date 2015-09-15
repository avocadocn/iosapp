//
//  TemplateHelpTableViewController.m
//  app
//
//  Created by tom on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TemplateHelpTableViewController.h"
#import "HelpTableViewCell.h"
#import "HelpCellFrame.h"
#import "HelpInfoModel.h"
#import "CommentsViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "getTemplateModel.h"
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"

@interface TemplateHelpTableViewController ()
@property (nonatomic, strong) NSMutableArray* helpData;
@property (nonatomic, strong) NSMutableArray *helpFrames;

@end

@implementation TemplateHelpTableViewController

static NSString * const ID = @"HelpTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"求助";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:ID];
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    self.tableView.height -=44 ;
    [self requestNet];
}

//进行网络数据获取
- (void)requestNet{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:3]];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
        NSLog(@"failed:-->%@",errorJson);
    }];
}
//解析返回的数据
- (void)analyDataWithJson:(id)json
{
    self.helpData = [NSMutableArray array];
    
    for (NSDictionary *dic  in json) {
        Interaction *inter = [[Interaction alloc]init];
        [inter setValuesForKeysWithDictionary:dic];
        [self.helpData addObject:inter];
        [self loadHelpArrayWithInter:inter];
    }
    [self.tableView reloadData];
}
- (void)loadHelpArrayWithInter:(Interaction*)inter
{
    if (!self.helpFrames) {
        self.helpFrames = [NSMutableArray array];
    }
    HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
    helpInfoModel.name = [NSString stringWithFormat:@"杨同"];
    helpInfoModel.time = inter.createTime;
    helpInfoModel.helpImageURL = [[inter.photos firstObject] objectForKey:@"uri"];
    helpInfoModel.helpText = inter.theme;
    helpInfoModel.avatarURL = @"1";
    
    HelpCellFrame *f = [[HelpCellFrame alloc]init];
    [f setTemplateHelpInfoModel:helpInfoModel];
    
    [self.helpFrames addObject:f];
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
    return self.helpFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[HelpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID isTemplate:true];
    }
    cell.helpCellFrame = self.helpFrames[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setModel:[self.helpData objectAtIndex:indexPath.row]];
    [cell setContext:self];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((HelpCellFrame *)self.helpFrames[indexPath.row]).cellHeight;
}

@end
