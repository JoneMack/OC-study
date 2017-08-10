//
//  PayProcessor.m
//  styler
//
//  Created by 冯聪智 on 14-10-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define TEN_PAYMENT  @"微信支付"
#define ALI_APP_PAYMENT    @"支付宝APP"
#define ALI_WEB_PAYMENT    @"支付宝网页版"

#import "PayProcessor.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "UserHdc.h"
#import "HdcOrder.h"
#import "Reminder.h"
#import "Page.h"
#import "HdcStore.h"
#import "UserStore.h"
#import "ConfirmHdcOrderController.h"
#import "UserHdcController.h"

//-------------------------------------------
//  支付类型的数据结构
//-------------------------------------------
@implementation PaymentType

-(id) initWithName:(NSString *)paymentTypeName paymentTypeIcon:(NSString *)paymentTypeIcon{
    self = [super init];
    _paymentTypeName = paymentTypeName;
    _paymentTypeIcon = paymentTypeIcon;
    return self;
}


-(BOOL) isTenPay{
    if ([self.paymentTypeName isEqualToString:TEN_PAYMENT]) {
        return YES;
    }
    return NO;
}

-(BOOL) isALIAPPPay{
    if ([self.paymentTypeName isEqualToString:ALI_APP_PAYMENT]) {
        return YES;
    }
    return NO;
}

-(BOOL) isALIWEBPay{
    if ([self.paymentTypeName isEqualToString:ALI_WEB_PAYMENT]) {
        return YES;
    }
    return NO;
}

@end

//-------------------------------------------
//  支付处理器
//-------------------------------------------
@implementation PayProcessor

/**
 *  获取支付方式
 */
-(NSMutableArray *) getPaymentTypes{
    if (self.paymentTypes == nil ) {
        self.paymentTypes = [[NSMutableArray alloc] init];
    }else{
        [self.paymentTypes removeAllObjects];
    }
    if ([WXApi isWXAppInstalled]) {
        PaymentType *paymentType = [[PaymentType alloc] initWithName:TEN_PAYMENT paymentTypeIcon:@"weixin_icon"];
        [self.paymentTypes addObject:paymentType];
    }
    
    if (![DeviceUtils isIpad]) {
        PaymentType *paymentType = [[PaymentType alloc] initWithName:ALI_APP_PAYMENT paymentTypeIcon:@"zhifubao_app_icon"];
        [self.paymentTypes addObject:paymentType];
    }
    
    PaymentType *paymentType = [[PaymentType alloc] initWithName:ALI_WEB_PAYMENT paymentTypeIcon:@"zhifubao_icon"];
    [self.paymentTypes addObject:paymentType];
    
    return self.paymentTypes;
}

/**
 *  获取默认的支付类型
 */
-(PaymentType *) getDefaultPaymentType{
    if (self.paymentTypes == nil) {
        [self getPaymentTypes];
    }
    return self.paymentTypes[0];
}



-(void) processFailPayment:(UINavigationController *)nav{
    
    Reminder *reminder = [[Reminder alloc] init];
    [reminder checkUnpaymentAmountHdcOrders];
    
    [MobClick event:log_event_name_cancel_hdc_order];
    
    [self processPayingData:NO];
    [SVProgressHUD showErrorWithStatus:@"订单未支付" duration:2.0];
    [[AppStatus sharedInstance] updateBadge];
    for (UIViewController *vc in nav.viewControllers) {
        if([vc isKindOfClass:[ConfirmHdcOrderController class]]){
            [nav popToViewController:vc animated:YES];
        }
    }
}

