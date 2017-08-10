//
//  MainViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainViewController.h"
#import "MainOtherServicesView.h"
#import "MainHeaderView.h"
#import "MainCarouselView.h"
#import "MainFindHouseWaysView.h"
#import "MainJoinUsView.h"
#import "MainHouseSourceTableView.h"
#import "UserLoginViewController.h"
#import "RentDelegateViewController.h"
#import "Banner.h"
#import "BannerStore.h"
#import "HouseStore.h"
#import "House.h"
#import "MyContractViewController.h"
#import "MessageCenterViewController.h"
#import "UserSettingViewController.h"
#import "AppDelegate.h"
#import "CollectionAndLookController.h"
#import "CouponViewController.h"
#import "SmartLockViewController.h"


@interface MainViewController ()

@end

/**
 *
 * 甲方修改首页头部为单图片，所在暂时先不用这个了。改用 Main2ViewController.h
 */

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_bind_left_menu_touch_slide_event object:nil];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_unbind_left_menu_touch_slide_event object:nil];
    self.drawerController = [(AppDelegate*)[UIApplication sharedApplication].delegate drawerController];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.frame.size.height);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.headerView = [MainHeaderView new];
    CGRect mainHeaderFrame = CGRectMake(0, 0, screen_width, 68);
    self.headerView.frame = mainHeaderFrame;
    [self.view addSubview:self.headerView];
    
    // 房源列表信息
    self.hourseSourcesView = [[MainHouseSourceTableView alloc] init];
    self.hourseSourcesView.navigationController = self.navigationController;
    self.hourseSourcesView.fydelegate = self;
    
    
    [self.view setBackgroundColor:[ColorUtils colorWithHexString:bg_gray]];
    
    [self loadData];
    
    [self loadBanner];
    
    [self loadNearHouses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInUserLoginView) name:notification_name_go_in_user_login_view object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNearHouses) name:notification_name_user_poi_has_update object:nil];
    
    // 进入我的收藏约看
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInMyCollection) name:notification_name_go_in_user_collection_look_view object:nil];
    
    
    // 进入我的合同
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInCoupon) name:notification_name_go_in_coupon_view object:nil];
    
    // 进入我的合同
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInMyContract) name:notification_name_go_in_my_contract_view object:nil];
    
    // 进入智能锁
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInSmartLock) name:notification_name_go_in_smart_lock_view object:nil];
    
    // 消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInMessageCenter) name:notification_name_go_in_message_center_view object:nil];
    
    
    // 用户设置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goInUserSetting) name:notification_name_go_in_user_setting_view object:nil];
    
    
}

-(void) loadData{
    
}

-(void) loadBanner
{
    [[BannerStore sharedStore] getBanners:^(NSArray<Banner *> *banners, NSError *err) {
        self.banners = banners;
        [self.mainCarouselView renderData:banners];
    } locationStr:@"10100110001"];
}

-(void) loadNearHouses
{
    
    AppStatus *as = [AppStatus sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(1) forKey:@"pageNum"];
    [params setValue:@(as.lastLng) forKey:@"x"];
    [params setValue:@(as.lastLat) forKey:@"y"];
    
    [[HouseStore sharedStore] getHouses:^(NSArray<House *> *houses, NSError *err) {
        
        self.hourseSourcesView.nearHouses = houses;
        [self.hourseSourcesView reloadData];
    
    } params:params];
      
}


#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


#pragma mark  返回 cell 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        return screen_width/5*4;
    }else if(indexPath.row == 1){
        return 140;
    }else if(indexPath.row == 2){
        return 123;
    }else if(indexPath.row == 3){

        if([self.hourseSourcesView.houseSourceType isEqualToString:house_source_type_recommend]){
            return 230*2+10+39;
        }else{
            return [self.hourseSourcesView.nearHouses count]*136+62+39;
        }
    }
    return 0;
}


#pragma mark 渲染 cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *expertCardCellIdentifier = @"expertCardCellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertCardCellIdentifier];
    
    if(indexPath.row == 0){
        CGRect frame =  CGRectMake(0, 0, screen_width, screen_width/5*4);
//        if(self.mainCarouselView == nil){
//            self.mainCarouselView = [[MainCarouselView alloc] initWithFrame:frame];
//            [self.mainCarouselView renderData:self.banners];
//            self.mainCarouselView.navigationController = self.navigationController;
//        }
//        [cell addSubview:self.mainCarouselView];
        
        if(self.mainCarouselTempView == nil){
            self.mainCarouselTempView = [[MainCarouselTempView alloc] initWithFrame:frame];
            self.mainCarouselTempView.navigationController = self.navigationController;
        }
        [cell addSubview:self.mainCarouselTempView];
        
    }else if(indexPath.row == 1){
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        if(self.mainFindHouseWaysView == nil){
            CGRect frame = CGRectMake(0, 0, screen_width, 140);
            self.mainFindHouseWaysView = [[MainFindHouseWaysView alloc] initWithFrame:frame navigationController:self.navigationController];
        }
        [cell addSubview:self.mainFindHouseWaysView];
    }else if(indexPath.row == 2){
       CGRect frame = CGRectMake(0, 0, screen_width, 123);
        if(self.mainFindHouseWaysView){
            self.mainJoinUsView = [MainJoinUsView new];
            self.mainJoinUsView.navigationController = self.navigationController;
            self.mainJoinUsView.frame = frame;
        }
        [cell addSubview:self.mainJoinUsView];
    }else if(indexPath.row == 3){
        [cell addSubview:self.hourseSourcesView];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.headerView setBackgroundColor:[ColorUtils colorWithHexString:bg_purple alpha:scrollView.contentOffset.y/200]];
}

-(void) changeHouseSourceType:(NSString *)houseSourceType height:(float)height
{
    [self.tableView reloadData];
}


-(void) goInUserLoginView
{
    UserLoginViewController *loginController = [UserLoginViewController new];
    [self.navigationController pushViewController:loginController animated:YES];
}

-(void) goInCoupon
{
    CouponViewController *couponViewController = [CouponViewController new];
    [self.navigationController pushViewController:couponViewController animated:YES];
}

- (void)goInMyCollection{
    CollectionAndLookController *mcvc = [[CollectionAndLookController alloc] init];
    [self.navigationController pushViewController:mcvc animated:YES];

}

-(void) goInMyContract{
    MyContractViewController *myContractViewController = [[MyContractViewController alloc] init];
    [self.navigationController pushViewController:myContractViewController animated:YES];
}

-(void) goInSmartLock{
    SmartLockViewController *smartLockViewController = [[SmartLockViewController alloc] init];
    [self.navigationController pushViewController:smartLockViewController animated:YES];
}

-(void) goInMessageCenter{
    MessageCenterViewController *messageCenterViewController = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenterViewController animated:YES];
}

-(void) goInUserSetting{
    UserSettingViewController *userSettingViewController = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:userSettingViewController animated:YES];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2){
        RentDelegateViewController * rentDelegateController = [[RentDelegateViewController alloc] init];
        [self.navigationController pushViewController:rentDelegateController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
