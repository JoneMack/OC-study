//
//  MyDoctorHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MyDoctorHeaderBtnTag) {

    AddDoctorTag,
    MyYuYueTag,
    FreeZiXunTag,
};

@protocol MyDoctorHeaderDelegate  <NSObject>

- (void)MyDoctorHeaderAction:(UIButton *)btn;

@end

typedef void(^BtnActionBlock)(UIButton *btn);

@interface MyDoctorHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *addDoctorBtn;
@property (weak, nonatomic) IBOutlet UIButton *MyYuYue;
@property (weak, nonatomic) IBOutlet UIButton *FreeZiXun;

@property (copy, nonatomic) BtnActionBlock block;
@property (weak, nonatomic) id<MyDoctorHeaderDelegate>delegate;

+ (instancetype)shareInstance;

@end
