//
//  ViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/17.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <objc/message.h>
#import "UserModel+cate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Lottie/Lottie.h>
#import <TYAttributedLabel.h>
#import <UIImageView+WebCache.h>
#import <CoreMotion/CoreMotion.h>
#import "MovieModel.h"
#import "Person.h"
#import "SingleDog.h"
#import "VWWWaterView.h"
#import "XBCoreTextView.h"
#import "Plane.h"
#import <Security/Security.h>
#import "NextViewController.h"
#import "TimeInViewController.h"
#import "DrawView.h"
#import <Masonry.h>
#import "RuntimeTest-Swift.h"
#import "RedpacketController.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "GPUImageViewController.h"
#import <YYCache.h>
#import <AVFoundation/AVFoundation.h>
#import "CaptivePortalCheck.h"
#import "FaceIDViewController.h"
#import "LaunchImageController.h"
#import "AIViewController.h"
//#import "PastTextField.h"
#define screen_width          [UIScreen mainScreen].bounds.size.width
#define screen_height          [UIScreen mainScreen].bounds.size.height
// 判断是否支持TouchID,只判断手机端，ipad端我们不支持
#define IS_Phone        (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define IOS8_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

@interface ViewController ()<UIScrollViewDelegate,CAAnimationDelegate,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    
    NSTimeInterval updateInterval;
    CGFloat  setx;//scroll的动态偏移量
    UITextField *field;
    
}
@property (nonatomic, strong) LOTAnimationView *lottieLogo;
@property (nonatomic, strong) NSArray *tableViewItems;
@property (nonatomic, strong) CADisplayLink *displayLinkTimer;//定时器

@property (nonatomic,strong) CMMotionManager *mManager;

@property (nonatomic , strong)UIScrollView *myScrollView;

//@property (nonatomic , assign)CGFloat offsetX;//初始偏移量

@property (nonatomic , assign)NSInteger offset;
@property (nonatomic , assign)int count;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *bigCaddiePrizeLogArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *betslipsView;

@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *moveLayer;

//WiFi认证
@property (strong, nonatomic)  UILabel *checkResultLabel;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIView *touchView;

@property (nonatomic, strong) CAShapeLayer *waveShapeLayer;
@property (nonatomic, strong) CAShapeLayer *waveShapeLayerT;
@property (nonatomic, assign) float offsetX;
@property (nonatomic, assign) float offsetXT;
@property (nonatomic, assign) float waveSpeed;
@property (nonatomic, assign) float waveWidth;
@property (nonatomic, assign) float waveHeight;
@property (nonatomic, assign) BOOL gundong;
 @property (strong, nonatomic) UIScrollView *scrollerView;
@property (nonatomic, strong) UIButton *rollBackBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *performBtn;
@property (nonatomic, strong)  DrawView *drawView;

