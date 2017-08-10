//
//  UIImage+SNTHelper.h
//
//  Created by Guo yu on 11/26/11.
//  Copyright (c) 2012年 __MyCompany__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TKHelper)

+ (UIImage*) imageBundled:(NSString*)imageName;
+ (UIImage*) imageWithBundleName:(NSString*)bundleName imageName:(NSString*)imageName;

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithScale:(CGFloat)scale interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;

- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

@end
