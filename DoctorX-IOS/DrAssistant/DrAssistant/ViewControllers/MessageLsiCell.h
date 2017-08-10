//
//  MessageLsiCell.h
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageLsiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;



@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger unreadCount;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
