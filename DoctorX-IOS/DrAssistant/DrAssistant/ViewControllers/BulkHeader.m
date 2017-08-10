//
//  BulkHeader.m
//  DrAssistant
//
//  Created by taller on 15/10/12.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BulkHeader.h"

@interface BulkHeader ()

@end

@implementation BulkHeader
+ (instancetype)bulkHeader
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"BulkHeader" owner:nil options:nil];
    return [arr lastObject];
}
- (void)awakeFromNib
{
     [super awakeFromNib];
    self.textView.delegate=self;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    
    
   
}
-(void)textViewDidChange:(UITextView *)textView

{
    
    //    textview 改变字体的行间距
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>140){
        //控制输入文本的长度
        return  NO;
    }
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        return NO;
    }
    else
    {
        return YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
