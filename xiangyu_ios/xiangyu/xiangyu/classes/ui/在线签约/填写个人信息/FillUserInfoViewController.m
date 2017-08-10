//
//  FillUserInfoViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "FillUserInfoViewController.h"
#import "ConfirmRentDateViewController.h"
#import "UserStore.h"


static NSString *fillUserInfoHouseSourceCellId = @"fillUserInfoHouseSourceCellId";
static NSString *fillUserInfoCellId = @"fillUserInfoCellId";
static NSString *fillUserIDPhotosCellId = @"fillUserIDPhotosCellId";

@interface FillUserInfoViewController ()

@end

@implementation FillUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    [self loadCustomerInfoData];
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"在线签约" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    CGRect frame = CGRectMake(0, 64, screen_width, screen_height - 64);
    self.bodyView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
    UINib *nib = [UINib nibWithNibName:@"MainHouseSourceCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:fillUserInfoHouseSourceCellId];
    
    nib = [UINib nibWithNibName:@"UserInfoCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:fillUserInfoCellId];
    
    [self.view addSubview:self.bodyView];
    
}

-(void) loadCustomerInfoData
{
    [[UserStore sharedStore] getCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
        if(err == nil){
            self.customerInfo = customerInfo;
            [self.bodyView reloadData];
        }
    }];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2){
        return 27;
    }
    return 0.00001f;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 130;
    }else if(indexPath.section == 1){
        return 390;
    }else if(indexPath.section == 2){
        return 101;
    }else if(indexPath.section == 3){
        return 133;
    }
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *bodyHeaderView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *bodyHeaderTitle = [UILabel new];
    bodyHeaderTitle.frame = CGRectMake(10, 0, screen_width-20, 27);
    [bodyHeaderTitle setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [bodyHeaderTitle setFont:[UIFont systemFontOfSize:11]];
    [bodyHeaderView.contentView addSubview:bodyHeaderTitle];
    if(section == 1){
        [bodyHeaderTitle setText:@"完善个人信息"];
    }else if(section == 2){
        [bodyHeaderTitle setText:@"本人证件照"];
    }
    return bodyHeaderView;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(self.houseSourceCell == nil){
            self.houseSourceCell = [tableView dequeueReusableCellWithIdentifier:fillUserInfoHouseSourceCellId forIndexPath:indexPath];
            [self.houseSourceCell renderData:self.house];
            [self.houseSourceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return self.houseSourceCell;
    }else if(indexPath.section == 1){
        if(self.userInfoCell == nil){
            self.userInfoCell = [tableView dequeueReusableCellWithIdentifier:fillUserInfoCellId forIndexPath:indexPath];
            [self.userInfoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [self.userInfoCell renderCustomerData:self.customerInfo];
        return self.userInfoCell;
    }else if(indexPath.section == 2){
        if(self.idPhotosCell == nil){
            self.idPhotosCell = [[IDPhotosCell alloc] init];
            [self.idPhotosCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self.idPhotosCell renderUI];
        }
        [self.idPhotosCell renderData:self.customerInfo];
        return self.idPhotosCell;
    }else if(indexPath.section == 3){
            if(self.bodyFooterView == nil){
                self.bodyFooterView = [[UITableViewCell alloc] init];
                UIButton *xieyi = [[UIButton alloc] init];
                [xieyi setImage:[UIImage imageNamed:@"selected_purple"] forState:UIControlStateNormal];
                [xieyi setTitle:@"承诺书,所填信息真实、有效,如有虚假,愿意承担违约责任" forState:UIControlStateNormal];
                [xieyi.titleLabel setFont:[UIFont systemFontOfSize:11]];
                [xieyi setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
                xieyi.frame = CGRectMake(2, 20, screen_width-20, 15);
                [xieyi setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [self.bodyFooterView.contentView addSubview:xieyi];
                
                
                UIButton *nextBtn = [[UIButton alloc] init];
                nextBtn.frame = CGRectMake(10, 133 - 50, screen_width-20, 40);
                [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
                [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                nextBtn.layer.masksToBounds = YES;
                nextBtn.layer.cornerRadius = 5;
                [nextBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
                [self.bodyFooterView.contentView addSubview:nextBtn];
                
                [nextBtn addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            [self.bodyFooterView setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self.bodyFooterView.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
            return self.bodyFooterView;
    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

-(void) nextEvent
{

    NSString *userName = self.userInfoCell.userName.text;
//    if([NSStringUtils isBlank:userName]){
//        [self.view makeToast:@"用户姓名不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *mobile = self.userInfoCell.mobile.text;
//    if([NSStringUtils isBlank:mobile]){
//        [self.view makeToast:@"用户手机号不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
//    if(mobile.length != 11){
//        [self.view makeToast:@"请输入正确的用户手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *sex = [self.userInfoCell getSex];
    
    NSString *idNo = self.userInfoCell.idNo.text;
//    if([NSStringUtils isBlank:idNo]){
//        [self.view makeToast:@"用户身份证号不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *confirmIdNo = self.userInfoCell.confirmIdNo.text;
//    if(![idNo isEqualToString:confirmIdNo]){
//        [self.view makeToast:@"两次身份证号不一致" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *emergencyContactName = self.userInfoCell.emergencyContactName.text;
//    if([NSStringUtils isBlank:emergencyContactName]){
//        [self.view makeToast:@"紧急联系人不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *emergencyContactPhone = self.userInfoCell.emergencyContactPhone.text;
//    if([NSStringUtils isBlank:emergencyContactPhone]){
//        [self.view makeToast:@"紧急联系人电话不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
//    if(emergencyContactPhone.length != 11){
//        [self.view makeToast:@"请输入正确的紧急联系人电话" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *contactRelation = self.userInfoCell.contactRelation.text;
//    if([NSStringUtils isBlank:contactRelation]){
//        [self.view makeToast:@"紧急联系人关系不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *idCardFrontPic = self.idPhotosCell.firstIDPhoto.imgUrl;
//    if([NSStringUtils isBlank:idCardFrontPic]){
//        [self.view makeToast:@"本人证件照正面不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *idCardBackPic = self.idPhotosCell.secondIDPhoto.imgUrl;
//    if([NSStringUtils isBlank:idCardBackPic]){
//        [self.view makeToast:@"本人证件照反面不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    NSString *idCardHandheldPic = self.idPhotosCell.thirdIDPhoto.imgUrl;
//    if([NSStringUtils isBlank:idCardHandheldPic]){
//        [self.view makeToast:@"本人证件照手持照不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
//        return;
//    }
    
    
    
    [[UserStore sharedStore] updateCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
        
        if(err == nil){
            NSLog(@"修改成功");
            
            ConfirmRentDateViewController *confirmRentDateViewController = [[ConfirmRentDateViewController alloc] init];
            confirmRentDateViewController.house = self.house;
            confirmRentDateViewController.houseInfo = self.houseInfo;
            confirmRentDateViewController.customerInfo = self.customerInfo;
            [self.navigationController pushViewController:confirmRentDateViewController animated:YES];

        }else{
            NSLog(@"修改失败");
            [self.view makeToast:@"修改失败" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
        
    } mobile:mobile userName:userName nickName:userName birthDay:@"" sex:sex headPic:@"" idNo:idNo emergencyContactName:emergencyContactName emergencyContactPhone:emergencyContactPhone contactRelation:contactRelation idCardFrontPic:idCardFrontPic idCardBackPic:idCardBackPic idCardHandheldPic:idCardHandheldPic signFlg:@"" authenticationFlg:@""];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
