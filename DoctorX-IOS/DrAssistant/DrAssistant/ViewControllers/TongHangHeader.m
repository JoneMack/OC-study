//
//  TongHangHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "TongHangHeader.h"

@implementation TongHangHeader

+ (instancetype)tongHangHeader
{
   NSArray *ayy = [[NSBundle mainBundle] loadNibNamed:@"TongHangHeader" owner:nil options:nil];
   return [ayy lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addTonghang.tag = addTonghangTag;
    self.qunFaXIaoXi.tag = qunFaXIaoXiTag;
    self.myQunLiao.tag = myQunLiaoTag;
    self.addHuiZhen.tag = addHuiZhenTag;
    self.jieZhen.tag = jieZhenTag;
    self.goodDoc.tag = goodDocTag;
}

- (IBAction)btnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(MyTongHangHeaderAction:)]) {
        [_delegate MyTongHangHeaderAction:sender];
    }
}
- (IBAction)newGroup:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(creatNewGroup)]) {
        [_delegate creatNewGroup];
    }
}

@end
