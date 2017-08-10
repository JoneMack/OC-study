//
//  MainFindWayCellView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainFindWayCellView.h"

@implementation MainFindWayCellView

-(void) awakeFromNib{
    
}

-(void) setLogoAndName:(NSString *)logo name:(NSString *)name
{
    [self.logo setImage:[UIImage imageNamed:logo]];
    [self.name setText:name];
}

@end
