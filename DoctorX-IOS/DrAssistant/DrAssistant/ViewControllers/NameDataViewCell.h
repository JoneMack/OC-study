//
//  NameDataViewCell.h
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameDataViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
@end