@end
const NSString *associatedKey = @"associate_array_with_string_key";
NSString *const accessItem = @"2QC668LVNU.com.yibao.runtimetest";
@implementation ViewController
- (void)viewDidAppear:(BOOL)animated_{
    
    [super viewDidAppear:animated_];
    //在界面已经显示后在调用方法(优化)
    [self startUpdateAccelerometerResult:0];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
//    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//    } else {
//        // Fallback on earlier versions
//    }
    
//    NSArray *array = [NSArray arrayWithObjects:@"hello",@"world", nil];
//    NSString *string = @"ios developer";
//
//    //将string关联到array
//    objc_setAssociatedObject(array, &associatedKey, string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    NSLog(@"------array------%@",array);
//
//    NSString *associateString = objc_getAssociatedObject(array, &associatedKey);
//
//    NSLog(@"-------associateString-----%@",associateString);
//
//
//    UserModel *model = [[UserModel alloc] init];
//    model.name = @"xubojoy";
//    model.gender = @"男";
//    model.remark = @"hello world !!!!";
//    NSLog(@"-UserModel----%@--%@--%@",model.name,model.gender,model.remark);
    
    
    NSLog(@"------count------->%ld",(long)count);
    
    
//    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 88, 87)];
//    field.backgroundColor = [UIColor purpleColor];
//    field.placeholder = @"请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈";
//    [self.view addSubview:field];
//
//    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
//    field1.backgroundColor = [UIColor purpleColor];
//    field1.placeholder = @"请输入xxxxxxxxx哈哈哈哈哈哈哈";
//    [self.view addSubview:field1];
    
    
//    _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
//    _drawView.backgroundColor = [UIColor whiteColor];
//    _drawView.lineWidth = 5;
//    _drawView.lineColor = [UIColor blackColor];
//    [self.view addSubview:_drawView];
//
//    _rollBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,screen_height-50,screen_width,50)];
//    _rollBackBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    _rollBackBtn.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
//    _rollBackBtn.layer.borderWidth = 1;
//    [_rollBackBtn setTitle:@"回退" forState:UIControlStateNormal];
//    [_rollBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_rollBackBtn addTarget:self action:@selector(rollBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_rollBackBtn];
    
    
//    0123      01234567
//
//    int remiand = 400 % 4;
//    NSLog(@"------remiand------%d",remiand);
//
//    int remiand1 = 401 % 4;
//    NSLog(@"------remiand1------%d",remiand1);
//
//    int remiand2 = 402 % 4;
//    NSLog(@"------remiand2------%d",remiand2);
//
//    int remiand3 = 403 % 4;
//    NSLog(@"------remiand3------%d",remiand3);
//
//    int remiand4 = 404 % 4;
//    NSLog(@"------remiand4------%d",remiand4);
//
//    int remiand5 = 405 % 4;
//    NSLog(@"------remiand5------%d",remiand5);
//
//    int remiand6 = 406 % 4;
//    NSLog(@"------remiand6------%d",remiand6);
//
//    int remiand7 = 407 % 4;
//    NSLog(@"------remiand7------%d",remiand7);
    
//    TYTextContainer *container = [[TYTextContainer alloc] init];
    
//    NSString *str = @"";
//
//    NSArray *array = [self getImageurlFromHtml:str];
//    NSLog(@"----------------%@",array);
//
    
//     NSString *str = @"请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈请输入xxxxxxxxx哈哈哈哈哈哈哈";
//    NSAttributedString * attrStr = [[NSAttributedString alloc]initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    [container createTextContainerWithTextWidth:CGRectGetWidth(self.view.frame)-30];
//    [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
//        if (value) {
//            NSTextAttachment *ment = value;
//            ment.image = [UIImage imageNamed:@"noavatar"];
//        }
//    }];
//    TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
////    label.textContainer = container;
//    [label setFrameWithOrign:CGPointMake(15, 64) Width:CGRectGetWidth(self.view.frame)-30];
//    [self.view addSubview:label];
////    NSString *str = @"请输入xxxxxxxxx哈哈哈哈哈哈哈请输入";
////    [label setText:str];
//    [label setAttributedText:attrStr];
//    [label setFont:[UIFont systemFontOfSize:14]];
//    [label sizeToFit];
//    CGSize labelSize = [label getSizeWithWidth:self.view.bounds.size.width-30];
//    NSLog(@"----------%f------%f",labelSize.height,labelSize.width);

//    self.bigCaddiePrizeLogArray = @[@"1",@"2",@"3",@"4",@"5",@"1",@"2",@"3",@"4",@"5"];
    
//    [self createView];
//    [self setUpUI];
    
//    [self authenticateUser];
    
    
    
//    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self.view addSubview:self.bgView];
//
//    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, self.bgView.frame.size.width-60, 200)];
//    self.alertView.backgroundColor = [UIColor cyanColor];
//    [self.bgView addSubview:self.alertView];
//    self.alertView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3);
//    [UIView animateWithDuration:1 animations:^{
//        self.alertView.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    } completion:^(BOOL finished) {
//
//    }];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
//    [self.bgView addGestureRecognizer:tap];
    
//    Person *person = [[Person alloc] init];
//    //动态添加方法
//    1
////    [person performSelector:@selector(eat) withObject:@"me"];
//    2
//    SEL selector = NSSelectorFromString(@"eat");
//    IMP imp = [person methodForSelector:selector];
//    void (*func)(id, SEL) = (void *)imp;
//    func(person, selector);
//
//    //增加实例变量
//    Class MyClass = objc_allocateClassPair([NSObject class], "MyClass", 0);
//    NSLog(@".....MyClass......%@",MyClass);
//    BOOL isSuccess = class_addIvar(MyClass, "test", sizeof(NSString *), 0, "@");
//
//    NSLog(@"%@",(isSuccess ? @"添加成功":@"添加失败"));
    
//    UserModel *model = [[UserModel alloc] init];
//
//    model.name = @"haha";
//    model.gender = @"未知";
//
//    //获取文件目录
//    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
//    NSLog(@"documentDirectory = %@",documentDirectory);
//    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"xb.plist"];
//    //自定义对象存到文件中
//    [NSKeyedArchiver archiveRootObject:model toFile:documentDirectory];
//
//    //解档：
//    UserModel* p = [NSKeyedUnarchiver unarchiveObjectWithFile:documentDirectory];
//    NSLog(@"name = %@,gender = %@",p.name,p.gender);
    
    
    
//    self.waveWidth = self.view.bounds.size.width-100;
//    self.waveHeight = 400;
//    [self wave];
    
//    XBCoreTextView *textView = [[XBCoreTextView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width-20, 100)];
//    textView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:textView];
//    float H = [textView getTextHeight];
//    NSLog(@"...........%f",H);
    
    
//    field = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
//    field.keyboardType = UIKeyboardTypeDecimalPad;
//    field.backgroundColor = [UIColor cyanColor];
//    field.clearButtonMode = UITextFieldViewModeWhileEditing;
//    field.delegate = self;
//    [self.view addSubview:field];
    
    
//
//
//    BOOL result = [@"x" isEqualToString:@"X"];
//    NSLog(@"--------result------->%d",result);
    
//    self.view.layer.backgroundColor = [UIColor purpleColor].CGColor;
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(30, 400, 50, 50);
    self.btn.backgroundColor = [UIColor cyanColor];
    [self.btn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
//    CALayer 不支持点击
//    [self.view.layer addSublayer:btn.layer];
    
    
//    self.performBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.performBtn.frame = CGRectMake(30, 500, 50, 50);
//    self.performBtn.backgroundColor = [UIColor cyanColor];
//    [self.performBtn addTarget:self action:@selector(completeClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.performBtn];
    
    
   
    //系统刷新控件
//    self.scrollerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:self.scrollerView];
//
//    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
//    testView.backgroundColor = [UIColor greenColor];
//    [self.scrollerView addSubview:testView];
//
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = [UIColor grayColor];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
//    if (@available(iOS 10.0, *)) {
//        self.scrollerView.refreshControl = refreshControl;
//    } else {
//        // Fallback on earlier versions
//    }
    
//    UIColor *color = [self colorAtPixel:CGPointMake(self.view.frame.size.width/2, 10) withImage:[UIImage imageNamed:@"mineHeaderBG@2x.png"]];
//    NSLog(@"---------颜色-----------%@",color);
    
    
//    Plane *plane = [Plane new];
//    [plane fly];
    
//    Person *person = [Person new];
//    [person performSelector:@selector(fly)];
    
    
    
//    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
//    nameField.keyboardType = UIKeyboardTypeDecimalPad;
//    nameField.backgroundColor = [UIColor cyanColor];
//    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    nameField.delegate = self;
//    [self.view addSubview:nameField];
//
//    UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, 300, 40)];
//    pwdField.keyboardType = UIKeyboardTypeDecimalPad;
//    pwdField.backgroundColor = [UIColor cyanColor];
//    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    pwdField.delegate = self;
//    [self.view addSubview:pwdField];
//
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    loginBtn.frame = CGRectMake(30, 240,100, 40);
//    loginBtn.backgroundColor = [UIColor cyanColor];
//    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];
    
//    NSString *userName = @"xubojoy";
//    NSString *pwd = @"123456";
//
//    [self addKeychainData:userName forKey:(__bridge id)(kSecAttrAccount)];
//    [self addKeychainData:pwd forKey:(__bridge id)(kSecValueData)];
//
//
//    NSString *name = (NSString *)[self readForkey:(__bridge id)(kSecAttrAccount)];
//
//    NSLog(@">>>>>>>>>>namenamename>>>>>>>>>>%@",name);
    
    
//    NSArray *array = [self propertyArr:[UILabel class]];
//    NSLog(@"--------------------%@",array);
    
    NSDictionary *dict = @{@"name":@"123",
                           @"gender":@"男"
                           };
    SingleDog *singleDog = [SingleDog zg_modelFromDic:dict];
    NSLog(@"-----------singleDog---------%@-----%@",singleDog.name,singleDog.gender);
    
//    const char *result = [@"joy" UTF8String];
//
//    NSLog(@"-------class_getInstanceVariable---------%@",class_getInstanceVariable(self.class, result));
    
//    [self class_getClassVariable:self.class name:"SingleDog"];
    
    
//    objc_property_t property = class_getProperty([SingleDog class],"SingleDog");
//
//    NSLog(@"%s%s%s",__func__,property_getName(property),property_getAttributes(property));
//    [self class_getProperty:SingleDog.class name:"gender"];
    
    //获取方法实现
 //入参:类Class，方法名SEL
 //返回:方法实现IMP
// IMP result = class_getMethodImplementation([ViewController class], @selector(test));
// result();
//
//    Method result = class_getClassMethod([SingleDog class], @selector(printDZ));
//    NSLog(@">>>>>>>>%@", result);
    
    //获取方法实现
    //入参:类Class，方法名SEL
    //返回:方法实现IMP
//    IMP result8 = class_getMethodImplementation_stret([ViewController class], @selector(method1));
//    result8();
//    [self loadData];
//    [self setUpUI];
//    [self.view bringSubviewToFront:self.btn];
//
//
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.delegate = self;
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.searchBar.placeholder = @"搜索";
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    [self.searchController.searchBar sizeToFit];
////    [self.view addSubview:self.searchController.searchBar];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    if (@available(iOS 11.0, *)) {
//        self.navigationItem.searchController = self.searchController;
//    } else {
        // Fallback on earlier versions
//    }
//    [self startTime];
//    [self startRedPackerts];
    
//    [self countDown:5];
    
//    [self startCycle];
//    [self initCountdownLabel];
//    [self initCHWButton];
//
//    @try {
//
//    } @catch (NSException *exception) {
//
//    } @finally {
//
//    }
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_group_async(group, queue, ^{
//
//    });
    
//    均失效  不允许获取Mac地址
//    NSLog(@"---------地址-------%@",[self getMacAddress]);
//    NSLog(@"---------地址-------%@",[self macaddress]);
//    NSLog(@"---------地址-------%@",[self getmacAddress]);
    
    
//    加一行代码使得printLog能正常打印。
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"before perform");
//        [self performSelector:@selector(printLog) withObject:nil  afterDelay:0];
//        [[NSRunLoop currentRunLoop] run];
//        NSLog(@"after perform");
//    });
//或者
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"before perform");
        [self performSelector:@selector(printLog) withObject:nil  afterDelay:0];
        NSLog(@"after perform");
    });
    
    
    
    
