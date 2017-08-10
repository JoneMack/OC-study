//
//  MyClubCell.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyClubCell.h"
#import "UIImage+Strecth.h"
#import "MyClubHandler.h"

@implementation MyClubCell

- (void)awakeFromNib {
    // Initialization code
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinClub:(id)sender {
//    NSLog(@"加入俱乐部");
//    NSString *cludID=self.cludId;
//    NSString *userID=[GlobalConst shareInstance].loginInfo.iD;
//    NSString *join=self.joinBtn.titleLabel.text;
//    NSString* attention=@"";
//    if ([join isEqualToString:@"未加入"]) {
//        attention=@"true";
//    }else{
//        attention=@"false";
//    }
//    NSLog(@"selected:%d",self.joinBtn.selected);
//    [MyClubHandler joinUserClub:cludID:userID:attention success:^(BaseEntity *object) {
//        if(object.msg){
//            if([attention isEqualToString:@"true"]){
//             self.joinBtn.titleLabel.text=@"已加入";
//                self.joinBtn.enabled = FALSE;
//                self.joinBtn.userInteractionEnabled=YES;
//            }else{
//                self.joinBtn.titleLabel.text=@"未加入";
//                self.joinBtn.enabled = TRUE;
//            }
//        }
//    } fail:^(id object) {
//       
//    }];
}
@end
