//
//  MyClubCell.h
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyClubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumnail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property(strong,nonatomic)NSString* cludId;
@end
