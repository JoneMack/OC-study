//
//  AppInfo.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/21.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : JSONModel

@property (nonatomic , copy) NSString *pay;
@property (nonatomic , copy) NSString *unPayInfo;
@property (nonatomic , copy) NSString *appInfo;
@property (nonatomic , copy) NSString *addPointInfo;

@end