-(void) successRedirect:(UINavigationController *)nav{
    [SVProgressHUD dismiss];
    NSString *message = @"购买成功，建议提前预约发型师";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    NSString *payFrom = [self.payFrom componentsSeparatedByString:@"&"][0];
    if([payFrom isEqualToString:@"myHDC"]){ // 从未付款的美发卡过来的。
        //退回到个人中心
        [nav popToRootViewControllerAnimated:NO];
        //跳回到发型师详情页
        StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
        //将当前的视图堆栈pop到根视图
        if ([tabBar getSelectedIndex] == tabbar_item_index_me) {
            UINavigationController *navController = [tabBar getSelectedViewController];
            [navController popToRootViewControllerAnimated:YES];
            NSArray *cardStatus = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
            UserHdcController *userHdcController = [[UserHdcController alloc] initWithCardStatus:cardStatus];
            [navController pushViewController:userHdcController animated:YES];
        }
        
    }else{
        //当前视图堆栈跳到根视图
        [nav popToRootViewControllerAnimated:NO];
        StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
        [tabBar setSelectedIndex:tabbar_item_index_me];
        UINavigationController *targetNav = [tabBar getSelectedViewController];
        [targetNav popToRootViewControllerAnimated:YES];
        NSArray *hdcStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
        UserHdcController *udc = [[UserHdcController alloc] initWithCardStatus:hdcStatuses];
        [targetNav pushViewController:udc animated:YES];
    }
    
    //切换视图堆栈到“个人中心”
    //        [tabBar setSelectedIndex:tabbar_item_index_contact];
    //        UINavigationController *navController = [tabBar getSelectedViewController];
    //
    //        int stylistId = [self.paidCards[0] stylistId];
    //
    //
    //        [[StylistStore sharedStore] getStylist:^(Stylist *stylist, NSError *err) {
    //            if (err == nil) {
    //                StylistProfileController *stylistProfileController = [[StylistProfileController alloc] init];
    //                stylistProfileController.stylist = stylist;
    //                [navController pushViewController:stylistProfileController animated:YES];
    //
    //                [MobClick event:log_event_name_goto_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:stylist.name, @"发型师名字",nil]];
    //            }else{
    //                // 获取发型师失败
    //                [nav popToRootViewControllerAnimated:NO];
    //            }
    //        } stylistId:stylistId refresh:NO];
    
    Reminder *reminder = [[Reminder alloc] init];
    [reminder checkUnpaymentAmountHdcOrders];
    //当前视图堆栈跳到根视图
//    [nav popToRootViewControllerAnimated:NO];
    
    //切换到"我"这个视图堆栈，并且push到美发卡列表页面
    //    LeveyTabBarController *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate leveyTabBar];
    //    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    //    [tabBar setSelectedIndex:tabbar_item_index_me];
    //    UINavigationController *targetNav = (UINavigationController *)[tabBar getSelectedViewController];
    //    [targetNav popToRootViewControllerAnimated:YES];
    //    NSArray *hdcStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
    //    UserHdcController *udc = [[UserHdcController alloc] initWithCardStatus:hdcStatuses];
    //    [nav pushViewController:udc animated:YES];
    //    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {  // 点查看进行跳转
        
        StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
        //将当前的视图堆栈pop到根视图
        if ([tabBar getSelectedIndex] == tabbar_item_index_me) {
            UINavigationController *navController = [tabBar getSelectedViewController];
            [navController popToRootViewControllerAnimated:YES];
        }
        
        //切换视图堆栈到“个人中心”
        [tabBar setSelectedIndex:tabbar_item_index_me];
        UINavigationController *navController = [tabBar getSelectedViewController];
        
        NSArray *cardStatus = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
        UserHdcController *userHdcController = [[UserHdcController alloc] initWithCardStatus:cardStatus];
        [navController pushViewController:userHdcController animated:YES];
        [tabBar.tabbarController hidesTabBar:YES animated:YES];
        
    }
}

/****
 同时遍历page结果集中的美发卡和本地已支付的美发卡
 如果page中不包含本地的某张美发卡，则将该张美发卡添加到page中，并且更新totalCount
 如果page中包含本地的某张美发卡，则将这张美发卡从本地缓存数据中清除，并将清除后的缓存数据
 重新保存
 */
-(void) mergePaidCardsWithLocal:(Page *)page{
    if (self.paidCards != nil && self.paidCards.count > 0) {
        int removeCount = 0;
        for (int i = 0; i < self.paidCards.count; i++) {
            //判断本地已经支付的美发卡是否存在于远程的结果集
            UserHdc *localHdc = self.paidCards[i];
            BOOL remoteContained = NO;
            int j = 0;
            for (; j < page.items.count; j++) {
                UserHdc *remoteHdc = (UserHdc *)page.items[j];
                if (localHdc.id == remoteHdc.id) {
                    remoteContained = YES;
                    break;
                }
            }
            
            if (remoteContained) {
                [self.paidCards removeObjectAtIndex:i];
                removeCount += 1;
            }else{
                NSMutableArray *newItems = [[NSMutableArray alloc] init];
                [newItems addObject:localHdc];
                [newItems addObjectsFromArray:page.items];
                page.items = newItems;
                page.totalCount = page.totalCount + 1;
            }
        }
        
        if (removeCount > 0) {
            [self savePayProcessor];
        }
    }
}

