//
//  CommonInfoCell.h
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;


-(void) renderContent:(NSString *)title content:(NSString *)content contentLine:(int)contentLine;

@end
