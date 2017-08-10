//
//  HouseSourceDetailFourthCellTableSubCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailFourthCellTableSubCell.h"

@implementation HouseSourceDetailFourthCellTableSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.sexLogo = [[UIImageView alloc] init];
        [self.sexLogo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"female"]]];
        self.sexLogo.frame = CGRectMake(30, 9, 22, 22);
        [self.contentView addSubview:self.sexLogo];
        
        self.room = [UILabel new];
        self.room.frame = CGRectMake(self.sexLogo.rightX+15, 10, screen_width*0.14, 21);
        self.room.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        [self.room setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.room];
        
        self.sex = [UILabel new];
        self.sex.frame = CGRectMake(self.room.rightX, 10, screen_width*80/750, 21);
        self.sex.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        [self.sex setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.sex];
        
        self.xingzuo = [UILabel new];
        self.xingzuo.frame = CGRectMake(self.sex.rightX, 10, screen_width*140/750, 21);
        self.xingzuo.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        [self.xingzuo setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.xingzuo];
        
        
        self.age = [UILabel new];
        self.age.frame = CGRectMake(self.xingzuo.rightX, 10, screen_width*120/750, 21);
        self.age.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        [self.age setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.age];
        
        self.mianji = [UILabel new];
        self.mianji.frame = CGRectMake(self.age.rightX, 10, 43, 21);
        self.mianji.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        [self.mianji setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.mianji];

    }
    return self;
}

-(void) renderData:(RoomShip *)roomShip
{
    NSLog(@" roomShip :%@" , roomShip);
    if([roomShip.alreadyStay isEqualToString:@"0"]){
        // 未入住
        [self.sexLogo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"female"]]];
        self.room.text = roomShip.roomName;
        self.sex.text = @"-";
        self.xingzuo.text = @"-";
        self.age.text = @"-";
        self.mianji.text = @"-";
        
    }else{
        if ([roomShip.sex isEqualToString:@"男"]) {
           [self.sexLogo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"male"]]];
        }else{
            [self.sexLogo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"female"]]];
        }
        self.room.text = roomShip.roomName;
        
        self.sex.text = roomShip.sex;
        self.xingzuo.text = @"天蝎座";
        self.age.text = @"80后";
        self.mianji.text = [NSString stringWithFormat:@"%@平" , roomShip.roomArea];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
