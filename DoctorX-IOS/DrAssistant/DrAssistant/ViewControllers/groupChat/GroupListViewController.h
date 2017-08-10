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

typedef enum : NSUInteger {
    push_from_patient_group_chat = 102,
    push_from_tonghang_group_chat = 103,
    push_from_patient_huizhen_chat = 104,
    push_from_tonghang_huizhen_chat = 105,
    
} GroupChatPushType;

@interface GroupListViewController : UITableViewController

@property (nonatomic, assign) GroupChatPushType groupChatPushType;
@property (nonatomic, strong) NSString *qunChatGroupListType;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic) NSInteger friend_IDType;
- (void)reloadDataSource;

@end
