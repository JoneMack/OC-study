//
//  ContractDetailViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/11.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ContractDetailViewController.h"
#import "UserInfoTableViewCell.h"
#import "ContractDetailCell.h"
#import "OwnerDetailInfoViewController.h"
#import "UserDetailInfoViewController.h"

static NSString *contractFirstTypeCellId = @"contractFirstTypeCellId";
static NSString *contractSecondTypeCellId = @"contractSecondTypeCellId";

@interface ContractDetailViewController ()

@end

@implementation ContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"合同详情" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    [self.view sendSubviewToBack:self.headerView];
}


-(void) initBodyView{

    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:contractFirstTypeCellId];
    
    nib = [UINib nibWithNibName:@"ContractDetailCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:contractSecondTypeCellId];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 7;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    return 27;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 55;
    }
    return 98;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(10, 0, screen_width - 20, 27);
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [label setText:@"第三期"];
    [headerView.contentView addSubview:label];
    return headerView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contractFirstTypeCellId forIndexPath:indexPath];
        if(indexPath.row == 0){
            [cell.title setText:@"合同编号"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
            
        }else if(indexPath.row == 1){
            [cell.title setText:@"房源地址"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 2){
            [cell.title setText:@"合同租期"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 3){
            [cell.title setText:@"房屋租金"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 4){
            [cell.title setText:@"结算方式"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 5){
            [cell.title setText:@"物业交割"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.rightArrow setHidden:YES];
        }else if(indexPath.row == 6){
            [cell.title setText:@"个人信息"];
            [cell.avatarView setHidden:YES];
            [cell.topLine setHidden:YES];
            [cell.content setHidden:YES];
        }
        return cell;
    }else{
        ContractDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:contractSecondTypeCellId forIndexPath:indexPath];
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 6){
            if([self.userType isEqualToString:@"user"]){
                UserDetailInfoViewController *userDetailController = [[UserDetailInfoViewController alloc] init];
                [self.navigationController pushViewController:userDetailController animated:YES];
            }else{
                OwnerDetailInfoViewController *ownerDetailController = [[OwnerDetailInfoViewController alloc] init];
                [self.navigationController pushViewController:ownerDetailController animated:YES];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
