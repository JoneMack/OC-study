//
//  CustomSwitchButton.h
//  styler
//
//  Created by aypc on 13-10-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@protocol CustomSwitchDelegate;

#import <UIKit/UIKit.h>

@interface CustomSwitchButton : UIView
{
    UIButton * switchBtn;
    UIImage * offImage;
    UIImage * onImage;
    UIImage * disenableImage;
}
@property int value;
@property BOOL enable;
@property (weak,nonatomic) id<CustomSwitchDelegate> delegate;
-(id)initWithFrame:(CGRect)frame andBackground:(UIImage *)image andButtonImage:(UIImage*)btnImage;
-(id)initWithFrame:(CGRect)frame andBackground:(UIImage *)image andOnImage:(UIImage*)OI andDisenableImage:(UIImage *)DI andButtonImage:(UIImage*)btnImage;
-(void)changeSwitchValue;
-(void)setSwitchEnable:(BOOL)enable;
-(void)setOn:(int)value;
-(void)setDisenable:(BOOL)enable;
@end

@protocol CustomSwitchDelegate <NSObject>

-(void)customSwitch:(CustomSwitchButton *)CustomSwitch ChangedValue:(int)value;

@end
