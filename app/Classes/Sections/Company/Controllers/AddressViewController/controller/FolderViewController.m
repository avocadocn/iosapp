//
//  FolderViewController.m
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FolderViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "CuntomFolderView.h"
#import "DLDatePickerView.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RestfulAPIRequestTool.h"
#import "AddressBookModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+DLGetWebImage.h"
static NSInteger num = 0;

@interface FolderViewController ()<DLDatePickerViewDelegate, UIAlertViewDelegate, DNImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong)NSMutableArray *infoArray;

@property (nonatomic, strong)UIButton *btn; // 相机按钮

@property (nonatomic, strong)UIButton *changePhotoButton;

@property (nonatomic, assign)BOOL photoChange;

@property (nonatomic, strong)UIPickerView *picker;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation FolderViewController
-(NSMutableArray *)infoArray { // 存放用户个人资料
    if (_infoArray == nil) {
        self.infoArray = [@[]mutableCopy];
    }
    return _infoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtScrollView];
    self.view.backgroundColor = DLSBackgroundColor;
    self.title = @"我的资料";
    
    num = 0;
    [self builtTitleView];  // 设置资料照片
    [self builtInformationView];  //设置资料 label
    if (self.judgeEditState) {
        [self getModel];
        [self editFolder]; //  用户编辑个人资料
    }
}

- (void)builtScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(DLScreenWidth, DLScreenHeight + 180);
    self.scrollView.backgroundColor = RGBACOLOR(238, 239, 240, 1);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:self.scrollView atIndex:0];
}

- (void)getModel{
    AddressBookModel *model = [[AddressBookModel alloc] init];
    Account *account = [AccountTool account];
    [model setUserId:account.ID];
    [self netRequstWithModel:model];
    NSLog(@"++++++++%@",model.userId);
}
- (void)netRequstWithModel:(AddressBookModel *)model { // 获取个人资料
    [RestfulAPIRequestTool routeName:@"getUserInfo" requestModel:model useKeys:@[@"userId"] success:^(id json) {
        NSLog(@"获取的用户信息为 %@",json);
        AddressBookModel *infoModel = [[AddressBookModel alloc] init];
        [infoModel setValuesForKeysWithDictionary:json];
        self.nickName.informationTextField.text = infoModel.nickname;
        self.synopsis.informationTextField.text = infoModel.introduce;
        self.realName.informationTextField.text = infoModel.realname;
        if ([[NSString stringWithFormat:@"%@",infoModel.gender] isEqualToString:@"0"]) {
            self.gender.informationTextField.text = @"女";
        } else {
            self.gender.informationTextField.text = @"男";
        }
        if (infoModel.birthday) {
            self.brithday.informationTextField.text = [infoModel.birthday substringToIndex:10];
                    [self setConstellationsText];// 设置星座
        }
        self.department.informationTextField.text = json[@"department"][@"name"];
        self.phoneNumber.informationTextField.text = infoModel.phone;
            CGFloat width = DLScreenWidth / (375.0 / 150.0);
        [self.folderPhotoImage dlGetRouteThumbnallWebImageWithString:infoModel.photo placeholderImage:nil withSize:CGSizeMake(width, width)];
    } failure:^(id errorJson) {
        NSLog(@"获取个人资料失败原因 %@",errorJson);
    }];
}
- (void)builtTitleView // 照片和选择照片
{
    self.scroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.scroll.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    self.scroll.showsVerticalScrollIndicator = FALSE;
    self.scroll.showsHorizontalScrollIndicator = FALSE;
    [self.scrollView addSubview:self.scroll];
    
    
    CGFloat width = DLScreenWidth / (375.0 / 150.0);
    self.folderPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake((DLScreenWidth - width) / 2, DLMultipleHeight(25.0), width, width)];
//    self.folderPhotoImage.image = [UIImage imageNamed:@"1"];
    self.folderPhotoImage.layer.masksToBounds = YES;
    self.folderPhotoImage.layer.cornerRadius = width / 2.0;
    [self.scroll addSubview:self.folderPhotoImage];
}

- (void)editFolder  //用户看自己的资料, 允许被编辑
{
    self.changePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn = self.changePhotoButton;
    self.btn.userInteractionEnabled = NO;
    [self.changePhotoButton addTarget:self action:@selector(choosePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.changePhotoButton setBackgroundImage:[UIImage imageNamed:@"cemera"] forState:UIControlStateNormal];
    
    [self.scroll addSubview:self.changePhotoButton];
    
    [self.changePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.folderPhotoImage.mas_bottom);
        make.right.mas_equalTo(self.folderPhotoImage.mas_right);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(40.0), DLMultipleWidth(40.0)));
    }];
    
    self.changePhotoButton.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    self.changePhotoButton.alpha = 0;
    self.changePhotoButton.layer.masksToBounds = YES;
    self.changePhotoButton.layer.cornerRadius = DLMultipleWidth(20.0);
    
    
    
    self.editLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [label setBackgroundColor:[UIColor blackColor]];
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editButtonAction:)];
    [self.editLabel addGestureRecognizer:tap];
    self.editLabel.text = @"编辑";
    self.editLabel.textAlignment = NSTextAlignmentRight;
    self.editLabel.font = [UIFont systemFontOfSize:15];
    self.editLabel.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editLabel];
    
}

