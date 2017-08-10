//
//  Evaluation.h
//  styler
//
//  Created by aypc on 13-12-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluationPicture.h"
#import "Stylist.h"
#import "JSONModel.h"

@protocol organizationEvaluation
@end
@protocol Evaluation
@end
@protocol StylistEvaluation
@end


//商户评价
@interface OrganizationEvaluation : JSONModel

@property (copy, nonatomic) NSString *userName;
@property int userId;
@property int organizationId;
@property int orderId;
@property int evaluationId;
@property long long int createTime;
@property float trafficScore;
@property float environmentScore;
@property (copy, nonatomic) NSString<Optional> *avatarUrl;

@end


@interface StylistEvaluation : JSONModel

@property (copy, nonatomic) NSString<Optional> *content;
@property (copy, nonatomic) NSString *userName;
@property int userGender;
@property int stylistId;
@property (strong, nonatomic) Stylist *stylist;
@property int userId;
@property int orderId;
@property long long int createTime;
@property (copy, nonatomic) NSString<Optional> *avatarUrl;
@property float effectScore;
@property float attitudeScore;
@property float promoteReasonableScore;
@property int evaluationId;
@property (strong, nonatomic)NSArray<EvaluationPicture, Optional> *evaluationPictures;

-(BOOL) hasContent;

-(NSString *) honorName;
@end


@interface Evaluation : JSONModel

@property (strong, nonatomic) OrganizationEvaluation<organizationEvaluation> *organizationEvaluation;
@property (strong, nonatomic) StylistEvaluation <StylistEvaluation> *stylistEvaluation;

+(NSString *) getScoreText:(int)score;

@end

////发表评价时用

@interface NewEvaluation : JSONModel

@property (copy, nonatomic) NSString<Optional> *content;
@property (copy, nonatomic) NSString *userName;
@property int stylistId;
@property (strong, nonatomic) Stylist *stylist;
@property int userId;
@property int orderId;
@property long long int createTime;
@property (copy, nonatomic) NSString<Optional> *avatarUrl;
@property int effectScore;
@property int attitudeScore;
@property int promoteReasonableScore;
@property int trafficScore;
@property int environmentScore;
@property int evaluationId;
@property (strong, nonatomic)NSArray<EvaluationPicture, Optional> *evaluationPictures;
@property int organizationId;

-(NSString *) getJsonString;



@end