//    objc_msgSend 传值
    
//    NSString *str = @"字符串objc_msgSend";
//    NSNumber *num = @20;
//    NSArray *arr = @[@"数组值1", @"数组值2"];
//    SEL sel = NSSelectorFromString(@"ObjcMsgSendWithString:withNum:withArray:");
//
// ((void (*) (id, SEL, NSString *, NSNumber *, NSArray *))objc_msgSend)(self, sel, str, num, arr);
    
//    YYCache缓存
//    NSString *userName = @"jack";
//    NSString *key = @"user_name";
//    YYCache *userInfoCache = [YYCache cacheWithName:@"userInfo"];
//    [userInfoCache setObject:userName forKey:key withBlock:^{
//        NSLog(@"缓存成功！！！");
//    }];
//
//    [userInfoCache containsObjectForKey:key withBlock:^(NSString * _Nonnull key, BOOL contains) {
//        if (contains) {
//           NSLog(@"存在！！！");
//        }
//    }];
//
//    [userInfoCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
//        NSLog(@"获取objc--userName----%@",object);
//    }];
    
    
//    CFStringRef UDID = MGCopyAnswer(CFSTR("UniqueDeviceID"));
//
//    CFStringRef IMEI =MGCopyAnswer(CFSTR("InternationalMobileEquipmentIdentity"));
//
//    CFStringRef serialNumber = MGCopyAnswer(CFSTR("SerialNumber"));
    
//    CFArrayRef ICCIDArray =MGCopyAnswer(CFSTR("CarrierBundleInfoArray"));
//    CFDictionaryRef ICCIDDic =CFArrayGetValueAtIndex(ICCIDArray, 0);
//    CFStringRef ICCID  =CFDictionaryGetValue(ICCIDDic, CFSTR("IntegratedCircuitCardIdentity"));
    
//    CFStringRef wifiAddress = MGCopyAnswer(CFSTR("WifiAddress"));
//
//    CFStringRef bluetoothAddress = MGCopyAnswer(CFSTR("BluetoothAddress"));
//
//    CFStringRef CPUArchitecture = MGCopyAnswer(CFSTR("CPUArchitecture"));
//
//    CFStringRef productType = MGCopyAnswer(CFSTR("ProductType"));
//
//    CFTypeRef airplaneMode = MGCopyAnswer(CFSTR("AirplaneMode"));
//
//    NSLog(@"------UDID---%@------IMEI---%@----serialNumber--%@-----wifiAddress--%@----bluetoothAddress--%@----CPUArchitecture--%@---productType---%@-----airplaneMode-%@",UDID,IMEI,serialNumber,wifiAddress,bluetoothAddress,CPUArchitecture,productType,airplaneMode);
    
    
//    NSString *str = @"hello,objective-c";
//    NSLog(@"reverseStr---\n %@",[self reverseStr:str]);
//    NSLog(@"inputValue---\n %@",[self inputValue:str]);
    
    
    
    //获取摄像机
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //创建会话对象
//    self.session = [[AVCaptureSession alloc] init];
//    //设置会话采集率
//    self.session.sessionPreset = AVCaptureSessionPresetHigh;
//    //创建设备输入流
//    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //    AVCaptureScreenInput
//    //创建数据输出流
//    AVCaptureMetadataOutput *metadataOuput = [[AVCaptureMetadataOutput alloc] init];
//    //    AVCaptureStillImageOutput
//    //    AVCaptureVideoDataOutput
//    //    AVCaptureAudioDataOutput
//    //    AVCaptureMetadataOutput
//    //    AVCaptureFileOutput
//    //    AVCapturePhotoOutput
//    [metadataOuput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    //创建设备输出流
//    //    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
//    //    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
//    //设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
//    metadataOuput.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
//    //添加设备输入流到会话对象
//    if ([self.session canAddInput:deviceInput]) {
//        [self.session addInput:deviceInput];
//    }
//    //添加设备输出流到会话对象
//    if ([self.session canAddOutput:metadataOuput]) {
//        [self.session addOutput:metadataOuput];
//    }
//    //    [self.session addOutput:videoDataOutput];
//    //设置设备输出类型
//    metadataOuput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//    //实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
//    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    // 保持纵横比；填充层边界
//    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    self.videoPreviewLayer.frame = CGRectMake(0, 0, screen_width, screen_height);
//    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
//
//    // 启动会话
//    [self.session startRunning];
    
//    UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
//    [switchBtn addTarget:self action:@selector(testModeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:switchBtn];
//
//
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(30, 400, 50, 50);
//    btn1.backgroundColor = [UIColor cyanColor];
//    [btn1 addTarget:self action:@selector(checkWifiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
    
}


- (void)testModeSwitchValueChanged:(UISwitch *)sender {
    [CaptivePortalCheck sharedInstance].openTestMode = sender.isOn;
}

- (void)checkWifiBtnClick:(UIButton *)sender {
    self.checkResultLabel.text = @"认证中...";
    // TODO 如果当前网络状态不是WIFI，则无需检查
    [[CaptivePortalCheck sharedInstance] checkIsWifiNeedAuthPasswordWithComplection:^(BOOL needAuthPassword) {
        self.checkResultLabel.text = needAuthPassword ? @"验证结果：需要认证" : @"验证结果：无需认证";
    } needAlert:YES];
}





