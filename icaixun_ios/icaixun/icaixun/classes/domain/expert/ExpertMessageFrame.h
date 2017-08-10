//
//  ExpertMessageFrame.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/3.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertMessage.h"

@interface ExpertMessageFrame : NSObject

/** 头像 **/
@property (nonatomic , assign) CGRect expertAvatarFrame;

@property (nonatomic , assign) CGRect expertNameFrame;
@property (nonatomic , assign) CGRect createTimeFrame;

@property (nonatomic , assign) CGRect privateFrame;

@property (nonatomic , assign) CGRect messageContentFrame;

@property (nonatomic , assign) CGRect messageImgFrame;

@property (nonatomic , assign) CGRect praiseBtnFrame;

@property (nonatomic , assign) CGRect cellBodyFrame;

@property (nonatomic , assign) float cellHeight;

-(instancetype) initWithExpertMessage:(ExpertMessage *)expertMessage;

@end
