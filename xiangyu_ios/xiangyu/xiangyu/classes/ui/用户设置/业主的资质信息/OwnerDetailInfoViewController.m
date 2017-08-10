//
//  OwnerDetailInfoViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/11.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "OwnerDetailInfoViewController.h"
#import "UserInfoTableViewCell.h"

static NSString *ownerDetailInfoCellId = @"ownerDetailInfoCellId";
@interface OwnerDetailInfoViewController ()

@end

@implementation OwnerDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    
}

-(void) initHeaderView{
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"资质信息" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    [self.view sendSubviewToBack:self.headerView];
    
}

-(void) initBodyView{
    
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:ownerDetailInfoCellId];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 7;
    }else{
        return 3;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    return 27;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(10, 0, screen_width - 20, 27);
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [label setText:@"结算帐户信息"];
    [headerView.contentView addSubview:label];
    return headerView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ownerDetailInfoCellId forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [cell.title setText:@"姓名"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 1){
            [cell.title setText:@"性别"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 2){
            [cell.title setText:@"手机号码"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 3){
            [cell.title setText:@"身份证号"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 4){
            [cell.title setText:@"紧急联系人"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 5){
            [cell.title setText:@"联系人电话"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 6){
            [cell.title setText:@"联系人关系"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
        }

    }else{
        if(indexPath.row == 0){
            [cell.title setText:@"开户行"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 1){
            [cell.title setText:@"账户名"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 2){
            [cell.title setText:@"账号"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
