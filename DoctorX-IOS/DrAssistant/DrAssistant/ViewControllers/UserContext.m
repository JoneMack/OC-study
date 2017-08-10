//
//  UserModel.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "UserContext.h"



@implementation UserContext

#define ID @"ID"                    //ID
#define REAL_NAME @"REAL_NAME"      //姓名
#define SEX @"SEX"                  //性别
#define STATUS @"STATUS"            //状态
#define USER_TYPE @"USER_TYPE"      //用户类别
#define LOGIN_NAME @"LOGIN_NAME"    //登录名
#define THUMB @"thumb"              //头像URL
#define POST @"POST"                //职称
#define MAJOR @"major"              //专业
#define DOCDESC @"docDesc"          //医生简介
#define WORK_UNIT_PHONE @"WORK_UNIT_PHONE"      //办公室电话
#define QUALIFIEDTHUMB @"qualifiedThumd"        //医院证件照片URL
#define SPECIALITY @"SPACIALITY"                //擅长内容
#define AGE @"age"                              //年龄
#define EDUCATION @"education"                  //学历
#define PHONE @"PHONE"                          //电话
#define BIRTHDAY @"BIRTHDAY"                    //出生日期
#define ADDRESS @"address"                      //住址
#define ID_CARD_NO @"ID_CARD_NO"                //身份证号码
#define BIRTHPLACE @"BIRTHPLACE"                //籍贯
#define NATION @"NATION"                        //民族
#define MARRIAGE @"MARRIAGE"                    //婚姻
#define GOAL @"goal"                            //学分
#define REMARK @"REMARK"                        //备注
#define CHANNEL_ID @"CHANNEL_ID"                //百度云推送ID
#define LAST_UPDATE_DATE @"LAST_UPDATE_DATE"    //最后登录时间
#define DEPT_ID @"DEPT_ID"                      //用户所属科室
#define ORG_ID @"ORG_ID"                        //用户所属医院
#define VISIT_TIME @"visit_time"                //出诊时间
#define CERT_STATUS @"CERT_STATUS"              //认证状态
#define CARD_NO @"cardNo"           //医师证编号

