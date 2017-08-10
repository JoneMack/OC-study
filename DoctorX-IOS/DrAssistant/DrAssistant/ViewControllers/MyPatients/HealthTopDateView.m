//
//  HealthTopDateView.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/28.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "HealthTopDateView.h"
@interface HealthTopDateView () {
    BOOL _byDay;
}
@end
@implementation HealthTopDateView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HealthTopDateView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        _byDay = NO;
        self.selectShowDataTypeBtn.tag = selectShowDataTypeBtnTag;
        self.startDateBtn.tag = startDateBtnTag;
        self.endDateBtn.tag = endDateBtnTag;
        self.mediumDateBtn.tag = mediumDateBtnTag;
    }
    return self;
}
- (IBAction)typeAndDateSecletBtnClick:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    _byDay = !_byDay;
    if (button.tag == selectShowDataTypeBtnTag) {
        if (_byDay == YES) {
            [self.selectShowDataTypeBtn setTitle: @"按天显示" forState: UIControlStateNormal];
            _startDateBtn.hidden = NO;
            _toLabel.hidden = NO;
            _endDateBtn.hidden = NO;
            _mediumDateBtn.hidden = YES;
        } else {
            [self.selectShowDataTypeBtn setTitle: @"按次显示" forState: UIControlStateNormal];
            _startDateBtn.hidden = YES;
            _toLabel.hidden = YES;
            _endDateBtn.hidden = YES;
            _mediumDateBtn.hidden = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(healthTypeAndDateSelectBtn:)]) {
        [self.delegate healthTypeAndDateSelectBtn:sender];
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