-(void)mergeUnpaymentCardsWithLocal:(Page *)page{
    if (self.paidCards != nil && self.paidCards.count > 0) {
        for (int i = 0; i < self.paidCards.count; i++) {
            //判断本地已经支付的美发卡是否存在于远程的结果集
            UserHdc *localHdc = self.paidCards[i];
            BOOL remoteContained = NO;
            int j = 0;
            for (; j < page.items.count; j++) {
                UserHdc *remoteHdc = (UserHdc *)page.items[j];
                if (localHdc.id == remoteHdc.id) {
                    remoteContained = YES;
                    break;
                }
            }
            
            if (remoteContained) {
                UserHdc *remoteHdc = (UserHdc *)page.items[j];
                if(remoteHdc.orderItemStatus == user_card_status_unpayment){
                    NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:page.items];
                    [newItems removeObjectAtIndex:j];
                    page.items = newItems;
                    page.totalCount = page.totalCount - 1;
                }
            }
        }
    }
}

//针对支付结果处理正在支付的本地数据
-(void) processPayingData:(BOOL)paymentResult{
    if (self.paidCards == nil) {
        self.paidCards = [NSMutableArray new];
    }
    if(paymentResult){
        
        NSMutableArray *userHdcNums = [[NSMutableArray alloc] init];
        
        for (UserHdc *userHdc in self.payingCards) {
            [userHdcNums addObject:userHdc.hdcNum];
            [userHdc setOrderItemStatus:user_card_status_paid];
            NSDate *now = [NSDate new];
            [userHdc setPayTime:[NSNumber numberWithLongLong:[now timeIntervalSince1970]]];
            [self.paidCards addObject:userHdc];
        }
        
        //  更新用户美发卡的状态,该操作用于通知server用户已付款成功，将未支付状态及时更新
        if (userHdcNums.count > 0) {
            [HdcStore updateUserHdcStatus:^(NSError *error) {
                //                NSLog(@"支付成功，将美发卡状态设置为等待支付，%d" , userHdcNums.count);
            } userHdcNums:userHdcNums hdcStatus:user_card_status_waitting_paid];
        }
        
        //收藏发型师
        int stylistId = [self.paidCards[0] stylistId];
        AppStatus * appStatus = [AppStatus sharedInstance];
        BOOL hasCollected = [appStatus.user hasAddFavStylist:stylistId];
        if (!hasCollected) {
            [[UserStore sharedStore] addFavStylist:^(NSError *err){
                if (err == nil) {
                    [[UserStore sharedStore] favStylists:^(NSArray *stylists, NSError *err) {
                        if (err == nil) {
                            
                            [appStatus.user addFavStylist:stylistId];
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  @(stylistId), @"发型师id", nil];
                            [MobClick event:log_event_name_add_fav_stylist attributes:dict];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_paid_success_collection_stylist object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_fav_stylist object:nil];
                        }
                    } userId:appStatus.user.idStr refresh:YES];
                }
            }userId:[appStatus.user.idStr intValue] stylistId:stylistId];
        }
    }
    
    [self.payingCards removeAllObjects];
    [self savePayProcessor];
}

-(void) addPayingCard:(UserHdc *)card{
    self.payingCards = [NSMutableArray new];
    [self.payingCards addObject:card];
}

-(void) addHdcOrder:(HdcOrder *)order{
    self.payingCards = [NSMutableArray new];
    [self.payingCards addObjectsFromArray:order.hdcOrderItems];
}

-(void)cleanLocalData{
    self.payingCards = nil;
    self.paidCards = nil;
    [self savePayProcessor];
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.paidCards forKey:@"paidCards"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.paidCards = [aDecoder decodeObjectForKey:@"paidCards"];
    }
    
    return self;
}

-(void) savePayProcessor{
    [NSKeyedArchiver archiveRootObject:[PayProcessor sharedInstance] toFile:[PayProcessor savedPath]];
}


+(NSString *) savedPath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"payment.archive"];
    return documentDirectory;
}


+(PayProcessor *) sharedInstance{
    static PayProcessor *sharedInstance = nil;
    if (sharedInstance == nil) {
        NSString *path = [PayProcessor savedPath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (sharedInstance == nil) {
            sharedInstance = [PayProcessor new];
        }
    }
    return sharedInstance;
}

//========================================================================================
//  支付结果 的 代理方法
//========================================================================================
-(void) paymentSuccess:(UINavigationController *)nav{
    [self processPayingData:YES];
    [self successRedirect:nav];
}

-(void) paymentFail:(UINavigationController *)nav{
    [self processFailPayment:nav];
}

-(void) wxpaymentSuccess:(UINavigationController *)nav{
    [self processPayingData:YES];
    [self successRedirect:nav];
}

-(void) wxpaymentFail:(UINavigationController *)nav{
    [self processFailPayment:nav];
}

@end
