
//
//  PerfectInfoViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PerfectInfoViewController.h"
#import "LLChangeBirthdayViewController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "UINavigationController+Extension.h"
#import "PPerfectEntity.h"
#import "PPerfectHandler.h"
#import "UploadImageResponseEntity.h"
#import "UserContext.h"
#import "HZAreaPickerView.h"
#import "XMLReader.h"
#import "MessageHandler.h"

@interface PerfectInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,HZAreaPickerDelegate, HZAreaPickerDatasource>
@property (weak, nonatomic) IBOutlet UIButton *birdayBtn;
@property(nonatomic,strong) NSString *imageUrl;
@property (strong, nonatomic) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
-(void)cancelLocatePicker;
@end

@implementation PerfectInfoViewController
@synthesize imageUrl;
@synthesize areaValue=_areaValue;
@synthesize locatePicker=_locatePicker;


-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue;
        self.nativePlace.text = areaValue;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self registerLJWKeyboardHandler];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.womenBtn.checking = YES;
    self.marriedBtn.checking = YES;
    self.name.delegate = self;
    self.address.delegate = self;
    self.numberID.delegate = self;
    self.telePhone.delegate = self;
    self.nativePlace.delegate = self;
    CALayer *layer = self.avatarImgView.layer;
    layer.cornerRadius = 40/2;
    layer.masksToBounds = YES;
    [self loadUserData];
}

- (void)loadUserData{
    [MessageHandler getUserInfoByUserAccount:[GlobalConst shareInstance].loginInfo.login_name success:^(BaseEntity *object) {
        ChatListUserEntity *chatEntity = (ChatListUserEntity *)object;
        NSDictionary *dict = chatEntity.dataDic;
        NSLog(@">>>>>>>>>>>>用户信息>>>>>>>>>>>>>%@",dict);
        NSString *temp = nil;
        NSInteger index=0;
        NSInteger j=0;
        for(int i =0; i < [dict[@"address"] length]; i++){
            temp = [dict[@"address"] substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"-"]) {
                index++;
                j=i;
            }
        }
        self.name.text = dict[@"REAL_NAME"];
        if (index>2) {
            self.address.text = [dict[@"address"] substringFromIndex:j+1];
            self.nativePlace.text = [dict[@"address"] substringToIndex:j];
        }else{
            self.nativePlace.text = dict[@"address"];
        }
        int sex = [dict[@"SEX"] intValue];
        if (sex == 1) {
            self.manBtn.checking = YES;
        }else{
            self.womenBtn.checking = YES;
        }
        self.birdayBtn.titleLabel.text = dict[@"BIRTHDAY"];
        self.numberID.text = dict[@"ID_CARD_NO"];
        self.telePhone.text = dict[@"PHONE"];
        int MARRIAGE = [dict[@"MARRIAGE"] intValue];
        if (MARRIAGE == 1) {
            self.sigleDogBtn.checking=YES;
        }else{
            self.marriedBtn.checking=YES;
        }
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:dict[@"thumb"]] placeholderImage:[UIImage placeholderAvater]];
    } fail:^(id object) {
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }
        
    }];


}

- (void)viewWillAppear:(BOOL)animated
{
    [_birdayBtn setTitle:[GlobalConst objectForKey:BIRTH_DAY] forState:UIControlStateNormal];
}

- (void) saveButtonAction
{
    if (_name.text.length == 0 || _address.text.length == 0 || _numberID.text.length == 0 || checkStringIsNull(_telePhone.text) || checkStringIsNull(_nativePlace.text)) {
        [self showString:@"请填写完信息"];
        return;
    }
    
    PPerfectEntity *entity = [PPerfectEntity new];
    entity.userEntity.address =[NSString stringWithFormat:@"%@%@%@",_nativePlace.text,@"-",LLValidatedString(_address.text)];
    //[LLValidatedString(_address.text) stringByAppendingString:_nativePlace.text];
    entity.userEntity.real_name = LLValidatedString(_name.text);
    entity.userEntity.iD=[GlobalConst shareInstance].loginInfo.iD;
    entity.userEntity.login_name=[GlobalConst shareInstance].loginInfo.login_name;
    entity.userEntity.sex = _manBtn.checking?male:female;
    entity.userEntity.birthday = _birdayBtn.titleLabel.text;
    entity.userEntity.id_card_no = _numberID.text;
    entity.userEntity.phone = _telePhone.text;
    entity.userEntity.birthplace = _nativePlace.text;
    entity.userEntity.marriage = _marriedBtn.checking?married:unMarried;
    entity.userEntity.thumb=imageUrl;
    [PPerfectHandler pPerfectRequestWithLoginInfo:entity success:^(BaseEntity *object) {
        [self showString:@"数据保存成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"用户数据保存成功" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(id object) {
        [self showString:@"数据更新失败"];
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }
    }];
}

