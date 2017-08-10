//
//  HealthTopDateView.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/28.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HealthTopDateViewBtnTag) {
    selectShowDataTypeBtnTag,
    startDateBtnTag,
    mediumDateBtnTag,
    endDateBtnTag,
};
@protocol HealthTopDateViewDelegate <NSObject>

- (void)healthTypeAndDateSelectBtn:(UIButton *)btn;

@end

@interface HealthTopDateView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectShowDataTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;

@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@property (nonatomic, assign) id<HealthTopDateViewDelegate> delegate;




@end
