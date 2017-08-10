//
//  LineDashView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/22.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDashView : UIView

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end
