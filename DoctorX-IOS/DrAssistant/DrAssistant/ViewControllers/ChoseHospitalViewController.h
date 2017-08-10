//
//  ChoseHospitalViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

@interface ChoseHospitalViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *diQuLab;
@property (weak, nonatomic) IBOutlet UILabel *yiYuanLab;
@property (weak, nonatomic) IBOutlet UILabel *keShiLab;
@property (weak, nonatomic) IBOutlet UITextField *dianHuaTF;
@property (weak, nonatomic) IBOutlet UITextField *chuZhenShiJianTF;
@property (nonatomic) NSDictionary *chatListUserEntityDic;
@property (weak, nonatomic) IBOutlet UIImageView *portIamge;
@property (weak, nonatomic) IBOutlet UITextField *IDNumF;
@property (weak, nonatomic) IBOutlet UIButton *renZhengBtn;
@end
