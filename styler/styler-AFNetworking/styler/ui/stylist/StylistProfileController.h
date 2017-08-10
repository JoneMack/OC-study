//
//  StylistProfileController.h
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "Stylist.h"
#import "Evaluation.h"
#import "StylistPriceList.h"
#import "HdcType.h"
#import <ShareSDK/ShareSDK.h>
#import "HairDressingCard.h"
#import "ShareContent.h"
#import "RewardActivityProcessor.h"

@interface StylistProfileController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,ISSShareViewDelegate,ISSViewDelegate,RewardActivityProcessorDelegate>
@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) UIButton *collectBtn;
@property (strong, nonatomic) UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView; 
@property (weak, nonatomic) IBOutlet UIView *orderStylistView;

@property (weak, nonatomic) IBOutlet UIView *bottomUpLine;

@property (weak, nonatomic) IBOutlet UIButton *telOrderStylistBtn;
@property (weak, nonatomic) IBOutlet UIButton *onLineOrderStylistBtn;
@property (retain, nonatomic) Stylist *stylist;
@property (strong, nonatomic) NSArray *works;
@property (nonatomic,strong)NSArray *hdcs;
@property (nonatomic,strong)HdcType *hdcType;
@property (retain, nonatomic) NSMutableString *infoStr;
@property (strong, nonatomic) HairDressingCard *hdc;

@property (copy, nonatomic) NSString *contentStr;
@property (strong, nonatomic) UIImage *shareImage;
@property int row;
@property (copy ,nonatomic) NSString *activityBannerUrl;



-(void)initRightBtn;
- (IBAction)orderAction:(UIButton *)sender;


@property BOOL evaluationsLoaded;
@property int stylistId;
-(id) initWithStylistId:(int)stylistId;
-(void) paidSuccessCollectionStylist;
-(ShareContent *) collectionShareContent;

@end
