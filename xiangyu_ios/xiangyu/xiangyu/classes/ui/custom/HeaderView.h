//
//  HeaderView.h
//  styler
//
//  Created by System Administrator on 14-1-16.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView


@property (strong, nonatomic) IBOutlet UIButton *leftBtn;

@property (strong, nonatomic) IBOutlet UIButton *centerBtn;

@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UIButton *rightLongBtn;

@property (weak, nonatomic) UINavigationController *nc;
@property (nonatomic, assign) popType type;

-(id) initWithTitle:(NSString *)title navigationController:(UINavigationController *)nc;



-(void) renderRightBtn:(NSString *)imgName;

- (IBAction)leftBtnEvent:(id)sender;

- (IBAction)centerBtnEvent:(id)sender;







@end
