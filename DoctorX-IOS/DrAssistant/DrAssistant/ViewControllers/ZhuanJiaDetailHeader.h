//
//  ZhuanJiaDetailHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/7.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZhuanJiaDetailHeaderTag) {

    ZaiXianLianXiTag,
    menZhenYuYueTag
};

@protocol ZhuanJiaDetailHeaderDelegate <NSObject>

- (void)ZhuanJiaDetailHeaderAction:(UIButton *)btn;

@end

@interface ZhuanJiaDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *zaixianlianxi;

@property (weak, nonatomic) IBOutlet UIButton *menZhenYuYue;
@property (weak, nonatomic) id<ZhuanJiaDetailHeaderDelegate>delegate;

+ (instancetype)initWithNib;

@end
