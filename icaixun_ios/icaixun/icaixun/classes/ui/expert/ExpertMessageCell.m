//
//  ExpertMessageCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define expert_message_cell_height 140

#import "ExpertMessageCell.h"
#import "UILabel+Custom.h"
#import "ExpertMessageImage.h"
#import "ExpertMessageStore.h"

@implementation ExpertMessageCell

-(instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self =  [[[NSBundle mainBundle] loadNibNamed:@"ExpertMessageCell"
                                               owner:self options:nil] lastObject];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}


- (void) renderWithExpertMessage:(ExpertMessage *)expertMessage expert:(Expert *)expert;
{
    self.expertMessage = expertMessage;
    self.expert = expert;
    
    [self.contentView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    // 内容块
    self.cellBodyView.backgroundColor = [UIColor whiteColor];
    self.cellBodyView.layer.masksToBounds = YES;
    self.cellBodyView.layer.cornerRadius = 8;
    
    // 头像
    self.expertAvatar.layer.masksToBounds = YES;
    self.expertAvatar.layer.cornerRadius = 25;
    
    // 创建时间
    self.createTime.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    // 私密
    if (expertMessage.secret) {
        self.privateIcon.hidden = NO;
    }else{
        self.privateIcon.hidden = YES;
    }
    
    self.expertMessageImg.layer.masksToBounds = YES;
    self.expertMessageImg.layer.cornerRadius = 5;
    
    // 内容详情
    self.messageContent.text = self.expertMessage.msg;
    
    // 头像
    [self.expertAvatar sd_setImageWithURL:[NSURL URLWithString:expert.avatarUrl]
                       placeholderImage:[UIImage imageNamed:@"icon_user_gray"]];

    // 发型师名称
    self.expertName.text = self.expert.name;
    
    // 创建时间
    self.createTime.text = [DateUtils stringFromLongLongIntAndFormat:self.expertMessage.createTime dateFormat:@"yyyy-MM-dd HH:mm"];
    
    if (self.expertMessage.expertMassageImages.count >0) {
        self.expertMessageImg.hidden = NO;
        ExpertMessageImage *img = self.expertMessage.expertMassageImages[0];
        [self.expertMessageImg sd_setImageWithURL:[NSURL URLWithString:img.url]];
        self.expertMessageImg.userInteractionEnabled = YES;
        self.expertMessageImg.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *clickImgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMaxImg)];
        [self.expertMessageImg addGestureRecognizer:clickImgRecognizer];
        
    }else{
        self.expertMessageImg.hidden = YES;
    }

    
    if ([self.expertMessage.praiseStatus isEqualToString:@"YES"]) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_good_black"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_good_gray"] forState:UIControlStateNormal];
    }
    [self.praiseBtn setTitle:[self.expertMessage getPraiseCountStr] forState:UIControlStateNormal];
    [self.praiseBtn setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [self.praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
}

-(void) renderBaseFrame:(ExpertMessageFrame *)expertMessageFrame
{

    self.cellBodyView.frame = expertMessageFrame.cellBodyFrame;
    
    // 头像
    self.expertAvatar.frame = expertMessageFrame.expertAvatarFrame;
    
    // 用户名
    self.expertName.frame = expertMessageFrame.expertNameFrame;
    
    // 发布时间
    self.createTime.frame = expertMessageFrame.createTimeFrame;
    
    // 私密
    self.privateIcon.frame = expertMessageFrame.privateFrame;
    
    // 内容
    self.messageContent.frame = expertMessageFrame.messageContentFrame;
    self.messageContent.numberOfLines = 0;
    [self.messageContent sizeToFit];
    
    // 图片
    self.expertMessageImg.frame = expertMessageFrame.messageImgFrame;
    
    // 赞
    self.praiseBtn.frame = expertMessageFrame.praiseBtnFrame;
}

- (IBAction)praiseMessage:(id)sender {
    
    if ([self.expertMessage.praiseStatus isEqualToString:@"YES"]){
        [SVProgressHUD showErrorWithStatus:@"亲，您已赞过喽。"];
        return;
    }
    
    [[ExpertMessageStore sharedInstance] praiseExpertMessage:^(ExpertMessage *message, NSError *err) {
        if (err == nil) {
            self.expertMessage.praiseCount = message.praiseCount;
            self.expertMessage.praiseStatus = @"YES";
            
            [[AppStatus sharedInstance] addPraiseId:message.id];
            
            [self renderWithExpertMessage:self.expertMessage expert:self.expert];
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
    } messageId:self.expertMessage.id];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void) showMaxImg
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    
    self.showMaxImgView = [UIView new];
    self.showMaxImgView.frame = CGRectMake(0, 0, screen_width, 0);
    [self.showMaxImgView setBackgroundColor:[UIColor blackColor]];
    [window addSubview:self.showMaxImgView];
    
    
    ExpertMessageImage *img = self.expertMessage.expertMassageImages[0];
    UIImageView *imgView = [UIImageView new];
    imgView.frame = CGRectMake(0, 0, screen_width, 0);
    [imgView sd_setImageWithURL:[NSURL URLWithString:img.url]];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *clickImgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaxImg)];
    [imgView addGestureRecognizer:clickImgRecognizer];
    [self.showMaxImgView addSubview:imgView];
    // 显示动画 ， 从上到下
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.showMaxImgView.frame;
        frame.size.height = screen_height;
        self.showMaxImgView.frame = frame;
        imgView.frame = frame;
    } completion:^(BOOL finished) {
    }];
    
    // 图片缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [imgView addGestureRecognizer:pinchGestureRecognizer];

}

#pragma mark 图片的缩放
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

-(void) removeMaxImg
{
    // 删除动画 ， 从上到下
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.showMaxImgView.frame;
        frame.origin.y = screen_height;
        self.showMaxImgView.frame = frame;
    } completion:^(BOOL finished) {
        [self.showMaxImgView removeFromSuperview];
    }];
}

@end