//拍照头像
- (IBAction)uploadHeadAction:(id)sender {
//     NSUInteger sourceType = 0;
//    // 判断是否支持相机
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        // 相机
//        sourceType = UIImagePickerControllerSourceTypeCamera;
//    }else{
//        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    
//    imagePickerController.allowsEditing = YES;
//    
//    imagePickerController.sourceType = sourceType;
//    
//    [self presentViewController:imagePickerController animated:YES completion:^{}];
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
              UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    NSString *imageName=[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"];
    [self saveImage:newImg WithName:imageName];
    [self upLoadImage:imageName];

 }

- (void)upLoadImage:(NSString *)imageName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [[GRNetworkAgent sharedInstance] uploadFile:UPLOAD_IMAGE_URL baseUrl:BASEURL filePath:path fileName:@"file" param:nil Success:^(GRBaseRequest *request, id responseObject) {
        UploadImageResponseEntity *entity = [UploadImageResponseEntity entityOfDic:responseObject];
        if (entity.success) {
            imageUrl=entity.dataDic;
            [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage placeholderAvater]];
            [self showString:@"添加头像成功"];
        }else{
             [self showString:@"添加头像失败"];
        }
    } failure:^(GRBaseRequest *request, NSError *error) {
        [self showString:@"网络异常"];
    } withTag:RequestTag_Default];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//选生日
- (IBAction)birthdayButtonAction:(id)sender {
    LLChangeBirthdayViewController *birthVC = [LLChangeBirthdayViewController simpleInstance];
    [self.navigationController pushViewController:birthVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName

{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}
#pragma mark - actionSheet
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"33333333333333");
    if(buttonIndex==0){
        [self snapImage];
        NSLog(@"111111111111");
    }else if(buttonIndex==1){
        [self pickImage];
        NSLog(@"222222222222");
    }
    
}
//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:^{}];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:^{}];
}
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    // release the UUID
    CFRelease(uuid);
    return uuidString;
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
//    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
//    
//        self.areaValue = [NSString stringWithFormat:@"%@-%@-%@", picker.locate.state, picker.locate.city, picker.locate.district];
//        NSLog(@">>>>>>>>>>>>>>>self.areaValueself.areaValueself.areaValueself.areaValueself.areaValueself.areaValue>>>>>>>>>>%@",self.areaValue);
//        
//    } else{
////        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
//    }
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    
    NSString* str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLString:str
                                                   options:XMLReaderOptionsProcessNamespaces
                                                     error:&error];
    
    NSArray *list = [[dict objectForKey:@"root"] objectForKey:@"province"];
    return list;
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

- (void)confirmAreaBtnItemClick{
    if (self.locatePicker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        
        self.areaValue = [NSString stringWithFormat:@"%@-%@-%@", self.locatePicker.locate.state, self.locatePicker.locate.city, self.locatePicker.locate.district];
        NSLog(@">>>>>>>>>>>>>>>self.areaValueself.areaValueself.areaValueself.areaValueself.areaValueself.areaValue>>>>>>>>>>%@",self.areaValue);
    }
    [self cancelLocatePicker];
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nativePlace]) {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict
                                                       withDelegate:self
                                                      andDatasource:self];
        CGRect pickerRect = self.locatePicker.frame;
        pickerRect.size.width = kSCREEN_WIDTH;
        self.locatePicker.frame = pickerRect;
        
        [self.locatePicker showInView:self.view];
        [self.view bringSubviewToFront:self.locatePicker];
        CGRect tableViewFramae = self.bgScrollView.frame;
        tableViewFramae.origin.y = -260;
        self.bgScrollView.frame = tableViewFramae;
        return NO;
    }else{
        [self.view sendSubviewToBack:self.locatePicker];
        [self cancelLocatePicker];
        [self.locatePicker removeFromSuperview];
    }
    
    return YES;
}

#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    NSLog(@">>>>>>>>>>>>>>>>>是否会有相应>>>>>>>");
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
