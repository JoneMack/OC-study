//
//  NextViewController.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/24.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopData)(NSString *str);
@interface NextViewController : UIViewController

@property (nonatomic, copy) PopData popdate;

@end
