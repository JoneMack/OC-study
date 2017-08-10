//
//  MenZhenYuYueCell.h
//  DrAssistant
//
//  Created by hi on 15/9/8.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoYuYueDelegate <NSObject>
@optional
-(void)goYuYueBtnAction:(UIButton *) btn;
@end
@interface MenZhenYuYueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *yuYueBtn;

@property (weak, nonatomic) IBOutlet UILabel *hospitalLab;

@property (weak, nonatomic) IBOutlet UILabel *keShiLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLAB;
@property(weak, nonatomic)id<GoYuYueDelegate>delegate;
@end
