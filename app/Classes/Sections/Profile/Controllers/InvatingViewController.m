//
//  InvatingViewController.m
//  app
//
//  Created by burring on 15/8/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InvatingViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "InvatingTableViewCell.h"
@interface InvatingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation InvatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"InvatingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InvatingTableViewCell"];
    [self ReadAllPeoples];
    
}
#pragma tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvatingTableViewCell" forIndexPath:indexPath];
    return cell;
}
-(void)ReadAllPeoples {
    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples) {
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
//        NSLog(@"联系人列表 %@",tmpFirstName);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSLog(@"Last name:%@ %@",tmpFirstName,tmpLastName);
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSLog(@"%@",tmpPhones);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
        }
    }
    //取得本地通信录名柄
/*    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
    //取得本地所有联系人记录
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSLog(@"First name:%@", tmpFirstName);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSLog(@"Last name:%@", tmpLastName);
        //获取的联系人单一属性:Nickname
        NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty);
        NSLog(@"Nickname:%@", tmpNickname);
        //获取的联系人单一属性:Company name
        NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);
        NSLog(@"Company name:%@", tmpCompanyname);
        //获取的联系人单一属性:Job Title
        NSString* tmpJobTitle= (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty);
        NSLog(@"Job Title:%@", tmpJobTitle);
        //获取的联系人单一属性:Department name
        NSString* tmpDepartmentName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty);
        NSLog(@"Department name:%@", tmpDepartmentName);

        //获取的联系人单一属性:Email(s)
        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
        for(NSInteger j = 0; ABMultiValueGetCount(tmpEmails); j++)
        {
            NSString* tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
            NSLog(@"Emails%ld:%@", (long)j, tmpEmailIndex);
        
        }
        CFRelease(tmpEmails);
        //获取的联系人单一属性:Birthday
        NSDate* tmpBirthday = (__bridge NSDate*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty);
        NSLog(@"Birthday:%@", tmpBirthday);
        //获取的联系人单一属性:Note
        NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNoteProperty);
        NSLog(@"Note:%@", tmpNote);
        //获取的联系人单一属性:Generic phone number
//        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
//        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
//        {
//            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
//            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
//        }
    }
 */
    
 
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
