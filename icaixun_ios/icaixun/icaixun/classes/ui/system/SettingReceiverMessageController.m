//
//  SettingReceiverMessageController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/28.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "SettingReceiverMessageController.h"
#import "UserStore.h"

@interface SettingReceiverMessageController ()


@property (nonatomic , strong) HeaderView *headerView;

@property (strong, nonatomic) UIView *bodyView;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingReceiverMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initHeaderView];
    
    [self initTableView];
    
}

- (void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"推送设置" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}


-(void) initTableView
{
    
    self.bodyView = [UIView new];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.view addSubview:self.bodyView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(15, 15, screen_width - 30, 123);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self.bodyView addSubview:self.tableView];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"接收全部消息"];
        if ([self.expert.massageReceiveStatus isEqualToString:@"allOn"]) {
            UIImageView *selectIcon = [UIImageView new];
            selectIcon.frame = CGRectMake(screen_width - 30 - 35, 8, 25, 25);
            selectIcon.image = [UIImage imageNamed:@"icon_select"];
            [cell addSubview:selectIcon];
        }
    }else if (indexPath.row == 1) {
        [cell.textLabel setText:@"只接收私密消息"];
        if ([self.expert.massageReceiveStatus isEqualToString:@"secretOn"]) {
            UIImageView *selectIcon = [UIImageView new];
            selectIcon.frame = CGRectMake(screen_width - 30 - 35, 8, 25, 25);
            selectIcon.image = [UIImage imageNamed:@"icon_select"];
            [cell addSubview:selectIcon];
        }
    }else if (indexPath.row == 2) {
        [cell.textLabel setText:@"不接收消息"];
        if ([self.expert.massageReceiveStatus isEqualToString:@"off"]) {
            UIImageView *selectIcon = [UIImageView new];
            selectIcon.frame = CGRectMake(screen_width - 30 - 35, 8, 25, 25);
            selectIcon.image = [UIImage imageNamed:@"icon_select"];
            [cell addSubview:selectIcon];
        }
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_common_color];
    separatorLine.frame = CGRectMake(0, 40.5, self.tableView.frame.size.width , splite_line_height);
    [cell addSubview:separatorLine];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString *status = nil;
    if (row == 0) {
        status = @"allOn";
    }else if(row == 1){
        status = @"secretOn";
    }else{
        status = @"off";
    }
    
    [[UserStore sharedStore] updateReceiveStatus:^(NSError *err) {
        if(err == nil){
            self.expert.massageReceiveStatus = status;
            [self.tableView reloadData];
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
    } expertId:self.expert.id status:status];
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
