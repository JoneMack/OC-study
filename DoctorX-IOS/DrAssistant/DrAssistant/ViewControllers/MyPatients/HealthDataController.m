//
//  HealthDataController.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/24.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "HealthDataController.h"
#import "MyPatientHandler.h"
#import "HZQDatePickerView.h"
#import "HealthEntity.h"
#import "HealthDetailDataEntity.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
#import "HealthDataListCell.h"
#import "NSStringUtils.h"
// 屏幕尺寸 ScreenRect
#define ScreenRect [UIScreen mainScreen].applicationFrame
#define ScreenRectHeight [UIScreen mainScreen].applicationFrame.size.height
#define ScreenRectWidth [UIScreen mainScreen].applicationFrame.size.width
@interface HealthDataController () <HZQDatePickerViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    UIView *_containerView;
    UITableView *_tableView;
    HZQDatePickerView *_pikerView;
    PNLineChartView *_lineChartView;
    NSMutableArray *_rateArray;
    NSMutableArray *_highRateArray;
    NSMutableArray *_lowRateArray;
    NSMutableArray *_normalRateArray;
    NSMutableArray *_timeArray;
    BOOL showChart;
    BOOL showToday;
    BOOL byDay;
}

@end

@implementation HealthDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康数据";
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 100.f, 40.f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle: @"列表显示" forState: UIControlStateNormal];
    [button addTarget: self action: @selector(showChart:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    showChart = YES;
    byDay = NO;
    _rateArray = [[NSMutableArray alloc] initWithCapacity: 0];
    _highRateArray = [[NSMutableArray alloc] initWithCapacity: 0];
    _lowRateArray = [[NSMutableArray alloc] initWithCapacity: 0];
    _normalRateArray = [[NSMutableArray alloc] initWithCapacity: 0];
    _timeArray = [[NSMutableArray alloc] initWithCapacity: 0];
    [self initTableView];
    _containerView = [[UIView alloc] initWithFrame: self.view.frame];
    [self.view addSubview: _containerView];
    [self initHealthTopDateView];
    [self loadHealthData];
    [self initChart];
    [self initFootView];
}
- (void)initChart {
    if (_lineChartView) {
        [_lineChartView removeFromSuperview];
    }
    _lineChartView = [[PNLineChartView alloc] initWithFrame: CGRectMake(0.f, 64.f + 44.f, self.view.frame.size.width, self.view.frame.size.height - 64.f - 44.f - 30.f)];
    _lineChartView.max = 240;
    _lineChartView.min = 0;
    
    _lineChartView.interval = (_lineChartView.max-_lineChartView.min) / 6;
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<=6; i++) {
        NSString* str = [NSString stringWithFormat:@"%.2f", _lineChartView.min+_lineChartView.interval*i];
        [yAxisValues addObject:str];
    }
    _lineChartView.xAxisValues = _timeArray;
    _lineChartView.yAxisValues = yAxisValues;
    _lineChartView.axisLeftLineWidth = 60;
    
    
    PNPlot *plot1 = [[PNPlot alloc] init];
    plot1.plottingValues = _lowRateArray;
    
    plot1.lineColor = [UIColor redColor];
    plot1.lineWidth = 0.5;
    
    [_lineChartView addPlot:plot1];
    
    
    PNPlot *plot2 = [[PNPlot alloc] init];
    
    plot2.plottingValues = _highRateArray;
    
    plot2.lineColor = [UIColor greenColor];
    plot2.lineWidth = 1;
    
    [_lineChartView  addPlot:plot2];
    
    PNPlot *plot3 = [[PNPlot alloc] init];
    
    plot3.plottingValues = _normalRateArray;
    
    plot3.lineColor = [UIColor blueColor];
    plot3.lineWidth = 1;
    
    [_lineChartView  addPlot: plot3];
    [_containerView addSubview: _lineChartView];
}
- (void)initFootView {
    UIView *footView = [[UIView alloc] initWithFrame: CGRectMake(0.f, self.view.frame.size.height - 30.f, self.view.frame.size.width, 30.f)];
    UIView *highRateView = [[UIView alloc] initWithFrame: CGRectMake(20.f, 14.f, 10.f, 2.f)];
    highRateView.backgroundColor = [UIColor redColor];
    [footView addSubview: highRateView];
    UILabel *highRateLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(highRateView.frame) + 5.f, 0.f, 40.f, 30.f)];
    highRateLabel.text = @"高压";
    highRateLabel.textAlignment = NSTextAlignmentCenter;
    highRateLabel.font = [UIFont boldSystemFontOfSize: 15.f];
    highRateLabel.textColor = [UIColor blackColor];
    [footView addSubview: highRateLabel];
    
    UIView *lowRateView = [[UIView alloc] initWithFrame: CGRectMake(CGRectGetMaxX(highRateLabel.frame) + 5.f, 14.f, 10.f, 2.f)];
    lowRateView.backgroundColor = [UIColor greenColor];
    [footView addSubview: lowRateView];
    UILabel *lowRateLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(lowRateView.frame) + 5.f, 0.f, 40.f, 30.f)];
    lowRateLabel.text = @"低压";
    lowRateLabel.textAlignment = NSTextAlignmentCenter;
    lowRateLabel.font = [UIFont boldSystemFontOfSize: 15.f];
    lowRateLabel.textColor = [UIColor blackColor];
    [footView addSubview: lowRateLabel];
    
    UIView *normalRateView = [[UIView alloc] initWithFrame: CGRectMake(CGRectGetMaxX(lowRateLabel.frame) + 5.f, 14.f, 10.f, 2.f)];
    normalRateView.backgroundColor = [UIColor blueColor];
    [footView addSubview: normalRateView];
    UILabel *normalRateLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(normalRateView.frame) + 5.f, 0.f, 40.f, 30.f)];
    normalRateLabel.text = @"心率";
    normalRateLabel.textAlignment = NSTextAlignmentCenter;
    normalRateLabel.font = [UIFont boldSystemFontOfSize: 15.f];
    normalRateLabel.textColor = [UIColor blackColor];
    [footView addSubview: normalRateLabel];
    [_containerView addSubview: footView];
}
- (void)initHealthTopDateView{
    self.healthTopDateView = [[HealthTopDateView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 44)];
    self.healthTopDateView.delegate = self;
    NSDate *date = [NSDate date];
    NSLog(@">>>>>>>%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];
    [self.healthTopDateView.mediumDateBtn setTitle:[NSString stringWithFormat:@"%@", currentOlderOneDateStr] forState:UIControlStateNormal];
    [self.healthTopDateView.startDateBtn setTitle:[NSString stringWithFormat:@"%@", currentOlderOneDateStr] forState:UIControlStateNormal];
    [self.healthTopDateView.endDateBtn setTitle:[NSString stringWithFormat:@"%@", currentOlderOneDateStr] forState:UIControlStateNormal];
    [_containerView addSubview:self.healthTopDateView];
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0.f, 64.f, self.view.frame.size.width, self.view.frame.size.height - 64.f) style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview: _tableView];
}
-(void)loadHealthData{
    [MyPatientHandler getHealthDataByFriendId:self.friendId success:^(BaseEntity *object) {
        HealthEntity *entity = (HealthEntity *)object;
        [entity.data enumerateObjectsUsingBlock: ^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSStringUtils isNotBlank: obj[@"RECORD_TIME"]] && [NSStringUtils isNotBlank: [obj[@"SZY"] stringValue]] && [NSStringUtils isNotBlank: [obj[@"SSY"] stringValue]] && [NSStringUtils isNotBlank: [obj[@"XL"] stringValue]]) {
                [_rateArray addObject: obj];
//                [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [_lowRateArray addObject: obj[@"SZY"]];
//                    [_highRateArray addObject: obj[@"SSY"]];
//                    [_normalRateArray addObject: obj[@"XL"]];
//                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
//                }];
            }
        }];
        if (byDay == YES) {
            [_lowRateArray removeAllObjects];
            [_highRateArray removeAllObjects];
            [_normalRateArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([ self date: [self asYMD: obj[@"RECORD_TIME"]] isBetweenDate: self.healthTopDateView.startDateBtn.titleLabel.text andDate: self.healthTopDateView.endDateBtn.titleLabel.text] == YES) {
                    [_lowRateArray addObject: obj[@"SZY"]];
                    [_highRateArray addObject: obj[@"SSY"]];
                    [_normalRateArray addObject: obj[@"XL"]];
                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                }
            }];
        } else {
            [_lowRateArray removeAllObjects];
            [_highRateArray removeAllObjects];
            [_normalRateArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[self asYMD: obj[@"RECORD_TIME"]] isEqualToString: self.healthTopDateView.mediumDateBtn.titleLabel.text] == YES) {
                    [_lowRateArray addObject: obj[@"SZY"]];
                    [_highRateArray addObject: obj[@"SSY"]];
                    [_normalRateArray addObject: obj[@"XL"]];
                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                }
            }];
        }
        [self initChart];
        [_tableView reloadData];
    } fail:^(id object) {
        
    }];

}
#pragma mark -
- (void)showChart: (id)sender {
    showChart = !showChart;
    UIButton *button = (UIButton *)sender;
    NSString *title = showChart == YES?@"列表显示":@"图形显示";
    [button setTitle: title forState: UIControlStateNormal];
    if (showChart == YES) {
        _containerView.hidden = NO;
        _tableView.hidden = YES;
    } else {
        _containerView.hidden = YES;
        _tableView.hidden = NO;
    }
}
#pragma mark - HealthTopDateViewDelegate

