//
//  URLMacros.h
//  DrAssistant
//
//  Created by hi on 15/8/28.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#ifndef DrAssistant_URLMacros_h
#define DrAssistant_URLMacros_h
#define test                       @"http://182.92.105.56"
#define  BASEURL                  @"http://101.201.148.249/doctorx"
//#define  BASEURL                  @"http://192.168.1.188:8080/doctorx"
#define LOGIN_URL               @"/action/user/login"
#define REGISTER_URL            @"/action/user/register"
#define FINDPWD_URL             @"/action/user/updatePassword"
#define UPDATE_USER_INFO_URL    @"/action/user/updateUserInfo"
#define ADDCASE_URL             @"/action/club/uploadClubParam"
#define UPLOAD_IMAGE_URL        @"/upload/uploadImage"
#define VALIDATECODEURL         @"/action/user/getCheckCode"
#define MYCLUBURL               @"/action/club/getMyClubs"
#define ZHUANJIALISTURL         @"/action/club/getClubExperts"
#define ADS_URL                 @"/action/ads/getAllAds"
#define ClubParamListURl        @ "/action/club/getClubParamList"
#define uploadClubParam         @"/action/club/uploadClubParam"
#define AllOrgs_URL             @"/action/org/getAllOrgs"
#define getMyDoctors_URL        @"/action/user/getMyDoctors"
#define getGroups_URL           @"/action/group/getGroupsByType"
#define searchUser_URL          @"/action/user/searchUser"
#define getDoctorsByOrgIdAndDeptId_URL  @"/action/user/getDoctorsByOrgIdAndDeptId"
#define getAssistantInfo_url          @"/action/assistant/getAssistantInfo"
#define contactAgreed          @"/action/group/contactAgreed"
#define getUserInfo_by_username_url  @"/action/user/getUserInfo"
#define addUserToGroup          @"/action/group/addUserToGroup"
#define getMyRecord             @"/action/record/getRecordsByNameNew"
#define payAttentionToClubUrl       @"/action/club/payAttentionToClub"
#define GetMyBespoke            @"/action/bespoke/getMyBespoke"
#define SaveBespoke             @"/action/bespoke/saveBespoke"
#define SearchDoctorsByName     @"/action/user/searchDoctorByName"
#define getDoctorBespoke            @"/action/bespoke/getDoctorBespoke"
#define GetTreatment            @"/action/treatment/getTreatment"
#define AddTreatment            @"/action/treatment/addTreatment"
#define SEARCHHOSPITAL          @"/action/org/searchHospital"
#define SEARCHDOCTOR            @"/action/user/searchDoctor"
#define GetChatGroups           @"/action/chatgroup/getChatGroups"

#define DeleteGroup             @"/action/group/deleteGroup"
#define AddGroup                @"/action/group/addGroup"
#define GetPushMessage          @"/action/chatgroup/getPushMsg"
/**
 *  第三方登录
 */
#define check_account_by_token_url  @"/action/user/getUserWithToken"
#define third_login_bind_url    @"/action/user/bindAccount"
/**
 *  助理
 */
#define applyAssistant          @"/action/assistant/applyAssistant"
#define getAssistantLimits_url        @"/action/assistant/getAssistantLimits"
#define updateLimits_url        @"/action/assistant/updateLimits"
/**
 *  医生端  好友操作
 */
#define delete_user_friends_url   @"/action/user/deleteFriend"
#define change_user_friends_url   @"/action/user/changeUserGroup"
/**
 *  医生端  俱乐部
 */

#define check_whether_joined_club_url   @"/action/group/getGroupsByType"
#define get_club_detail_data_url      @"/action/club/getClubByDoctorId"
#define get_friend_health_data_url    @"/action/club/getClubParamList"

/**
 *  医生认证
 */
#define verifyDoctor                @"/action/user/verifyDoctor"

#define UPLoadUserImage             @"/action/user/updateUserThumb"
/**
 *  聊天
 */
#define Assistant_service_url       @"/followed_pe/webservice/msgDoctor"
/**
 *  确认接诊
 */
#define checkTreatment       @"/action/treatment/checkTreatment"

#endif
