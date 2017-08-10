//
//  BulkHeader.h
//  DrAssistant
//
//  Created by taller on 15/10/12.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BulkHeader : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
+ (instancetype)bulkHeader;
@end
