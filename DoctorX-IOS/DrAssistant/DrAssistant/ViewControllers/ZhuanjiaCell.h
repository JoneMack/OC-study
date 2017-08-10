//
//  ZhuanjiaCell.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuanjiaCell;
@protocol  ZhuanjiaCellDelegate <NSObject>

@optional
- (void)addFriedAction:(ZhuanjiaCell *)cell;

@end

@interface ZhuanjiaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addbtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) UserEntity *entity;
- (IBAction)addDoctor:(id)sender;

@property (weak, nonatomic) id<ZhuanjiaCellDelegate>delegate;

@end
