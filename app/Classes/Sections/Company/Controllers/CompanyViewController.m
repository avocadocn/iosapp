//
//  CompanyViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//
#import "SchoolFirstPageCell.h"
#import "CircleContextModel.h"
#import "SchoolTempModel.h"
#import <AFNetworking.h>
#import "AddressBookModel.h"
#import "CompanyViewController.h"
#import <ReactiveCocoa.h>
#import "CompanySmallCell.h"
#import "PrefixHeader.pch"
#import "CompanyHeader.h"
#import "ColleagueViewController.h"
#import "PrefixHeader.pch"
#import "CompanyModel.h"
#import "PersonReportController.h"
#import "BrithdayBlessController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "SendSchollTableModel.h"
#import <MJRefresh.h>
@interface CompanyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *photoArray;

@end

@implementation CompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtInterface]; //铺设截面
    [self netRequest];
    [self getRequestNet];
    [self getBrithdayNet];
    [self refreshMJ];
}
- (void)builtInterface
{
    self.photoArray = [NSMutableArray arrayWithArray:@[@"dacxcx", @"grdg", @"dwad"]];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout alloc];
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 85);
    layout.minimumLineSpacing = 11;
    self.BigCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.BigCollection.delegate = self;
    self.BigCollection.dataSource = self;
//    self.BigCollection.backgroundColor = [UIColor cyanColor];
    [self.BigCollection registerClass:[CompanySmallCell class] forCellWithReuseIdentifier:@"SmallCell"]; //注册重用池
