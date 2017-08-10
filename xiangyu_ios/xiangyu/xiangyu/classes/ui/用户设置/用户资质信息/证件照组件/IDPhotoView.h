//
//  IDPhotoView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDPhotoView : UIButton <UIActionSheetDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate>

@property (nonatomic , strong) NSString *imgUrl;

-(instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame;

@end
