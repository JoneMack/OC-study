//
//  ExpertMessageCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertMessage.h"
#import "Expert.h"
#import "ExpertMessageFrame.h"

@interface ExpertMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellBodyView;
@property (strong, nonatomic) IBOutlet UIImageView *expertAvatar;


@property (strong, nonatomic) IBOutlet UILabel *expertName;


@property (strong, nonatomic) IBOutlet UILabel *createTime;

@property (strong, nonatomic) IBOutlet UIImageView *privateIcon;

@property (strong, nonatomic) IBOutlet UILabel *messageContent;

@property (strong, nonatomic) IBOutlet UIImageView *expertMessageImg;

@property (strong, nonatomic) IBOutlet UIButton *praiseBtn;

@property (strong, nonatomic) UIView *showMaxImgView;



@property (strong , nonatomic) ExpertMessage *expertMessage;
@property (strong , nonatomic) Expert *expert;


-(instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void) renderWithExpertMessage:(ExpertMessage *)expertMessage expert:(Expert *)expert;


-(void) renderBaseFrame:(ExpertMessageFrame *)expertMessageFrame;

- (IBAction)praiseMessage:(id)sender;

@end
