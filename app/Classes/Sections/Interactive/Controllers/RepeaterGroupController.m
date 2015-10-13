//
//  RepeaterGroupController.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RepeaterGroupController.h"
#import "GroupCardViewTransmitCell.h"
#import "photoSectionHeader.h"
#import "DWBubbleMenuButton.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "GroupCardModel.h"
#import "LaunchEventController.h"
#import "PublishVoteController.h"
#import "PublishSeekHelp.h"
#import "Interaction.h"
#import "TemplateModel.h"
#import "UIImageView+DLGetWebImage.h"
@interface RepeaterGroupController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property UILabel* titleLabel;
@property float cellWidth;
@property float cellHeight;
@end

@implementation RepeaterGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNet];
//    [self makeFalseData];
    [self builtInterface];
}
- (void)requestNet{
    Account *acc= [AccountTool account];
    [RestfulAPIRequestTool routeName:@"getGroupList" requestModel:acc useKeys:@[@"ID"] success:^(id json) {
        [self analyDataWithJson:json];
                //NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
                //NSLog(@"failed:-->%@",errorJson);
    }];
    
}

//解析返回的数据
- (void)analyDataWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    
    for (NSDictionary *dic  in [json objectForKey:@"groups"]) {
        GroupCardModel *group = [[GroupCardModel alloc]init];
        [group setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:group];
    }
    [self.groupListCollection reloadData];
}

- (void)makeFalseData
{
    self.modelArray = [NSMutableArray array];
    NSArray *array = @[@"已经转发的小队"];
    for (NSString *str in array) {
        
        NSDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:str forKey:@"title"];
        NSMutableArray *tempArray = [NSMutableArray array];
        NSInteger inte = arc4random() % 15+5;
        for (int i = 0; i < inte; i++) {
            [tempArray addObject:@"动梨基地"];
        }
        [dic setValue:tempArray forKey:@"array"];
        [self.modelArray addObject:dic];
    }
}

- (void)builtInterface
{
    //添加高斯模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, DLScreenWidth, DLScreenHeight);
    [self.view addSubview:effectview];
    //添加标题label
    self.titleLabel = [UILabel new];
    NSString* titleStr =  @"选择转发的小队";
    UIFont* titleFont = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.text = titleStr;
    [self.titleLabel setTextColor:RGB(0xfd, 0xb9, 0x0)];
    CGSize maxTitleLabelSize = CGSizeMake(DLScreenWidth, 30);
    CGSize trueTitleLabelSize = [titleStr sizeWithFont:titleFont constrainedToSize:maxTitleLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.titleLabel.size = trueTitleLabelSize;
    self.titleLabel.x = (DLScreenWidth-self.titleLabel.width)/2.0;
    self.titleLabel.y = 57;
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    //添加分割线
    UIView* separater = [UIView new];
    separater.backgroundColor = [UIColor whiteColor];
    separater.x = 10;
    separater.y = CGRectGetMaxY(self.titleLabel.frame) + 40;
    separater.width = DLScreenWidth-DLMultipleWidth(11.0)*2;
    separater.height= 1;

    //添加collectionview
    NSInteger interval = 10;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(interval, interval , interval, interval);
    //添加一个头
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 30);
    CGRect frame = CGRectMake(0, CGRectGetMaxY(separater.frame)+10, DLScreenWidth, (DLScreenHeight-CGRectGetMaxY(separater.frame)-10)/3.0*2);
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    //进行模态窗口时，需要设置背景色的透明度
    [self.groupListCollection setBackgroundColor:[UIColor clearColor]];
    [self.groupListCollection registerClass:[GroupCardViewTransmitCell class] forCellWithReuseIdentifier:@"groupCardTransmitCell"];
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    
//    [self.groupListCollection registerClass:[photoSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section"];
    //添加关闭按钮
    UIButton* closeBtn = [UIButton new];
    NSInteger closeBtnRadius = DLMultipleWidth(20.0);
//    [closeBtn setBackgroundColor:RGB(0xfd, 0xb9, 0)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    closeBtn.width = closeBtnRadius*2;
    closeBtn.height = closeBtnRadius*2;
    closeBtn.x = DLScreenWidth/2-closeBtnRadius;
    closeBtn.y =CGRectGetMaxY(self.groupListCollection.frame)+(DLScreenHeight-CGRectGetMaxY(self.groupListCollection.frame))/2-closeBtnRadius;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:separater];
    [self.view addSubview:self.groupListCollection];
    [self.view addSubview:closeBtn];
    
}

#pragma mark UICollectionViewController delegate data source
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    photoSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section" forIndexPath:indexPath];
//    [header setBackgroundColor:[UIColor clearColor]];
//    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
//    NSString *str = [dic objectForKey:@"title"];
//    header.label.text = str;
//    header.label.textColor = [UIColor orangeColor];
//    return header;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger interval = 10;
    NSInteger width = (DLScreenWidth - 4 * interval)/3.0;
    self.cellWidth=width;
    self.cellHeight=DLMultipleHeight(126.0);
    return CGSizeMake(width, DLMultipleHeight(126.0));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCardViewTransmitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardTransmitCell" forIndexPath:indexPath];
    GroupCardModel* g = [self.modelArray objectAtIndex:indexPath.row];
    [cell cellReconsitutionWithModel:g];
    //for debug
//    [cell.groupImageView setImage:[UIImage imageNamed:@"mzx.jpg"]];
    [cell.groupImageView dlGetRouteThumbnallWebImageWithString:g.logo placeholderImage:nil withSize:CGSizeMake(self.cellWidth*2, self.cellHeight*2)];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
    //初始化参数
    GroupCardModel* group = [self.modelArray objectAtIndex:indexPath.row];
    [self.model setTarget:group.groupId];
    [self.model setTargetType:[NSNumber numberWithInt:2]];
    UIViewController* v ;
    if (self.type == RepeaterGroupTranimitTypeActtivity) {
        v = [[LaunchEventController alloc] init];
        [(LaunchEventController*)v setIsTemplate:true];
        [(LaunchEventController*)v setModel:self.model];
        
    }else if (self.type == RepeaterGroupTranimitTypeVote) {
        v = [[PublishVoteController alloc] init];
        [(PublishVoteController*)v setIsTemplate:true];
        [(PublishVoteController*)v setModel:self.model];
        
    }else if (self.type == RepeaterGroupTranimitTypeHelp) {
        v = [[PublishSeekHelp alloc] init];
        [(PublishSeekHelp*)v setModel:self.model];
        
    }
    // 判断是否已经转发
    Account *acc= [AccountTool account];
    TemplateModel * model = [TemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateId:self.model.ID];
    [model setTemplateType:[NSNumber numberWithInt:self.type]];
    
    [RestfulAPIRequestTool routeName:@"getTemplateValidate" requestModel:model useKeys:@[@"templateType",@"templateId",@"userId"] success:^(id json) {
        NSLog(@"success:-->%@",json);
        for (NSDictionary* dic in [json objectForKey:@"teams"]) {
            if ([[dic objectForKey:@"_id"] isEqualToString:group.groupId]) {
                Boolean isTrue = [[dic objectForKey:@"published"] boolValue];
                if (isTrue) {
                    NSLog(@"已转发");
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该小队已转发！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }else{
                    if (v) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self.context pushViewController:v animated:YES];
                        }];
                    }
                }
            }
        }
    } failure:^(id errorJson) {
        NSLog(@"failed:-->%@",errorJson);
    }];
    
    
    
}

- (void)closeBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
