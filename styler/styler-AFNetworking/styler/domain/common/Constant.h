//
//  Constant.h
//  styler
//
//  Created by System Administrator on 13-5-10.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "UIImage+imagePlus.h"

#define navigation_height     44
#define status_bar_height     20
#define tabbar_height         51
#define general_margin        15
#define general_cell_height   44
#define general_padding       10
#define general_height        40
#define splite_line_height    0.5
#define screen_width          [UIScreen mainScreen].bounds.size.width
#define main_content_height   [UIScreen mainScreen].bounds.size.height - self.header.frame.size.height
#define bottomY(view)         view.frame.size.height + view.frame.origin.y
#define leftX(view)           view.frame.size.width + view.frame.origin.x
#define IOS6                  ([[[UIDevice currentDevice] systemVersion] floatValue] < 7)?YES:NO
#define IOS7                  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO
#define IOS8                  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO
#define loading_frame         CGRectMake(0, 100, screen_width, 40)
#define red_dot_width          7

//字体大小
#define smallest_font_size  10
#define smaller_font_size   11
#define small_font_size     12
#define default_2_font_size 13
#define default_font_size   14
#define default_1_font_size 15
#define big_font_size       16
#define bigger_font_size    18
#define biggest_font_size   24
#define default_txt_height  16
//色值
#define black_text_color          @"#222222"
#define gray_text_color           @"#666666"
#define gray_place_holder_color   @"#dcdcdc"
#define orange_text_color         @"#ff532b"
#define white_text_color          @"#ffffff"
#define light_gray_text_color     @"#999999"
#define lighter_gray_text_color   @"#cccccc"
#define backgroud_color           @"#f6f6f6"
#define splite_line_color         @"#cccccc"
#define red_color                 @"#cc0000"
#define blue_color                @"#3399ff"
#define red_default_color         @"#ea0000"
#define red_select_color          @"#cc3300"
#define green_background_color    @"#7cc576"
#define light_gray_color          @"#f2f2f2"
#define light_gray_2_color        @"#e5e5e5"
#define green_order_status_backgroud_color  @"#7cc576"
#define gray_order_status_backgroud_color   @"#cccccc"
#define blue_order_status_backgroud_color   @"#90c4f5"
#define orange_order_status_backgroud_color @"#ff9933"
//绿色#7cc576   灰色#cccccc  蓝色#90c4f5 橙色#ff9933

#define account_session_from_inx                  1
#define account_session_from_feedback             2
#define account_session_from_my_order             3
#define account_session_from_my_stylist           4
#define account_session_from_my_favorite          5
#define account_session_from_add_favorite_works   6
#define account_session_from_add_favorite_stylist 7
#define account_session_from_user_home            8
#define account_session_from_stylist_order        10
#define account_session_from_stylist_profile_set_evaluation 11
#define account_session_from_evaluations_set_evaluation     12
#define account_session_from_buy_card             13

#define brand_cell_height   100
#define network_timeout     10
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

#define work_list_page_size    10
#define stylist_list_page_size 20
#define evaluation_page_size   500
#define user_hdc_page_size     10

#define user_common_styler_type  3
#define my_fav_styler_type       2
#define common_styler_type       1

#define tabbar_item_index_special_offer 0
#define tabbar_item_index_work          1
#define tabbar_item_index_contact       2
#define tabbar_item_index_me            3


//通知
#define notification_name_update_user_name                  @"updateNameNotification"
#define notification_name_update_user_avatar                @"updateAvatar"
#define notification_name_update_user_gender                @"updateGenderNotification"
#define notification_name_user_login                        @"userLogin"
#define notification_name_user_order_stylist                @"userOrder"
#define notification_name_session_update                    @"sessionUpdate"
#define notification_name_pn_account_session_from           @"accountSessionFrom"
#define notification_name_update_fav_stylist                @"removeFavstylist"
#define notification_name_paid_success_collection_stylist   @"paidSuccessCollectionStylist"
#define notification_name_receive_feedback_info             @"receiveFeedBackInfo"
#define notification_name_read_all_feedback_info            @"readAllFeedBackInfo"
#define notification_name_order_changed                     @"myOrderChanged"
#define notification_name_social_account_status_changed     @"social_account_changed"
#define notification_name_update_post_queue                 @"update_post_queue"
#define notification_name_update_my_evaluations             @"update_my_evalutions"
#define notification_name_post_evaluation                   @"post_evaluaiton"
#define notification_name_update_push                       @"update_push"
#define notification_name_log_out                           @"log_out"
#define notification_name_update_has_unevaluate_order       @"update_has_unevaluation"
#define notification_name_update_has_unpayment_hdc          @"update_has_unpayment_hdc"
#define notification_name_remove_red_envelope_activity_mark   @"remove_red_envelope_activity_mark"
#define notification_name_update_work_list                  @"update_work_list"
#define notification_name_im_message_status_update          @"im_message_status_update"
#define notification_name_update_red_dot                    @"update_red_dot"
#define notification_name_user_shared_success_show_reward_activity  @"user_shared_success_show_reward_activity"
#define notification_name_reward_activity_after_input_mobile_no     @"reward_activity_after_input_mobile_no"
#define notification_name_reload_table_view                 @"reload_table_view"
#define notification_name_has_new_stylist_works             @"hasNewStylistWorks"


