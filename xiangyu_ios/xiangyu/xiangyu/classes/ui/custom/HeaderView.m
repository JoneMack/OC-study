//
//  HeaderView.m
//  styler
//
//  Created by System Administrator on 14-1-16.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HeaderView.h"
#import "UIImage+imagePlus.h"
#import "ColorUtils.h"
@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

-(id)initWithTitle:(NSString *)titleStr navigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor whiteColor];
        self.nc = navigationController;
        
        [self.centerBtn setTitle:titleStr forState:UIControlStateNormal];
        [self.centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.centerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:bigger_font_size]];
        [self.centerBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.centerBtn.backgroundColor = [UIColor clearColor];
        
        [self.leftBtn setImage:[UIImage imageNamed:@"leftArrow"]
                      forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(popToFrontViewController:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.backgroundColor = [UIColor clearColor];
        [self.leftBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
        
        [self.rightBtn setHidden:YES];
        [self.rightLongBtn setHidden:YES];
    }
    return self;
}

-(void) renderRightBtn:(NSString *)imgName{
    
    [self.rightBtn setHidden:NO];
    [self.rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    self.rightBtn.backgroundColor = [UIColor clearColor];
}


- (IBAction)leftBtnEvent:(id)sender {
    
}

- (IBAction)centerBtnEvent:(id)sender {
    
}


-(void)popToFrontViewController:(id)sender
{
    if (self.type == from_order) {
        [self.nc popToRootViewControllerAnimated:YES];
    }else if (self.type == from_set_user_info){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_avatar object:nil];
        [self.nc popViewControllerAnimated:YES];
    }else if (self.type == from_user_shopping_cart){
        [self.nc popToRootViewControllerAnimated:YES];
    }else if (self.type == from_user_commodity_order_detail){
        [self.nc popToRootViewControllerAnimated:YES];
    }else if (self.type == from_user_commodity_order_list){
        [self.nc popToRootViewControllerAnimated:YES];
    }else if (self.type == from_fill_user_pay_vc){
        [self.nc popToRootViewControllerAnimated:YES];
    }
    else{
        [self.nc popViewControllerAnimated:YES];
    }
}

@end
