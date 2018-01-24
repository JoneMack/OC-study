//
//  RedpacketController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "RedpacketController.h"

#import <Masonry/Masonry.h>

#define screen_width          [UIScreen mainScreen].bounds.size.width
#define screen_height          [UIScreen mainScreen].bounds.size.height
@interface RedpacketController ()

@end

@implementation RedpacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
//    [self initBtnView];
    
//    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
//    self.bgView.backgroundColor = [UIColor orangeColor];
//    self.bgView.userInteractionEnabled = YES;
//    [self.view addSubview:self.bgView];
    [self beginBtnClick];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRed:)];
    [self.view addGestureRecognizer:tap];
}

//- (void)initBtnView{
//    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.beginBtn.frame = CGRectMake(0, screen_height-50, screen_width/2, 50);
//    [self.beginBtn setTitle:@"开始" forState:UIControlStateNormal];
//    self.beginBtn.backgroundColor = [UIColor cyanColor];
//    [self.beginBtn addTarget:self action:@selector(beginBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.beginBtn];
//
//    self.endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.endBtn.frame = CGRectMake(screen_width/2, screen_height-50, screen_width/2, 50);
//    [self.endBtn setTitle:@"结束" forState:UIControlStateNormal];
//    self.endBtn.backgroundColor = [UIColor cyanColor];
//    [self.beginBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.endBtn];
//}


- (void)beginBtnClick{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.5) target:self selector:@selector(addAnimation) userInfo:nil repeats:YES];
}

//- (void)showRain{
//    UIImageView * imageV = [UIImageView new];
//    imageV.image = [UIImage imageNamed:@"x.png"];
//    imageV.frame = CGRectMake(0, 0, 44 , 62.5 );
//
//    self.moveLayer = [CALayer new];
//    self.moveLayer.bounds = imageV.frame;
//    self.moveLayer.anchorPoint = CGPointMake(0, 0);
//    self.moveLayer.position = CGPointMake(0, -62.5 );
//    self.moveLayer.contents = (id)imageV.image.CGImage;
//    [self.view.layer addSublayer:self.moveLayer];
//
//    [self addAnimation];
//}

- (void)addAnimation
{
//    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % (414), 0)];
//    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % (414), screen_height)];
//    moveAnimation.values = @[A,B];
//    moveAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
//    moveAnimation.repeatCount = 1;
//    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [self.moveLayer addAnimation:moveAnimation forKey:nil];
//
//    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
//    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
//    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
//    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    tranAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
//    //为了避免旋转动画完成后再次回到初始状态。
//    [tranAnimation setFillMode:kCAFillModeForwards];
//    [tranAnimation setRemovedOnCompletion:NO];
//    [self.moveLayer addAnimation:tranAnimation forKey:nil];
    
    CALayer *moveLayer = [CALayer new];
    moveLayer.bounds = CGRectMake(0, 0, 40, 80);
    moveLayer.anchorPoint = CGPointMake(0, 0);
    moveLayer.position = CGPointMake(0, -80/2);
    moveLayer.contents = (id)[UIImage imageNamed:@"x"].CGImage;
    [self.view.layer addSublayer:moveLayer];
    
   
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, 0)];
    NSValue *B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, screen_height)];
    
    moveAnimation.values = @[A,B];
    moveAnimation.duration = arc4random() %200 / 100.0 + 3.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [moveLayer addAnimation:moveAnimation forKey:nil];
    
    CAKeyframeAnimation *transAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360),0,0,-1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360),0,0,-1);
    
    transAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
    transAnimation.duration = arc4random() %200 / 100.0 + 3.5;
    transAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [transAnimation setFillMode:kCAFillModeForwards];
    [transAnimation setRemovedOnCompletion:NO];
    [moveLayer addAnimation:transAnimation forKey:nil];
    
}

- (void)clickRed:(UITapGestureRecognizer *)sender{
    NSLog(@"-------------点击");
    
    CGPoint point = [sender locationInView:self.view];
    for (int i = 0 ; i < self.view.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.view.layer.sublayers[i];
        if ([[layer presentationLayer] hitTest:point] != nil)
        {
            NSLog(@"%d",i);
            
            BOOL hasRedPacketd = !(i % 3) ;
            
            UIImageView * newPacketIV = [UIImageView new];
            if (hasRedPacketd)
            {
                newPacketIV.image = [UIImage imageNamed:@"logo.jpeg"];
                newPacketIV.frame = CGRectMake(0, 0, 63.5, 74);
            }
            else
            {
                newPacketIV.image = [UIImage imageNamed:@"x"];
                newPacketIV.frame = CGRectMake(0, 0, 45.5, 76.5);
            }
            
            layer.contents = (id)newPacketIV.image.CGImage;
            
            UIView * alertView = [UIView new];
            alertView.layer.cornerRadius = 5;
            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
            [self.view addSubview:alertView];
            
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:17];
            
            if (!hasRedPacketd)
            {
                label.text = @"旺旺年！人旺旺";
                label.textColor = [UIColor whiteColor];
            }
            else
            {
                NSString * string = [NSString stringWithFormat:@"+%d金币",i];
                NSString * iString = [NSString stringWithFormat:@"%d",i];
                NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:27]
                                      range:NSMakeRange(0, 1)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangTC-Semibold" size:32]
                                      range:NSMakeRange(1, iString.length)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:17]
                                      range:NSMakeRange(1 + iString.length, 2)];
                label.attributedText = attributedStr;
                label.textColor = [UIColor purpleColor];
            }
            
            [alertView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView.mas_centerX);
                make.centerY.equalTo(alertView.mas_centerY);
            }];
            
            [UIView animateWithDuration:1 animations:^{
                alertView.alpha = 0;
                alertView.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
            } completion:^(BOOL finished) {
                [alertView removeFromSuperview];
            }];
        }
    }
}

//- (void)endBtnClick{
//
//    [self.timer invalidate];
//
//    for (NSInteger i = 0; i < self.view.layer.sublayers.count ; i ++)
//    {
//        CALayer * layer = self.view.layer.sublayers[i];
//        [layer removeAllAnimations];
//    }
//}

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
