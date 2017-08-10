//
//  YuYueRecordCell.h
//  DrAssistant
//
//  Created by hi on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuYueRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *keMu;
@property (weak, nonatomic) IBOutlet UILabel *yiYuan;

@property (weak, nonatomic) IBOutlet UILabel *noteInfo;

@property (weak, nonatomic) IBOutlet UILabel *date;
@end
