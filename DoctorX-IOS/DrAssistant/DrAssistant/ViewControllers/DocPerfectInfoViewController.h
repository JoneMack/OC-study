//
//  DocPerfectInfoViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "MMRadioButton.h"

@interface DocPerfectInfoViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *docorName;
@property (weak, nonatomic) IBOutlet MMRadioButton *women;
@property (weak, nonatomic) IBOutlet MMRadioButton *men;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *professionalLevel;
@property (weak, nonatomic) IBOutlet UITextField *specialty;

@end
