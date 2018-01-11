//
//  UserModel.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/17.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const count;

@interface UserModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;


@end
