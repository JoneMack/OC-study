//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerInfo.h"
#import "ContractInfoList.h"
//#import "Page.h"
@interface UserStore : NSObject
+ (UserStore *) sharedStore;

//忘记密码重新获取
-(void) requestTempPwd:(void (^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo;


//普通登陆
-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd;

//退出登陆
-(void) removeSession:(void (^)(NSError *err))completionBlock accessToken:(NSString *)accessToken;


//上传图片
-(void) upLoadImg:(void(^)(NSString *imgUrl, NSError *err))completionBlock tongueImage:(UIImage *)image;


//修改用户信息
-(void)updateCustomerInfo:(void (^)(CustomerInfo *customerInfo ,NSError *err))completionBlock
                   mobile:(NSString *)mobile
                 userName:(NSString *)userName
                 nickName:(NSString *)nickName
                 birthDay:(NSString *)birthDay
                      sex:(NSString *)sex
                  headPic:(NSString *)headPic
                     idNo:(NSString *)idNo
     emergencyContactName:(NSString *)emergencyContactName
    emergencyContactPhone:(NSString *)emergencyContactPhone
          contactRelation:(NSString *)contactRelation
           idCardFrontPic:(NSString *)idCardFrontPic
            idCardBackPic:(NSString *)idCardBackPic
        idCardHandheldPic:(NSString *)idCardHandheldPic
                  signFlg:(NSString *)signFlg
        authenticationFlg:(NSString *)authenticationFlg;

//修改用户头像
-(void) updateAvatar:(void (^)(NSString *imgUrl, NSError *))completionBlock avatarImage:(UIImage *)avatarImage;


- (void) getCustomerInfo:(void (^)(CustomerInfo *customerInfo, NSError *err))completionBlock;


//获取租客合同
///userContracts/userCfContractList

-(void) getUserCfContractList:(void(^)(NSArray<ContractInfoList *> *userCfContractList, NSError *err))completionBlock
                      pageNum:(NSString *)pageNum orderType:(NSString *)orderType;

///userContracts/userSfContractList
-(void) getUserSfContractList:(void(^)(NSArray<ContractInfoList *> *userSfContractList, NSError *err))completionBlock
                      pageNum:(NSString *)pageNum orderType:(NSString *)orderType;

@end