- (void)buttonState:(BOOL)state
{
    if (state) {
        self.changePhotoButton.alpha = 0;
    }
}

- (void)choosePhotoAction:(UIButton *)sender
{
    DNImagePickerController *image = [[DNImagePickerController alloc]init];
    image.allowSelectNum = 1;
    image.imagePickerDelegate = self;
    
    [self presentViewController:image animated:YES completion:nil];
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
//    DNAsset *dnasset = [imageAssets firstObject];
//    ALAssetsLibrary *lib = [ALAssetsLibrary new];
//    
//    [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset) {
//        
//        UIImage *aImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    self.folderPhotoImage.image = imageAssets[0];//aImage;
        
        self.photoChange = YES;
//    } failureBlock:^(NSError *error) {
//        
//    }];
}



// 编辑按钮
- (void)editButtonAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"编辑");
    
    for (int i = 0; i < [self.companyArray count]-1; i++) {
        CuntomFolderView *view = [self.companyArray objectAtIndex:i];
        if (self.buttonState == EnumOfEditButtonNo) { //未编辑
            view.informationTextField.userInteractionEnabled = YES;
            self.btn.userInteractionEnabled = YES;
            view.informationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            NSLog(@"可以被编辑");
        }
        else
        {
            view.informationTextField.userInteractionEnabled = NO;
            self.btn.userInteractionEnabled = NO;
            NSLog(@"无法编辑");
        }
    }
    if (self.buttonState == EnumOfEditButtonNo) {
        
        self.changePhotoButton.alpha = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrithdayAction:)];
        [self.brithday.informationTextField addGestureRecognizer:tap];
        
        UITapGestureRecognizer *gender = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderAction:)];
        [self.gender.informationTextField addGestureRecognizer:gender];
        self.buttonState = EnumOfEditButtonYes;
        self.editLabel.text = @"完成";
    } else { //写编辑完成后的网络请求
        
        self.changePhotoButton.alpha = 0;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"要保存您的修改吗?" message:nil delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alert show];
        self.editLabel.text = @"编辑";
        self.buttonState = EnumOfEditButtonNo;//编辑完成
    }
}
- (void)genderAction:(UITapGestureRecognizer *)tap
{
    self.gender.informationTextField.userInteractionEnabled = NO;
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DLScreenHeight - DLMultipleHeight(250.0) + 49.0, DLScreenWidth, DLMultipleHeight(250.0))];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;
    self.picker.backgroundColor = [UIColor whiteColor];
    [self.picker selectRow:2 inComponent:0 animated:YES];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    [view addSubview:self.picker];
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnButton setTitle:@"确认" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnButton setBackgroundColor:[UIColor whiteColor]];
    [returnButton addTarget:self action:@selector(returnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [returnButton setBackgroundColor:[UIColor greenColor]];
    [view addSubview:returnButton];
    [returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.picker.mas_top);
        make.right.mas_equalTo(self.picker.mas_right);
        make.left.mas_equalTo(self.picker.centerX);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(returnButton.mas_bottom);
        make.left.mas_equalTo(self.picker.mas_left);
        make.right.mas_equalTo(returnButton.mas_left);
        make.top.mas_equalTo(returnButton.mas_top);
    }];

    
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(tapAction:)]];
    
    
    
    [self.scrollView addSubview:view];
}

