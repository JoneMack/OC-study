//
//  UserModel.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 SEX                  varchar(1) not null comment '1 -男 0 -女',
 STATUS               varchar(1) not null comment '1 -正常，2 -删除',
 USER_TYPE            varchar(1) not null comment '1 -医生 2 -患者 3 -助理role用户角色,用于表示是医生还是患者.',
 MARRIAGE             tinyint comment 'bool婚姻状况1 -未婚 2 -已婚 3 -丧偶 4 -离异',
 */

typedef NS_ENUM(NSInteger, SexType) {
    female = 0,
    male
};

typedef NS_ENUM(NSInteger, Status){
    normals = 1,
    deletes
};

typedef NS_ENUM(NSInteger, Marriage){
    unMarried = 1,
    married ,
    widow ,
    divorce
};

typedef NS_ENUM(NSInteger, USER_TYPE) {
    
    DoctorType = 1,
    PatientType ,
    Role
};

@interface UserContext : NSObject

@property (nonatomic,strong)NSMutableDictionary *context;

-(NSString*)iD;
-(void)setID:(NSString*)value;
-(void)setReal_name:(NSString*)value;
-(NSString*)real_name;
-(void)setSex:(NSInteger)value;
-(NSInteger)sex;
-(void)setStatus:(NSString*)value;
-(NSString*)status;
-(void)setUser_type:(NSInteger)value;
-(NSInteger)user_type;
-(void)setLogin_name:(NSString*)value;
-(NSString*)login_name;
-(void)setThumb:(NSString*)value;
-(NSString*)thumb;
-(void)setPost:(NSString*)value;
-(NSString*)post;
-(void)setMajor:(NSString*)value;
-(NSString*)major;
-(void)setDocDesc:(NSString*)value;
-(NSString*)docDesc;
-(void)setWork_unit_phone:(NSString*)value;
-(NSString*)work_unit_phone;
-(NSString*)qualifiedThumb;
-(void)setQualifiedThumb:(NSString*)value;
-(void)setSpeciality:(NSString*)value;
-(NSString*)speciality;
-(void)setAge:(NSString*)value;
-(NSString*)age;
-(void)setEducation:(NSString*)value;
-(NSString*)education;
-(void)setPhone:(NSString*)value;
-(NSString*)phone;
-(void)setBirthday:(NSString*)value;
-(NSString*)birthday;
-(void)setAddress:(NSString*)value;
-(NSString*)address;
-(void)setId_card_no:(NSString*)value;
-(NSString*)id_card_no;
-(void)setBirthplace:(NSString*)value;
-(NSString*)birthplace;
-(void)setNation:(NSString*)value;
-(NSString*)nation;
-(void)setMarriage:(NSInteger)value;
-(NSInteger)marriage;
-(void)setGoal:(NSString*)value;
-(NSString*)goal;
-(void)setRemark:(NSString*)valuel;
-(NSString*)remark;
-(void)setChanel_ID:(NSString*)value;
-(NSString*)channel_ID;
-(void)setLast_update_date:(NSString*)value;
-(NSString*)last_update_date;
-(void)setDept_ID:(NSString*)value;
-(NSString*)dept_ID;
-(void)setOrg_ID:(NSString*)value;
-(NSString*)org_ID;
-(void)setVisit_time:(NSString*)value;
-(NSString*)visit_time;
- (void)setCert_status:(NSString *)value;
- (NSString *)cert_status;
- (void)setCard_no:(NSString *)value;
- (NSString *)card_no;


+ getUserContextWithDataDic:(NSDictionary *)data;

@end

extern NSString *LLValidatedString(NSString *string);
