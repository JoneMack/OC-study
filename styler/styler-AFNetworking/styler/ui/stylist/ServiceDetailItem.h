//
//  ServiceDetailItem.h
//  styler
//
//  Created by System Administrator on 13-7-4.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonItemTxt.h"


#define service_detail_padding 10
#define title_font_size 13
#define content_font_size 13
#define title_width 45

@interface ServiceDetailItem : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;

@property (nonatomic, retain) CommonItemTxt *itemTxt;

+(id) instanceServiceDetailItem:(CommonItemTxt *)itemText;
-(void) initUI;
+(CGSize) contentSize:(NSString *)content;
+(float) judgeHeight:(NSArray *)itemTxts;

@end