//此代理方法为扫码之后获取的二维码信息,在这里可以请求登录
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"---------metadataObjects--------%@", metadataObjects);
}


- (NSString *)reverseStr:(NSString *)str{
    NSMutableArray *strArray = [NSMutableArray new];
    for (NSInteger i = 0; i < str.length; i ++) {
        NSString *tmp = [str substringWithRange:NSMakeRange(i, 1)];
        [strArray addObject:tmp];
    }
    NSArray *array = [[strArray reverseObjectEnumerator] allObjects];
    NSLog(@"-->%@",array);
    NSString *reverseStr = [array componentsJoinedByString:@""];
    NSLog(@"-reverseStr->%@",reverseStr);
    return reverseStr;
}

-(NSString *)inputValue:(NSString *)str{
    NSMutableString *string=[[NSMutableString alloc] init];
    for(int i=0;i<str.length;i++){
        [string appendString:[str substringWithRange:NSMakeRange(str.length-i-1, 1)]];
    }
    
    return string;
}

- (void)printLog {
    NSLog(@"printLog");
}


- (void)ObjcMsgSendWithString:(NSString *)string withNum:(NSNumber *)number withArray:(NSArray *)array {
    NSLog(@"%@, %@, %@", string, number, array[0]);
}

-(void)completeClicked:(UIButton *)sender{
    NSLog(@"点击");
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClick:) object:sender];
    [self performSelector:@selector(buttonClick:) withObject:sender afterDelay:0.2f];
}
//这种方式是在点击后设为不可被点击的状态，1秒后恢复

-(void)buttonClick:(id)sender{
    NSLog(@"禁止点击");
    self.btn.enabled =NO;
    
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止重复点击
    
}

-(void)changeButtonStatus{
    NSLog(@"允许点击");
    self.btn.enabled =YES;
}



+ (CGFloat)getCurrentBatteryLevel {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive){
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]){
            int batteryLevel = 0;
            for (id bview in [aview subviews]){
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0){
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar){
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        if (batteryLevel > 0 && batteryLevel <= 100){
                            return batteryLevel;
                        }else{
                            return 0;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

- (NSString *) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

- (NSString *)getmacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}








- (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
    // *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

- (void)initCHWButton{
    CHWButton *btn = [[CHWButton alloc] initWithCount:5 frame:CGRectMake(50, 100, 100, 50) color:nil];
    btn.animaType = CountBtnTypeCHWBtnTypeScale;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    CHWButton *btn2 = [[CHWButton alloc] initWithCount:5 frame:CGRectMake(200, 100, 100, 50) color:[UIColor cyanColor]];
    btn2.animaType = CountBtnTypeCHWBtnTypeRotate;
    btn2.enabled_bgColor = [UIColor greenColor];
    btn2.layer.cornerRadius = 5;
    btn2.layer.masksToBounds = YES;
    [self.view addSubview:btn2];
    
//    let btn = CHWButton(count: 5, frame: CGRect(x: 50,y: 100,width: 100,height: 50), color:nil)
//    btn.animaType = CountBtnType.CHWBtnTypeScale
//    btn.layer.masksToBounds = true
//    btn.layer.cornerRadius = 5
//    self.view.addSubview(btn)
//
//    let btn2 = CHWButton(count: 5, frame: CGRect(x :200,y: 100,width: 100,height: 50), color:UIColor.cyan)
//    btn2.enabled_bgColor = UIColor.green
//    btn2.animaType = CountBtnType.CHWBtnTypeRotate
//    btn2.layer.masksToBounds = true
//    btn2.layer.cornerRadius = 5
//    self.view.addSubview(btn2)
}

//倒计时动画Swift版本
- (void)initCountdownLabel{
    CountDownLabel *countdownLabel = [[CountDownLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    countdownLabel.textColor = [UIColor redColor];
    countdownLabel.center = self.view.center;
    countdownLabel.font =  [UIFont systemFontOfSize:25];
    countdownLabel.count = 5;
    [self.view addSubview:countdownLabel];
    //可以在合适的地方 －开始倒计时
    [countdownLabel startCount];
}


#pragma mark - lazyInstall
-(CAShapeLayer*)shapeLayer {
    if (!_shapeLayer) {
        //创建出CAShapeLayer
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = CGRectMake(0, 100, 57, 80);
        self.shapeLayer.position = self.view.center;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        //设置线条的宽度和颜色
        self.shapeLayer.lineWidth = 2.0f;
        self.shapeLayer.strokeColor = [UIColor greenColor].CGColor;
        
        //创建出圆形贝塞尔曲线
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 100, 57, 80) cornerRadius:3];
        //让贝塞尔曲线与CAShapeLayer产生联系
        self.shapeLayer.path = circlePath.CGPath;
    }
    return _shapeLayer;
}

#pragma mark - Timer
-(void)startCycle {//用定时器模拟数值输入的情况
    [self.view.layer addSublayer:self.shapeLayer];
    
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 1;
    
//    _displayLinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(circleAnimationType)];
//    _displayLinkTimer.frameInterval = 1; //设置刷新60次响应一次
//    [_displayLinkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    if (!_displayLinkTimer) {
        _displayLinkTimer = [CADisplayLink displayLinkWithTarget:self         selector:@selector(circleAnimationType)];
        _displayLinkTimer.frameInterval = 0.25; //设置刷新60次响应一次
        [_displayLinkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)circleAnimationType {//用定时器调用的方法
    if (_shapeLayer.strokeStart != 1) {
        _shapeLayer.strokeStart += 5;
    }
}

-(void)endCycle {
    [_displayLinkTimer invalidate];
    _displayLinkTimer = nil;
    
    _shapeLayer.strokeStart = 1;
    _shapeLayer.strokeEnd = 0;
    //    [_timer setFireDate:[NSDate distantFuture]];
   
}







- (void)startTime
{
    __block int timeout = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self startRedPackerts];
            });
        }
        else
        {
            int seconds = timeout % 6;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self countDown:seconds];
            });
            timeout = timeout-1;
        }
    });
    dispatch_resume(_timer);
}


-(void)startTime1{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}




-(void)countDown:(int)count{
    if(count <=0){
        //倒计时已到，作需要作的事吧。
        return;
    }
    UILabel* lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 50, 50)];
    lblCountDown.textColor = [UIColor redColor];
    lblCountDown.font = [UIFont boldSystemFontOfSize:66];
    
    lblCountDown.backgroundColor = [UIColor clearColor];
    
    lblCountDown.text = [NSString stringWithFormat:@"%d",count];
    
    [self.view addSubview:lblCountDown];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        lblCountDown.alpha = 0;
        lblCountDown.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    } completion:^(BOOL finished) {
        [lblCountDown removeFromSuperview];
        //递归调用，直到计时为零
//        [self countDown:count-1];
    }];
}


