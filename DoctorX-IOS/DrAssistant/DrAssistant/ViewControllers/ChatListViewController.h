//
//  MessageListController.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
@interface ChatListViewController : BaseViewController
@property (nonatomic, strong) UserEntity *userEntity;
@property (nonatomic, strong) NSMutableArray *friendEntityArray;
@property (nonatomic, strong) NSMutableArray *resultDataArray;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end
