//
//  UpdatePassLockCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/28.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePassLockCell : UITableViewCell


@property (nonatomic , strong) UILabel *tixingLabel;
@property (nonatomic , strong) UILabel *firstStar;
@property (nonatomic , strong) UILabel *secondStar;
@property (nonatomic , strong) UILabel *thirdStar;
@property (nonatomic , strong) UILabel *fourthStar;
@property (nonatomic , strong) UILabel *fifthStar;
@property (nonatomic , strong) UILabel *sixthStar;
@property (nonatomic , strong) UIView *lineView; // 6根线

@property (nonatomic , strong) UIButton *btn1;
@property (nonatomic , strong) UIButton *btn2;
@property (nonatomic , strong) UIButton *btn3;
@property (nonatomic , strong) UIButton *btn4;
@property (nonatomic , strong) UIButton *btn5;
@property (nonatomic , strong) UIButton *btn6;
@property (nonatomic , strong) UIButton *btn7;
@property (nonatomic , strong) UIButton *btn8;
@property (nonatomic , strong) UIButton *btn9;
@property (nonatomic , strong) UIButton *btn0;

@property (nonatomic , strong) UIButton *bottomBtn;

@property (nonatomic , strong) NSString *currentStatus ; // 旧密码:old , 新的:new , 确认:confirm

@property (nonatomic , weak) UINavigationController *navigationController;

-(void) renderView;

@end
