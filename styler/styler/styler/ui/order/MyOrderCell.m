//
//  MyOrderCell.m
//  styler
//
//  Created by System Administrator on 13-6-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "MyOrderCell.h"
#import "PostEvaluationController.h"

@implementation MyOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil][0];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //初始化发型师名字
        self.stylistName.font = [UIFont systemFontOfSize:default_font_size];
        self.stylistName.textColor = [ColorUtils colorWithHexString:black_text_color];
        
        //初始化商户名字
        self.organizationName.font = [UIFont systemFontOfSize:small_font_size];
        self.organizationName.textColor = [ColorUtils colorWithHexString:black_text_color];
        
        //初始化订单名
        self.serviceName.font = [UIFont systemFontOfSize:small_font_size];
        self.serviceName.textColor = [ColorUtils colorWithHexString:gray_text_color];
        
        //初始化订单的预约时间
        self.orderTime.font = [UIFont systemFontOfSize:small_font_size];
        self.orderTime.textColor = [ColorUtils colorWithHexString:gray_text_color];
        
        //初始化分割线
        self.grayLine.frame = CGRectMake(0, self.frame.size.height - splite_line_height, self.frame.size.width, splite_line_height);
        self.grayLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    }
    return self;
}

-(void)renderOrderView:(ServiceOrder *)order
{
    self.order = order;
    
    //渲染头像
    [self.stylistAvatar setImageWithURL:[NSURL URLWithString:order.stylist.avatarUrl] placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    CALayer *layer  = self.stylistAvatar.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:layer.frame.size.width/2];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[UIColor clearColor].CGColor];

    //渲染发型师名字
    self.stylistName.text = order.stylistName;
    CGSize size = CGSizeMake(200, 25);
    CGSize stylistNameSize = [order.stylistName sizeWithFont:self.stylistName.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGRect stylistNameFrame = self.stylistName.frame;
    stylistNameFrame.size.width = stylistNameSize.width;
    self.stylistName.frame = stylistNameFrame;
    self.stylistName.backgroundColor = [UIColor clearColor];
    
    //渲染商户信息
    self.organizationName.text = order.stylist.organization.name;
    CGRect organizationNameFrame = self.organizationName.frame;
    organizationNameFrame.origin.x = self.stylistName.frame.origin.x+self.stylistName.frame.size.width+6;
    organizationNameFrame.size.width = 260-organizationNameFrame.origin.x;
    self.organizationName.frame = organizationNameFrame;
    self.organizationName.backgroundColor = [UIColor clearColor];
    //渲染订单名
    self.serviceName.text = order.orderTitle;
    self.serviceName.backgroundColor = [UIColor clearColor];
    //渲染预约时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *minuteComponents = [gregorian components:NSMinuteCalendarUnit fromDate:[order getScheduleTime]];
    if(minuteComponents.minute == 30)
    {
        [dateFormatter setDateFormat:@"yyyy年M月d日 H点半 EEE"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy年M月d日 H点 EEE"];
    }
    self.orderTime.text = [dateFormatter stringFromDate:[order getScheduleTime]];
    
    //渲染状态按钮
    [self.operateBtn setTitle:[order statusTxt] forState:UIControlStateNormal];
    [self.operateBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
    layer  = self.operateBtn.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:2];
    if (order.orderStatus == order_status_completed && order.evaluationStatus == evaluation_status_unpost) {
        self.evaluationBtn.hidden = NO;
    }else{
        self.evaluationBtn.hidden = YES;
    }

    switch (self.order.orderStatus) {
        case order_status_waiting_confirm://订单处于等待确认状态
            self.operateBtn.backgroundColor = [ColorUtils colorWithHexString:green_order_status_backgroud_color];
            break;
        case order_status_confirmed://订单处于已经确认状态
            self.operateBtn.backgroundColor = [ColorUtils colorWithHexString:green_order_status_backgroud_color];
            break;
        case order_status_canceled://订单处于取消状态
            self.operateBtn.backgroundColor = [ColorUtils colorWithHexString:gray_order_status_backgroud_color];
            break;
        case order_status_completed://订单已完成
            if (self.order.evaluationStatus == evaluation_status_unpost) {//待评价
                self.operateBtn.backgroundColor = [ColorUtils colorWithHexString:blue_order_status_backgroud_color];
            }else if (self.order.evaluationStatus == evaluation_status_post){//已评价
                self.operateBtn.backgroundColor = [ColorUtils colorWithHexString:orange_order_status_backgroud_color];
            }
            break;
        default:
            break;
    }
}

- (IBAction)operatorAction:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
