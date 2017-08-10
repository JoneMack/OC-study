//
//  ChatSettingViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatSettingViewController : BaseViewController
@property (nonatomic, strong) UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UISwitch *receiveMsgSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *openVoiceSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *yangShengQiSwitch;


- (IBAction)newTongZhi:(id)sender;

- (IBAction)soundSet:(id)sender;
- (IBAction)shockSet:(id)sender;
- (IBAction)voiceSet:(id)sender;

@end
