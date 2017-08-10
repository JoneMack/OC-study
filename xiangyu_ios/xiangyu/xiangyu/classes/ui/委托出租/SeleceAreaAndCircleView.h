//
//  SeleceAreaAndCircleView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/27.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@protocol SelectAreaAndCircleDelegate <NSObject>

-(void) selectedAreaAndCircle;

@end

@interface SeleceAreaAndCircleView : UIView < UIPickerViewDelegate , UIPickerViewDataSource>


@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;


@property (strong, nonatomic) IBOutlet UIButton *confirm;


@property (strong, nonatomic) IBOutlet UIButton *cancel;

@property (strong, nonatomic) NSString *currentChengQu;
@property (strong, nonatomic) NSString *currentShangQuan;
@property (strong, nonatomic) NSString *selectedChengQu;
@property (strong, nonatomic) NSString *selectedShangQuan;

@property (nonatomic , strong) Circle *circle;

@property (nonatomic , weak) id<SelectAreaAndCircleDelegate> delegate;



- (IBAction)confirmEvent:(id)sender;


- (IBAction)cancelEvent:(id)sender;


-(void) showLastSelected;

@end
