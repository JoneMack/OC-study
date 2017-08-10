//
//  ReceiveRedEnvelopeView.h
//  styler
//
//  Created by wangwanggy820 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface RewardActivityResultView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *redEnvelopeView;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeRedEnvelopeBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property int seedId;

-(id)initWithReceiveDesc:(NSString *)receiveDesc amount:(int)perAmount secondRedEnvelopeSeedId:(int)secondRedEnvelopeSeedId;

- (IBAction)removeFromSuperview:(id)sender;



@end
