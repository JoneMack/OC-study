//
//  MainJoinUsView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainJoinUsView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titl1;

@property (strong, nonatomic) IBOutlet UIButton *phone;

@property (strong, nonatomic) IBOutlet UIButton *joinUs;

@property (strong, nonatomic) UIView *separatorLine;

@property (nonatomic , strong) UINavigationController *navigationController;

- (IBAction)weituochuzhu:(id)sender;

@end
