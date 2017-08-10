//
//  SaveZhuanZhenView.h
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SaveZhuanZhenViewButtonItemStyle) {
    SearchHospitalBtnTag,
    SearchDoctorBtnTag,
};

@protocol SaveZhuanZhenViewActionDelegate <NSObject>

- (void)recordZhuanZhenInfoAction:(UIButton *)sender;

@end

@interface SaveZhuanZhenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *zhuanRuYiYuan_lab;
@property (weak, nonatomic) IBOutlet UILabel *zhuanRuYiSheng_lab;

@property (weak, nonatomic) IBOutlet UITextField *patientName_tf;
@property (weak, nonatomic) IBOutlet UITextField *patientPhone_tf;
@property (weak, nonatomic) IBOutlet UITextField *patientDescribe_tf;


@property (weak, nonatomic) IBOutlet UIControl *Bg_controlView;
@property (weak, nonatomic) IBOutlet UIButton *searchHospital_Btn;
@property (weak, nonatomic) IBOutlet UIButton *searchDoctor_Btn;

@property (nonatomic,strong) id<SaveZhuanZhenViewActionDelegate> delegate;

+ (instancetype)saveZhuanZhenView;

@end