- (void)returnButtonAction:(UIButton *)sender
{
    [self pickerDismiss];
    int a =  (int)[self.picker selectedRowInComponent:0];
    self.gender.informationTextField.text = (a == 0 ? @"男" : @"女");

}
- (void)cancelButtonAction:(UIButton *)sender
{
    [self pickerDismiss];

}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self pickerDismiss];
    int a =  (int)[self.picker selectedRowInComponent:0];
    self.gender.informationTextField.text = (a == 0 ? @"男" : @"女");

}
- (void)pickerDismiss
{
    UIView *view = (UIView *)[self.picker superview];
    [view removeFromSuperview];
    self.gender.informationTextField.userInteractionEnabled = YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.gender.informationTextField.text =( row ==  0 ? @"男" : @"女");
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return row == 0 ? @"男" : @"女";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: // 确认修改
        {
            AddressBookModel *model = [[AddressBookModel alloc] init];
            Account *account = [AccountTool account];
            [model setUserId:account.ID];
            for (int i = 1000; i <= 1005; i++) {
               CuntomFolderView *view = (CuntomFolderView *)[self.view viewWithTag:i];
                NSString *str = [NSString stringWithFormat:@"%@",view.informationTextField.text];
                [self.infoArray addObject:str];
            }
            [model setNickname:self.infoArray[0]];
            [model setIntroduce:self.infoArray[1]];
            [model setRealname:self.infoArray[2]];
            if ([self.infoArray[3] isEqualToString:@"男"]) {
                [model setGender:@"1"];
            }
            [model setBirthday:self.infoArray[4]];
            [model setPhone:self.infoArray[5]];
            if (self.photoChange ){
                NSData *data = UIImagePNGRepresentation(self.folderPhotoImage.image);
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[data ,@"photo"] forKeys:@[@"data", @"name"]];
                model.uploadPhoto = [NSArray arrayWithObjects:dic, nil];
            }
        [RestfulAPIRequestTool routeName:@"modifyUserInfo" requestModel:model useKeys:@[@"nickname",@"introduce",@"realname",@"gender",@"birthday",@"phone",@"uploadPhoto",] success:^(id json) {
//            [self netRequstWithModel:model]; // 编辑成功重新请求一次数据
            [self.infoArray removeAllObjects]; // 将存放编辑信息的数组清空
        } failure:^(id errorJson) {
            NSLog(@"编辑失败原因 %@" ,[errorJson objectForKey:@"msg"]);
        }];
            break;
        }
        default:
            break;
    }
}
//点击生日弹出 pickerview
- (void)tapBrithdayAction:(UITapGestureRecognizer *)tap
{
    self.brithday.informationTextField.userInteractionEnabled = NO;
    DLDatePickerView *picker = [[DLDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    picker.delegate = self;
    NSDate *minDate = [self dateFromString:@"1960-01-01"];
    
    NSDate *maxDate = [[NSDate alloc] initWithTimeInterval:- 60 * 60 * 24 * 365 * 3 sinceDate:[NSDate date]];
    [picker reloadWithMaxDate:maxDate minDate:minDate dateMode:UIDatePickerModeDate];
    
    [self.scrollView addSubview:picker];
    [picker show];
}
//pickerview 消失后的方法
- (void)outPutStringOfSelectDate:(NSString *)str withTag:(NSInteger)tag
{
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    self.brithday.informationTextField.text = [array firstObject];
    
    NSString *dateStr = [array firstObject];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    NSString *conste = [self getAstroWithMonth:[[dateArray objectAtIndex:1] intValue] day:[[dateArray objectAtIndex:2] intValue]];
    self.constellation.informationTextField.text = [NSString stringWithFormat:@"%@座",conste];
    self.brithday.informationTextField.userInteractionEnabled = YES;
}
- (void)dismiss
{
    self.brithday.informationTextField.userInteractionEnabled = YES;
}
- (void)setConstellationsText { // 获取数据后设置星座

        NSArray *dateArray = [self.brithday.informationTextField.text componentsSeparatedByString:@"-"];
        NSString *conste = [self getAstroWithMonth:[[dateArray objectAtIndex:1] intValue] day:[[dateArray objectAtIndex:2] intValue]];
        self.constellation.informationTextField.text = [NSString stringWithFormat:@"%@座",conste];
    
}
//判断星座
-(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

//根据输入的日期获取时间
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

- (void)builtInformationView
{
    self.nickName = [CuntomFolderView new];
    self.synopsis = [CuntomFolderView new];
    self.realName = [CuntomFolderView new];
    self.gender = [CuntomFolderView new];
    self.brithday = [CuntomFolderView new];
//    self.department = [CuntomFolderView new];
    self.phoneNumber = [CuntomFolderView new];
    self.constellation = [CuntomFolderView new];
    self.companyArray = @[self.nickName, self.synopsis, self.realName, self.gender, self.brithday, self.phoneNumber, self.constellation];
    NSArray *labelName = @[@"昵       称", @"个人简介", @"真实姓名", @"性       别", @"生       日", @"手机号码", @"星       座"];

    for (CuntomFolderView *view in self.companyArray) {
        view.frame = CGRectMake(0,DLMultipleHeight(200.0) + num * 45, DLScreenWidth, 45);
        view.titleLabel.text = [labelName objectAtIndex:num];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = 1000 + num;

        [self.scroll addSubview:view];
        num ++;
    }
    self.scroll.contentSize = CGSizeMake(0, DLMultipleHeight(200.0) + 45 * num);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

- (void)setFoloderModel:(AddressBookModel *)foloderModel
{
    _foloderModel = foloderModel;
    [self netRequstWithModel:foloderModel];
}


- (void)viewWillAppear:(BOOL)animated  // 注册通知 监测 键盘弹出状态
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification  // 弹出回调

{
//    NSDictionary *userInfo = [aNotification userInfo];
    
//    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    NSTimeInterval animationDuration = [[userInfo
//                                         
//                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    CGRect newFrame = self.scrollView.frame;
//    newFrame.size.height -= keyboardRect.size.height;
    [self.scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
//    [UIView beginAnimations:@"ResizeTextView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    self.view.frame = newFrame;  
    
    [UIView commitAnimations];

}

- (void) keyboardWillHide:(NSNotification *)aNotification {  // 消失回调
    [self.scrollView setContentOffset:CGPointMake(0, - 60) animated:YES];
//    [UIView beginAnimations:@"ResizeTextView" context:nil];

}


- (void)viewDidDisappear:(BOOL)animated
{  // 移除通知
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}


@end
