//
//  AddCompanyController.m
//  YJ
//
//  Created by xubojoy on 2017/7/4.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "AddCompanyController.h"
#import "AddCompanyView.h"
@interface AddCompanyController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) HeaderView *headerView;
@property(nonatomic, strong) UIButton *logoBtn;
@property(nonatomic, strong) UILabel *companyNameLabel;
@property(nonatomic, strong) UILabel *companyCodeLabel;
@end

@implementation AddCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeaderView];
    [self initUI];
}

- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"公司详情" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(screen_width-60, 20, 60, 40);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:saveBtn];
}

- (void)initUI{
    [self initLogoView];
    [self initAddCompanyView];
}

- (void)initLogoView{
    self.logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoBtn.frame = CGRectMake((screen_width-80)/2, self.headerView.frame.size.height+40, 80, 80);
    self.logoBtn.backgroundColor = [UIColor clearColor];
    [self.logoBtn setBackgroundImage:[UIImage imageNamed:@"golf"] forState:UIControlStateNormal];
    [self.logoBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoBtn];
}

- (void)initAddCompanyView{
    AddCompanyView *addCompanyView = [[AddCompanyView alloc] initWithFrame:CGRectMake(0, self.logoBtn.frame.origin.y+self.logoBtn.frame.size.height+general_space, screen_width, 140)];
    [self.view addSubview:addCompanyView];
}

- (void)saveBtnClick{

}

- (void)addImageBtnClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *imgLibrary = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:takePhoto];//添加按钮
    [alert addAction:imgLibrary];//添加按钮
    [alert addAction:cancel];//添加按钮
    //以modal的形式
    [self presentViewController:alert animated:YES completion:^{ }];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."  maskType:SVProgressHUDMaskTypeGradient];
    image = [ImageUtils imageWithImageSimple:image scaledToSize:CGSizeMake(220, 220)];
    [self.logoBtn setBackgroundImage:image forState:UIControlStateNormal];
    
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
