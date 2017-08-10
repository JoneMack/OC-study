//
//  UserSettingController.h
//  styler
//
//  Created by System Administrator on 13-5-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettingController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel* userName;
    UILabel* userSex;
    UIImageView* userImage;
    UIImageView* gobackImageView;
}


//////////////////
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerPhoto;
@property (weak, nonatomic) IBOutlet UIView *upSpliteLine;
@property (weak, nonatomic) IBOutlet UIView *downSpliteLine;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *changeHeader;



@end
