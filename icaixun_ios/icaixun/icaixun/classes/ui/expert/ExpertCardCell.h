//
//  ExpertCardCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"

@interface ExpertCardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellBodyView;

@property (strong, nonatomic) IBOutlet UIImageView *expertAvatar;


@property (strong, nonatomic) IBOutlet UILabel *expertName;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;


@property (strong, nonatomic) IBOutlet UILabel *messageCount;


@property (strong, nonatomic) IBOutlet UILabel *subscribeLabel;

@property (strong, nonatomic) IBOutlet UILabel *subscribeCount;

@property (strong, nonatomic) IBOutlet UILabel *authInfo;
    

@property (strong, nonatomic) IBOutlet UIButton *attentionStatus;

@property (strong, nonatomic) IBOutlet UIButton *subscribeStatus;


@property (nonatomic , strong) Expert *expert;
@property (nonatomic , copy) NSString *relationStatus; // 与专家的状态 , 关注:Follow , 收藏:Subscribe , 没有关注：None
@property (nonatomic , strong) UINavigationController *navigationController;

- (void) renderWithExpert:(Expert *)expert navigationController:(UINavigationController *)navigationController;

- (IBAction)updateAttentionStatus:(id)sender;


- (IBAction)subscribeExpert:(id)sender;

@end