//    [self.BigCollection setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.5]];
    
    self.BigCollection.backgroundColor = RGBACOLOR(236, 238, 238, 1);
    [self.BigCollection registerClass:[CompanyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BigHeader"];
    [self.BigCollection registerNib:[UINib nibWithNibName:@"SchoolFirstPageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"sasasasa"];
    
    
    [self.view addSubview:self.BigCollection];
    

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 49  + (((DLScreenWidth - 22 )/ 3.0 - 1 ) * 2);
    
    return CGSizeMake(DLScreenWidth, height);
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     CompanySmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallCell" forIndexPath:indexPath];
    cell.tag = indexPath.row + 1;
    
    if ([[self.photoArray objectAtIndex:indexPath.row] isKindOfClass:[SendSchollTableModel class]])
    {
        SendSchollTableModel *model = [self.photoArray objectAtIndex:indexPath.row];
        [cell interCellWithModel:model];
    }
    
     [cell reloadWithIndexpath:indexPath];
    
    return cell;
*/
    
    SchoolFirstPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sasasasa" forIndexPath:indexPath];
    
    [cell reloadWithIndexpath:indexPath];
    if ([[self.photoArray objectAtIndex:indexPath.row] isKindOfClass:[SendSchollTableModel class]])
    {
        SendSchollTableModel *model = [self.photoArray objectAtIndex:indexPath.row];
        cell.schoolModel = model;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CompanyHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BigHeader" forIndexPath:indexPath];
    header.viewCon = self;
    return header;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    SendSchollTableModel *model = [self.photoArray objectAtIndex:section];
    
    return self.photoArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return self.photoArray.count;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)netRequest {
    AddressBookModel *model = [[AddressBookModel alloc] init];
    
    [model setLimit:10];
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
        NSLog(@"请求成功-- %@",json);
//        [self reloadTableViewWithJson:json];

        if (json) {
            
            SendSchollTableModel *model = [self getPhotoArrayFromJson:json];
            [self.photoArray replaceObjectAtIndex:0 withObject:model];
            
            [self saveDefaultWithJson:json];
            
            [self.BigCollection reloadData];
            
//            [self getRequestNet];
        } else
        {
            NSFileManager *manger = [NSFileManager defaultManager];
            NSArray *tempArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *path = [tempArray lastObject];
            path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
            
            BOOL judge = [manger fileExistsAtPath:path];
            if (judge) {
//                [manger removeObserver:nil forKeyPath:path];
                [manger removeItemAtPath:path error:nil];
            }
        }
        
    } failure:^(id errorJson) {
        NSLog(@"请求失败 %@",errorJson);
    }];
    [self.BigCollection.header endRefreshing];
}

- (void)saveDefaultWithJson:(id)json
{
    NSMutableArray *IDArray = [NSMutableArray array];
    
    for (NSDictionary *jsonDic in json) {
        
        CircleContextModel *model = [[CircleContextModel alloc]init];
        
        NSDictionary *dic = [jsonDic objectForKey:@"content"];
        
        [model setValuesForKeysWithDictionary:dic];
        NSDictionary *poster = [dic objectForKey:@"poster"];
        NSDictionary *target = [dic objectForKey:@"target"];
        model.poster = [[AddressBookModel alloc]init];
        model.target = [[AddressBookModel alloc]init];
        [model.poster setValuesForKeysWithDictionary:poster];
        [model.target setValuesForKeysWithDictionary:target];
        
        NSArray *comments = [jsonDic objectForKey:@"comments"];
        model.comments = [NSMutableArray array];
        for (NSDictionary *tempDic in comments) {
            CircleContextModel *tempModel = [[CircleContextModel alloc]init];
            [tempModel setValuesForKeysWithDictionary:tempDic];
            tempModel.poster = [[AddressBookModel alloc]init];
            tempModel.target = [[AddressBookModel alloc]init];
            NSDictionary *tempPoster = [tempDic objectForKey:@"poster"];
            NSDictionary *tempTarget = [tempDic objectForKey:@"target"];
            [tempModel.poster setValuesForKeysWithDictionary:tempPoster];
            [tempModel.target setValuesForKeysWithDictionary:tempTarget];
            
            [model.comments addObject:tempModel];
        }
        
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];  //得到了 data
//        
        [IDArray addObject:model.ID];
//        [self writeFileWithData:data andAddress:model.ID];

        [model save];
        
    }
    
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *tempArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [tempArray lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
    
    BOOL judge = [manger fileExistsAtPath:path];
    if (judge) {
        
        NSArray *array = [NSArray arrayWithContentsOfFile:path]; //原来的
//        [IDArray removeObjectsInArray:array];
//        IDArray = (NSMutableArray *)[IDArray arrayByAddingObjectsFromArray:array];
        [manger removeItemAtPath:path error:nil];
        
//        NSInteger num = IDArray.count;
//        if (num > 10) {
//            [IDArray removeObjectsInRange:NSMakeRange(10, num - 10)];
//        }
        
        [IDArray writeToFile:path atomically:YES]; // 把ID数据存进去
        
    } else
    {
        [IDArray writeToFile:path atomically:YES];
    }
    
}



- (SendSchollTableModel *)getPhotoArrayFromJson:(id)json
{
    SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
    
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        NSDictionary *content = [dic objectForKey:@"content"];
        NSArray *array = [content objectForKey:@"photos"];
        if (array.count) {
            NSDictionary *tempDic = [array firstObject];
            SchoolTempModel *school = [[SchoolTempModel alloc]init];
            [school setValuesForKeysWithDictionary:tempDic];
            [photoArray addObject:school];
            
        }
        if (photoArray.count == 6) {
//            SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
//            model.photoArray = [NSArray arrayWithArray:photoArray];
//            model.titleName = @"同事圈";
//            model.detileName = @"不一样的精彩";
            model.photoArray = [NSMutableArray arrayWithArray:photoArray];
            return model;
        }
    }
    model.photoArray = [NSMutableArray arrayWithArray:photoArray];
    
    return model;
}

- (void)getRequestNet
{
    Account *acc = [AccountTool account];
    
    //    FreshModel *model =[[FreshModel alloc]init];
    //    [model setCompanyId:acc.cid];
    //    [model setFreshman:NO];
    //    [model setPage:@1];
    
    NSString *str = [NSString stringWithFormat:@"%@/users/list/%@?freshman=%d&page=%@", BaseUrl,acc.cid,YES,@1];
    NSLog(@"请求的网址为 %@", str);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];
    
    [manger GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"获取新人列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@", dic);
        
        SendSchollTableModel *model = [self getImageFromDic:dic];
        
        [self.photoArray replaceObjectAtIndex:1 withObject:model];
        
//        [self.photoArray addObject:model];
        [self.BigCollection reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (SendSchollTableModel *)getImageFromDic: (NSDictionary *)dic
{
    SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    NSArray *array = [dic objectForKey:@"users"];
    int i = 0;
    for (NSDictionary *tempDic in array) {
//        photoArray
        SchoolTempModel *school = [[SchoolTempModel alloc]init];
        [school setValuesForKeysWithDictionary:tempDic];
        [photoArray addObject:school];
        if (i == 3) {
            
            model.photoArray = [NSArray arrayWithArray:photoArray];
            return model;
        }
        i++;
    }
    model.photoArray = [NSArray arrayWithArray:photoArray];
    return model;
    
}

//成功

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getBrithdayNet{
    [RestfulAPIRequestTool routeName:@"getBirthdayList" requestModel:nil useKeys:@[] success:^(id json) {
        NSLog(@" 获取到过生日的用户为%@", json);
        self.modelArray = [NSMutableArray array];
        for (NSDictionary *dic in json) {
            AddressBookModel *model = [[AddressBookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        
        
        SendSchollTableModel *model = [self getBrithdayFromJson:json];
        
        [self.photoArray replaceObjectAtIndex:2 withObject:model];
        
        //        [self.photoArray addObject:model];
        [self.BigCollection reloadData];
        
        
    } failure:^(id errorJson) {
        NSLog(@"获取生日失败");
    }];
}
- (SendSchollTableModel *)getBrithdayFromJson:(id)json
{
    SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    int i = 0;
    
    for (NSDictionary *tempDic in json) {
        //        photoArray
        SchoolTempModel *school = [[SchoolTempModel alloc]init];
        [school setValuesForKeysWithDictionary:tempDic];
        [photoArray addObject:school];
        if (i == 3) {
            
            model.photoArray = [NSArray arrayWithArray:photoArray];
            return model;
        }
        i++;
    }
    model.photoArray = [NSArray arrayWithArray:photoArray];
    return model;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

        switch (indexPath.row) {
                
            case 0:
            {
                ColleagueViewController *coll = [[ColleagueViewController alloc]init];
                [self.navigationController pushViewController:coll animated:YES];
                
            }
                break;
            case 1:
            {
                PersonReportController *report = [[PersonReportController alloc]init];
                [self.navigationController pushViewController:report animated:YES];
            }
                break;
            case 2:
            {
                BrithdayBlessController *brith = [[BrithdayBlessController alloc]init];
                [self.navigationController pushViewController:brith animated:YES];
            }
                break;
            default:
                break;
        }
        NSLog(@"点击");

}

- (void)refreshMJ {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.BigCollection.header = header;
}
- (void)refresh{
    [self netRequest];
    [self getRequestNet];
    [self getBrithdayNet];

}
@end
