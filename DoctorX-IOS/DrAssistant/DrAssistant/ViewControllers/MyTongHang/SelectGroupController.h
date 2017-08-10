//
//  SelectGroupController.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/21.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GroupInfoEntity.h"
typedef enum : NSUInteger {
    patient_friend_type = 0,
    tonghang_friend_type = 1,
    
} FriendType;

@interface SelectGroupController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, assign) FriendType friendType;
@end
