//
//  ChoseHospitalViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ChoseHospitalViewController.h"
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
#import "SelectAeraViewController.h"
#import "DcoZoneSelModel.h"

@interface ChoseHospitalViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *_yiShiCardURL;
}
@property (nonatomic,strong) NSMutableArray *arr_diQu;
@property (nonatomic,strong) NSMutableArray *arr_yiYuan;
@property (nonatomic,strong) NSMutableArray *arr_keShi;
@property (nonatomic) NSString *postStr;
@property (nonatomic) NSString *IDStr; // 机构ID

@property (nonatomic) NSString *ORGID;//医院ID
@property (nonatomic) NSString *KeShiID;//科室ID

@end

@implementation ChoseHospitalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"认证信息";
    _arr_diQu = [[NSMutableArray alloc]init];
    _arr_keShi = [[NSMutableArray alloc]init];
    _arr_yiYuan = [[NSMutableArray alloc]init];
    
    self.IDStr = @"";
    
    self.view.backgroundColor = [UIColor defaultBgColor];
    self.bigView.layer.cornerRadius = 10;
    self.bigView.layer.masksToBounds = YES;
    [self registerLJWKeyboardHandler];
    self.nameTF.text = [self.chatListUserEntityDic safeObjectForKey:@"REAL_NAME"];
    NSString *address = [self.chatListUserEntityDic safeObjectForKey:@"address"];
    NSArray *addArr = [address componentsSeparatedByString:@"-"];
    self.diQuLab.text = [addArr safeObjectAtIndex:0];
    self.yiYuanLab.text = [addArr safeObjectAtIndex:1];
    self.keShiLab.text = [self.chatListUserEntityDic safeObjectForKey:@"major"];
    self.dianHuaTF.text= [self.chatListUserEntityDic safeObjectForKey:@"WORK_UNIT_PHONE"];
    self.chuZhenShiJianTF.placeholder = @"例如:周一到周五 9:00～17:00";
    self.chuZhenShiJianTF.text = [self.chatListUserEntityDic safeObjectForKey:@"visit_time"];
    [self.portIamge sd_setImageWithURL:[NSURL URLWithString:[self.chatListUserEntityDic safeObjectForKey:@"qualifiedThumb"]] placeholderImage:[UIImage imageNamed:@"set_about.png"]];
    self.postStr = [self.chatListUserEntityDic safeObjectForKey:@"POST"];
    self.IDNumF.text = [self.chatListUserEntityDic safeObjectForKey:@"ID_CARD_NO"];
    NSString *CERT_STATUS = [self.chatListUserEntityDic safeObjectForKey:@"CERT_STATUS"];
    CERT_STATUS = [NSString stringWithFormat:@"%@",CERT_STATUS];
    if ([CERT_STATUS isEqualToString:@"1"])
    {
        self.bigView.userInteractionEnabled = NO;
        [self.renZhengBtn setTitle:@"审核中" forState:UIControlStateNormal];
        self.renZhengBtn.userInteractionEnabled = NO;
    }
    if ([CERT_STATUS isEqualToString:@"2"])
    {
        self.bigView.userInteractionEnabled = YES;
        [self.renZhengBtn setTitle:@"已认证" forState:UIControlStateNormal];
        self.renZhengBtn.userInteractionEnabled = YES;
    }

    
    [[GRNetworkAgent sharedInstance] requestUrl:AllOrgs_URL param: [BaseEntity sign:nil] baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        DcoZoneSelModel *model = [DcoZoneSelModel objectWithKeyValues:responeObect];
        NSMutableArray *arrayData = [model.data mutableCopy];
        
        if (arrayData.count == 0) {
            [self showString:@"请返回重试"];
            return ;
        }
        
        for (NSDictionary *dic in arrayData) {
            
            NSString *ORG_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ORG_TYPE"]];
            
            if ([ORG_type isEqualToString:@"2"] || [ORG_type isEqualToString:@"1"]) {
                [_arr_diQu safeAddObject:dic];
            }
            if ([ORG_type isEqualToString:@"3"]) {
                [_arr_yiYuan safeAddObject:dic];
            }
            if ([ORG_type isEqualToString:@"4"]) {
                [_arr_keShi safeAddObject:dic];
                
            }
            
        }
        
        //BLOCK_SAFE_RUN(success, nil);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        // BLOCK_SAFE_RUN(fail, error);
    } withTag:RequestTag_Default];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)diQuXuanZe:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDiQuLab:) name:@"changeDiQuLab" object:nil];
    SelectAeraViewController *selDiQu = [SelectAeraViewController simpleInstance];
    selDiQu.dataArray = _arr_diQu;
    [self.navigationController pushViewController:selDiQu animated:YES];
}
- (IBAction)yiYuanXueZe:(id)sender
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in self.arr_yiYuan) {
        NSString *pid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"parent_id"]];
        if ([pid isEqualToString:self.IDStr]) {
            [tempArray safeAddObject:dic];
        }
    }    
    if (tempArray.count == 0) {
        [self showString:@"暂无数据,请重新选择地区"];
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeYiYuanLab:) name:@"changeYiYuanLab" object:nil];
    SelectAeraViewController *selDiQu = [SelectAeraViewController simpleInstance];
    selDiQu.dataArray = tempArray;
    [self.navigationController pushViewController:selDiQu animated:YES];
    //self.IDStr = @"";
}
- (IBAction)keShiXuanZe:(id)sender
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in self.arr_keShi) {
        NSString *pid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"parent_id"]];
        if ([pid isEqualToString:self.IDStr]) {
            [tempArray safeAddObject:dic];
        }
        self.ORGID = self.IDStr;
    }
    if (tempArray.count == 0) {
        [self showString:@"暂无数据,请重新选择地区"];
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeShiLab:) name:@"changeKeShiLab" object:nil];
    SelectAeraViewController *selDiQu = [SelectAeraViewController simpleInstance];
    selDiQu.dataArray = tempArray;
    [self.navigationController pushViewController:selDiQu animated:YES];
    //self.IDStr = @"";
}
- (IBAction)takeAPhoto:(id)sender
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}
- (IBAction)renZhen:(UIButton *)sender
{
    NSLog(@"Save");
    
    if (self.nameTF.text.length == 0 || self.diQuLab.text.length == 0 || self.yiYuanLab.text.length == 0 || self.keShiLab.text.length == 0 || self.IDNumF.text.length == 0 ) {
        [self showString:@"请填写完整信息"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSString *Id = [GlobalConst shareInstance].loginInfo.iD;
    NSString *LGName = [GlobalConst shareInstance].loginInfo.iD;
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [dic safeSetObject:self.nameTF.text forKey:@"real_name"];
    [dic safeSetObject:[NSString stringWithFormat:@"%@-%@",self.diQuLab.text,self.yiYuanLab.text] forKey:@"address"];
    [dic safeSetObject:self.keShiLab.text forKey:@"major"];
    [dic safeSetObject:self.postStr forKey:@"post"];
    if (self.dianHuaTF.text.length == 0) {
        self.dianHuaTF.text = @"--";
    }
    [dic safeSetObject:self.dianHuaTF.text forKey:@"work_unit_phone"];
    [dic safeSetObject:LGName forKey:@"account"];
    if (self.chuZhenShiJianTF.text.length == 0) {
        self.chuZhenShiJianTF.text = @"--";
    }
    [dic safeSetObject:self.chuZhenShiJianTF.text forKey:@"visit_time"];
    [dic safeSetObject:_yiShiCardURL forKey:@"qualifiedThumb"];
    
    [dic safeSetObject:self.ORGID forKey:@"orgId"];
    [dic safeSetObject:self.KeShiID forKey:@"deptId"];
    [dic safeSetObject:self.IDNumF.text forKey:@"cardNo"];

    [[GRNetworkAgent sharedInstance] requestUrl:verifyDoctor param: dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        NSLog(@"%@",responeObect);
        NSString *success = [NSString stringWithFormat:@"%@",[responeObect safeObjectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            [self showString:@"认证申请已发送"];
            
            [self.renZhengBtn setTitle:@"审核中" forState:UIControlStateNormal];
            self.bigView.userInteractionEnabled = NO;
            self.renZhengBtn.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfoAfterRenZheng" object:nil];
        }
        else
        {
            [self showString:@"认证申请发送失败(如果您是二次认证,请重新选择医院科室)"];
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        [self showString:@"数据错误,请返回个人中心重试"];
        
    } withTag:RequestTag_Default];
 
}
- (void)changeDiQuLab:(NSNotification *)notify
{
    NSLog(@"%@",notify);
    NSDictionary *dic = notify.object;
    self.diQuLab.text = [dic safeObjectForKey:@"ORG_NAME"];
    self.IDStr = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"ID"]];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
 }
- (void)changeYiYuanLab:(NSNotification *)notify
{
    NSLog(@"%@",notify);
    NSDictionary *dic = notify.object;
    self.yiYuanLab.text = [dic safeObjectForKey:@"ORG_NAME"];
    self.IDStr = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"ID"]];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)changeKeShiLab:(NSNotification *)notify
{
    NSLog(@"%@",notify);
    NSDictionary *dic = notify.object;
    self.keShiLab.text = [dic safeObjectForKey:@"ORG_NAME"];
    self.KeShiID = [dic safeObjectForKey:@"ID"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
            NSLog(@"%@",entity.dataDic);
            _yiShiCardURL = entity.dataDic;
            [self.portIamge sd_setImageWithURL:[NSURL URLWithString:entity.dataDic] placeholderImage:[UIImage imageNamed:@"set_about.png"]];
            [self showString:@"已上传医师证"];
        }else{
            [self showString:@"上传医师证未成功"];
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
