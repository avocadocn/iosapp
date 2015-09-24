//
//  GroupCoverSetting.m
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "RestfulAPIRequestTool.h"
#import "UIImageView+DLGetWebImage.h"
#import "GroupDetileModel.h"
#import "GroupCoverSetting.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AmendGroupName.h"
typedef NS_ENUM(NSInteger, ChangeState) {
    ChangeStateNo,
    ChangeStateName,
    ChangeStateAll
};

@interface GroupCoverSetting ()<UITableViewDataSource, UITableViewDelegate, DNImagePickerControllerDelegate, AmendGroupNameDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *stringArray;
@property (nonatomic, strong)UIImageView *headerView;

@property (nonatomic, assign)ChangeState state;

@end

static NSString *ID = @"fserklfjkdsrhdj";

@implementation GroupCoverSetting

- (void)awakeFromNib
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.title = @"社团信息管理";
    
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenWidth)];
    [self.headerView dlGetRouteWebImageWithString:self.detileModel.logo placeholderImage:nil];
    
    self.tableview.tableHeaderView = self.headerView;
    self.stringArray = [NSMutableArray arrayWithObjects:@"更换封面",self.detileModel.name, nil];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = view;
    
    [self.view addSubview:self.tableview];
//    self.view insertSubview:<#(UIView *)#> aboveSubview:<#(UIView *)#>
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGroup" object:<#(id)#> userInfo:<#(NSDictionary *)#>];
    
    [self.view bringSubviewToFront:self.cancleButton];
    [self.view bringSubviewToFront:self.OKButton];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [self.stringArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            DNImagePickerController *im = [[DNImagePickerController alloc]init];
            im.allowSelectNum = 1;
            im.imagePickerDelegate = self;
            [self.navigationController presentViewController:im animated:YES completion:nil];
            
        }
            break;
        case 1:{
            
            AmendGroupName *am = [[AmendGroupName alloc]initWithNibName:@"AmendGroupName" bundle:nil];
            am.delegate = self;
            am.detileModel = self.detileModel;
            [self.navigationController pushViewController:am animated:YES];
        }
        default:
            break;
    }
}

- (void)sendNewName:(NSString *)str
{
    [self.stringArray replaceObjectAtIndex:1 withObject:str];
    [self.tableview reloadData];
    self.state = ChangeStateName;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    
    self.state = ChangeStateAll;
    DNAsset *dnasser = [imageAssets firstObject];
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library assetForURL:dnasser.url resultBlock:^(ALAsset *asset) {
        
        self.headerView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)cancleButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)OKButtonAction:(id)sender {
    
    switch (self.state) {
        case ChangeStateNo:
        {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"失败" message:@"您未作任何修改" delegate: self cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
            [al show];
        }            break;
         case ChangeStateName:
        {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.detileModel.ID, [self.stringArray objectAtIndex:1]] forKeys:@[@"groupId", @"name"]];
            
            [RestfulAPIRequestTool routeName:@"editeGroupsInfos" requestModel:dic useKeys:@[@"groupId", @"name"] success:^(id json) {
                NSLog(@"修改成功   %@", json);
                
                
            } failure:^(id errorJson) {
                NSLog(@"修改失败   %@", errorJson);
            }];
        }
            case ChangeStateAll:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[self.detileModel.ID, [self.stringArray objectAtIndex:1]] forKeys:@[@"groupId", @"name"]];
            [dic setObject:@[@{@"data":UIImagePNGRepresentation(self.headerView.image), @"name":@"photo"}] forKey:@"photo"];
            
            // 图片也得换
            [RestfulAPIRequestTool routeName:@"editeGroupsInfos" requestModel:dic useKeys:@[@"groupId", @"name", @"photo"] success:^(id json) {
                NSLog(@"成功  %@", json);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGroup" object:nil userInfo:nil];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改成功" message:[json objectForKey:@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
                NSDictionary * tempDic = [NSDictionary dictionaryWithObject:self.headerView.image forKey:@"image"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeGroupAlbumPhoto" object:nil userInfo:tempDic];
                
            } failure:^(id errorJson) {
                NSLog(@"失败  %@",  errorJson);
            }];
            
            
        }
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
