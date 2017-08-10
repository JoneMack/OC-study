//
//  HouseSourceDetailSecondCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailSecondCell.h"

@implementation HouseSourceDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.firstRow = [[UILabel alloc] init];
        self.firstRow.frame = CGRectMake(0, 20, screen_width, bigger_font_size);
        self.firstRow.textColor = [ColorUtils colorWithHexString:text_color_deep_gray2];
        self.firstRow.font = [UIFont systemFontOfSize:18];
        self.firstRow.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.firstRow];
        
        self.secondRow = [[UILabel alloc] init];
        self.secondRow.frame = CGRectMake(0, self.firstRow.bottomY+10, screen_width, 13);
        self.secondRow.textColor = [ColorUtils colorWithHexString:text_color_deep_gray3];
        self.secondRow.font = [UIFont systemFontOfSize:13];
        self.secondRow.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.secondRow];
        
        self.firstTag = [[UILabel alloc] init];
        [self.firstTag.layer setBorderWidth:0.5];
        self.firstTag.layer.masksToBounds = YES;
        self.firstTag.layer.cornerRadius = 5;
        [self.firstTag setFont:[UIFont systemFontOfSize:10]];
        self.firstTag.textAlignment = NSTextAlignmentCenter;
        [self.firstTag.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_orange] CGColor]];
        [self.firstTag setTextColor:[ColorUtils colorWithHexString:text_color_orange]];
        [self.contentView addSubview:self.firstTag];
        [self.firstTag setHidden:YES];
        
        
        self.secondTag = [[UILabel alloc] init];
        [self.secondTag.layer setBorderWidth:0.5];
        self.secondTag.layer.masksToBounds = YES;
        self.secondTag.layer.cornerRadius = 5;
        [self.secondTag setFont:[UIFont systemFontOfSize:10]];
        self.secondTag.textAlignment = NSTextAlignmentCenter;
        [self.secondTag.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_blue] CGColor]];
        [self.secondTag setTextColor:[ColorUtils colorWithHexString:text_color_blue]];
        [self.contentView addSubview:self.secondTag];
        [self.secondTag setHidden:YES];
        
        
        self.thirdTag = [[UILabel alloc] init];
        [self.thirdTag.layer setBorderWidth:0.5];
        self.thirdTag.layer.masksToBounds = YES;
        self.thirdTag.layer.cornerRadius = 5;
        [self.thirdTag setFont:[UIFont systemFontOfSize:10]];
        self.thirdTag.textAlignment = NSTextAlignmentCenter;
        [self.thirdTag.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_red] CGColor]];
        [self.thirdTag setTextColor:[ColorUtils colorWithHexString:text_color_red]];
        [self.contentView addSubview:self.thirdTag];
        [self.thirdTag setHidden:YES];
        
        
        self.fourthTag = [[UILabel alloc] init];
        [self.fourthTag.layer setBorderWidth:0.5];
        self.fourthTag.layer.masksToBounds = YES;
        self.fourthTag.layer.cornerRadius = 5;
        [self.fourthTag setFont:[UIFont systemFontOfSize:10]];
        self.fourthTag.textAlignment = NSTextAlignmentCenter;
        [self.fourthTag.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_light_purple] CGColor]];
        [self.fourthTag setTextColor:[ColorUtils colorWithHexString:text_color_light_purple]];
        [self.contentView addSubview:self.fourthTag];
        [self.fourthTag setHidden:YES];
        
        
        self.fifthTag = [[UILabel alloc] init];
        [self.fifthTag.layer setBorderWidth:0.5];
        self.fifthTag.layer.masksToBounds = YES;
        self.fifthTag.layer.cornerRadius = 5;
        [self.fifthTag setFont:[UIFont systemFontOfSize:10]];
        self.fifthTag.textAlignment = NSTextAlignmentCenter;
        [self.fifthTag.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_green] CGColor]];
        [self.fifthTag setTextColor:[ColorUtils colorWithHexString:text_color_green]];
        [self.contentView addSubview:self.fifthTag];
        [self.fifthTag setHidden:YES];
        
        
    }
    return self;
}

-(void) renderData:(HouseInfo *)houseInfo
{
    
    self.firstRow.text = [NSString stringWithFormat:@"%@  %@" , houseInfo.projectName , houseInfo.fewRoom];
    self.secondRow.text = [NSString stringWithFormat:@"%@ %@" , houseInfo.inDistrict , houseInfo.circle];
    
    float intervalWidth = (screen_width - 56*5)/6 ;
    self.firstTag.frame = CGRectMake( intervalWidth, self.secondRow.bottomY+10, 56, 21);
    self.secondTag.frame = CGRectMake( self.firstTag.rightX + intervalWidth , self.secondRow.bottomY+10, 56, 21);
    self.thirdTag.frame = CGRectMake( self.secondTag.rightX + intervalWidth , self.secondRow.bottomY+10, 56, 21);
    self.fourthTag.frame = CGRectMake( self.thirdTag.rightX + intervalWidth , self.secondRow.bottomY+10, 56, 21);
    self.fifthTag.frame = CGRectMake( self.fourthTag.rightX + intervalWidth , self.secondRow.bottomY+10, 56, 21);
    
    
    NSString *tabInfoNames = houseInfo.tabInfoName;
    NSMutableArray *newTabArr = [NSMutableArray new];
    if ([NSStringUtils isNotBlank:houseInfo.tabInfoName]) {
        NSArray *tabArrs =[tabInfoNames componentsSeparatedByString:@","];
        [newTabArr addObjectsFromArray:tabArrs];
    }
    if([newTabArr count]<5 && [newTabArr count]%2 == 0){
        [newTabArr addObject:@"相寓好房"];
    }
    if ([newTabArr count] >0) {
        [self.thirdTag setText:newTabArr[0]];
        [self.thirdTag setHidden:NO];
    }
    if (newTabArr.count >=2) {
        [self.secondTag setText:newTabArr[1]];
        [self.secondTag setHidden:NO];
        [self.fourthTag setText:newTabArr[2]];
        [self.fourthTag setHidden:NO];
    }
    if (newTabArr.count >=4) {
        [self.firstTag setText:newTabArr[3]];
        [self.firstTag setHidden:NO];
        
        [self.fifthTag setText:newTabArr[4]];
        [self.fifthTag setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    
}

@end
