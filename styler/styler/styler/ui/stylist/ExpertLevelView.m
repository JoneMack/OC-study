//
//  ExpertLevelView.m
//  styler
//
//  Created by aypc on 13-12-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ExpertLevelView.h"

@implementation ExpertLevelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExpertLevelView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}



//初始为0心 老客8成 新客2成 黑卡
//10个预约1心 老客6成 新客4成 金卡
//20个预约2心 老客4成 新客6成 银卡
//30个预约3心 老客2成 新客8成 粉卡
//40个预约4心
//50个预约1星
//100个预约2星
//300个预约3星
//400个预约4星
//500个预约5星
//600个预约1钻
//800个预约2钻
//1000个预约3钻
//1200个预约4钻
//1400个预约5钻
//2000个预约1银色黄冠
//4000个预约2银色黄冠
//6000个预约3银色皇冠
//8000个预约4银色皇冠
//10000个预约为5银色皇冠
//13000个预约为1金色皇冠

-(void)loadWithLevel:(int)level
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
