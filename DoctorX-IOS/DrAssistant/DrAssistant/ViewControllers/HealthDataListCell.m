//
//  HealthDataListCell.m
//  DrAssistant
//
//  Created by 张保华 on 15/10/29.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "HealthDataListCell.h"

@implementation HealthDataListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(10.f, 10.f, self.frame.size.width - 10.f, 20.f)];
        _timeLabel.font = [UIFont systemFontOfSize: 15.f];
        _timeLabel.textColor = [UIColor blackColor];
        [self addSubview: _timeLabel];
        
        _pressureLabel = [[UILabel alloc] initWithFrame: CGRectMake(20.f, CGRectGetMaxY(_timeLabel.frame) + 10.f, self.frame.size.width - 20.f, 20.f)];
        _pressureLabel.font = [UIFont systemFontOfSize: 15.f];
        _pressureLabel.textColor = [UIColor blackColor];
        [self addSubview: _pressureLabel];
        
        _rateLabel = [[UILabel alloc] initWithFrame: CGRectMake(20.f, CGRectGetMaxY(_pressureLabel.frame) + 10.f, self.frame.size.width - 20.f, 20.f)];
        _rateLabel.font = [UIFont systemFontOfSize: 15.f];
        _rateLabel.textColor = [UIColor blackColor];
        [self addSubview: _rateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _timeLabel.frame = CGRectMake(10.f, 10.f, self.frame.size.width - 10.f, 20.f);
    _pressureLabel.frame = CGRectMake(20.f, CGRectGetMaxY(_timeLabel.frame) + 10.f, self.frame.size.width - 20.f, 20.f);
    _rateLabel.frame = CGRectMake(20.f, CGRectGetMaxY(_pressureLabel.frame) + 10.f, self.frame.size.width - 20.f, 20.f);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
