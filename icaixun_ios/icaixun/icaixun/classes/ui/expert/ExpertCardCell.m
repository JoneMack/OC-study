//
//  ExpertCardCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertCardCell.h"
#import "UserStore.h"
#import "SubscribeDescController.h"

@implementation ExpertCardCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awakeFromNib ExpertCardCell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) renderWithExpert:(Expert *)expert navigationController:(UINavigationController *)navigationController
{

    self.expert = expert;
    self.navigationController = navigationController;
    
    [self setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    self.contentView.frame = CGRectMake(0, 0, screen_width, 172);
    
    self.cellBodyView.backgroundColor = [UIColor whiteColor];
    self.cellBodyView.layer.masksToBounds = YES;
    self.cellBodyView.layer.cornerRadius = 8;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:expert.avatarUrl]];
    UIImage *avatar = [[UIImage alloc] initWithData:data];
    [self.expertAvatar setImage:avatar];
    self.expertAvatar.layer.masksToBounds = YES;
    self.expertAvatar.layer.cornerRadius = 27.5;
    
    self.expertName.text = self.expert.name;
    
    [self.messageCount setText:[NSString stringWithFormat:@"%d" , expert.msgCount]];
    
    [self.subscribeCount setText:[NSString stringWithFormat:@"%d" , expert.subscribeCount]];
    
    [self.authInfo setText:expert.shortIntroduction];
    [self.authInfo setNumberOfLines:0];
    [self.authInfo sizeToFit];
    
    self.attentionStatus.layer.masksToBounds = YES;
    self.attentionStatus.layer.borderWidth = 1;
    self.attentionStatus.layer.borderColor = [[ColorUtils colorWithHexString:gray_black_line_color] CGColor];
    [self.attentionStatus setTitleColor:[ColorUtils colorWithHexString:light_gray_text_color] forState:UIControlStateNormal];
    self.attentionStatus.layer.cornerRadius = 14.5;
    
    self.subscribeStatus.layer.masksToBounds = YES;
    self.subscribeStatus.layer.borderWidth = 1;
    self.subscribeStatus.layer.borderColor = [[ColorUtils colorWithHexString:gray_black_line_color] CGColor];
    self.subscribeStatus.layer.cornerRadius = 14.5;
    [self.subscribeStatus setTitle:@"马上订阅" forState:UIControlStateNormal];
    [self.subscribeStatus setTitleColor:[ColorUtils colorWithHexString:light_gray_text_color] forState:UIControlStateNormal];
    
    if ([self.expert.relationStatus isEqualToString:@"Subscribe"]) {  // 收藏
        self.attentionStatus.layer.borderColor = [[ColorUtils colorWithHexString:orange_red_line_color] CGColor];
        self.subscribeStatus.layer.borderColor = [[ColorUtils colorWithHexString:orange_red_line_color] CGColor];
        [self.attentionStatus setTitle:@"已关注" forState:UIControlStateNormal];
        [self.subscribeStatus setTitle:@"已订阅" forState:UIControlStateNormal];
    }else if ([self.expert.relationStatus isEqualToString:@"Follow"]) {  // 关注
        self.attentionStatus.layer.borderColor = [[ColorUtils colorWithHexString:orange_red_line_color] CGColor];
        [self.attentionStatus setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.attentionStatus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

- (IBAction)updateAttentionStatus:(id)sender {
    
    if (self.expert.relationStatus == nil || [self.expert.relationStatus isEqualToString:@""]) {
        
        [[UserStore sharedStore] addAttentionExpert:^(NSError *err) {
            if (err == nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAttitionExpert" object:self.expert];
            }
        } expertId:self.expert.id];
    }else if ([self.expert.relationStatus isEqualToString:@"Follow"]){
        
        [[UserStore sharedStore] removeAttentionExpert:^(NSError *err) {
            if (err == nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAttitionExpert" object:self.expert];
            }
        } expertId:self.expert.id];
    }
    
    
}

- (IBAction)subscribeExpert:(id)sender {
    SubscribeDescController *subscribeDescController = [[SubscribeDescController alloc] initWithExpert:self.expert];
    [self.navigationController pushViewController:subscribeDescController animated:YES];
}

@end