-(id)init
{
    self = [super init];
    if ( self ) {
        _context = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (UserContext *)getUserContextWithDataDic:(NSDictionary *)data
{
    UserContext *user = [UserContext new];
    [user saveUserData:data];
    return user;
}

-(void)dealloc
{
    _context = nil;
}

-(void)setID:(NSString*)value {
    self.context[ID] = value;
}

-(NSString*)iD {
    NSString* value = self.context[ID];
    return value;
}


-(void)setReal_name:(NSString*)value {
    self.context[REAL_NAME] = value;
}

-(NSString*)real_name {
    NSString* value = self.context[REAL_NAME];
    return value;
}

-(void)setSex:(NSInteger)value {
    self.context[SEX] = [NSNumber numberWithInteger:value];
}

-(NSInteger)sex {
    NSNumber* value = self.context[SEX];
    return [value integerValue];
}

-(void)setStatus:(NSString*)value {
    self.context[STATUS] = value;
}

-(NSString*)status {
    NSString* value = self.context[STATUS];
    return value;
}

-(void)setUser_type:(NSInteger)value {
    self.context[USER_TYPE] = [NSNumber numberWithInteger:value];
}

-(NSInteger)user_type {
    NSNumber* value = self.context[USER_TYPE];
    return [value integerValue];
}

-(void)setLogin_name:(NSString*)value {
    self.context[LOGIN_NAME] = value;
}

-(NSString*)login_name {
    NSString* value = self.context[LOGIN_NAME];
    return value;
}

-(void)setThumb:(NSString*)value {
    self.context[THUMB] = value;
}

-(NSString*)thumb {
    NSString* value = self.context[THUMB];
    return value;
}

-(void)setPost:(NSString*)value {
    self.context[POST] = value;
}

-(NSString*)post {
    NSString* value = self.context[POST];
    return value;
}

-(void)setMajor:(NSString*)value {
    self.context[MAJOR] = value;
}

-(NSString*)major {
    NSString* value = self.context[MAJOR];
    return value;
}

-(void)setDocDesc:(NSString*)value {
    self.context[DOCDESC] = value;
}

-(NSString*)docDesc {
    NSString* value = self.context[DOCDESC];
    return value;
}

-(void)setWork_unit_phone:(NSString*)value {
    self.context[WORK_UNIT_PHONE] = value;
}

-(NSString*)work_unit_phone {
    NSString* value = self.context[WORK_UNIT_PHONE];
    return value;
}

-(void)setQualifiedThumb:(NSString*)value {
    self.context[QUALIFIEDTHUMB] = value;
}

-(NSString*)qualifiedThumb {
    NSString* value = self.context[QUALIFIEDTHUMB];
    return value;
}




-(void)setSpeciality:(NSString*)value {
    self.context[SPECIALITY] = value;
}

-(NSString*)speciality {
    NSString* value = self.context[SPECIALITY];
    return value;
}

-(void)setAge:(NSString*)value {
    self.context[AGE] = value;
}

-(NSString*)age {
    NSString* value = self.context[AGE];
    return value;
}

-(void)setEducation:(NSString*)value {
    self.context[EDUCATION] = value;
}

-(NSString*)education {
    NSString* value = self.context[EDUCATION];
    return value;
}

-(void)setPhone:(NSString*)value {
    self.context[PHONE] = value;
}

-(NSString*)phone {
    NSString* value = self.context[PHONE];
    return value;
}



-(void)setBirthday:(NSString*)value {
    self.context[BIRTHDAY] = value;
}

-(NSString*)birthday {
    NSString* value = self.context[BIRTHDAY];
    return value;
}

-(void)setAddress:(NSString*)value {
    self.context[ADDRESS] = value;
}

-(NSString*)address {
    NSString* value = self.context[ADDRESS];
    return value;
}

-(void)setId_card_no:(NSString*)value {
    self.context[ID_CARD_NO] = value;
}

-(NSString*)id_card_no {
    NSString* value = self.context[ID_CARD_NO];
    return value;
}

-(void)setBirthplace:(NSString*)value {
    self.context[BIRTHPLACE] = value;
}

-(NSString*)birthplace {
    NSString* value = self.context[BIRTHPLACE];
    return value;
}

-(void)setNation:(NSString*)value {
    self.context[NATION] = value;
}

-(NSString*)nation {
    NSString* value = self.context[NATION];
    return value;
}



-(void)setMarriage:(NSInteger)value {
    self.context[MARRIAGE] = [NSNumber numberWithInteger:value];
}

-(NSInteger)marriage {
    NSNumber *value = self.context[MARRIAGE];
    return [value integerValue];
}

-(void)setGoal:(NSString*)value {
    self.context[GOAL] = value;
}

-(NSString*)goal {
    NSString* value = self.context[GOAL];
    return value;
}

-(void)setRemark:(NSString*)value {
    self.context[REMARK] = value;
}

-(NSString*)remark {
    NSString* value = self.context[REMARK];
    return value;
}

-(void)setChanel_ID:(NSString*)value {
    self.context[CHANNEL_ID] = value;
}

-(NSString*)channel_ID {
    NSString* value = self.context[CHANNEL_ID];
    return value;
}

-(void)setLast_update_date:(NSString*)value {
    self.context[LAST_UPDATE_DATE] = value;
}

-(NSString*)last_update_date {
    NSString* value = self.context[LAST_UPDATE_DATE];
    return value;
}

-(void)setDept_ID:(NSString*)value {
    self.context[DEPT_ID] = value;
}

-(NSString*)dept_ID {
    NSString* value = self.context[DEPT_ID];
    return value;
}

-(void)setOrg_ID:(NSString*)value {
    self.context[ORG_ID] = value;
}

-(NSString*)org_ID {
    NSString* value = self.context[ORG_ID];
    return value;
}

-(void)setVisit_time:(NSString*)value {
    self.context[VISIT_TIME] = value;
}

-(NSString*)visit_time {
    NSString* value = self.context[VISIT_TIME];
    return value;
}
- (void)setCert_status:(NSString *)value{
    self.context[CERT_STATUS] = value;
}
- (NSString *)cert_status{
    NSString *value = self.context[CERT_STATUS];
    return value;
}

- (void)setCard_no:(NSString *)value
{
    self.context[CARD_NO] = value;
}
- (NSString *)card_no{
    NSString *value = self.context[CARD_NO];
    return value;
}

+ (NSInteger) LLValidatedNSInteger:(NSInteger)data
{
    if (!data) {
        return -1;
    }
    return (NSInteger)data;
}

- (void) saveUserData:(NSDictionary *)dataDic
{
    self.context[ID] =LLValidatedString([dataDic stringValueForKey: ID]);
    self.context[REAL_NAME] = LLValidatedString(dataDic[REAL_NAME]);
    self.context[SEX] = dataDic[SEX];
    self.context[STATUS] = LLValidatedString(dataDic[STATUS]);
    self.context[USER_TYPE] = dataDic[USER_TYPE];
    self.context[LOGIN_NAME] = LLValidatedString(dataDic[LOGIN_NAME]);
    self.context[THUMB] = LLValidatedString(dataDic[THUMB]);
    self.context[POST] = LLValidatedString(dataDic[POST]);
    self.context[MAJOR] = LLValidatedString(dataDic[MAJOR]);
    self.context[DOCDESC] = LLValidatedString(dataDic[DOCDESC]);
    self.context[WORK_UNIT_PHONE] = LLValidatedString(dataDic[WORK_UNIT_PHONE]);
    self.context[QUALIFIEDTHUMB] = LLValidatedString(dataDic[QUALIFIEDTHUMB]);
    self.context[SPECIALITY] = LLValidatedString(dataDic[SPECIALITY]);
    self.context[AGE] = LLValidatedString(dataDic[AGE]);
    self.context[EDUCATION] = LLValidatedString(dataDic[EDUCATION]);
    self.context[PHONE] = LLValidatedString(dataDic[PHONE]);
    self.context[BIRTHDAY] = LLValidatedString(dataDic[BIRTHDAY]);
    self.context[ADDRESS] = LLValidatedString(dataDic[ADDRESS]);
    self.context[ID_CARD_NO] = LLValidatedString(dataDic[ID_CARD_NO]);
    self.context[BIRTHPLACE] = LLValidatedString(dataDic[BIRTHPLACE]);
    self.context[NATION] = LLValidatedString(dataDic[NATION]);
    self.context[MARRIAGE] = LLValidatedString(dataDic[MARRIAGE]);
    self.context[GOAL] = LLValidatedString(dataDic[GOAL]);
    self.context[REMARK] = LLValidatedString(dataDic[REMARK]);
    self.context[CHANNEL_ID] = LLValidatedString(dataDic[CHANNEL_ID]);
    self.context[LAST_UPDATE_DATE] = LLValidatedString(dataDic[LAST_UPDATE_DATE]);
    self.context[DEPT_ID] = LLValidatedString(dataDic[DEPT_ID]);
    self.context[ORG_ID] = LLValidatedString(dataDic[ORG_ID]);
    self.context[VISIT_TIME] = LLValidatedString(dataDic[VISIT_TIME]);
    self.context[CERT_STATUS] = LLValidatedString(dataDic[CERT_STATUS]);
    self.context[CARD_NO] = LLValidatedString(dataDic[CARD_NO]);
}
@end

NSString *LLValidatedString(NSString *string)
{
    if ([string isKindOfClass:[NSString class]])
        return string;
    else if ([string isKindOfClass:[NSNumber class]])
        return [(NSNumber *)string stringValue];
    else
        return @"";
}

