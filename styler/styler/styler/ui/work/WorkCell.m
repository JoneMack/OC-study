//
//  WorkCell.m
//  styler
//
//  Created by wangwanggy820 on 14-6-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WorkCell.h"
#import "UIView+Custom.h"
#import "WorkListController.h"



@implementation WorkCell
{
//    UITapGestureRecognizer *tap;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"WorkCell" owner:self options:nil] objectAtIndex:0];
        self.contentView.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        
//        self.title.backgroundColor = [UIColor clearColor];
//        self.title.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
//        self.title.font = [UIFont systemFontOfSize:default_font_size];
        
        self.deleteBtn.backgroundColor = [UIColor clearColor];
        self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size];
        
        CALayer *layer  = self.deleteBtn.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2];
//        [layer setBorderWidth:1.0f];
//        [layer setBorderColor:[UIColor redColor].CGColor];
        
        self.upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        CGRect frame = self.upSpliteLine.frame;
        frame.size.height = splite_line_height;
        frame.size.width = screen_width;
        self.upSpliteLine.frame = frame;
        
        self.downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        frame = self.downSpliteLine.frame;
        frame.size.height = splite_line_height;
        self.downSpliteLine.frame = frame;
        
        int i = 0;
        for (UIButton *btn in self.wapper.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                btn.tag = i;
                [btn addTarget:self action:@selector(tagNameWork:) forControlEvents:UIControlEventTouchUpInside];
                i++;
            }
        }
        self.workWapper.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
//        self.wapper.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        self.wapper.backgroundColor = [UIColor clearColor];
        frame = self.wapper.frame;
        frame.origin.y = self.coverPicture.frame.size.height;
        frame.size.height = self.workWapper.frame.size.height - self.coverPicture.frame.size.height-splite_line_height;
        frame.size.width = screen_width - 30;
        self.wapper.frame = frame;
    }
    return self;
}

-(void)initUI:(StylistWork *)work viewController:(UIViewController *)viewController{
    self.viewController = viewController;
    self.work = work;
    [self getWorkWapper:work];
    [self setWapperBtn:work];
}

//根据work得到WorkWapper
-(void)getWorkWapper:(StylistWork *)work{
//    if (!tap) {
//        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//        [self.workWapper addGestureRecognizer:tap];
//    }
    [self.coverPicture setBackgroundColor:[[Constant sharedInstance] getWaterfallBgColor]];
    self.coverPicture.contentMode = UIViewContentModeScaleAspectFill;
    self.coverPicture.clipsToBounds = YES;
    for (ServicePicture *servicePicture in work.servicePictures) {
        if (servicePicture.id == work.coverPictureId ) {
          [self.coverPicture setImageWithURL:[NSURL URLWithString:servicePicture.fileUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        }
    }
    self.title.text = work.title;
}

-(void)setWapperBtn:(StylistWork *)work{
    int i = 0;
    int x = general_padding;
    for (UIButton *btn in self.wapper.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.userInteractionEnabled = NO;
            if (i < work.tagNames.count) {
                NSString *name = work.tagNames[i];
                btn.titleLabel.font = [UIFont systemFontOfSize:default_font_size];
                [btn setTitleColor:[ColorUtils colorWithHexString:light_gray_text_color] forState:UIControlStateNormal];
                [btn setTitle:name forState:UIControlStateNormal];
                btn.hidden = NO;
                CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                CGRect frame = btn.frame;
                frame.origin.x = x;
                frame.origin.y = 0;
                frame.size.height = self.workWapper.frame.size.height - self.coverPicture.frame.size.height-splite_line_height;
                if (i > 5) {
                    frame.origin.y = 30;
                }
                
                if (i%6 == 0) {
                    x = general_padding;
                }
                frame.size.width = size.width;
                btn.frame = frame;
                x += size.width + general_padding;
            }else{
                btn.hidden = YES;
            }
            i++;
        }
    }
//
    CGRect frame = self.downSpliteLine.frame;
    frame.origin.y = (1 + work.tagNames.count/6)*title_height;
    self.downSpliteLine.frame = frame;
}


-(void)tapGesture:(UIGestureRecognizer *)sender{
    WorkDetailController *wdc = [[WorkDetailController alloc] init];
    wdc.work = self.work;
    [self.viewController.navigationController pushViewController:wdc animated:YES];
    
    [MobClick event:log_event_name_work_detail attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.work.stylist.id), @"作品", nil]];
}

-(void)tagNameWork:(UIButton *)button{
    NSString *tagName = self.work.tagNames[button.tag];
    if ([self.viewController.title isEqualToString:tagName]) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/works?tagName=%@&orderType=8",tagName];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WorkListController *wclc = [[WorkListController alloc] initWithRequestURL:urlStr title:tagName type:tag_name_work];
    [self.viewController.navigationController pushViewController:wclc animated:YES];
    
    
    [MobClick event:log_event_name_view_stylist_work_list attributes:[NSDictionary dictionaryWithObjectsAndKeys:tagName, @"作品", nil]];
}

@end
