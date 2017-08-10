//
//  Macros.h
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#ifndef DrAssistant_Macros_h
#define DrAssistant_Macros_h

#define umeng_app_key   @"5617711267e58e3dfb002747"
#define easemob_app_key   @"doctor123#doctorx"
#define wx_appid        @"wxdef127146f8b708a"
#define wx_appSecret    @"8380f2334ae8b1e3f92ba0dbbfce444f"
#define qq_appid        @"1104878782"
#define qq_app_key      @"1g1bkUiLMh3bgSXG"

#define umeng_share_txt  @"作为一家为中国医生提供“专属助理”服务的公司，我们将会第一时间搭建起您和医生联系的桥梁，并及时推荐更适合您疾病治疗的专科医生，细腻、贴心、持续、无缝隙的医生助理服务将会带给您更加便捷、高效的医疗体验！"

#define umeng_share_url   @"http://www.doctor-assistant.cn"

//群聊类型
#define patients_group_list    @"ZZDBDZKJYXGS0"
#define tongHang_group_list    @"ZZDBDZKJYXGS1"
#define huizhen_group_list     @"ZZDBDZKJYXGS2"


#define BLOCK_SAFE_RUN(block, ...)              block ? block(__VA_ARGS__) : nil;

#endif
