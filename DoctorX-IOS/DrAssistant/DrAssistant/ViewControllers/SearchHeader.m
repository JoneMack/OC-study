//
//  SearchHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/14.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "SearchHeader.h"

@implementation SearchHeader

+ (instancetype)searchHeader
{
   return  [[[NSBundle mainBundle] loadNibNamed:@"SearchHeader" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.v_QuYU.tag = QuYuTag;
    self.v_YiYuan.tag = YiYuanTag;
    self.v_KeShi.tag = KeShiTag;
//    self.chaXunBtn.tag = chaXunTag;
    
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.v_QuYU addGestureRecognizer: g1];
    UITapGestureRecognizer *g2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.v_YiYuan addGestureRecognizer: g2];
    UITapGestureRecognizer *g3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.v_KeShi addGestureRecognizer: g3];
    
}


- (void)tap:(UITapGestureRecognizer *)tapG
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchHeaderclickAtbtn:)]) {
        [_delegate searchHeaderclickAtbtn: tapG.view.tag];
    }
}

- (IBAction)chaXunAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(searchHeaderclickAtbtn:)]) {
        [_delegate searchHeaderclickAtbtn: sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
