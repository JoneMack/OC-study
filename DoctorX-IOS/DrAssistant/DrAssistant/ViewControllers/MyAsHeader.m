//
//  MyAsHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyAsHeader.h"

@implementation MyAsHeader

+ (instancetype)asHeader
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyAsHeader" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    self.avatar.layer.masksToBounds = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
