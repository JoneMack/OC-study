//
//  CaseDetailViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "AddCaseHandler.h"

#import "UploadImageResponseEntity.h"
NSString *TMP_UPLOAD_IMG_PATH=@"";
@interface CaseDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>

@end

@implementation CaseDetailViewController
static CGRect oldframe;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"上传病历";
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    [self.lookImage addGestureRecognizer:tap];
    self.lookImage.userInteractionEnabled = NO;
    self.lookImage.layer.cornerRadius = 37.5;
    self.lookImage.layer.masksToBounds = YES;
    /*****此处用于查看病例****/
    if ([self.fromPatientDetail isEqualToString:@"LAIZI_MyCaseViewController"]) {
        if ([self.reciveNameString length]) {
            self.name.text = self.reciveNameString;
        }else{
             self.name.text = @"本人";
        }
        self.date.text = self.healthInfo.RECORD_TIME;
        self.caseContent.text = self.healthInfo.RECORD;
        if (self.healthInfo.RECORD_IMG.length == 0) {
            self.lookImage.image = [UIImage imageNamed:@"adcase_pica.png"];
        }
        else
        {
            [self.lookImage sd_setImageWithURL:[NSURL URLWithString:self.healthInfo.RECORD_IMG]];
        }
        
        [self.uploadImage setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.lookImage.userInteractionEnabled = YES;
        self.caseContent.userInteractionEnabled = NO;
        self.uploadImage.userInteractionEnabled = NO;
        return;
    }
    
    if ([self.fromPatientDetail isEqualToString:@"LAIZI_XIANGQINGBINGLIXINXI"]) {
        if ([self.reciveNameString length]) {
            self.name.text = self.reciveNameString;
        }else{
            self.name.text = @"本人";
        }
        self.date.text = [self.reciveDataDic safeObjectForKey:@"RECORD_TIME"];
        self.caseContent.text = [self.reciveDataDic safeObjectForKey:@"RECORD"];
        if ([NSString stringWithFormat:@"%@",[self.reciveDataDic safeObjectForKey:@"RECORD_IMG"]].length == 0) {
            self.lookImage.image = [UIImage imageNamed:@"adcase_pica.png"];
        }
        else
        {
            [self.lookImage sd_setImageWithURL:[NSURL URLWithString:[self.reciveDataDic safeObjectForKey:@"RECORD_IMG"]]];
        }
        
        [self.uploadImage setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.lookImage.userInteractionEnabled = YES;
        self.caseContent.userInteractionEnabled = NO;
        self.uploadImage.userInteractionEnabled = NO;
        return;
    }
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.name.text=[GlobalConst shareInstance].loginInfo.real_name;
    self.date.text=[df stringFromDate:currentDate];
    self.caseContent.delegate = self;
    
}
- (void)magnifyImage
{
    NSLog(@"局部放大--%@",self.lookImage);
    if (self.lookImage.image == nil) {
        [self showString:@"附件不存在"];
        return;
    }
    
    [self showImage:self.lookImage];//调用方法
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void) saveButtonAction
{
    self.healthInfo.CLUB_ID = self.ClubInfo.ID;
    self.healthInfo.USER_ID = [GlobalConst shareInstance].loginInfo.iD;
    
    if ([self.caseContent.text isEqualToString:@"请输入你的症状"] || self.caseContent.text.length == 0) {
        [self showString:@"请完成信息"];
        return;
    }
    self.healthInfo.RECORD=self.caseContent.text;
    self.healthInfo.TYPE=1;
    NSMutableDictionary *dic = self.healthInfo.keyValues;
    [dic addEntriesFromDictionary: [BaseEntity sign: nil]];
    [[GRNetworkAgent sharedInstance] requestUrl:uploadClubParam param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        BOOL success = [reponeObject boolValueForKey:@"success"];
        NSString *msg = [reponeObject stringValueForKey:@"msg"];
        if (success) {
            [self showString:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:Key_AddHeathDataSuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (!msg) {
                msg = @"添加失败";
            }
            [self showString:msg];
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];

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


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
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
            self.healthInfo.RECORD_IMG=entity.dataDic;
            [self showString:@"上传图片成功"];
            [self.lookImage sd_setImageWithURL:[NSURL URLWithString:self.healthInfo.RECORD_IMG] placeholderImage:nil];
            self.lookImage.userInteractionEnabled = YES;
        }else{
            [self showString:@"传图片失败"];
        }
    } failure:^(GRBaseRequest *request, NSError *error) {
        [self showString:@"网络异常"];
    } withTag:RequestTag_Default];
   [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
//
//{
//    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
//    NSData* imageData = UIImagePNGRepresentation(tempImage);
//    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    
//    // Now we get the full path to the file
//    
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    
//    // and then we write it out
//    TMP_UPLOAD_IMG_PATH=fullPathToFile;
//    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@""];
//    NSLog(@"===new fullPathToFile===%@",fullPathToFile);
//    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
//    self.healthInfo.RECORD_IMG=[nameAry objectAtIndex:[nameAry count]-1];
//    [imageData writeToFile:fullPathToFile atomically:NO];
//    
//}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName

{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
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

- (IBAction)pictureAccessoryAction:(id)sender
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];

}
- (HealthDataEntity *)healthInfo{
    if (_healthInfo == nil) {
        _healthInfo = [[HealthDataEntity alloc] init];
    }
    return _healthInfo;
}
/**********用于查看拍照的附件的***********/
 
-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
