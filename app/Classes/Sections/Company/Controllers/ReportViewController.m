//
//  ReportViewController.m
//  app
//
//  Created by tom on 15/11/2.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "ReportViewController.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"

@interface ReportViewController () <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) NSMutableArray* items;
@property (nonatomic, strong) UIPickerView* picker;
@property (nonatomic) ReportType reportType;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self builtInterface];
}
- (void)builtInterface
{
    [self setupForDismissKeyboard];
    self.items = [[NSMutableArray alloc] initWithObjects:@"淫秽色情",@"敏感信息",@"垃圾营销",@"诈骗",@"人身攻击",@"泄露我的隐私",@"虚假资料", nil];
    self.title = @"举报";
    [self.view setBackgroundColor:RGB(235, 234, 236)];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.okBtn addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"transmit_btn"] forState:UIControlStateNormal];
//    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"transmit_btn"] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:RGB(253, 185, 0)];
    [self.okBtn setBackgroundColor:RGB(253, 185, 0)];

    self.nameLabel.text = [self.data objectForKey:REPORT_TITLE];

    
    //
    UIPickerView* picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    [picker selectRow:0 inComponent:0 animated:NO];
    [self.typeTextField setInputView:picker];
    self.typeTextField.text = [self.items firstObject];
    [self.typeTextField setDelegate:self];
    [self.typeTextField setTintColor:[UIColor clearColor]];
}
- (void)cancelBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)okBtnClicked
{
    NSString* content = self.contentTextView.text;
    if (!content||[content isEqualToString:@""]) {
        content = @"";
    }
    Account * acc = [AccountTool account];
    NSMutableDictionary * data =[[NSMutableDictionary alloc] initWithObjects:@[acc.ID,[NSNumber numberWithInteger:self.reportType],[self.data objectForKey:REPORT_ID],content] forKeys:@[@"userId",@"reportType",@"hostId",@"content"]];
    if (self.reportSection==ReportSectionUser) {
        [data setObject:@"user" forKey:@"hostType"];
    }else if(self.reportSection == ReportSectionActivity) {
        [data setObject:@"activity" forKey:@"hostType"];
    }else if(self.reportSection == ReportSectionHelp) {
        [data setObject:@"question" forKey:@"hostType"];
    }else if(self.reportSection == ReportSectionVote) {
        [data setObject:@"poll" forKey:@"hostType"];
    }else if(self.reportSection == ReportSectionCircle) {
        [data setObject:@"circle" forKey:@"hostType"];
    }else if(self.reportSection == ReportSectionComment) {
        [data setObject:@"comment" forKey:@"hostType"];
    }
    
    [RestfulAPIRequestTool routeName:@"marchingReport" requestModel:data useKeys:@[@"userId",@"hostType",@"hostId",@"reportType",@"content"] success:^(id json) {
        NSLog(@"%@",json);
        [self showMessage:@"举报成功!"];
    } failure:^(id errorJson) {
        NSLog(@"%@",errorJson);
        NSString* msg = @"举报失败";
        if ([errorJson objectForKey:@"msg"]) {
            msg = [errorJson objectForKey:@"msg"];
        }
        [self showMessage:msg];
    }];
}
- (void)showMessage:(NSString*)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}
#pragma mark textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}
#pragma mark pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.reportType = (ReportType)row;
    self.typeTextField.text = [self.items objectAtIndex:row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.items objectAtIndex:row];
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

@end