- (void)initTouchView{
    self.touchView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.touchView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.touchView];
}


- (void)startRedPackerts
{
//    [self initTouchView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/4.0) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    [self.timer invalidate];
}
- (void)showRain
{
    UIImageView * imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"logo.jpeg"];
    imageV.frame = CGRectMake(0, 0, 44 , 62.5 );
    
    self.moveLayer = [CALayer new];
    self.moveLayer.bounds = imageV.frame;
    self.moveLayer.anchorPoint = CGPointMake(0, 0);
    self.moveLayer.position = CGPointMake(0, -62.5 );
    self.moveLayer.contents = (id)imageV.image.CGImage;
    [self.view.layer addSublayer:self.moveLayer];
    
    [self addAnimation];
}

- (void)addAnimation
{
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, 0)];
    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, screen_height)];
    moveAnimation.values = @[A,B];
    moveAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.moveLayer addAnimation:moveAnimation forKey:nil];
    
    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tranAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    //为了避免旋转动画完成后再次回到初始状态。
    [tranAnimation setFillMode:kCAFillModeForwards];
    [tranAnimation setRemovedOnCompletion:NO];
    [self.moveLayer addAnimation:tranAnimation forKey:nil];
}


- (void)endAnimation
{
    [self.timer invalidate];
    
    for (NSInteger i = 0; i < self.view.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.view.layer.sublayers[i];
        [layer removeAllAnimations];
    }
}


- (void)clickRed:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.view];
    for (int i = 0 ; i < self.view.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.view.layer.sublayers[i];
        if ([[layer presentationLayer] hitTest:point] != nil)
        {
            NSLog(@"%d",i);
            
            BOOL hasRedPacketd = !(i % 3) ;
            
            UIImageView * newPacketIV = [UIImageView new];
            if (hasRedPacketd)
            {
                newPacketIV.image = [UIImage imageNamed:@"logo.jpeg"];
                newPacketIV.frame = CGRectMake(0, 0, 63.5, 74);
            }
            else
            {
                newPacketIV.image = [UIImage imageNamed:@"logo.jpeg"];
                newPacketIV.frame = CGRectMake(0, 0, 45.5, 76.5);
            }
            
            layer.contents = (id)newPacketIV.image.CGImage;
            
            UIView * alertView = [UIView new];
            alertView.layer.cornerRadius = 5;
            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
            [self.view addSubview:alertView];
            
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:17];
            
            if (!hasRedPacketd)
            {
                label.text = @"旺旺年！人旺旺";
                label.textColor = [UIColor whiteColor];
            }
            else
            {
                NSString * string = [NSString stringWithFormat:@"+%d金币",i];
                NSString * iString = [NSString stringWithFormat:@"%d",i];
                NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:27]
                                      range:NSMakeRange(0, 1)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangTC-Semibold" size:32]
                                      range:NSMakeRange(1, iString.length)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:17]
                                      range:NSMakeRange(1 + iString.length, 2)];
                label.attributedText = attributedStr;
                label.textColor = [UIColor redColor];
            }
            
            [alertView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView.mas_centerX);
                make.centerY.equalTo(alertView.mas_centerY);
            }];
            
            [UIView animateWithDuration:1 animations:^{
                alertView.alpha = 0;
                alertView.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
            } completion:^(BOOL finished) {
                [alertView removeFromSuperview];
            }];
        }
    }
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

- (void)rollBackBtnClicked:(UIButton *)sender{
    [_drawView rollback];
}

//- (void)method1{
//
//}

- (void)loadData{
    self.bigCaddiePrizeLogArray = [NSMutableArray new];
    NSArray* familys = [UIFont familyNames];
    
    for (int i = 0; i<[familys count]; i++) {
        
        NSString* family = [familys objectAtIndex:i];
        
        NSLog(@"Fontfamily:%@=====",family);
        
        NSArray* fonts = [UIFont fontNamesForFamilyName:family];
        [self.bigCaddiePrizeLogArray addObjectsFromArray:fonts];
        
        for (int j = 0; j<[fonts count]; j++) {
            
            NSLog(@"FontName:%@",[fonts objectAtIndex:j]);
//            [self.bigCaddiePrizeLogArray arrayByAddingObject:[fonts objectAtIndex:j]];
        }
    }
    
    NSLog(@"self.bigCaddiePrizeLogArray----------:%@",self.bigCaddiePrizeLogArray);
    [self.tableView reloadData];
}


- (void)test{
    NSLog(@"-----------获取方法实现--------");
}

- (void)class_getProperty:(Class)class name:(const char *)name {
    unsigned int count = 0;
    objc_property_t property = class_getProperty(class,name);
    NSLog(@"%s%s%s",__func__,property_getName(property),property_getAttributes(property));
    property_copyAttributeList(property, &count);
}


- (void)class_getClassVariable:(Class)class name:(const char *)name {
    Ivar ivar = class_getClassVariable(class,name);
    NSLog(@"%s%s%s",__func__,ivar_getTypeEncoding(ivar),ivar_getName(ivar));
}


//获取父类
//入参:类Class
//返回:类Class
//Class class_getSuperclass(Class cls)

//获取实例大小（返回size_t）
//入参:实例的类Class
//返回:大小size_t
//深究请看这篇文章http://www.jianshu.com/p/df6b252fbaae
//size_t class_getInstanceSize(Class cls)

//获取类中指定名称实例成员变量的信息
//入参:类Class，变量名
//返回:变量信息Ivar
//* 1.实例变量是指变量不是属性.例如某类有个属性为:username 那么它对应的实例变量为_username
//* 2.这个方法可以获取属性的变量,也可以获取私有变量(这点很重要)
//* 3.如果获取的变量为空,那么 ivar_getName和 ivar_getTypeEncoding 获取的值为空,那么[NSString stringWithUTF8String:ivar1Name] 执行崩溃
//Ivar class_getInstanceVariable(Class cls, const char *name)

//类成员变量的信息
//入参:类Class，变量名char数组
//返回:Ivar
//* 1.目前没有找到关于Objective-C中类变量的信息，一般认为Objective-C不支持类变量。注意，返回的列表不包含父类的成员变量和属性。
//Ivar class_getClassVariable(Class cls, const char *name)

//获取指定的属性
//入参:类Class，属性名char数组
//返回:属性objc_property_t
// *  1.属性不是变量,此方法只能获取属性
// *  2.如果属性不存在那么返回的结构体为0(可以参考下面的判断)
// *  3.属性不存在获取property_getName 和 property_getAttributes 会崩溃
//objc_property_t class_getProperty(Class cls, const char *name)

//获取方法实现
//入参:类Class，方法名SEL
//返回:方法实现IMP
//IMP class_getMethodImplementation(Class cls, SEL name)
//获取方法实现
//入参:类Class，方法名SEL
//返回:方法实现IMP
//IMP class_getMethodImplementation_stret(Class cls, SEL name)

