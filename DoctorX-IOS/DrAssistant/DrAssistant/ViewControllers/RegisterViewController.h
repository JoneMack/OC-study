//
//  RegisterViewController.h
//  DrAssistant
//
//  Created by hi on 15/8/29.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    push_from_loginVC = 100,
    push_from_third_platfrom = 101,
} pushType;

@interface RegisterViewController : BaseViewController

@property (nonatomic, assign) pushType pushType;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *birthPlace;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *location;

@end
