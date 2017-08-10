//
//  PatientDetailTableViewCell.h
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientDetailTableViewCell : UITableViewCell

+ (instancetype)patientDetailTableViewCell;
@property (weak, nonatomic) IBOutlet UILabel *leftLabCell;
@property (weak, nonatomic) IBOutlet UIImageView *reightImageCell;
@property (weak, nonatomic) IBOutlet UILabel *recordTimelabCell;

@end