//获取类方法
//入参:类Class，方法名SEL
//返回:方法Method
//Method class_getClassMethod(Class cls, SEL name)











- (NSArray *)ivarArray:(Class)cls {
    unsigned int count = 0;
    
    Ivar *ivarsA = class_copyIvarList(cls, &count);
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0;i < count; i++) {
        Ivar iv = ivarsA[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(iv)];
        [arr addObject:ivarName];
    }
    free(ivarsA);
    return arr;
}


- (NSArray *)propertyArr:(Class)cls {
    unsigned count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    if (count == 0) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)] ;
        [arr addObject:propertyName];
    }
    free(properties);
    return arr;
}




- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            (id)kSecClassGenericPassword,(id)kSecClass,
            
            service, (id)kSecAttrService,
            
            service, (id)kSecAttrAccount,
            
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            
            nil];
    
}

//增加一个值
- (void)addKeychainData:(id)data forKey:(NSString *)key{
    
    //Get search dictionary
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //Delete old item before add new item
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:accessItem forKey:(id)kSecAttrAccessGroup];
    
    //Add new object to search dictionary(Attention:the data format)
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
}

//删除一个
- (void)deleteWithService:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
}

//更改一个值
- (void)updateKeychainData:(id)data forKey:(NSString *)key {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:accessItem forKey:(id)kSecAttrAccessGroup];
    
    NSData * updata = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    NSDictionary *myDate = @{(__bridge id)kSecValueData : updata};
    
    SecItemUpdate((__bridge CFDictionaryRef)keychainQuery, (__bridge CFDictionaryRef)myDate);
    
}


//查找一个值
- (id)readForkey:(NSString *)key {
    
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        } @catch (NSException *e) {
            
            NSLog(@"Unarchive of %@ failed: %@", key, e);
            
        } @finally {
            
        }
        
    }
    
    if (keyData)
        
        CFRelease(keyData);
    
    return ret;
    
}


- (void)loginBtnClick:(UIButton *)sender{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSString *QQ = @"752875355";
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


-(void)refreshAction
{
    NSLog(@"下拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [self.scrollerView.refreshControl endRefreshing];
        } else {
            // Fallback on earlier versions
        } //结束刷新
    });
}

#pragma mark 同意按钮----------------
- (void)protocolBtnClick:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    NSLog(@">>>>>>>>>>>>>选中状态>>>>____________%d",sender.selected);
//    NSNumber *num = [NSNumber numberWithBool:sender.selected];
//    NSLog(@">>>>>>>>>>>>>选中状态num>>>>____________%@",num);
//    objc_setAssociatedObject(sender, @"protocolBtn", num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//
//    NSNumber *select = objc_getAssociatedObject(sender, @"protocolBtn");
//    NSLog(@"____________当前状态___________%d",[select boolValue]);
    
//    NextViewController *nvc = [[NextViewController alloc] init];
//    nvc.popdate = ^(NSString *str) {
//        NSLog(@"-----------------回传数据--------------%@",str);
//    };
//    [self.navigationController pushViewController:nvc animated:YES];
    
//    TimeInViewController *timevc = [[TimeInViewController alloc] init];
//    [self.navigationController pushViewController:timevc animated:YES];
    
    
//    ShowRainController *svc = [[ShowRainController alloc] init];
//    [self.navigationController pushViewController:svc animated:YES];
    
//    RedpacketController *svc = [[RedpacketController alloc] init];
//    [self.navigationController pushViewController:svc animated:YES];

//    GPUImageViewController *gpuvc = [[GPUImageViewController alloc] init];
//    [self.navigationController pushViewController:gpuvc animated:YES];
    
    
//    TestSwiftViewController *testvc = [[TestSwiftViewController alloc] init];
//    [self.navigationController pushViewController:testvc animated:YES];
    
//    控制状态栏菊花加载状态
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = ![UIApplication sharedApplication].isNetworkActivityIndicatorVisible;
    
//    FaceIDViewController *testvc = [[FaceIDViewController alloc] init];
//    [self.navigationController pushViewController:testvc animated:YES];

    
//    LaunchImageController *testvc = [[LaunchImageController alloc] init];
//    testvc.showLaunchAnimation = YES;
//    [self.navigationController pushViewController:testvc animated:YES];
    
    AIViewController *aivc = [[AIViewController alloc] init];
    [self.navigationController pushViewController:aivc animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    BOOL check = [self validateIDCardNumber:field.text];
//    NSLog(@"--------校验结果------->%d",check);
//   BOOL result = [self resultWithText:textField.text];
//    NSLog(@"--------校验结果------->%d",result);
}


- (BOOL) resultWithText:(NSString *)text{
    NSExpression *lhs = [NSExpression expressionForKeyPath: @"age"];
    NSExpression *greaterThanRhs = [NSExpression expressionForConstantValue: @(5)];
    
    NSPredicate *greaterThanPredicate = [NSComparisonPredicate predicateWithLeftExpression: lhs
                                                                           rightExpression: greaterThanRhs
                                                                                  modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType
                                                                            options: 0];
    NSNumber *num = [NSNumber numberWithInt:[text intValue]];
    if ([greaterThanPredicate evaluateWithObject:num]) {
        return YES;
    }else{
        return NO;
    }

}




//判断身份证号码
- (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                NSLog(@"%@",M);
                NSLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }
            }else {
                return NO;
            }
                    
                    
                    
//                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
//                    return YES;// 检测ID的校验位
//                }else {
//                    return NO;
//                }
//                
//            }else {
//                return NO;
//            }
        default:
            return false;
    }
}







//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
////    if (textField == field) {
//        NSString *text = [textField text];
//
//        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
//        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
//            return NO;
//        }
//
//        text = [text stringByReplacingCharactersInRange:range withString:string];
//        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//        NSString *newString = @"";
//        while (text.length > 0) {
//            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
//            newString = [newString stringByAppendingString:subString];
//            if (subString.length == 4) {
//                newString = [newString stringByAppendingString:@" "];
//            }
//            text = [text substringFromIndex:MIN(text.length, 4)];
//        }
//
//        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
//
//        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 27) {
//
//            return NO;
//        }
//        [textField setText:newString];
//
//        if([text isEqualToString:@""] && [newString isEqualToString:@""])
//        {
//
//        }
//        return NO;
////    }
////    return YES;
//
//}


