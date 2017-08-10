//
//  CustomAnnotationView.h
//  lbsdemo
//
//  Created by xubojoy on 16/6/14.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  Arror_height 15
@interface CustomAnnotationView : UIView

@property (nonatomic ,strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end
