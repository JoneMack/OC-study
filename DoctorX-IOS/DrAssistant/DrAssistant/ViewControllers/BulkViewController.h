//
//  BulkViewController.h
//  DrAssistant
//
//  Created by taller on 15/10/12.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "BulkHeader.h"

typedef enum : NSUInteger {
    push_from_my_patient_vc = 106,
    push_from_my_tonghang_vc = 107,
} QunFaMsgType;

@interface BulkViewController : BaseViewController

@property (nonatomic, strong) BulkHeader *bulkHeader;
@property (nonatomic, assign) QunFaMsgType qunFaMsgType;
@property (nonatomic, strong) NSMutableArray *groupInfoFriendsArray;
@end
