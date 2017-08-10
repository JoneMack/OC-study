//
//  LiveListCell.h
//  videotest
//
//  Created by xubojoy on 16/9/12.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
@interface LiveListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImg;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLookLabel;

@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;


@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

- (void)renderLiveListCellWithLiveListModel:(LiveListModel *)liveListModel;

@end
