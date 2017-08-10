//
//  WorkDetailController.h
//  styler
//
//  Created by wangwanggy820 on 14-6-5.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define CONTENT NSLocalizedString(@"TEXT_SHARE_CONTENT", @"ShareSDK不仅集成简单、支持如QQ好友、微信、新浪微博、腾讯微博等所有社交平台，而且还有强大的统计分析管理后台，实时了解用户、信息流、回流率、传播效应等数据，详情见官网http://sharesdk.cn @ShareSDK")


#import <UIKit/UIKit.h>
#import "StylistWork.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "EvaluationScoreView.h"
#import "ShareContent.h"
#import "RewardActivityProcessor.h"

@interface WorkDetailController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,ISSShareViewDelegate,RewardActivityProcessorDelegate>
{
    UIButton *shareBtn;

}
@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) UIImageView *workImageView;

@property (retain, nonatomic) UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *wapper;
@property (weak, nonatomic) IBOutlet UIImageView *stylistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *stylistName;
@property (weak, nonatomic) IBOutlet UILabel *haircutPriceAndWorkNum;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *scoreView;

@property (weak, nonatomic) IBOutlet UIView *workTag;
@property (weak, nonatomic) IBOutlet UILabel *numOfCollect;
@property (weak, nonatomic) IBOutlet UIView *collectView;

@property (weak, nonatomic) IBOutlet UIView *spliteLine;
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIView *line;

@property int workId;
@property (strong, nonatomic) StylistWork *work;
@property (nonatomic, retain) UIImage *shareImage;
@property (nonatomic, copy) NSString *activityBannerUrl;

-(id)initWithWorkId:(int)workId;
-(ShareContent *) collectionShareContent;
@end
