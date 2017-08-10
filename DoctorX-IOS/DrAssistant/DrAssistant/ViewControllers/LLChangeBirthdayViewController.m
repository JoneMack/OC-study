//
//  LLChangeBirthdayViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "LLChangeBirthdayViewController.h"
#import "NSDate+Format.h"

@interface LLChangeBirthdayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPickerView;

@end

@implementation LLChangeBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self addRightBtnAction];
    
    // init date

    self.birthday.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];

    [self.birthdayPickerView setDate:[NSDate date] animated:YES];
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.birthdayPickerView.locale  = locale;


    [self.birthdayPickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
-(void)dateChanged:(id)sender
{

    NSString *date = [_birthdayPickerView.date stringWithFormat:@"yyyy-MM-dd"];
    self.birthday.text = date;
    [GlobalConst save:date withKey:BIRTH_DAY];
}

- (void)saveButtonAction
{
    MMActivityIndicator_start();
    NSString *date = [_birthdayPickerView.date stringWithFormat:@"yyyy-MM-dd"];
    [GlobalConst save:date withKey:BIRTH_DAY];
    MMActivityIndicator_stop();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
