//
//  AddConsultationView.m
//  DrAssistant
//
//  Created by Seiko on 15/10/13.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "AddConsultationView.h"

@implementation AddConsultationView
+ (instancetype)addConsultationView
{
    NSArray *ayy = [[NSBundle mainBundle] loadNibNamed:@"AddConsultationView" owner:nil options:nil];
    return [ayy lastObject];
    
    
}
- (void)awakeFromNib
{
    
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.hopView addGestureRecognizer: g1];
}


- (void)tap:(UITapGestureRecognizer *)tapG
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapHopViewSelector:)]) {
        [_delegate tapHopViewSelector:tapG];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
