/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

/**
 *  群组成员类型
 */
typedef enum{
    GroupOccupantTypeOwner,//创建者
    GroupOccupantTypeMember,//成员
}GroupOccupantType;

@interface ChatGroupDetailViewController : UITableViewController<IChatManagerDelegate>
@property (nonatomic) NSInteger friend_type;
@property (nonatomic, strong) NSString *qunGroup_type;// 患者群聊，医生群聊，会诊
- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;

@end
