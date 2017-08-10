//
//  IDPhotosCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#define id_photo_btn_width             100
#define id_photo_btn_height            80

#import "IDPhotosCell.h"
#import "UIButton+WebCache.h"

@implementation IDPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void) renderUI
{
    float jianju = (screen_width - (id_photo_btn_width*3))/4;
    
    CGRect frame = CGRectMake( jianju, 11 , id_photo_btn_width, id_photo_btn_height);
    self.firstIDPhoto = [[IDPhotoView alloc] initWithTitle:@"添加正面证件照" frame:frame];
    [self.contentView addSubview:self.firstIDPhoto];
    
    
    frame = CGRectMake( id_photo_btn_width + jianju*2 , 11 , id_photo_btn_width, id_photo_btn_height);
    self.secondIDPhoto = [[IDPhotoView alloc] initWithTitle:@"添加反面证件照" frame:frame];
    [self.contentView addSubview:self.secondIDPhoto];
    
    
    frame = CGRectMake( id_photo_btn_width*2 + jianju*3 , 11 , id_photo_btn_width, id_photo_btn_height);
    self.thirdIDPhoto = [[IDPhotoView alloc] initWithTitle:@"添加手持证件照" frame:frame];
    [self.contentView addSubview:self.thirdIDPhoto];
}


-(void) renderData:(CustomerInfo *)customerInfo
{
    
    if(customerInfo!= nil){
        if([NSStringUtils isNotBlank:customerInfo.idCardFrontPic]){
            [self.firstIDPhoto.imageView removeFromSuperview];
            [self.firstIDPhoto setTitle:@"" forState:UIControlStateNormal];
            self.firstIDPhoto.imgUrl = customerInfo.idCardFrontPic;
            [self.firstIDPhoto sd_setBackgroundImageWithURL:[NSURL URLWithString:customerInfo.idCardFrontPic] forState:UIControlStateNormal];
        }
        if([NSStringUtils isNotBlank:customerInfo.idCardBackPic]){
            [self.secondIDPhoto.imageView removeFromSuperview];
            [self.secondIDPhoto setTitle:@"" forState:UIControlStateNormal];
            self.secondIDPhoto.imgUrl = customerInfo.idCardBackPic;
            [self.secondIDPhoto sd_setBackgroundImageWithURL:[NSURL URLWithString:customerInfo.idCardBackPic] forState:UIControlStateNormal];
        }
        if([NSStringUtils isNotBlank:customerInfo.idCardHandheldPic]){
            [self.thirdIDPhoto.imageView removeFromSuperview];
            [self.thirdIDPhoto setTitle:@"" forState:UIControlStateNormal];
            self.thirdIDPhoto.imgUrl = customerInfo.idCardHandheldPic;
            [self.thirdIDPhoto sd_setBackgroundImageWithURL:[NSURL URLWithString:customerInfo.idCardHandheldPic] forState:UIControlStateNormal];
        }
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
