//
//  InsetLabel.h
//  iUser
//
//  Created by System Administrator on 13-5-6.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetLabel : UILabel

@property(nonatomic) UIEdgeInsets  insets;
-(id)  initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets)  insets;
-(id)  initWithInsets: (UIEdgeInsets)  insets;

@end
