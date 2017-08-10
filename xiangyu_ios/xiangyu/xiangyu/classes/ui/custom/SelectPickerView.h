//
//  SelectPickerView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/4.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPickerViewDelegate <NSObject>

-(void) selectedVal:(NSString *)val type:(NSString *)type ;

@end

@interface SelectPickerView : UIView <UIPickerViewDelegate , UIPickerViewDataSource>

@property (nonatomic , strong) UIView *controlView;
@property (nonatomic , strong) UIButton *confirmBtn;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UIPickerView *pickView;

@property (nonatomic , weak) id<SelectPickerViewDelegate> delegate;

@property (nonatomic , strong) NSArray<NSString *> *params;
@property (nonatomic , strong) NSString *type; // 当前picker的类型,因为在同一个页面可能有多个地方用到这个pickerView，所以需要传个类型进来


-(void) renderParams:(NSArray *)params type:(NSString *)type;

@end
