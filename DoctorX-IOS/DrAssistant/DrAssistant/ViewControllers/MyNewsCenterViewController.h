//
//  MyNewsCenterViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/31.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, MyNewsCenterType) {
    DoctorNews,
    PatientNews
};
@interface MyNewsCenterViewController : BaseViewController
@property (nonatomic)MyNewsCenterType myNewsType;
@end
