//
//  MyPatientsCellTableViewCell.h
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPatientsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+ (instancetype)patientCell;

@end
