//
//  SubscribeHistoryCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeExpertLog.h"

@interface SubscribeHistoryCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *subscribeLabel;

@property (strong, nonatomic) IBOutlet UILabel *expertName;


@property (strong, nonatomic) IBOutlet UILabel *subscribeTime;

@property (strong, nonatomic) IBOutlet UILabel *costPoint;

@property (strong, nonatomic) IBOutlet UILabel *pointLabel;

@property (weak, nonatomic) SubscribeExpertLog *subscribeExpertLog;


- (void)renderData:(SubscribeExpertLog *)subscribeExpertLog;

@end
