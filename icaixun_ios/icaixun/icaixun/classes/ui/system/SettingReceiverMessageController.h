//
//  SettingReceiverMessageController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/28.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"

@interface SettingReceiverMessageController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) Expert *expert;

@end
