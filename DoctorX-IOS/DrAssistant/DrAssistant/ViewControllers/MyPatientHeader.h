//
//  MyPatientHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyPatientHeaderBtnTag) {
    
    AdPatientTag,
    qunFaXiaoXiTag,
    myQunLiaoTag,
    yuYueTag,
    clubTag,
};

@protocol MyPatientHeaderDelegate <NSObject>

@optional
- (void)myPatientHeaderBtnAction:(UIButton *)btn;
- (void)creatNewGroupForGroupList;

@end

@interface MyPatientHeader : UIView
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *addPatient;
@property (weak, nonatomic) IBOutlet UIButton *qunFaXiaoXi;
@property (weak, nonatomic) IBOutlet UIButton *myQunLiao;
@property (weak, nonatomic) IBOutlet UIButton *huiZhen;
@property (weak, nonatomic) IBOutlet UIButton *yuYueButton;
@property (weak, nonatomic) IBOutlet UIButton *clubButton;

@property (weak, nonatomic) id<MyPatientHeaderDelegate>delegate;

+ (instancetype)patientHeader;

@end
