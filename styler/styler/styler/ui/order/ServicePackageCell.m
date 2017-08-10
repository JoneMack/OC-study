//
//  ServicePackageCell.m
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ServicePackageCell.h"

#define service_package_picture_height 100

@implementation ServicePackageCell

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ServicePackageCell" owner:self options:nil][0];
        self.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
        //设置图片
        float ratio = 3.0/2.0;
        float pictureHeight = self.frame.size.width/ratio;
        self.servicePackagePicture.contentMode = UIViewContentModeScaleToFill;
        self.servicePackagePicture.frame = CGRectMake(0, 0, self.frame.size.width, pictureHeight);
        
        //设置服务项目名
        self.serviceName.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.serviceName.font = [UIFont systemFontOfSize:big_font_size];
        
        //设置原价
        self.serviceOriginPirceInfo.textColor = [ColorUtils colorWithHexString:gray_text_color];
        self.serviceOriginPirceInfo.font = [UIFont systemFontOfSize:small_font_size];
        //在原价上面添加一条线
        self.lineOfPrice.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
        CGRect lineFrame = self.lineOfPrice.frame;
        lineFrame.size.height = splite_line_height;
        self.lineOfPrice.frame = lineFrame;
        
        //设置预定label价格，位置，大小
        self.priceOfOrderInfo.textColor = [ColorUtils colorWithHexString:gray_text_color];
        self.priceOfOrderInfo.font = [UIFont systemFontOfSize:default_font_size];
        
        //设置cell的外框
        CALayer *layer=[self layer];
        //是否设置边框被遮住
        [layer setMasksToBounds:YES];
        //设置边框线的宽
        [layer setBorderWidth:splite_line_height];
        //设置边框线的颜色  
        [layer setBorderColor:[[ColorUtils colorWithHexString:splite_line_color] CGColor]];
    }
    return self;
}

-(void)renderServicePackage:(StylistServicePackage *)servicePackage
{
    //图片
    [self.servicePackagePicture setImageWithURL:[NSURL URLWithString:servicePackage.icon] placeholderImage:[UIImage imageNamed:@"service_package_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    //服务项目名
    self.serviceName.text = servicePackage.name;
    CGSize serviceNameSize = [servicePackage.name sizeWithFont:self.serviceName.font constrainedToSize:CGSizeMake(100, collection_cell_txt_line_height) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = CGRectMake(collection_cell_item_margin, collection_cell_item_margin + self.servicePackagePicture.frame.size.height, serviceNameSize.width, collection_cell_txt_line_height);
    self.serviceName.frame = frame;

    //原价
    CGSize spaceSize = [@" " sizeWithFont:self.priceOfOrderInfo.font constrainedToSize:CGSizeMake(100, collection_cell_txt_line_height) lineBreakMode:NSLineBreakByCharWrapping];
    self.serviceOriginPirceInfo.text = [NSString stringWithFormat:@"￥%d",servicePackage.targetServiceItemSuite.price];
    CGSize originPirceSize = [self.serviceOriginPirceInfo.text sizeWithFont:self.serviceOriginPirceInfo.font constrainedToSize:CGSizeMake(100, collection_cell_txt_line_height) lineBreakMode:NSLineBreakByWordWrapping];
    frame = CGRectMake(self.serviceName.frame.origin.x + self.serviceName.frame.size.width + spaceSize.width, self.serviceName.frame.origin.y, originPirceSize.width, collection_cell_txt_line_height);
    self.serviceOriginPirceInfo.frame = frame;
    
    //原价上面的线
    self.lineOfPrice.frame = CGRectMake(self.serviceOriginPirceInfo.frame.origin.x+1, self.serviceOriginPirceInfo.frame.origin.y + self.serviceOriginPirceInfo.frame.size.height/2, originPirceSize.width, splite_line_height);
    
    //优惠价
    NSString *text = [NSString stringWithFormat:@"预订价￥%d起",servicePackage.targetServiceItemSuite.specialOfferPrice];
    int lenght = [NSString stringWithFormat:@"%d",servicePackage.targetServiceItemSuite.specialOfferPrice].length;
    NSMutableAttributedString *textAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    
    [textAttribute addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:gray_text_color] range:NSMakeRange(0,3)];
    [textAttribute addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:black_text_color] range:NSMakeRange(3,lenght+1)];
    [textAttribute addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:gray_text_color] range:NSMakeRange(3+(lenght+1),1)];

    self.priceOfOrderInfo.attributedText = textAttribute;
    self.priceOfOrderInfo.frame = CGRectMake(collection_cell_item_margin, bottomY(self.serviceName), self.priceOfOrderInfo.frame.size.width, collection_cell_txt_line_height);
}

+(float)getServiceCellHeight{
    return service_package_picture_height + 2*collection_cell_txt_line_height + 2*collection_cell_item_margin;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

@end
