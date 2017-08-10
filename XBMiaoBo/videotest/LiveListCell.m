//
//  LiveListCell.m
//  videotest
//
//  Created by xubojoy on 16/9/12.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "LiveListCell.h"

@implementation LiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatorImg.layer.cornerRadius = self.userAvatorImg.frame.size.width/2;
    self.userAvatorImg.layer.masksToBounds = YES;
    self.userAvatorImg.layer.borderColor = [ColorUtils colorWithHexString:@"#d252c3"].CGColor;
    self.userAvatorImg.layer.borderWidth = splite_line_height;
    self.roomIdLabel.textColor = [ColorUtils colorWithHexString:@"#d252c3"];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.clipsToBounds = YES;
}

- (void)renderLiveListCellWithLiveListModel:(LiveListModel *)liveListModel{
    [self.userAvatorImg sd_setImageWithURL:[NSURL URLWithString:liveListModel.smallpic] placeholderImage:[UIImage imageNamed:@""]];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:liveListModel.bigpic] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = liveListModel.myname;
    if (liveListModel.starlevel == 5) {
       self.levelImageView.image = [UIImage imageNamed:@"girl_star5_40x19"];
    }else if (liveListModel.starlevel == 2) {
        self.levelImageView.image = [UIImage imageNamed:@"girl_star2_40x19"];
    }else if (liveListModel.starlevel == 3) {
        self.levelImageView.image = [UIImage imageNamed:@"girl_star3_40x19"];
    }else if (liveListModel.starlevel == 4) {
        self.levelImageView.image = [UIImage imageNamed:@"girl_star4_40x19"];
    }else{
        self.levelImageView.image = [UIImage imageNamed:@"girl_star1_40x19"];
    }
    
    self.numLookLabel.text = [NSString stringWithFormat:@"%d人在看",liveListModel.allnum];
    self.addressLabel.text = liveListModel.gps;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间号：%d",liveListModel.roomid];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
