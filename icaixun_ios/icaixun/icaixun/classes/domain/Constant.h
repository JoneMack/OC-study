//
//  Constant.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject


// 字号大小
#define default_font_size   14

// 色值
#define black_text_color          @"#222222"
#define gray_button_color         @"#e5e5e5"
#define light_gray_text_color     @"#999999"
#define splite_line_color         @"#cccccc"
#define orange_text_color         @"#ff532b"
#define orange_text_low_color     @"#faa773"
#define orange_red_line_color     @"#ff6666"
#define gray_common_color         @"#f2f2f2"
#define gray_text_color           @"#666666"
#define gray_line_color           @"#c9c9c9"
#define gray_black_line_color     @"#707070"
#define gray_black_line2_color    @"#bfbfbf"
#define bg_black_color            @"#313131"


// 间距
#define screen_width          [UIScreen mainScreen].bounds.size.width
#define screen_height          [UIScreen mainScreen].bounds.size.height
#define general_padding       10
#define navigation_height     44
#define status_bar_height     20
#define tabbar_height         40
#define general_cell_height   44
#define splite_line_height    0.5
#define border_width          0.5

#define IOS6                  ([[[UIDevice currentDevice] systemVersion] floatValue] < 7)?YES:NO
#define IOS7                  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO
#define IOS8                  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO
#define CURRENT_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// 其它定义
#define network_timeout     10  // 超时
#define network_retry_count 1

//网络状态
#define network_unconnect_note      @"网络不通，请检查网络"
#define network_request_fail        @"网络不通，请联网后点击刷新"
#define network_status_loading      @"正在加载..."
#define network_status_cancel       @"正在取消..."
#define network_status_no_more      @"没有更多"
#define network_status_retry        @"网络不通，请重试"
#define network_status_refresh      @"下拉刷新..."
#define network_status_refreshing   @"正在刷新..."
#define network_status_register     @"正在注册..."

// 会话跳转
#define account_session_from_user_center 1

// 通知
#define notification_name_update_user_avatar        @"update_user_avatar"
#define notification_name_update_user_info          @"update_user_info"
#define notification_name_update_pay_success        @"update_pay_success"
#define notification_name_update_attention_expert      @"update_attention_expert"
#define notification_name_change_tabbar_controller  @"change_tabbar_controller"

#define notification_name_receive_expert_message    @"receive_expert_message"
#define notification_name_network_not_reachable     @"network_not_reachable"


// 状态机
#define load_data_status_waiting_load 1
#define load_data_status_loading      2
#define load_data_status_load_over    3
#define load_data_status_load_fail    4
#define load_data_status_load_success 5

#define event_load_data_init_load              1
#define event_load_data_load_success           2
#define event_load_data_load_over              3
#define event_load_data_load_fail              4
#define event_load_data_pull_up                5
#define event_load_data_pull_down              6

typedef enum{
    pay = 1,
}HeaderOtherBtnType;

@end
