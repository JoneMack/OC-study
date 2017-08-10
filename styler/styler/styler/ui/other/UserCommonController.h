//
//  UserCommonController.h
//  styler
//
//  Created by wangwanggy820 on 14-5-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "UIView+Custom.h"

@interface UserCommonController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *warpper;
//热线
@property (weak, nonatomic) IBOutlet UIView *telphone;
@property (weak, nonatomic) IBOutlet UILabel *serviceLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLable;
@property (weak, nonatomic) IBOutlet UIButton *telphoneBtn;

//在线客服
@property (weak, nonatomic) IBOutlet UIView *onlineService;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;
@property (weak, nonatomic) IBOutlet UILabel *onlineServiceLable;
@property (weak, nonatomic) IBOutlet UILabel *customerServiceLable;
@property (weak, nonatomic) IBOutlet UIButton *onlineServiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *unreadPushDotImage;

@property (weak, nonatomic) IBOutlet UILabel *reminder;
@property(strong, nonatomic) HeaderView *header;

- (IBAction)touchUpInside:(UIButton *)sender;
- (IBAction)touchDown:(UIButton *)sender;

@end
