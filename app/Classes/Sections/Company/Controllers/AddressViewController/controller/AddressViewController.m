//
//  AddressViewController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AddressViewController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "AddressTableViewCell.h"
#import "AddressBookModel.h"
#import "ColleaguesInformationController.h"
@interface AddressViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterFace];
}
- (void)builtInterFace
{
    self.title = @"公司通讯录";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
/*
    self.searchColleague = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, 30)];
    self.searchColleague.layer.borderWidth = 2;
    

//    self.searchColleague.backgroundColor = [UIColor clearColor];
    NSLog(@"子视图有%@", [self.searchColleague subviews]);
    [[self.searchColleague.subviews objectAtIndex:0] removeFromSuperview];
    
    self.searchColleague.delegate = self;
    
//    [self.searchColleague setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.searchColleague];
  */
    
    self.addressSearch = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, 40)];
    self.addressSearch.textAlignment = NSTextAlignmentCenter;
    self.addressSearch.placeholder = @"Search";  [self.addressSearch placeholder];
    self.addressSearch.layer.borderWidth = 5;
    self.addressSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addressSearch.backgroundColor = DLSBackgroundColor;
    [self.view addSubview:self.addressSearch];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, DLScreenWidth, DLScreenHeight - 64 - 30) style:UITableViewStylePlain];
    [self.myTableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"addressTableViewCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    [self.view addSubview:self.myTableView];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.7]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressTableViewCell" forIndexPath:indexPath];
    [cell cellReloadWithAddressModel:nil];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //找到相对应的资料model,跳到相对应的资料页面
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    [self.navigationController pushViewController:coll animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",@"I",@"J", @"K", @"L",@"M", @"N",@"O", @"P", @"Q", @"R", @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    return 26;
}


@end
