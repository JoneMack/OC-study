//
//  RedEnvelopeCardView.h
//  styler
//
//  Created by 冯聪智 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopeCardView : UIView

@property (nonatomic , strong) IBOutlet UIButton *cloneBtn;

-(void) showRedEnvelopeCardView;

- (void) hideRemindRedEnvelopeCardView;

@end