-(void)healthTypeAndDateSelectBtn:(UIButton *)btn{
    switch (btn.tag) {
        case selectShowDataTypeBtnTag:
        {
            byDay = ! byDay;
            if (byDay == YES) {
                [_lowRateArray removeAllObjects];
                [_highRateArray removeAllObjects];
                [_normalRateArray removeAllObjects];
                [_timeArray removeAllObjects];
                [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([ self date: [self asYMD: obj[@"RECORD_TIME"]] isBetweenDate: self.healthTopDateView.startDateBtn.titleLabel.text andDate: self.healthTopDateView.endDateBtn.titleLabel.text] == YES) {
                        [_lowRateArray addObject: obj[@"SZY"]];
                        [_highRateArray addObject: obj[@"SSY"]];
                        [_normalRateArray addObject: obj[@"XL"]];
                        [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                    }
                }];
            } else {
                [_lowRateArray removeAllObjects];
                [_highRateArray removeAllObjects];
                [_normalRateArray removeAllObjects];
                [_timeArray removeAllObjects];
                [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[self asYMD: obj[@"RECORD_TIME"]] isEqualToString: self.healthTopDateView.mediumDateBtn.titleLabel.text] == YES) {
                        [_lowRateArray addObject: obj[@"SZY"]];
                        [_highRateArray addObject: obj[@"SSY"]];
                        [_normalRateArray addObject: obj[@"XL"]];
                        [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                    }
                }];
            }
            [self initChart];
        }
            break;
        case startDateBtnTag:
            [self setupDateView:DateTypeOfStart];
            break;
        case endDateBtnTag:
            [self setupDateView:DateTypeOfEnd];
            break;
        case mediumDateBtnTag:
            [self setupDateView:DateTypeMedium];
            break;
        default:
            break;
    }
}

