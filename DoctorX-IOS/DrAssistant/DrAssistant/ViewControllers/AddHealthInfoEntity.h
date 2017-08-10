//
//  AddHealthInfoEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface AddHealthInfoEntity : NSObject

@property (nonatomic, assign) NSInteger TYPE;
@property (nonatomic, copy) NSString *USER_ID;
@property (nonatomic, copy) NSString *SZY;
@property (nonatomic, copy) NSString *SSY;
@property (nonatomic, copy) NSString *XL;
@property (nonatomic, copy) NSString *KFXT;
@property (nonatomic, copy) NSString *CHXT;
@property (nonatomic, copy) NSString *XYBHD;
@property (nonatomic, copy) NSString *CLUB_ID;

@end
