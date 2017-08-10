//
//  ZhuanJiaDetailController.m
//  DrAssistant
//
//  Created by hi on 15/9/6.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanJiaDetailController.h"
#import "ZhuanJiaDetailHeader.h"
#import "MyDoctorHeader.h"
#import "ChatViewController.h"
#import "MenZhenYuYueController.h"

@interface ZhuanJiaDetailController ()<ZhuanJiaDetailHeaderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZhuanJiaDetailHeader *header;
@end

@implementation ZhuanJiaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"医生详情";
    
    self.header = [ZhuanJiaDetailHeader initWithNib];
    self.header.delegate = self;
    
    self.header.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.header;
    self.tableView.backgroundColor = [UIColor defaultBgColor];
    
    self.header.nameLabel.text = self.zhuanJiaInfo.REAL_NAME;
    self.header.avatarImageView.layer.cornerRadius = self.header.avatarImageView.frame.size.width/2;
    self.header.avatarImageView.layer.masksToBounds = YES;
    [self.header.avatarImageView sd_setImageWithURL:[NSURL URLWithString: self.zhuanJiaInfo.thumb] placeholderImage:[UIImage placeholderAvater]];
//    
//    CGFloat radius = 15.0;
//    self.header.menZhenYuYue.layer.cornerRadius = radius;
//    self.header.zaixianlianxi.layer.cornerRadius = radius;
    if ([self.zhuanJiaxiangQingType isEqualToString:@"isTongHang"])
    {
        self.header.menZhenYuYue.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ZhuanJiaDetailHeaderAction:(UIButton *)btn
{
    switch (btn.tag) {
        case ZaiXianLianXiTag:
        {
            [self zaiXianLianXi];
        }
            break;
            
        case menZhenYuYueTag:
        {
            MenZhenYuYueController *menZhen = [MenZhenYuYueController simpleInstance];
            menZhen.dataEntity = self.zhuanJiaInfo;
            [self.navigationController pushViewController:menZhen animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:return 1;
        case 1:return 3;
        case 2:return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static  NSString  *CellIdentiferId = @"zhuanjiaCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
        //cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    };
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.zhuanJiaInfo.docDesc.length == 0) {
                cell.textLabel.text = @"简介：暂无信息";
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"简介：%@", self.zhuanJiaInfo.docDesc];
            }
            
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (self.zhuanJiaInfo.POST.length == 0) {
                        cell.textLabel.text = @"职称：暂无信息";
                    }
                    else
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"职称：%@", self.zhuanJiaInfo.POST];
                    }
                }
                    
                    break;
                case 1:
                {
                    if (self.zhuanJiaInfo.major.length == 0) {
                        cell.textLabel.text = @"科室：暂无信息";
                    }
                    else
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"科室：%@", self.zhuanJiaInfo.major];
                    }
                }
                    break;
                case 2:
                {
                    if (self.zhuanJiaInfo.address.length == 0) {
                        cell.textLabel.text = @"医院：暂无信息";
                    }
                    else
                    {
                        if([self.zhuanJiaInfo.address rangeOfString:@"-"].length){
                            NSArray *mpArray = [self.zhuanJiaInfo.address componentsSeparatedByString:@"-"] ;
                            cell.textLabel.text = [NSString stringWithFormat:@"医院：%@", mpArray[1]];
                        }else{
                            cell.textLabel.text = @"医院：暂无信息";
                        }
                        
                    }
                    
                }
                    
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2:
        {
            if (self.zhuanJiaInfo.SPECIALITY.length == 0) {
                cell.textLabel.text = @"专长：暂无信息";
            }
            else
            {
                 cell.textLabel.text = [NSString stringWithFormat:@"专长：%@",  self.zhuanJiaInfo.SPECIALITY];
            }
            
            break;
        }
    }
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
//    switch (section) {
//        case 0:{label.text = @"  医生简介";break;}
//        case 1:{label.text = @"  职业信息";break;}
//        case 2:{label.text = @"  专长";break;}
//    }
//    return label;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:{return @"医生简介";}
        case 1:{return @"职业信息";}
        case 2:{return @"专长";}
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:return 50;
        case 1:return 30;
        case 2:return 50;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - chat
- (void)zaiXianLianXi
{
    EMBuddy *buddy = [EMBuddy buddyWithUsername: self.zhuanJiaInfo.LOGIN_NAME];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:buddy.username]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.username isGroup:NO];
    chatVC.title = self.zhuanJiaInfo.REAL_NAME;
    chatVC.msg_type=patient_to_doctor;
    [self.navigationController pushViewController:chatVC animated:YES];
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
