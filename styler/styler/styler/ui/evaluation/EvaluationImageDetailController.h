//
//  EvaluationImageDetailController.h
//  styler
//
//  Created by aypc on 13-12-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeleteEvaluationImageDelegate <NSObject>
-(void)deleteEvaluationImage:(UIImage *)image;
@end


@interface EvaluationImageDetailController : UIViewController
@property (weak, nonatomic) id<DeleteEvaluationImageDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage * image;
-(id)initWithImage:(UIImage *)image;
@end
