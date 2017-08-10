//
//  LeftBodyView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "LeftBodyView.h"
#import "UIButton+WebCache.h"

static NSString *leftBodyViewCellId = @"leftBodyViewCellId";

@implementation LeftBodyView


-(instancetype) initWithNavigationController:(UINavigationController *) navigationController
{
    self = [super init];
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"LeftBodyView"
                                              owner:self options:nil] lastObject];
        self.navigationController = navigationController;
        [self setBackgroundColor:[ColorUtils colorWithHexString:bg_deep_gray_color]];
        [self initHeaderView];
        [self initBodyView];
        [self initBottomView];
        [self renderUserInfo];
        
    }
    return self;
}

-(void) initHeaderView{
}

-(void) initBodyView{
    
    [self.tableView setBackgroundColor:[ColorUtils colorWithHexString:bg_deep_gray_color]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    // 注册cell class
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:leftBodyViewCellId];
}

-(void) initBottomView{
    [self.phone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}



#pragma mark  返回 cell 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark 渲染 cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftBodyViewCellId forIndexPath:indexPath];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[ColorUtils colorWithHexString:@"595959"]];
    separatorLine.frame = CGRectMake(0, 0, screen_width, splite_line_height);
    [cell addSubview:separatorLine];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[ColorUtils colorWithHexString:bg_deep_gray_color]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.row == 0){
        [cell.imageView setImage:[UIImage imageNamed:@"star_white"]];
        [cell.textLabel setText:@"收藏约看"];
    }else if(indexPath.row == 1){
        [cell.imageView setImage:[UIImage imageNamed:@"note_white"]];
        [cell.textLabel setText:@"账单管理"];
    }else if(indexPath.row == 2){
        [cell.imageView setImage:[UIImage imageNamed:@"youhujuan_white"]];
        [cell.textLabel setText:@"优 惠 券"];
    }else if(indexPath.row == 3){
        [cell.imageView setImage:[UIImage imageNamed:@"hetong_white"]];
        [cell.textLabel setText:@"我的合同"];
    }else if(indexPath.row == 4){
        [cell.imageView setImage:[UIImage imageNamed:@"zhinengsuo_white"]];
        [cell.textLabel setText:@"智 能 锁"];
//    }else if(indexPath.row == 99){
//        [cell.imageView setImage:[UIImage imageNamed:@"msg_white"]];
//        [cell.textLabel setText:@"消息中心"];
    }else if(indexPath.row == 5){
        [cell.imageView setImage:[UIImage imageNamed:@"setting_white"]];
        [cell.textLabel setText:@"设  置"];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[ColorUtils colorWithHexString:@"595959"]];
        separatorLine.frame = CGRectMake(0, 49.5, screen_width, splite_line_height);
        [cell addSubview:separatorLine];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppStatus *as = [AppStatus sharedInstance];
    if(![as logined]){
        // 跳到登录页
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_user_login_view object:nil];
        return ;
    }
    
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_user_collection_look_view object:nil];
    }else if(indexPath.row == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_coupon_view object:nil];
    }else if(indexPath.row == 3){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_my_contract_view object:nil];
    }else if(indexPath.row == 4){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_smart_lock_view object:nil];
//    }else if(indexPath.row == 5){
//        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_message_center_view object:nil];
    }else if(indexPath.row == 5){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_user_setting_view object:nil];
    }
}


-(void) renderUserInfo
{
    AppStatus *as = [AppStatus sharedInstance];
    
    if([as logined]){
        [self.loginBtn setTitle:as.user.userName forState:UIControlStateNormal];
    }else{
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    if([as logined] && [NSStringUtils isNotBlank:as.user.headPic]){
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:as.user.headPic] forState:UIControlStateNormal];
        
        [self.avatarBtn.layer setMasksToBounds:YES];
        [self.avatarBtn.layer setCornerRadius:38]; //设置矩形四个圆角半径
        [self.avatarBtn.layer setBorderWidth:2]; //边框宽度
        [self.avatarBtn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
        

    }else{
        [self.avatarBtn setImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
        [self.avatarBtn.layer setMasksToBounds:NO];
        [self.avatarBtn.layer setBorderWidth:0]; //边框宽度
        [self.avatarBtn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    }
}


- (IBAction)userLogin:(id)sender {
    
    AppStatus *as = [AppStatus sharedInstance];
    if(![as logined]){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_go_in_user_login_view object:nil];
    }
    
    
}

- (IBAction)phoneEvent:(id)sender {
    
    //拨打电话
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4009515515"]];
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    
    if(!canOpen){//不能打开
        NSLog(@"不能打开 拨打电话");
        return;
    }else{
        NSLog(@"能打开电话");
    }
    
    //打电话
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:request];
    
    [self addSubview:phoneCallWebView];

}



@end
