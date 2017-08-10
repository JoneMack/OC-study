//
//  PassLockCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/27.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "PassLockCell.h"

@implementation PassLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void) renderView
{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    self.lockedStatusView = [[UIImageView alloc] init];
    self.lockedStatusView.frame = CGRectMake(0, 0, 90, 90);
    self.lockedStatusView.center = CGPointMake(screen_width/2, 60);
    [self.lockedStatusView setImage:[UIImage imageNamed:@"locked_yuan"]];
    [self.contentView addSubview:self.lockedStatusView];
        
    self.tixingLabel = [[UILabel alloc] init];
    self.tixingLabel.frame = CGRectMake(0, self.lockedStatusView.bottomY+20, screen_width, 13);
    [self.tixingLabel setText:@"输入解锁密码"];
    [self.tixingLabel setFont:[UIFont systemFontOfSize:13]];
    [self.tixingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tixingLabel setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.tixingLabel];
        
    self.thirdStar = [[UILabel alloc] init];
    self.thirdStar.frame = CGRectMake(screen_width/2 - 5 - 24, self.tixingLabel.bottomY+20, 24, 24);
    [self.thirdStar setText:@"*"];
    [self.thirdStar setFont:[UIFont systemFontOfSize:25]];
    [self.thirdStar setTextAlignment:NSTextAlignmentCenter];
    [self.thirdStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.thirdStar];
        
        
    self.secondStar = [[UILabel alloc] init];
    self.secondStar.frame = CGRectMake(self.thirdStar.rightX - 10 - 24*2, self.tixingLabel.bottomY+20, 24, 24);
    [self.secondStar setText:@"*"];
    [self.secondStar setFont:[UIFont systemFontOfSize:25]];
    [self.secondStar setTextAlignment:NSTextAlignmentCenter];
    [self.secondStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.secondStar];
        
        
    self.firstStar = [[UILabel alloc] init];
    self.firstStar.frame = CGRectMake(self.secondStar.rightX - 10 - 24*2, self.tixingLabel.bottomY+20, 24, 24);
    [self.firstStar setText:@"*"];
    [self.firstStar setFont:[UIFont systemFontOfSize:25]];
    [self.firstStar setTextAlignment:NSTextAlignmentCenter];
    [self.firstStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.firstStar];
    
    
    self.fourthStar = [[UILabel alloc] init];
    self.fourthStar.frame = CGRectMake(self.thirdStar.rightX+10, self.tixingLabel.bottomY+20, 24, 24);
    [self.fourthStar setText:@"*"];
    [self.fourthStar setFont:[UIFont systemFontOfSize:25]];
    [self.fourthStar setTextAlignment:NSTextAlignmentCenter];
    [self.fourthStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.fourthStar];
    
    
    self.fifthStar = [[UILabel alloc] init];
    self.fifthStar.frame = CGRectMake(self.fourthStar.rightX+10, self.tixingLabel.bottomY+20, 24, 24);
    [self.fifthStar setText:@"*"];
    [self.fifthStar setFont:[UIFont systemFontOfSize:25]];
    [self.fifthStar setTextAlignment:NSTextAlignmentCenter];
    [self.fifthStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.fifthStar];
    
    
    self.sixthStar = [[UILabel alloc] init];
    self.sixthStar.frame = CGRectMake(self.fifthStar.rightX+10, self.tixingLabel.bottomY+20, 24, 24);
    [self.sixthStar setText:@"*"];
    [self.sixthStar setFont:[UIFont systemFontOfSize:25]];
    [self.sixthStar setTextAlignment:NSTextAlignmentCenter];
    [self.sixthStar setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.sixthStar];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.firstStar.rightX-24, self.firstStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.secondStar.rightX-24, self.secondStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.thirdStar.rightX-24, self.thirdStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.fourthStar.rightX-24, self.fourthStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.fifthStar.rightX-24, self.fifthStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(self.sixthStar.rightX-24, self.sixthStar.bottomY+5, 24, 1);
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.lineView];
    
    self.btn2 = [[UIButton alloc] init];
    self.btn2.frame = CGRectMake(0, 0, 70, 70);
    [self.btn2 setTitle:@"2" forState:UIControlStateNormal];
    [self.btn2.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn2.center = CGPointMake(screen_width/2, self.lineView.bottomY+60);
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 35;
    [self.btn2.layer setBorderWidth:1]; //边框宽度
    [self.btn2.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn2];
    
    
    self.btn5 = [[UIButton alloc] init];
    self.btn5.frame = CGRectMake(0, 0, 70, 70);
    self.btn5.center = CGPointMake(screen_width/2, self.btn2.bottomY+15+35);
    [self.btn5 setTitle:@"5" forState:UIControlStateNormal];
    [self.btn5.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn5 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn5.layer.masksToBounds = YES;
    self.btn5.layer.cornerRadius = 35;
    [self.btn5.layer setBorderWidth:1]; //边框宽度
    [self.btn5.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn5];
    
    
    self.btn8 = [[UIButton alloc] init];
    self.btn8.frame = CGRectMake(0, 0, 70, 70);
    self.btn8.center = CGPointMake(screen_width/2, self.btn5.bottomY+15+35);
    [self.btn8 setTitle:@"8" forState:UIControlStateNormal];
    [self.btn8.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn8 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn8.layer.masksToBounds = YES;
    self.btn8.layer.cornerRadius = 35;
    [self.btn8.layer setBorderWidth:1]; //边框宽度
    [self.btn8.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn8];
    
    
    self.btn0 = [[UIButton alloc] init];
    self.btn0.frame = CGRectMake(0, 0, 70, 70);
    self.btn0.center = CGPointMake(screen_width/2, self.btn8.bottomY+15+35);
    [self.btn0 setTitle:@"0" forState:UIControlStateNormal];
    [self.btn0.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn0 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn0.layer.masksToBounds = YES;
    self.btn0.layer.cornerRadius = 35;
    [self.btn0.layer setBorderWidth:1]; //边框宽度
    [self.btn0.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn0];
    
    
    self.btn1 = [[UIButton alloc] init];
    self.btn1.frame = CGRectMake(self.btn2.rightX - 70*2 - 15, self.lineView.bottomY+25, 70, 70);
    [self.btn1 setTitle:@"1" forState:UIControlStateNormal];
    [self.btn1.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.cornerRadius = 35;
    [self.btn1.layer setBorderWidth:1]; //边框宽度
    [self.btn1.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn1];
    
    
    self.btn4 = [[UIButton alloc] init];
    self.btn4.frame = CGRectMake(self.btn5.rightX - 70*2 - 15, self.btn1.bottomY+15, 70, 70);
    [self.btn4 setTitle:@"4" forState:UIControlStateNormal];
    [self.btn4.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn4 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn4.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 35;
    [self.btn4.layer setBorderWidth:1]; //边框宽度
    [self.btn4.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn4];
    
    
    self.btn7 = [[UIButton alloc] init];
    self.btn7.frame = CGRectMake(self.btn8.rightX - 70*2 - 15, self.btn4.bottomY+15, 70, 70);
    [self.btn7 setTitle:@"7" forState:UIControlStateNormal];
    [self.btn7.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn7 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn7.layer.masksToBounds = YES;
    self.btn7.layer.cornerRadius = 35;
    [self.btn7.layer setBorderWidth:1]; //边框宽度
    [self.btn7.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn7];
    
    
    self.btn3 = [[UIButton alloc] init];
    self.btn3.frame = CGRectMake(self.btn2.rightX + 15, self.lineView.bottomY+25, 70, 70);
    [self.btn3 setTitle:@"3" forState:UIControlStateNormal];
    [self.btn3.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 35;
    [self.btn3.layer setBorderWidth:1]; //边框宽度
    [self.btn3.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn3];
    
    self.btn6 = [[UIButton alloc] init];
    self.btn6.frame = CGRectMake(self.btn5.rightX + 15, self.btn3.bottomY+15, 70, 70);
    [self.btn6 setTitle:@"6" forState:UIControlStateNormal];
    [self.btn6.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn6 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn6.layer.masksToBounds = YES;
    self.btn6.layer.cornerRadius = 35;
    [self.btn6.layer setBorderWidth:1]; //边框宽度
    [self.btn6.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn6];

    
    self.btn9 = [[UIButton alloc] init];
    self.btn9.frame = CGRectMake(self.btn8.rightX + 15, self.btn6.bottomY+15, 70, 70);
    [self.btn9 setTitle:@"9" forState:UIControlStateNormal];
    [self.btn9.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [self.btn9 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn9 setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
    self.btn9.layer.masksToBounds = YES;
    self.btn9.layer.cornerRadius = 35;
    [self.btn9.layer setBorderWidth:1]; //边框宽度
    [self.btn9.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.contentView addSubview:self.btn9];


    [self.btn0 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn0 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn0 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn1 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn1 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn1 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn2 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn2 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn3 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn3 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn4 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn4 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn4 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn5 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn5 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn5 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn6 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn6 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn6 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn7 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn7 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn7 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn8 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn8 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn8 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btn9 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn9 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn9 addTarget:self action:@selector(touchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
}


-(void) touchDown:(UIButton *) btn
{
    [btn setBackgroundColor:[ColorUtils colorWithHexString:black_text_color alpha:0.2]];
}

-(void) touchOutside:(UIButton *)btn
{
    [btn setBackgroundColor:[ColorUtils colorWithHexString:white_text_color alpha:0.2]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
