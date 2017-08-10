//
//  ExpertMessageFrame.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/3.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertMessageFrame.h"
#import "UILabel+Custom.h"

@implementation ExpertMessageFrame

-(instancetype) initWithExpertMessage:(ExpertMessage *)expertMessage;
{
    self = [super init];
    if (self) {
        
        self.expertAvatarFrame = CGRectMake(10, 8, 50, 50);
        
        self.expertNameFrame = CGRectMake( 70, 15, 100, 21);
        
        self.createTimeFrame = CGRectMake(70, 35, 100, 15);
        
        self.privateFrame = CGRectMake( screen_width - 50 - 30, 10, 50, 50);
        
        
        
        self.messageContentFrame = CGRectMake(17, 70, screen_width - 20 - 17*2, [self getMessageContentHeight:expertMessage]);
        
        if (expertMessage.expertMassageImages.count > 0) {
            self.messageImgFrame = CGRectMake(17, self.messageContentFrame.origin.y + self.messageContentFrame.size.height + 10,
                                              60,60);
            self.praiseBtnFrame = CGRectMake((screen_width-150)/2, self.messageImgFrame.origin.y + self.messageImgFrame.size.height , 150, 45);
        }else{
            self.praiseBtnFrame = CGRectMake((screen_width-150)/2, self.messageContentFrame.origin.y + self.messageContentFrame.size.height , 150, 45);
        }
        
        self.cellBodyFrame = CGRectMake(10, 10, screen_width - 20,
                                        self.praiseBtnFrame.origin.y+self.praiseBtnFrame.size.height);
        
        self.cellHeight = self.cellBodyFrame.origin.y +self.cellBodyFrame.size.height;
    }
    return self;
}

-(float) getMessageContentHeight:(ExpertMessage *)message
{
    UILabel *label = [UILabel new];
    label.text = message.msg;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    CGSize size = [label boundingRectWithSize:CGSizeMake(screen_width - 20 - 17*2 , 0)];
    return size.height;
}

@end
