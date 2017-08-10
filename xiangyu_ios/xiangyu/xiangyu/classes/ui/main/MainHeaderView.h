//
//  MainHeaderView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderView : UIView


-(instancetype) initWithFrame:(CGRect) frame;

@property (strong, nonatomic) IBOutlet UIButton *leftMenu;

@property (strong, nonatomic) IBOutlet UIButton *currentCity;

@property (strong, nonatomic) IBOutlet UIButton *systemMsg;

- (IBAction)showLeftMenu:(id)sender;


@end
