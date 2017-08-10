//
//  UIView+SDHelper.h
//  MinShengBankCreditCard
//
//  Created by Yu Guo on 12-9-10.
//  Copyright (c) 2012年 __MyCompnay__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(TKHelper)

@property (nonatomic, readwrite) CGFloat frameOriginX;
@property (nonatomic, readwrite) CGFloat frameOriginY;
@property (nonatomic, readwrite) CGPoint frameOrigin;
@property (nonatomic, readwrite) CGSize frameSize;
@property (nonatomic, readwrite) CGFloat frameSizeWidth;
@property (nonatomic, readwrite) CGFloat frameSizeHeight;

- (NSArray*) subviewsOfClassType:(Class)viewClass orOtherClassType:(Class)viewClass1;

- (void)resizeOnSameCenter:(CGSize)size;

@end