//
#define gaode_map_key        @"455d1bd453f3f2450dc1db2ae3e9d375"
#define umeng_app_key        @"51f6226a56240b8f80050ba4"
#define weixin_developer_id  @"wx8216675fb452a3d6"
//分享文字
#define share_app_txt                @"用时尚猫美发，比办卡、团购都省钱，而且服务好效果赞！"
#define share_work_txt               @"好漂亮的发型，真心喜欢！"
#define share_work_follow_sina_weibo @"这个发型不错，很喜欢。"
#define share_organization_txt       @"常去这家做头发，品质、优惠非常棒！"
#define share_profile_txt            @"一位服务、技术、时尚感都很赞的发型师，推荐给大家。"
#define share_profile_title_txt      @"一位技术、时尚感都很赞的发型师！"
#define um_share_app_icon [UIImage loadImageWithImageName:@"logo_1024"]
#define special_offer_note          @"1)最终价格以店内实际选择的产品及服务而定\n2)相关优惠为时尚猫用户预约专享\n3)仅限本人当次消费使用\n4)优惠不可抵扣现金、不与店内其他优惠叠加使用\n5)到店后请向发型师出示预约单以享受优惠";

#define order_reminder      @"建议购买此发型师适用的美发卡搭配使用，否则将\n无法享受专享优惠与折扣。"
#define order_illustrate    @"请准时到店，迟到请拨沙龙电话或时尚猫，迟到超10分钟将不保证发型师为您按时提供服务。\n预约后提前1小时可以取消预约或更改预约时间。\n到店后请告知沙龙前台您的手机号后4位及预约发型师。\n预约后更改预约时间请先取消预约后再进行新的预约。\n每天晚7点至早10点间提交的预约，我们将在早11点前进行确认。"
#define order_detail_illustrate     @"请准时到店，迟到请拨沙龙电话或时尚猫，迟到超10分钟将不保证发型师为您按时提供服务。\n预约后提前1小时可以取消预约或更改预约时间。\n到店后请告知沙龙前台您的手机号后4位及预约发型师。\n预约后更改预约时间请先取消预约后再进行新的预约。"

#define share_to_sina_weibo_key     @"share_to_sina_weibo"
#define binding_sina_weibo_key      @"binding_sina_weibo"
#define binding_wechat_key          @"binding_wechat"
#define binding_qq_key              @"binding_qq"
#define binding_tencent_weibo_key   @"binding_tencent_weibo"


