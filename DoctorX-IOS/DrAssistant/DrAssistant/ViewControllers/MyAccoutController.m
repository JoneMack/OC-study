//
//  MyAccoutController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyAccoutController.h"

@implementation MyAccoutController
- (IBAction)myShareAction:(id)sender {
    if (_delegete &&[_delegete respondsToSelector:@selector(shareButtonAction)]) {
        [_delegete shareButtonAction];
    }
}
- (IBAction)newsAction:(id)sender {
    if (_delegete &&[_delegete respondsToSelector:@selector(myNewsButtonAction)]) {
        [_delegete myNewsButtonAction];
    }
}
- (IBAction)settingAction:(id)sender {
    if (_delegete &&[_delegete respondsToSelector:@selector(settingButtionAction)]) {
        [_delegete settingButtionAction];
    }
}
- (IBAction)editAction:(id)sender {
    if (_delegete&&[_delegete respondsToSelector:@selector(editButtonAction)]) {
        [_delegete editButtonAction];
    }
}
- (IBAction)QRCodeAction:(id)sender {
    if (_delegete&&[_delegete respondsToSelector:@selector(QRCodeButtonAction)]) {
        [_delegete QRCodeButtonAction];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)viewDidLoad {

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)tongjiButtonAction:(id)sender {
    if (_delegete&&[_delegete respondsToSelector:@selector(tongjiButtonAction)]) {
        [_delegete tongjiButtonAction];
    }
}
@end
