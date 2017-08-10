//
//  MyAsHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAsHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *dianhuaLianXI;
@property (weak, nonatomic) IBOutlet UIButton *onlineLianXI;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

+ (instancetype)asHeader;
@end
