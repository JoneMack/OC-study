//
//  MyPAccountController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

@interface MyPAccountController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *PatientName;
@property (weak, nonatomic) IBOutlet UILabel *telePhone;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
- (IBAction)setting:(id)sender;

@end