#define page_name_home                       @"首页"
#define page_name_special_offers             @"优惠"
#define page_name_special_offers_title       @"时尚猫"
#define page_name_all_hdc_type_title         @"全部美发卡类型"
#define page_name_work_detail                @"作品详情页"
#define page_name_work_pictures              @"作品图片浏览页"
#define page_name_stylist_profile            @"发型师主页"
#define page_name_stylist_introduction       @"发型师介绍页"
#define page_name_stylist_work_list          @"发型师作品列表"
#define page_name_my_fav_works               @"我收藏的作品列表"
#define page_name_tag_work_list              @"标签作品列表"
#define page_name_stylist_special_offer_list @"发型师优惠列表"
#define page_name_information                @"个人信息"
#define page_name_user_center                @"个人中心"
#define page_name_setting_name               @"姓名"
#define page_name_setting_sex                @"性别"
#define page_name_setting_pwd                @"修改密码"
#define page_name_bing_socail_account        @"账号关联"
#define page_name_reg                        @"会员注册"
#define page_name_first_login                @"用户注册"
#define page_name_login                      @"会员登录"
#define page_name_my_order                   @"我的订单"
#define page_name_order_detail_info          @"预约详情"
#define page_name_choose_service_packge      @"选择服务"
#define page_name_choose_service_condition   @"选择项目"
#define page_name_choose_order_time          @"选择时间"
#define page_name_order_service_items        @"订单项目"
#define page_name_organization_list          @"商户列表"
#define page_name_organization_detail        @"商户主页"
#define page_name_more                       @"更多"
#define page_name_my_evaluations             @"我的评价"
#define page_name_feedback                   @"在线客服"
#define page_name_notice                     @"系统消息"
#define page_name_about_us                   @"关于我们"
#define page_name_common                     @"常用"
#define page_name_organization_map           @"机构地图"
#define page_name_price_list                 @"价目表"
#define page_name_sort_content_list          @"栏目内容列表"
#define page_name_evaluation                 @"评价"
#define page_name_evaluation_creator         @"评价发表页"
#define page_name_evaluation_pictures        @"评价照片"
#define page_name_evaluation_picture         @"查看单张评价照片(发表评价时)"
#define page_name_organization_evaluation    @"店铺评价"
#define page_name_stylist_evaluations        @"全部评价"
#define page_name_all_businesscircles        @"全部商圈"
#define page_name_all_brand                  @"选择沙龙品牌"
#define page_name_all_hair_style             @"全部发型"
#define page_name_stylist_list               @"发型师列表"  
#define page_name_buy_hdc                    @"提交订单"
#define page_name_my_hdcs                    @"我的美发卡"
#define page_name_my_red_envelope            @"我的红包"
#define page_name_user_select_red_envelope   @"选择使用的红包"
#define page_name_refund                     @"退款"
#define page_name_alipay_payment             @"支付宝支付"
#define page_name_hdc                        @"美发卡详情页"
#define page_name_user_hdc_detail            @"用户美发卡详情页"
#define page_name_reward_activity_remind     @"奖励活动提醒"
#define page_name_reward_activity_over       @"奖励活动没有奖品"
#define page_name_reward_activity_get        @"奖励活动得到奖品"
#define page_name_reward_activity_input_mobile_no   @"奖励活动输入手机号"
#define page_name_organization_special_offer_list   @"优惠列表"