//- (void)zipFile{
//    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    zipFilePath = [docsPath stringByAppendingPathComponent:@"teZipFile.zip"];
//    //实例化一个压缩文档，并创建文件
//    ZipArchive *za = [[ZipArchive alloc]init];
//    [za CreateZipFile2:zipFilePath];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
//    //进行图片压缩
//
//    UIImage * imageK = [UIImage imageNamed:@""];
//    NSData * imgData = UIImageJPEGRepresentation(imageK, 0.6);
//    if([imageK isKindOfClass:[UIImage class]])
//    {
//        [za addDataToZip:imgData fileAttributes:nil newname:[NSString stringWithFormat:@"%ld.png",(long)timeSp]];
//    }
//
//    //关闭zip文件操作
//    BOOL success = [za CloseZipFile2];
//    if (success) {
//        [self uploadZipData];
//    }else{
//        NSLog( @"压缩失败");
//    }
//}
//
//-(void)uploadZipData{
//    NSFileManager* fm = [NSFileManager defaultManager];
//    NSData* data = [[NSData alloc] init];
//    data = [fm contentsAtPath:zipFilePath];
//    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//}


- (void)wave{
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = [UIColor purpleColor].CGColor;
    [self.view.layer addSublayer:self.waveShapeLayer];
    
//    self.waveShapeLayerT = [CAShapeLayer layer];
//    self.waveShapeLayerT.fillColor = [UIColor purpleColor].CGColor;
//    [self.view.layer addSublayer:self.waveShapeLayerT];
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWave{
    self.offsetX += self.waveSpeed;
    //声明第一条波曲线的路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始点
    CGPathMoveToPoint(path, nil, 50, self.waveHeight);
    CGFloat y = 0;
    
    
    
    //第一个波纹的公式
//    y = self.waveAmplitude * sin((300 / self.waveWidth) * (x * M_PI / 180) - self.offsetX * M_PI / 270) + self.waveHeight*1;
//
//    CGPathAddLineToPoint(path, nil, x, y);
//
//    x++;
    
    for (float x = 0; x <= self.waveWidth; x ++ ) {
        y = 100 * sin((300/self.waveWidth) * (x * M_PI/180)-self.offsetX*M_PI/270)+self.waveHeight*1;
        CGPathAddLineToPoint(path, nil, x, y);
        x ++;
        
    }
    
    //把绘图信息添加到路径里
    CGPathAddLineToPoint(path, nil, self.waveWidth, self.waveHeight);
    CGPathAddLineToPoint(path, nil, 0, self.waveHeight);
    //结束绘制信息
    CGPathCloseSubpath(path);
    
    self.waveShapeLayer.path = path;
    //释放绘制路径
    CGPathRelease(path);
    
    //绘制第二个
//    self.offsetXT += self.waveSpeed;
//
//    CGMutablePathRef pathT = CGPathCreateMutable();
//    CGPathMoveToPoint(pathT, nil, 0, self.waveHeight+100);
//    CGFloat yT = 0;
//    for (float x = 0.f; x <= self.waveWidth ; x++) {
//        yT = 100*1.6 * sin((260 / self.waveWidth) * (x * M_PI / 180) - self.offsetXT * M_PI / 180) + self.waveHeight;
//
//        CGPathAddLineToPoint(pathT, nil, x, yT-10);
//
//    }
//    CGPathAddLineToPoint(pathT, nil, self.waveWidth, 200);
//
//    CGPathAddLineToPoint(pathT, nil, 0, 200);
//
//    CGPathCloseSubpath(pathT);
//
//    self.waveShapeLayerT.path = pathT;
//
//    CGPathRelease(pathT);
//
    
    
}






























- (void)tapBgView{
    [UIView animateWithDuration:1 animations:^{
        self.alertView.layer.transform = CATransform3DMakeScale(1, 0.0001, 0.1);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}


- (void)setUpUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
//    self.gundong = YES;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeerStart) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timeerStart{
    NSLog(@"..............执行");
    self.gundong = !self.gundong;
    if (self.gundong) {
        [self startAnimation];
    }else{
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)startAnimation{
//    self.gundong = NO;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    if (@available(iOS 10.0, *)) {
//        self.displayLink.preferredFramesPerSecond = 1;
    } else {
        // Fallback on earlier versions
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}

//CADisplayLink 定时器 系统默认每秒调用60次
- (void) tick:(CADisplayLink *)displayLink {
    
    self.count ++;
    //NSLog(@"----------self.count---------%d",self.count);
    //(25.0 / 30.0) * (float)self.count) ---> (tableview需要滚动的contentOffset / 一共调用的次数) * 第几次调用
    //比如该demo中 contentOffset最大值为 = cell的高度 * cell的个数 ,5秒执行一个循环则调用次数为 300,没1/60秒 count计数器加1,当count=300时,重置count为0,实现循环滚动.
    int totalCount = (int)(self.bigCaddiePrizeLogArray.count/2);
    [self.tableView setContentOffset:CGPointMake(0, ((totalCount*30 / (totalCount*30)) * (float)self.count)) animated:NO];
    if (self.count >= totalCount*30) {
        self.count = 0;
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bigCaddiePrizeLogArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    header.backgroundColor = [UIColor grayColor];
//    return header;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    NSString *str = self.bigCaddiePrizeLogArray[indexPath.row];
    cell.textLabel.text = self.bigCaddiePrizeLogArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:str size:16];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}


- (void)createView{
    
    //collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *myCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    myCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myCollection];
    
    
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 100)];
    _myScrollView.backgroundColor = [UIColor lightGrayColor];
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
    
    
    for (int i = 0; i < 8; i ++) {
        
        NSString *name = [NSString stringWithFormat:@"%d.jpg",i + 1];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5 + 885 * i, 10, 80, 80)];
        image.image = [UIImage imageNamed:name];
        image.backgroundColor = [UIColor orangeColor];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 40;
        [_myScrollView addSubview:image];
        //偏移量为最后 image 的 frame + origin
        _myScrollView.contentSize = CGSizeMake (image.frame.size.width + image.frame.origin.x, 10);
        
        
    }
    
    
    
}

//手指触碰时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _offsetX = scrollView.contentOffset.x;
    [self stopUpdate];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //优化处理
    setx = scrollView.contentOffset.x;
    
    _offset = scrollView.contentOffset.x - _offsetX;
    
    if (_offset > 0) {
        
        //left
        
    }else{
        
        //right
        
    }
    
    
}
//手指离开时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startUpdateAccelerometerResult:0];
    
}

