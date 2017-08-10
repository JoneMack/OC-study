//
//  SchoolIntroDuceController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "SchoolIntroDuceController.h"
#import "HMBannerView.h"
#import "GRNetworkAgent.h"

@interface SchoolIntroDuceController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SchoolIntroDuceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.userInteractionEnabled = YES;
    self.textView.text = self.ClubInfo.INTRODUCTION;
    NSURL *url = [NSURL URLWithString:self.ClubInfo.CLUB_THUMB];
    [self.clubBigImage sd_setImageWithURL:url placeholderImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
