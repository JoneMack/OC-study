//
//  CaseDetailViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "MyClubEntity.h"
#import "HealthDataEntity.h"
@interface CaseDetailViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) HealthDataEntity *healthInfo;
@property (nonatomic, strong) NSDictionary *reciveDataDic;
@property (nonatomic, strong) NSString *fromPatientDetail;
@property (nonatomic, strong) NSString *reciveNameString;

@property (weak, nonatomic) IBOutlet UIImageView *lookImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *caseContent;
@property (weak, nonatomic) IBOutlet UIButton *uploadImage;

- (IBAction)pictureAccessoryAction:(id)sender;

@property (nonatomic, strong) MyClubEntity *ClubInfo;

@end