- (void)setupDateView:(DateType)type {
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    switch (type) {
        case DateTypeOfStart:
        {
            [self.healthTopDateView.startDateBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
            [_lowRateArray removeAllObjects];
            [_highRateArray removeAllObjects];
            [_normalRateArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([ self date: [self asYMD: obj[@"RECORD_TIME"]] isBetweenDate: date andDate: self.healthTopDateView.endDateBtn.titleLabel.text] == YES) {
                    [_lowRateArray addObject: obj[@"SZY"]];
                    [_highRateArray addObject: obj[@"SSY"]];
                    [_normalRateArray addObject: obj[@"XL"]];
                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                }
            }];
            [self initChart];
        }
            break;
            
        case DateTypeOfEnd:
        {
            [self.healthTopDateView.endDateBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
            [_lowRateArray removeAllObjects];
            [_highRateArray removeAllObjects];
            [_normalRateArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([ self date: [self asYMD: obj[@"RECORD_TIME"]] isBetweenDate: self.healthTopDateView.startDateBtn.titleLabel.text andDate: date] == YES) {
                    [_lowRateArray addObject: obj[@"SZY"]];
                    [_highRateArray addObject: obj[@"SSY"]];
                    [_normalRateArray addObject: obj[@"XL"]];
                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                }
            }];
            [self initChart];
        }
            break;
        case DateTypeMedium:
        {
            NSLog(@"-----------------------------");
            [self.healthTopDateView.mediumDateBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
            [_lowRateArray removeAllObjects];
            [_highRateArray removeAllObjects];
            [_normalRateArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_rateArray enumerateObjectsUsingBlock: ^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[self asYMD: obj[@"RECORD_TIME"]] isEqualToString: date] == YES) {
                    [_lowRateArray addObject: obj[@"SZY"]];
                    [_highRateArray addObject: obj[@"SSY"]];
                    [_normalRateArray addObject: obj[@"XL"]];
                    [_timeArray addObject: [self asHourAndMinute: obj[@"RECORD_TIME"]]];
                }
            }];
            [self initChart];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    NSDictionary *entity = [_rateArray safeObjectAtIndex: indexPath.row];
    HealthDataListCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (! cell) {
        cell = [[HealthDataListCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    if ([NSStringUtils isNotBlank:entity[@"RECORD_TIME"]]) {
        cell.timeLabel.text = entity[@"RECORD_TIME"];
    }
    if ([NSStringUtils isNotBlank: [entity[@"SZY"] stringValue]] && [NSStringUtils isNotBlank: [entity[@"SSY"] stringValue]]) {
        cell.pressureLabel.text = [NSString stringWithFormat: @"低压/高压：  %@/%@   毫米汞柱",[entity[@"SZY"] stringValue],[entity[@"SSY"] stringValue]];
    }
    if ([NSStringUtils isNotBlank: [entity[@"XL"] stringValue]]) {
        cell.rateLabel.text = [NSString stringWithFormat: @"心率： %@ 次/分钟",[entity[@"XL"] stringValue]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

#pragma mark - privete
- (NSString *)asHourAndMinute: (NSString *)dateStr {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate *theDate = [dateFormat dateFromString: dateStr];
    if (! theDate) {
        return dateStr;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    return [dateFormatter stringFromDate: theDate];
}

- (NSString *)asYMD: (NSString *)dateStr {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate *theDate = [dateFormat dateFromString: dateStr];
    if (! theDate) {
        return dateStr;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd"];
    return [dateFormatter stringFromDate: theDate];
}

- (BOOL)date:(NSString *)dateStr isBetweenDate:(NSString *)beginDateStr andDate:(NSString *)endDateStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"YYYY-MM-dd"];
    NSDate *theDate = [dateFormat dateFromString: dateStr];
    NSDate *beginDate = [dateFormat dateFromString: beginDateStr];
    NSDate *endDate = [dateFormat dateFromString: endDateStr];
    if ([theDate compare: beginDate] == NSOrderedAscending)
        return NO;
    if ([theDate compare: endDate] == NSOrderedDescending)
        return NO;
    return YES;
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
