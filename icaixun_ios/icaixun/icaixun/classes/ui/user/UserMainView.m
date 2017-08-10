//
//  UserMainView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "UserMainView.h"
#import "UIView+Custom.h"
#import "AboutUsController.h"
#import "ChangePwdViewController.h"
#import "PayHistoryViewController.h"
#import "SubscribeHistoryViewController.h"
#import "SettingUserInfoViewController.h"
#import "InviteUserViewController.h"

@implementation UserMainView

-(id) initWithNavigationController:(UINavigationController *)navigationController frame:(CGRect) frame
{
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
        self.frame = frame;
        
        [self setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
        CGRect mainTableFrame = CGRectMake(0 , 0 ,
                                           screen_width, frame.size.height);
        self.mainTableView = [[UITableView alloc] initWithFrame:mainTableFrame style:UITableViewStylePlain];
        self.mainTableView.backgroundColor = [ColorUtils colorWithHexString:gray_common_color];
        self.mainTableView.dataSource = self;
        self.mainTableView.delegate = self;
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.mainTableView];
    }
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {

            return 6;
//    }
//    else if(section == 1){
//        return 0;
//    }
//    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userMainIdentifier = @"mainTableViewCell";
    UserMainCellView *cell = [tableView dequeueReusableCellWithIdentifier:userMainIdentifier];
    if (cell == nil) {
        cell = [[UserMainCellView alloc] initWithReuseIdentifier:userMainIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([AppStatus sharedInstance].myAccount != 0) {
                [cell fillIconAndTitle:@"icon_money" title:@"我的财币" firstCell:YES lastCell:NO];
            }
        }else if (indexPath.row == 1) {
            if ([AppStatus sharedInstance].orderRecord != 0) {
                [cell fillIconAndTitle:@"icon_section" title:@"订阅记录" firstCell:NO lastCell:NO];
            }
        }else if (indexPath.row == 2) {
            [cell fillIconAndTitle:@"icon_pen" title:@"修改个人信息" firstCell:NO lastCell:NO];
        }else if (indexPath.row == 3) {
            [cell fillIconAndTitle:@"icon_lock" title:@"修改密码" firstCell:NO lastCell:NO];
        }else if(indexPath.row == 4){
            if ([AppStatus sharedInstance].recommend != 0) {
                [cell fillIconAndTitle:@"icon_gift" title:@"推荐有奖" firstCell:NO lastCell:NO];
            }
        }
        else if (indexPath.row == 5) {
            [cell fillIconAndTitle:@"icon_i" title:@"关于我们" firstCell:NO lastCell:YES];
        }
    }
//    else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            [cell fillIconAndTitle:@"icon_phone" title:@"联系方式" firstCell:YES lastCell:NO];
//        }else if (indexPath.row == 1) {
//            [cell fillIconAndTitle:@"icon_i" title:@"关于我们" firstCell:NO lastCell:YES];
//        }
//    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([AppStatus sharedInstance].myAccount == 0) {
            return 0;
        }else{
            return general_cell_height;
        }
    }else if (indexPath.row == 1){
        if ([AppStatus sharedInstance].orderRecord == 0) {
            return 0;
        }else{
            return general_cell_height;
        }
    }else if (indexPath.row == 4){
        if ([AppStatus sharedInstance].recommend == 0) {
            return 0;
        }else{
            return general_cell_height;
        }
    }
    else{
        return general_cell_height;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PayHistoryViewController *payHistoryController = [[PayHistoryViewController alloc] init];
        [self.navigationController pushViewController:payHistoryController animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
        SubscribeHistoryViewController *historyController = [SubscribeHistoryViewController new];
        [self.navigationController pushViewController:historyController animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 2){
        
        SettingUserInfoViewController *settingController = [SettingUserInfoViewController new];
        [self.navigationController pushViewController:settingController animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        AppStatus *appStatus = [AppStatus sharedInstance];
        ChangePwdViewController *changePwdController = [[ChangePwdViewController alloc] init];
        changePwdController.env = @"inner";
        changePwdController.userId = appStatus.user.id;
        [self.navigationController pushViewController:changePwdController animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 4){
        
        InviteUserViewController *inviteUserController = [[InviteUserViewController alloc] init];
        [self.navigationController pushViewController:inviteUserController animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        AboutUsController *aboutUsController = [[AboutUsController alloc] init];
        [self.navigationController pushViewController:aboutUsController animated:YES];
    }
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        
//        //拨打电话
//        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"18663824658"]];
//        
//        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
//        
//        if(!canOpen){//不能打开
//            NSLog(@"不能打开 拨打电话");
//            return;
//        }else{
//            NSLog(@"能打开电话");
//        }
//        
//        //打电话
//        NSURLRequest *request=[NSURLRequest requestWithURL:url];
//        UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        [phoneCallWebView loadRequest:request];
//        
//        [self addSubview:phoneCallWebView];
//        
//    }else if (indexPath.section == 1 && indexPath.row == 1) {
//        AboutUsController *aboutUsController = [[AboutUsController alloc] init];
//        [self.navigationController pushViewController:aboutUsController animated:YES];
//    }
}


@end


@implementation UserMainCellView

-(id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void) fillIconAndTitle:(NSString *)iconName title:(NSString *)title firstCell:(BOOL)firstCell lastCell:(BOOL)lastCell
{
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    
    [self.contentView addSubview:self.icon];
    CGRect iconFrame = CGRectMake(20, 7, 30, 30);
    self.icon.frame = iconFrame;
    
    self.title = [[UILabel alloc] init];
    self.title.text = title;
    [self.contentView addSubview:self.title];
    CGRect titleFrame = CGRectMake(self.icon.rightX + 10, 7, 200, 30);
    self.title.frame = titleFrame;
    
    self.upSeparatorLine = [[UIView alloc] init];
    self.upSeparatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    self.downSeparatorLine = [[UIView alloc] init];
    self.downSeparatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    if (firstCell) {
        self.upSeparatorLine.frame = CGRectMake( 0, 0, screen_width, splite_line_height);
        [self addSubview:self.upSeparatorLine];
        self.downSeparatorLine.frame = CGRectMake( 15, self.frame.size.height-splite_line_height ,
                                              screen_width-15, splite_line_height);
        [self addSubview:self.downSeparatorLine];
    }
    if (lastCell) {
        self.downSeparatorLine.frame = CGRectMake( 0, self.frame.size.height-splite_line_height ,
                                              screen_width, splite_line_height);
        [self addSubview:self.downSeparatorLine];
    }
    
    if (!firstCell && !lastCell) {
        self.downSeparatorLine.frame = CGRectMake( 15, self.frame.size.height-splite_line_height ,
                                              screen_width-15, splite_line_height);
        [self addSubview:self.downSeparatorLine];
    }
    
}

@end
