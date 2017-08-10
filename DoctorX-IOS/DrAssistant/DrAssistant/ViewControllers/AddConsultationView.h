//
//  AddConsultationView.h
//  DrAssistant
//
//  Created by Seiko on 15/10/13.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddConsultationViewDelegate <NSObject>

- (void)tapHopViewSelector:(UITapGestureRecognizer *)tapG;

@end

@interface AddConsultationView : UIView
@property (nonatomic,strong) id<AddConsultationViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *hopView;

@property (weak, nonatomic) IBOutlet UILabel *patName_lab;

@property (weak, nonatomic) IBOutlet UIImageView *arrows_image;

@property (weak, nonatomic) IBOutlet UITextView *discribe_tv;
+ (instancetype)addConsultationView;

@end

