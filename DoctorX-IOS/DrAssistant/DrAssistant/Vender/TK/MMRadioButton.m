//
//  MMRadioButton.m
//  mobmarketing
//
//  Created by 郭煜 on 13-12-16.
//  Copyright (c) 2013年 Yu Guo. All rights reserved.
//

#import "MMRadioButton.h"

@implementation MMRadioButton

- (void)sharedInit {
    
    if (nil == self.radioStyle) {
        self.radioStyle = @0;
    }
    
    switch ([self.radioStyle integerValue]) {
        case 0: {
            self.applyToBackground = FALSE; [UIImage imageNamed:@"通用-rb-off.png"];
            self.uncheckedImage = [[UIImage imageNamed:@"通用-rb-off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.checkedImage = [[UIImage imageNamed:@"通用-rb-on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.uncheckedTitleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            self.checkedTitleColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
            break;
        case 1: {
            self.applyToBackground = FALSE; [UIImage imageNamed:@"选择1.png"];
            self.uncheckedImage = [[UIImage imageNamed:@"register_circle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.checkedImage = [[UIImage imageNamed:@"rgister_daGou.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.uncheckedTitleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            self.checkedTitleColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
            break;
        case 2: {
            self.applyToBackground = TRUE;
//            UIImage *image = MMImageOf(@"理财产品-产品详细页面按钮.png");
//            UIImage *rsImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(24, 25, 24, 25)
//                                                     resizingMode:UIImageResizingModeStretch];
//            self.uncheckedImage = rsImage;
//            
//            image = MMImageOf(@"理财产品-产品详细页面按钮选中.png");
//            rsImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(24, 25, 24, 25)
//                                            resizingMode:UIImageResizingModeStretch];
//            self.checkedImage = rsImage;
//            
//            self.uncheckedTitleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
//            self.checkedTitleColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        
            break;
            
        default:
            break;
    }
    
    [super sharedInit];
}

@end
