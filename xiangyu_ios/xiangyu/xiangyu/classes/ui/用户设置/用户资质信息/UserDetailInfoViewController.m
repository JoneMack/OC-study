//
//  UserDetailInfoViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "UserDetailInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "IDPhotosCell.h"
#import "UserStore.h"
#import "UserStore.h"

static NSString *userDetailInfoCellId = @"userDetailInfoCellId";
static NSString *userIDPhotosCellId = @"userIDPhotosCellId";
static NSString *userSelectSexCellId = @"userSelectSexCellId";

@interface UserDetailInfoViewController ()

@end

@implementation UserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self setRightSwipeGestureAndAdaptive];
    
    [self loadData];
    
}

-(void) initHeaderView{
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"资质信息" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    [self.view sendSubviewToBack:self.headerView];
    
}

-(void) initBodyView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:userDetailInfoCellId];
    [self.tableView registerClass:[IDPhotosCell class] forCellReuseIdentifier:userIDPhotosCellId];
    
    nib = [UINib nibWithNibName:@"SelectUserSexCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:userSelectSexCellId];
    
}

-(void) initBottomView
{
    [self.saveBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;

}

-(void) loadData
{
    [[UserStore sharedStore] getCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
        self.customerInfo = customerInfo;
        
        [self.tableView reloadData];
    }];
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
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return 25;
    }else{
        return 27;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 55;
    }else{
        return 101;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
    if(section == 0){
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(10, 5, 15, 15);
        [imgView setImage:[UIImage imageNamed:@"tanhao_gray"]];
        [view addSubview:imgView];
        UILabel *txt = [UILabel new];
        [txt setText:@"个人信息及资质信息在签约后将不能修改，请您注意!"];
        [txt setTextColor:[ColorUtils colorWithHexString:text_color_gray2]];
        [txt setFont:[UIFont systemFontOfSize:11]];
        txt.frame = CGRectMake(imgView.rightX+5, 5, screen_width - imgView.rightX - 5, 15);
        [view addSubview:txt];
        [view.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_light_yellow]];
    }else{
        UILabel *txt = [UILabel new];
        [txt setText:@"本人证件照"];
        [txt setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
        [txt setFont:[UIFont systemFontOfSize:11]];
        txt.frame = CGRectMake(10, 0, screen_width - 20, 27);
        [view addSubview:txt];
    }
    return view;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            if(self.selectUserSexCell == nil){
                self.selectUserSexCell = [tableView dequeueReusableCellWithIdentifier:userSelectSexCellId forIndexPath:indexPath];
                [self.selectUserSexCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
            }
            [self.selectUserSexCell renderData:self.customerInfo];
            return self.selectUserSexCell;
        }
        
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userDetailInfoCellId forIndexPath:indexPath];
        if(indexPath.row == 0){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"姓名"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.userName]){
                [cell.content setText:self.customerInfo.userName];
            }
        }else if(indexPath.row == 2){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"手机号码"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.mobile]){
                [cell.content setText:self.customerInfo.mobile];
            }
            [cell.content setEnabled:NO];
        }else if(indexPath.row == 3){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"身份证号"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.idNo]){
                [cell.content setText:self.customerInfo.idNo];
            }
        }else if(indexPath.row == 4){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"紧急联系人"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.emergencyContactName]){
                [cell.content setText:self.customerInfo.emergencyContactName];
            }
        }else if(indexPath.row == 5){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"联系人电话"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.emergencyContactPhone]){
                [cell.content setText:self.customerInfo.emergencyContactPhone];
            }
            
        }else if(indexPath.row == 6){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"联系人关系"];
            [cell.topLine setHidden:YES];
            if(self.customerInfo != nil && [NSStringUtils isNotBlank:self.customerInfo.contactRelation]){
                [cell.content setText:self.customerInfo.contactRelation];
            }
        }
        return cell;
    }else{
        if(self.idPhotosCell == nil){
            self.idPhotosCell = [tableView dequeueReusableCellWithIdentifier:userIDPhotosCellId forIndexPath:indexPath];
            [self.idPhotosCell renderUI];
        }
        if(self.customerInfo != nil){
            [self.idPhotosCell renderData:self.customerInfo];    
        }
        return self.idPhotosCell;
    }
    
}



- (IBAction)saveInfo:(id)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *userName = cell.content.text;
    
    NSString *sex = [self.selectUserSexCell getSelectedSex];
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *mobile = cell.content.text;
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *idNo = cell.content.text;
    
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *emergencyContactName = cell.content.text;
    
    indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *emergencyContactPhone = cell.content.text;
    
    indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *contactRelation = cell.content.text;
    
    NSString *idCardFrontPic = self.idPhotosCell.firstIDPhoto.imgUrl;
    NSString *idCardBackPic = self.idPhotosCell.secondIDPhoto.imgUrl;
    NSString *idCardHandheldPic = self.idPhotosCell.thirdIDPhoto.imgUrl;
    
    [[UserStore sharedStore] updateCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
        
        if(err == nil){
            NSLog(@"修改成功");
            [self.view makeToast:@"修改成功" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }else{
            NSLog(@"修改失败");
            [self.view makeToast:@"修改失败" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
        
    } mobile:mobile userName:userName nickName:userName birthDay:@"" sex:sex headPic:@"" idNo:idNo emergencyContactName:emergencyContactName emergencyContactPhone:emergencyContactPhone contactRelation:contactRelation idCardFrontPic:idCardFrontPic idCardBackPic:idCardBackPic idCardHandheldPic:idCardHandheldPic signFlg:@"" authenticationFlg:@""];
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
