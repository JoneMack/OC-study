//
//  UserSettingViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//
#import "UserSettingViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserDetailInfoViewController.h"
#import "UserStore.h"

static NSString *userSettingCellId = @"userSettingCellId";
@interface UserSettingViewController ()

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    
    [self setRightSwipeGestureAndAdaptive];
    
    [self loadData];
    
}

-(void) initHeaderView{
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"设置" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    [self.view sendSubviewToBack:self.headerView];

}

-(void) initBodyView
{
    
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:userSettingCellId];
    [self.bodyView setScrollEnabled:NO];
    
}


-(void) initBottomView{
    [self.logoutBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.layer.cornerRadius = 5;
}

-(void) loadData
{
    [[UserStore sharedStore] getCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
        self.customerInfo = customerInfo;
        
        [self.bodyView reloadData];
    }];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return 25;
    }else{
        return 10;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
    }
    return view;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSettingCellId forIndexPath:indexPath];
    AppStatus *as = [AppStatus sharedInstance];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [cell.content setHidden:YES];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"头像"];
        }else if(indexPath.row == 1){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"姓名"];
            [cell.topLine setHidden:YES];
            [cell.content setText:as.user.userName];
        }else if(indexPath.row == 2){
            [cell.avatarView setHidden:YES];
            [cell.content setHidden:NO];
            [cell.rightArrow setHidden:YES];
            [cell.title setText:@"电话"];
            [cell.topLine setHidden:YES];
            [cell.content setText:as.user.userId];
        }
    }else{
        [cell.avatarView setHidden:YES];
        [cell.content setHidden:YES];
        [cell.rightArrow setHidden:NO];
        [cell.title setText:@"资质信息"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    
        if(indexPath.row == 0){
            // 修改用户头像
            
            [self updateUserAvatar];
        }
        
    }else if(indexPath.section == 1){
        UserDetailInfoViewController *userDetailInfoViewController = [[UserDetailInfoViewController alloc] init];
        [self.navigationController pushViewController:userDetailInfoViewController animated:YES];
    }
}


-(void) updateUserAvatar{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheet代理方法
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    if(buttonIndex == 0){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."  maskType:SVProgressHUDMaskTypeGradient];
    image = [ImageUtils imageWithImageSimple:image scaledToSize:CGSizeMake(220, 220)];
    
    [[UserStore sharedStore] updateAvatar:^(NSString *imgUrl , NSError *err) {
        if (err == nil) {
            
            AppStatus *as = [AppStatus sharedInstance];
            [[UserStore sharedStore] updateCustomerInfo:^(CustomerInfo *customerInfo, NSError *err) {
                if(err == nil){
                    self.customerInfo.headPic = imgUrl;
                    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:customerInfo.headPic]]];// 清除旧的头像缓存
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    UserInfoTableViewCell *cell = [self.bodyView cellForRowAtIndexPath:indexPath];
                    NSLog(@"user avatar:%@" , imgUrl);
                    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                                       placeholderImage:[UIImage imageNamed:@"default_avatar"]
                                                options:SDWebImageRefreshCached
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  //                                          [self.userAvatar setImage:image];
                                                  [SVProgressHUD showSuccessWithStatus:@"头像更新成功"];
                                                  
                                                  //                                          [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_info object:nil];
                                              }];
                }else{
                    NSLog(@"");
                }
            } mobile:@"" userName:as.user.userName nickName:@"" birthDay:@"" sex:@"" headPic:imgUrl idNo:@"" emergencyContactName:@"" emergencyContactPhone:@"" contactRelation:@"" idCardFrontPic:@"" idCardBackPic:@"" idCardHandheldPic:@"" signFlg:@"" authenticationFlg:@""];
            
           
        }else{
            [SVProgressHUD showErrorWithStatus:@"头像更新失败"];
        }
    } avatarImage:image];
}




- (IBAction)logout:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出登录？" message:@"" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"退出", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 退出
        //返回tabbar第一个view
        AppStatus *appStatus = [AppStatus sharedInstance];
        [appStatus initBaseData];
        [AppStatus saveAppStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_log_out object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
