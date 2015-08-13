//
//  TeamInfomationViewController.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TeamInfomationViewController.h"
#import "CustomMarginSettingTableViewCell.h"
#import "CustomMemberTableViewCell.h"
#import "TeamSettingViewController.h"


// 每一行item的个数
#define ItemCountPerLine 8
// 每个item的间距
#define cellSpacing 4.0
// 行距
#define lineSpacing 4.0

@interface TeamInfomationViewController ()

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
    
    CustomMemberTableViewCell *defaultMemberCell = [self.tableView dequeueReusableCellWithIdentifier:memberCell];
    self.defaultMemberCell = defaultMemberCell;
    
    [self setupCollectionViewUI];

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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:settingCell];
        if (!cell) {
            cell =  [[CustomMarginSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingCell];
            [cell.textLabel setText:@"设置"];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailTextLabel setText:@"群主"];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }else if (indexPath.section == 1){
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
    
    [cell setHighlighted:NO];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0) {
        return 64;
    }else if (indexPath.section == 1){
        return self.cellHeight;
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
    if (indexPath.section == 0) {
        TeamSettingViewController *settingController = [[TeamSettingViewController alloc]initWithIdentity:kTeamIdentityMaster];
        [self.navigationController pushViewController:settingController animated:YES];
    }
}


#pragma mark - setter方法
-(void)setMemberInfos:(NSArray *)memberInfos{
    _memberInfos = memberInfos;
 
}

@end
