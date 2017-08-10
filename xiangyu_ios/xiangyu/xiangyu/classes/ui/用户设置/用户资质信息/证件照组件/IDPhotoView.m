//
//  IDPhotoView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "IDPhotoView.h"
#import "UserStore.h"
#import "UIButton+WebCache.h"

@implementation IDPhotoView

-(instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setImage:[UIImage imageNamed:@"add_black"] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:0.5]; //边框宽度
        [self.layer setBorderColor:[[ColorUtils colorWithHexString:separator_line_color] CGColor]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(25, -24.5, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-25, 35, 0, 0)];
        
        

        [self addTarget:self action:@selector(changeIDPhoto) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void) changeIDPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.window];
}


#pragma mark - UIActionSheet代理方法
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    if(buttonIndex == 0){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."  maskType:SVProgressHUDMaskTypeGradient];
    
//    image = [ImageUtils imageWithImageSimple:image scaledToSize:CGSizeMake(420, 220)];
    
    [[UserStore sharedStore] updateAvatar:^(NSString *imgUrl , NSError *err) {
        if (err == nil) {
            
            self.imgUrl = imgUrl;
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.imageView removeFromSuperview];
            [self setTitle:@"" forState:UIControlStateNormal];
            [self sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } avatarImage:image];
    
}



@end
