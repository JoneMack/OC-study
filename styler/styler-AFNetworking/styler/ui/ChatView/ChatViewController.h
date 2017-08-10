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
#import "HeaderView.h"

@interface ChatViewController : UIViewController

@property (strong, nonatomic) HeaderView *header;

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

- (instancetype)initWithChatter:(NSString *)chatter;


@end