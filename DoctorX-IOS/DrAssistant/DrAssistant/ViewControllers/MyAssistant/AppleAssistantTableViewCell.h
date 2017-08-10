//
//  AppleAssistantTableViewCell.h
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppleAssistantTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *baseImage;
@property (weak, nonatomic) IBOutlet UILabel *baseLable;
@property (weak, nonatomic) IBOutlet UIButton *baseBtn;
@property (weak, nonatomic) IBOutlet UIView *imageAndAssTypView;
@property (weak, nonatomic) IBOutlet UILabel *assTypeNameLab;
@end
