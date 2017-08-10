//
//  MyClubEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface MyClubEntity : BaseEntity

@property (nonatomic, strong) NSArray *clubList;

@property (nonatomic, copy) NSString *clubName;
@property (nonatomic, copy) NSString *CLUB_THUMB;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *INTRODUCTION;
@property (nonatomic, assign) NSInteger  NUMS;
@property (nonatomic, assign) NSInteger  SORT;
@property (nonatomic, assign) BOOL  isJoined;

+ (MyClubEntity*)entityOfDic:(NSArray *)dataArr;

@end
