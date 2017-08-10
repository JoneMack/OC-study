//
//  PatientDetialHeader.h
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, lianXiFriendTag)
{
    OnLineTag = 1,
    PhoneTag,
};


@protocol PatientDetialHeader <NSObject>

- (void)patientDetialHeaderclickAtbtn:(UIButton *)button;

@end
@interface PatientDetialHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *pic_img;

@property (weak, nonatomic) IBOutlet UILabel *nameForFriend;

@property (weak, nonatomic) IBOutlet UILabel *phoneForFriend;

@property (weak, nonatomic) IBOutlet UIButton *basicInfo_btn;

@property (weak, nonatomic) IBOutlet UIButton *bingLiInfo_btn;

@property (weak, nonatomic) IBOutlet UIButton *phoneLianXiBtn;

@property (weak, nonatomic) IBOutlet UIButton *OnLineBtn;

@property (weak, nonatomic) id<PatientDetialHeader> delegate;

+ (instancetype)patientDetialHeader;



@end