#pragma mark - 重力感应
- (CMMotionManager *)mManager
{
    if (!_mManager) {
        updateInterval = 1.0/15.0;
        _mManager = [[CMMotionManager alloc] init];
    }
    return _mManager;
}
//开始
- (void)startUpdateAccelerometerResult:(void (^)(NSInteger))result
{
    
    if ([self.mManager isAccelerometerAvailable] == YES) {
        //回调会一直调用,建议获取到就调用下面的停止方法，需要再重新开始，当然如果需求是实时不间断的话可以等离开页面之后再stop
        [self.mManager setAccelerometerUpdateInterval:updateInterval];
        [self.mManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             double x = accelerometerData.acceleration.x;
             double y = accelerometerData.acceleration.y;
             if (fabs(y) >= fabs(x))
             {//前后
                 if (y >= 0){
                     //Down
                 }
                 else{
                     //Portrait
                 }
                 
             } else { //左右
                 
                 if (x >= 0){
                     
                     setx += 10;
                     
                     if (setx <= 360) {
                         //由于以10为单位改变 contentOffset, 会出现顿的现象,加上动画就可解决这个问题
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             _myScrollView.contentOffset = CGPointMake(setx, 0);
                         }];
                         //模仿 scroll 的回弹效果
                         if (setx == 360) {
                             
                             [UIView animateWithDuration:0.5 animations:^{
                                 
                                 _myScrollView.contentOffset = CGPointMake(setx + 50, 0);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.5 animations:^{
                                     
                                     _myScrollView.contentOffset = CGPointMake(setx , 0);
                                     
                                 }];
                                 
                             }];
                             
                         }
                         
                     }else{
                         
                         setx = 360;
                     }
                     
                     
                 }else{
                     
                     setx -= 10;
                     
                     if (setx >= 0) {
                         
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             _myScrollView.contentOffset = CGPointMake(setx, 0);
                             
                         }];
                         
                         //模仿 scroll 的回弹效果
                         if (setx == 0) {
                             
                             [UIView animateWithDuration:0.5 animations:^{
                                 
                                 _myScrollView.contentOffset = CGPointMake(setx - 50, 0);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.5 animations:^{
                                     
                                     _myScrollView.contentOffset = CGPointMake(setx, 0);
                                     
                                 }];
                                 
                             }];
                             
                         }
                         
                     }else{
                         
                         setx = 0;
                         
                     }
                 }
             }
         }];
    }
}

//停止感应方法
- (void)stopUpdate
{
    if ([self.mManager isAccelerometerActive] == YES)
    {
        [self.mManager stopAccelerometerUpdates];
    }
}
//离开页面后停止(移除 mManager)
- (void)dealloc
{
    //制空,防止野指针
    _mManager = nil;
}
























- (NSArray *)getImageurlFromHtml:(NSString *)webString
{
    NSMutableArray * imageurlArray = @[].mutableCopy;
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    return imageurlArray;
}

- (void)authenticateUser
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入登陆密码";
    //错误对象
    NSError* error = nil;
    NSString* result = @"需要验证指纹";
    /**
     注意两者的区别，
     首先支持的版本不同、
     //LAPolicyDeviceOwnerAuthentication  iOS 9.0 以上
     //kLAPolicyDeviceOwnerAuthenticationWithBiometrics  iOS 8.0以上
     其次输入 密码次数有关
     用kLAPolicyDeviceOwnerAuthenticationWithBiometrics 就好拉
     
     最主要的是，前者  使用“context.localizedFallbackTitle = @"输入登陆密码";”
     上面这个属性的时候，不能按我们设定的要求走，它会直接弹出验证
     
     所以还是用后者，kLAPolicyDeviceOwnerAuthenticationWithBiometrics
     
     */
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                NSLog(@"验证成功");
            }
            else
            {
                
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                        
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}



//是否可以用 Touch ID

/**
 <#Description#>
//
// @param policy <#policy description#>
// @param error <#error description#>
// @return <#return value description#>
// */
//- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error{
//    return YES;
//}
////用Touch ID后，返回的结果，是否成功
//- (void)evaluatePolicy:(LAPolicy)policy
//       localizedReason:(NSString *)localizedReason
//                 reply:(void(^)(BOOL success, NSError *error))reply{
//    LAContext *context = [[LAContext alloc] init];
//    NSError *error;
//    context.localizedFallbackTitle = @"输入登陆密码";
//
//
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
//    {
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//                localizedReason:NSLocalizedString(@"Home键验证已有手机指纹", nil)
//                          reply:^(BOOL success, NSError *error)
//         {
//             if (success)
//             {
//                 NSLog(@"验证通过");
//             }
//             else
//             {
//                 switch (error.code)
//                 {
//
//                     case LAErrorUserCancel:
//                         //认证被用户取消.例如点击了 cancel 按钮.
//                         NSLog(@"密码取消");
//                         break;
//
//                     case LAErrorAuthenticationFailed:
//                         // 此处会自动消失，然后下一次弹出的时候，又需要验证数字
//                         // 认证没有成功,因为用户没有成功的提供一个有效的认证资格
//                         NSLog(@"连输三次后，密码失败");
//                         break;
//
//                     case LAErrorPasscodeNotSet:
//                         // 认证不能开始,因为此台设备没有设置密码.
//                         NSLog(@"密码没有设置");
//                         break;
//
//                     case LAErrorSystemCancel:
//                         //认证被系统取消了(例如其他的应用程序到前台了)
//                         NSLog(@"系统取消了验证");
//                         break;
//
//                     case LAErrorUserFallback:
//                         //当输入觉的会有问题的时候输入
//                         NSLog(@"登陆");
//                         break;
//                     case LAErrorTouchIDNotAvailable:
//                         //认证不能开始,因为 touch id 在此台设备尚是无效的.
//                         NSLog(@"touch ID 无效");
//
//                     default:
//                         NSLog(@"您不能访问私有内容");
//                         break;
//                 }
//             }
//         }];
//    }
//    else
//    {
//
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您的Touch ID 设置 有问题" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//
//        switch (error.code) {
//            case LAErrorTouchIDNotEnrolled:
//                alert.message = @"您还没有进行指纹输入，请指纹设定后打开";
//                break;
//            case  LAErrorTouchIDNotAvailable:
//                alert.message = @"您的设备不支持指纹输入，请切换为数字键盘";
//                break;
//            case LAErrorPasscodeNotSet:
//                alert.message = @"您还没有设置密码输入";
//                break;
//            default:
//                break;
//        }
//        [alert show];
//
//
//    }
//}
//
//
////是否是iOS8.0以上的系统
//
////是否是5s以上的设备支持
//+ (NSString *)platform
//{
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    free(machine);
//    return platform;
//}
//
//+ (BOOL)judueIPhonePlatformSupportTouchID
//{
//    /*
//     if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone1G GSM";
//     if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone3G GSM";
//     if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone3GS GSM";
//     if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone4 GSM";
//     if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone4 CDMA";
//     if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone4S";
//     if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone5";
//     if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone5";
//     if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5c (A1456/A1532)";
//     if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5c (A1507/A1516/A1526/A1529)";
//     if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5s (A1453/A1533)";
//     if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5s (A1457/A1518/A1528/A1530)";
//     */
//    if(IS_Phone){
//        if([self platform].length > 6 )
//        {
//            NSString * numberPlatformStr = [[self platform] substringWithRange:NSMakeRange(6, 1)];
//            NSInteger numberPlatform = [numberPlatformStr integerValue];
//            // 是否是5s以上的设备
//            if(numberPlatform > 5){
//                return YES;
//            }
//            else{
//                return NO;
//            }
//        }else{
//            return NO;
//        }
//    }else{
//        // 我们不支持iPad 设备
//        return NO;
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
