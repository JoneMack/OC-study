//
//  RewardActivityOverView.h
//  styler
//
//  Created by wangwanggy820 on 14-9-12.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardActivityOverView : UIView

@property (weak, nonatomic) IBOutlet UIView *rewardActivityOverRemindView;

@property (weak, nonatomic) IBOutlet UILabel *activityOverRemindContentLab;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


- (IBAction)closeBtnclick:(id)sender;

@end
