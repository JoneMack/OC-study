//
//  GroupInfoEntity.h
//  DrAssistant
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface GroupInfoEntity : BaseEntity


@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *u_id;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end