#define log_event_name_organization_brand        @"选择品牌"
#define log_event_name_hdc_type                  @"选择美发卡类型"
#define log_event_name_add_fav_work              @"收藏作品"
#define log_event_name_remove_fav_work           @"删除收藏作品"
#define log_event_name_add_fav_stylist           @"收藏发型师"
#define log_event_name_remove_fav_stylist        @"删除收藏发型师"
#define log_event_name_forget_psw                @"忘记密码"
#define log_event_name_get_psw                   @"获取密码"
#define log_event_name_share_to_sina_weibo       @"分享到新浪微博"
#define log_event_name_share_to_sina_weibo_evaluation @"评价自动分享到新浪微博"
#define log_event_name_share_to_sina_weibo_collection @"收藏自动分享到新浪微博"
#define log_event_name_share_to_wechat_Fav       @"分享到微信收藏"
#define log_event_name_share_to_wechat_session   @"分享到微信好友"
#define log_event_name_share_to_wechat_time_line @"分享到微信朋友圈"
#define log_event_name_share_to_sms              @"分享到短信"
#define log_event_name_goto_feedback             @"进入在线客服"
#define log_event_name_goto_my_stylist           @"查看我的发型师"
#define log_event_name_goto_my_collect_work_list @"查看我收藏的作品"
#define log_event_name_goto_my_order             @"查看我的预约"
#define log_event_name_goto_login                @"提交登录"
#define log_event_name_goto_reg                  @"注册"
#define log_event_name_submit_reg                @"提交注册"
#define log_event_name_check_active_code         @"校验激活码"
#define log_event_name_goto_my_evaluations       @"查看我的评价"
#define log_event_name_goto_unevaluation         @"查看待评价"
#define log_event_name_goto_user_set             @"设置"
#define log_event_name_change_avatar             @"更新头像"
#define log_event_name_cancel_logoin             @"退出登录"
#define log_event_name_change_name               @"更新用户名"
#define log_event_name_submit_new_name           @"提交新用户名"
#define log_event_name_work_list_paging          @"作品列表翻页"
#define log_event_name_change_gender             @"设置性别"
#define log_event_name_submit_new_gender         @"提交新性别"
#define log_event_name_search_stylist            @"搜索发型师"
#define log_event_name_change_psw                @"更新密码"
#define log_event_name_submit_new_psw            @"提交新密码"
#define log_event_name_sender_feedback           @"发表反馈"
#define log_event_name_goto_about_us             @"查看关于我们"
#define log_event_name_clean_cache               @"清除缓存"
#define log_event_name_goto_stylist_profile      @"查看发型师详情"
#define log_event_name_order_stylist             @"预约发型师"
#define log_event_name_sender_evaluation                   @"发表评价"
#define log_event_name_delete_evaluation_image             @"删除评价照片"
#define log_event_name_check_evluation_picture             @"查看评价照片"
#define log_event_name_goto_order_detail_info              @"查看预约详情"
#define log_event_name_goto_sender_evaluation_page         @"查看发型师评价"
#define log_event_name_goback_myself_center                @"查看预约-回到个人中心"
#define log_event_name_goback_stylist_profile              @"回到发型师主页-购买超值美发卡"
#define log_event_name_view_stylist_from_work              @"从作品查看发型师"
#define log_event_name_choose_service_package              @"选择服务包"
#define log_event_name_view_evaluations                    @"查看发型师评价"
#define log_event_name_view_price_list                     @"查看价目表"
#define log_event_name_view_stylist_work_list       @"查看作品列表"
#define log_event_name_call_org_phone               @"拨打机构电话"
#define log_event_name_confirm_call_org_phone       @"确认拨打电话"
#define log_event_name_view_org_map                 @"查看地图"
#define log_event_name_view_same_org_stylist        @"查看同店发型师"
#define log_event_name_view_stylist_introduction    @"查看发型师介绍"
#define log_event_name_select_brand                 @"查看全部品牌"
#define log_event_name_select_org                   @"查看机构详情"
#define log_event_name_select_district              @"选择城区"
#define log_event_name_select_businesscirlces       @"选择商圈"
#define log_event_name_add_evaluation_image         @"添加评价照片"
#define log_event_name_choose_order_time            @"确认选择预约时间"
#define log_event_name_order                        @"提交预约"
#define log_event_name_brand                        @"查看品牌下商户"
#define log_event_name_phone_order                  @"电话预约"   //电话预约
#define log_event_name_online_service               @"在线预约"
#define log_event_name_work_detail                  @"查看作品详情"
#define log_event_name_choose_hdc_count             @"更新美发卡购买张数"
#define log_event_name_submit_hdc_order             @"提交支付美发卡订单"
#define log_event_name_submit_hdc                   @"提交支付美发卡"
#define log_event_name_choose_map_navigation        @"选择导航方式"
#define log_event_name_view_hdc_in_stylist          @"从发型师详情页查看美发卡"
#define log_event_name_view_my_hdcs                 @"查看我的美发卡"
#define log_event_name_view_my_red_envelope         @"查看我的红包"
#define log_event_name_choose_my_hdcs_type          @"选择我的美发卡类型"
#define log_event_name_phone_service                @"拨打客服热线--常用"   //拨打客服电话
#define log_event_name_view_suitable_stylist        @"查看适用发型师"
#define log_event_name_view_hdc_in_organization     @"机构详情页查看美发卡"
#define log_event_name_buy_hdc                      @"购买美发卡"
#define log_event_name_cancel_hdc_order             @"取消用户美发卡订单"
#define log_event_name_buy_user_hdc                 @"购买用户美发卡"
#define log_event_name_refund_hdc                   @"美发卡页面退款"
#define log_event_name_refund_user_hdc              @"用户美发卡页面退款"
#define log_event_name_select_red_envelope          @"选择红包"
#define log_event_name_submit_order_stylist         @"提交预约"
#define log_event_name_login_im_success             @"登录环信成功"
#define log_event_share_immediately                 @"立即分享"
#define log_event_name_obtain_red_envelope          @"领取红包"
#define log_event_name_selected_hdc_type            @"优惠列表-选择了美发卡类型"
#define log_event_name_selected_business_circles    @"优惠列表-选择了商圈"
#define log_event_name_selected_city_district       @"优惠列表-选择了城区"
#define log_event_name_selected_order_type          @"优惠列表-选择了排序类型"

#define log_event_name_share_organization_reward_activity     @"分享机构得红包奖励活动"


#define APP_ID 673935108

#define shishangmaoAppURL @"https://itunes.apple.com/cn/app/shi-shang-mao/id673935108?mt=8"


#import <Foundation/Foundation.h>

@interface Constant : NSObject

@property (nonatomic, retain) NSArray *bgColors;

+(Constant *) sharedInstance;
-(UIColor *) getWaterfallBgColor;

@end
