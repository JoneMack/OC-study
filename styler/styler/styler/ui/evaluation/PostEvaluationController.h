//
//  ExpertEvaluationController.h
//  styler
//
//  Created by aypc on 13-12-5.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//


#import "EvaluationScoreView.h"
#import "Stylist.h"
#import "EvaluationImageDetailController.h"
#import "CTAssetsPickerController.h"
#import "HeaderView.h"
#import "ServiceOrder.h"

@interface PostEvaluationController : UIViewController <UITextViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,DeleteEvaluationImageDelegate,CTAssetsPickerControllerDelegate>
{
    NSMutableArray *imageViewArray;
}

@property(strong, nonatomic) HeaderView *header;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *scoreView;

@property (weak, nonatomic) IBOutlet EvaluationScoreView *effectScoreView;
@property (strong, nonatomic) IBOutlet EvaluationScoreView *attitudeScoreView;
@property (strong, nonatomic) IBOutlet EvaluationScoreView *promoteReasonableScoreView;
@property (strong, nonatomic) IBOutlet EvaluationScoreView *trafficConvenientScoreView;
@property (strong, nonatomic) IBOutlet EvaluationScoreView *environmentScoreView;
@property (weak, nonatomic) IBOutlet UILabel *effect;
@property (weak, nonatomic) IBOutlet UILabel *attitude;
@property (weak, nonatomic) IBOutlet UILabel *promoteReasonable;
@property (weak, nonatomic) IBOutlet UILabel *trafficConvenient;
@property (weak, nonatomic) IBOutlet UILabel *environment;

@property (weak, nonatomic) IBOutlet UIView *evaluationTextViewWrapper;
@property (weak, nonatomic) IBOutlet UITextView *evaluationTextView;

@property (weak, nonatomic) IBOutlet UIView *addImageWrapper;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;

@property (strong, nonatomic) NSMutableArray * imageArray;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;


@property (retain, nonatomic) ServiceOrder *order;
@property int currentImgInx;

- (IBAction)addImage:(id)sender;
-(id)initWithOrder:(ServiceOrder*)order;

@end
