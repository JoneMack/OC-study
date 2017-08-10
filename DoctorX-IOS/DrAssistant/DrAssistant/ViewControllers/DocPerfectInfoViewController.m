//
//  DocPerfectInfoViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "DocPerfectInfoViewController.h"
#import "ChoseHospitalViewController.h"
#import "UploadImageResponseEntity.h"
#import "UserContext.h"
#import "AddCaseHandler.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "MessageHandler.h"
@interface DocPerfectInfoViewController ()<UIActionSheetDelegate>
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSDictionary *userEntityDic;
@end

@implementation DocPerfectInfoViewController
@synthesize imageUrl;
- (void)loadUserData{
    [self showString:@"请等待.."];
    [MessageHandler getUserInfoByUserAccount:[GlobalConst shareInstance].loginInfo.login_name success:^(BaseEntity *object) {
        ChatListUserEntity *chatEntity = (ChatListUserEntity *)object;
        NSDictionary *dict = chatEntity.dataDic;
        //NSLog(@">>>>>>>>>>>>用户信息>>>>>>>>>>>>>%@",dict);
        [self dismissToast];
        self.docorName.text = [dict safeObjectForKey:@"REAL_NAME"];
        self.phoneNum.text = [dict safeObjectForKey:@"PHONE"];
        NSString *sex = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"SEX"]];
        if ([sex isEqualToString:@"1"])
        {
            self.men.checking = YES;
        }
        else
        {
            self.women.checking = YES;
        }
        NSString *zhiCheng = [dict safeObjectForKey:@"POST"];
        self.professionalLevel.text = zhiCheng;
        
        NSURL *imageURL_Pic = [NSURL URLWithString:[dict safeObjectForKey:@"thumb"]];
//        [self.headImage sd_setImageWithURL:imageURL];
        [self.headImage sd_setImageWithURL:imageURL_Pic placeholderImage:[UIImage placeholderAvater]];
        
         self.specialty.text = [dict safeObjectForKey:@"SPECIALITY"];
        self.userEntityDic = dict;

    } fail:^(id object) {
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerLJWKeyboardHandler];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    self.userEntityDic = [[NSDictionary alloc]init];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    [self loadUserData];
    
    // Do any additional setup after loading the view from its nib.
   
}

- (IBAction)hospitalAction:(id)sender {
    
    if (self.professionalLevel.text.length == 0) {
        [self showString:@"请完善信息并保存"];
        return;
    }
    ChoseHospitalViewController *hospital = [ChoseHospitalViewController simpleInstance];
    hospital.chatListUserEntityDic = self.userEntityDic;
    [self.navigationController pushViewController:hospital animated:YES];
}

- (IBAction)uploadHeadAction:(id)sender {
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

- (void) saveButtonAction
{
    NSLog(@"Save");
    if (self.docorName.text.length == 0 || self.phoneNum.text.length == 0 ) {
        [self showString:@"请填写完信息"];
        return;
    }
    
    NSString *sex;
    if (self.women.checking == YES) {
        sex = @"0";
    }
    else
    {
        sex = @"1";
    }
    
    [self showString:@"请等待.."];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *Id = [GlobalConst shareInstance].loginInfo.iD;
    NSString *LGName = [GlobalConst shareInstance].loginInfo.login_name;
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [dic safeSetObject:Id forKey:@"ID"];
    [dic safeSetObject:LGName forKey:@"LOGIN_NAME"];
    [dic safeSetObject:self.docorName.text forKey:@"REAL_NAME"];
    [dic safeSetObject:sex forKey:@"SEX"];
    [dic safeSetObject:self.phoneNum.text forKey:@"PHONE"];
    [dic safeSetObject:self.professionalLevel.text forKey:@"POST"];
    [dic safeSetObject:self.specialty.text forKey:@"SPECIALITY"];
    [[GRNetworkAgent sharedInstance] requestUrl:UPDATE_USER_INFO_URL param: dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        //NSLog(@"%@",responeObect);        
        NSString *success = [responeObect safeObjectForKey:@"msg"];
        [self showString:success];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"用户数据加载刷新" object:nil];
        [self loadUserData];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:RequestTag_Default];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)uploadImageFinish
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *loginName = [GlobalConst shareInstance].loginInfo.login_name;

    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [dic safeSetObject:loginName forKey:@"account"];
    [dic safeSetObject:imageUrl forKey:@"thumb"];

    [[GRNetworkAgent sharedInstance] requestUrl:UPLoadUserImage param: dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        NSLog(@"%@",responeObect);
        NSString *success = [responeObect safeObjectForKey:@"msg"];
        [self showString:success];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:RequestTag_Default];

 
}
- (void)upLoadImage:(NSString *)imageName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [[GRNetworkAgent sharedInstance] uploadFile:UPLOAD_IMAGE_URL baseUrl:BASEURL filePath:path fileName:@"file" param:nil Success:^(GRBaseRequest *request, id responseObject) {
        UploadImageResponseEntity *entity = [UploadImageResponseEntity entityOfDic:responseObject];
        if (entity.success) {
            NSLog(@"%@",entity.dataDic);
                        imageUrl=entity.dataDic;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage placeholderAvater]];
            [self uploadImageFinish];
//            [self showString:@"添加头像成功"];
        }else{
            [self showString:@"添加头像失败"];
        }
    } failure:^(GRBaseRequest *request, NSError *error) {
        [self showString:@"网络异常"];
    } withTag:RequestTag_Default];
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName

{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
