//
//  SearchHandler.h
//  DrAssistant
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"

@interface SearchHandler : BaseHandler

/**
 *  模糊查询
 *
 *  @param name    real_name模糊查询
 *  @param type    1是病人 2是 医生
 *  @param success
 *  @param fail
 */
+ (void)searchUserWithAccount:(NSString *)name type:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

/**
 *  通过医院和科室id查询用户接口
 *
 *  @param YiYuanID
 *  @param keShiID
 *  @param success
 *  @param fail
 */
+ (void)searchUserWithYiYuanID:(NSString *)YiYuanID keShiID:(NSString *)keShiID  success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;


/*根据医生名字查找*/
+ (void)searchUserWithAccountByNmae:(NSString *)name success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
@end
