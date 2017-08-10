//
//  RemindGetRedEnvelopeView.h
//  styler
//
//  Created by wangwanggy820 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedEnvelopeCardView.h"
#import "ShareContent.h"

@interface RedEnvelopeActivityRemindView : UIView
@property (weak, nonatomic) IBOutlet UIView *remindView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *remindContentLab;

@property ShareContent *shareContent;
@property int amount;

-(id)initWithShareContent:(ShareContent *)shareContent activityDescription:(NSString *)activityDescription amount:(int)amount;

-(IBAction)cancelRemindRedEnvelopeView;
-(IBAction)shareImmediately:(id) sender;

@end
