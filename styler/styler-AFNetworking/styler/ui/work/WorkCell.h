//
//  WorkCell.h
//  styler
//
//  Created by wangwanggy820 on 14-6-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistWork.h"
#import "WorkDetailController.h"

#define title_height   32
#define tag_name_with  60
#define tag_name_font  13

#define work_status_out_of_stack 1
#define work_status_open 2


@interface WorkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *workWapper;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverPicture;
@property (weak, nonatomic) IBOutlet UIView *wapper;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *upSpliteLine;
@property (weak, nonatomic) IBOutlet UIView *downSpliteLine;

@property (retain, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) StylistWork *work;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn4;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn5;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn6;






-(void)initUI:(StylistWork *)work viewController:(UIViewController *)viewController;

@end
