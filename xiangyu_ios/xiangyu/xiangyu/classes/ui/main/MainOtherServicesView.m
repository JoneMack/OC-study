//
//  MainOtherServicesView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainOtherServicesView.h"

/**
 * 首页其它服务
 */
@implementation MainOtherServicesView


-(id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MainOtherServicesView" owner:self options:nil] objectAtIndex:0];
    if (self) {

    }
    return self;
}

-(void) setFrame {

    
    CGRect frame = self.weiTuoChuZu.frame;
    frame.size.width = screen_width/3;
    self.weiTuoChuZu.frame = frame;
    
    
    frame = self.xiangYuWeiXiu.frame;
    frame.size.width = screen_width/3;
    self.xiangYuWeiXiu.frame = frame;
    
    frame = self.xiangYuBaoJie.frame;
    frame.size.width = screen_width/3;
    self.xiangYuBaoJie.frame = frame;
    
}



@end
