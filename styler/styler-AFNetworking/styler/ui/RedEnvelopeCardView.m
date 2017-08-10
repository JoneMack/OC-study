//
//  RedEnvelopeCardView.m
//  styler
//
//  Created by 冯聪智 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define red_envelope_card_animate_duration 0.3

#import "RedEnvelopeCardView.h"

@implementation RedEnvelopeCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) showRedEnvelopeCardView{
    [UIView animateWithDuration:red_envelope_card_animate_duration animations:^{
        self.center = self.superview.center;
    }];
}

- (void) hideRemindRedEnvelopeCardView{
    [UIView animateWithDuration:red_envelope_card_animate_duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -self.frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}


@end
