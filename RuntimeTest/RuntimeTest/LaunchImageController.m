//
//  LaunchImageController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/2/9.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "LaunchImageController.h"
#import <lottie-ios/Lottie/Lottie.h>
#import "NSObject+ZJUIExtension.h"
//防止循环引用
#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj

@interface LaunchImageController ()
@property (nonatomic, strong) UIImageView *launchMask;
@property (nonatomic, strong) LOTAnimationView *launchAnimation;
@end

@implementation LaunchImageController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
//    [self setupSubViews];
    
    if (self.isShowLaunchAnimation) {
        [self setupLaunchMask];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
            }];
        }];
    }
}

#pragma mark - private
- (void)setupLaunchMask{
    _launchMask = [UIImageView imageViewWithFrame:self.view.bounds image:[UIImage imageNamed:@"launchAnimationBg"]];
    
    [self.view addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"launchAnimation"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleAspectFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
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
