//
//  ExpertEvaluationController.m
//  styler
//
//  Created by aypc on 13-12-5.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "PostEvaluationController.h"
#import "ImageUtils.h"
#import "EvaluationStore.h"
#import "StylerException.h"
#import "Toast+UIView.h"
#import "StylistEvaluationsController.h"
#import "Organization.h"
#import "SocialShareStore.h"
#import "UIImage+imagePlus.h"
#import "EvaluationImageViewController.h"
#import "UIViewController+Custom.h"

#define label_blackgroud_color    @"#ebebeb"
#define TextViewDefineText       @"说点什么吧~"
#define evaluation_content_font_size 14
#define post_btn_origin_x 265
#define post_btn_size_width 47
#define post_btn_size_height 26
#define textView_rise_width 100
#define image_width 44
#define image_height 44
#define space_width 10

#define evaluationViewFrame(y) CGRectMake(15,y,285,200)
#define scoreViewFrame(y) CGRectMake(15,y,280,160)

//#define shareToSinaWeiboUrl @"http://styler.meilizhuanjia.cn/appStartup?target=evaluations&expertId="

@interface PostEvaluationController ()

@end

@implementation PostEvaluationController
{
    int count;//用来记录相册的第一个页面，还是第二个页面
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithOrder:(ServiceOrder *)order
{
    self = [self init];
    self.order = order;
    
    [self initHeader];
    [self initContentView];
    count = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEvaluationImage:) name:@"delete_evalustion_image" object:nil];
    return self;
}
#pragma mark --初始化头部
//初始化头部
-(void)initHeader
{
    self.header = [[HeaderView alloc]initWithTitle:page_name_evaluation navigationController:self.navigationController];
    UIButton *postBtn = [[UIButton alloc]init];
    postBtn.frame = CGRectMake(post_btn_origin_x, self.header.frame.size.height - post_btn_size_height - (navigation_height - post_btn_size_height)/2, post_btn_size_width, post_btn_size_height);
    
    [postBtn setImage:[UIImage imageNamed:@"post_default"] forState:UIControlStateNormal];
    [postBtn setImage:[UIImage imageNamed:@"post_selected"] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(sendEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:postBtn];
    [self.header.backBut addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.header];
}
#pragma mark --内容
-(void) initContentView{
    self.contentView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = self.view.frame.size.height-frame.origin.y;
    self.contentView.frame = frame;
    self.imageArray = [[NSMutableArray alloc]init];
    //添加右滑手势
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(popView)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:right];
    
    [self initScoreView];
    [self initEvaluationView];
    [self initBottomView];
    [self initAddImageWrapper];
}

//发布评价
-(void)sendEvaluation:(id)sender
{
    [MobClick event:log_event_name_sender_evaluation attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name,[NSString stringWithFormat:@"对发型师%@评价",self.order.stylist.name],nil]];
    [self.evaluationTextView resignFirstResponder];
    if (self.effectScoreView.score == 0 || self.attitudeScoreView.score == 0 || self.promoteReasonableScoreView.score == 0 || self.trafficConvenientScoreView.score == 0 || self.environmentScoreView.score == 0) {
        [self.view makeToast:@"亲，请完成评心后发布" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
    }else
    {
        if (self.evaluationTextView.text.length < 10) {
            [self.view makeToast:@"请赐至少10个字~~" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在发布，请稍后.." maskType:SVProgressHUDMaskTypeBlack];
        NewEvaluation *evaluation = [[NewEvaluation alloc] init];
    
        
        evaluation.stylistId = self.order.stylist.id;
        evaluation.userId = [[[AppStatus sharedInstance] user].idStr intValue];
        evaluation.content = self.evaluationTextView.text;
        evaluation.effectScore = self.effectScoreView.score;
        evaluation.attitudeScore = self.attitudeScoreView.score;
        evaluation.promoteReasonableScore = self.promoteReasonableScoreView.score;
        evaluation.orderId = self.order.id;
        evaluation.trafficScore = self.trafficConvenientScoreView.score;
        evaluation.environmentScore = self.environmentScoreView.score;
        evaluation.organizationId = self.order.stylist.organization.id;
        for (int i = 0; i < self.imageArray.count ; i++) {
            self.imageArray[i] = [self cutImageForImageBtn:self.imageArray[i]];
        }
        evaluation.evaluationPictures = (NSArray<EvaluationPicture,Optional>*)[[NSMutableArray alloc]initWithArray:self.imageArray];
        
        EvaluationStore *evaluationStore = [EvaluationStore shareInstance];
        [evaluationStore submitEvaluation:^(NSError *err) {
            if (!err) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:binding_sina_weibo_key]) {
                    [self followSinaWeiBo];
                }
                [MobClick event:log_event_name_sender_evaluation attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name,[NSString stringWithFormat:@"对发型师%@评价",self.order.stylist.name],nil]];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [[AppStatus sharedInstance] addEvaluatedOrderId:self.order.id];
                [EvaluationStore checkEvaluationStatus:^(NSError *error) {}];
                [SVProgressHUD dismiss];
            }else{
                StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
                [SVProgressHUD showErrorWithStatus:exception.message duration:2];
            }
        } evaluation:evaluation evaluationImages:self.imageArray];
        
    }
}

-(void) followSinaWeiBo{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/stylists/%d",as.webPageUrl,self.order.stylist.id];
    NSString * contentWithUrl = [NSString stringWithFormat:@"我评价了%@ 发型师%@ %@  %@ @时尚猫官方微博", self.order.stylist.organization.name,self.order.stylist.nickName, [self getAverageScore], url];
    id<ISSContent> publishContent = [ShareSDK content:contentWithUrl
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:self.order.stylist.avatarUrl]
                                                title:nil
                                                  url:url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                   targets:nil
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess) {
                            NSLog(@">>>>>>>评价分享成功");
                            [MobClick event:log_event_name_share_to_sina_weibo_evaluation attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"成功", @"分享结果",nil]];
                        }else if (state == SSResponseStateFail){
                            [MobClick event:log_event_name_share_to_sina_weibo_evaluation attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"失败", @"分享结果",nil]];
                            NSLog(@">>>>>>>评价分享失败");
                        }
            }];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 评分
//初始化评分
-(void)initScoreView
{
    UIView *spliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, general_padding, screen_width, splite_line_height)];
    spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.contentView addSubview:spliteLine];
    
    UIView *downSpliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.scoreView.frame.size.height - splite_line_height, screen_width, splite_line_height)];
    downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.scoreView addSubview:downSpliteLine];
    self.scoreView.backgroundColor = [UIColor clearColor];
    Evaluation *evluation = [[Evaluation alloc]init];

    
    [self.effectScoreView updateStarStatus:evluation.stylistEvaluation.effectScore viewMode:evaluation_score_view_mode_editing];
    [self.attitudeScoreView updateStarStatus:evluation.stylistEvaluation.attitudeScore viewMode:evaluation_score_view_mode_editing];
    [self.promoteReasonableScoreView updateStarStatus:evluation.stylistEvaluation.promoteReasonableScore viewMode:evaluation_score_view_mode_editing];
    [self.trafficConvenientScoreView updateStarStatus:evluation.organizationEvaluation.trafficScore viewMode:evaluation_score_view_mode_editing];
    [self.environmentScoreView updateStarStatus:evluation.organizationEvaluation.environmentScore viewMode:evaluation_score_view_mode_editing];
    
    self.effect.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.attitude.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.promoteReasonable.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.trafficConvenient.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.environment.textColor = [ColorUtils colorWithHexString:black_text_color];
}
//初始化输入框
-(void)initEvaluationView
{
    self.evaluationTextView.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.evaluationTextView.text = TextViewDefineText;

    self.evaluationTextView.delegate = self;
    self.evaluationTextView.returnKeyType = UIReturnKeyDone;
    
    UIView *spliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
    spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.evaluationTextViewWrapper addSubview:spliteLine];
    
    UIView *downSpliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.evaluationTextView.frame.size.height, screen_width, splite_line_height)];
    downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.evaluationTextViewWrapper addSubview:downSpliteLine];
    self.evaluationTextViewWrapper.backgroundColor = [UIColor whiteColor];;
    self.evaluationTextView.backgroundColor = [UIColor whiteColor];
}

//初始化最下边的label
-(void)initBottomView
{
    self.bottomLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.bottomLabel.backgroundColor = [ColorUtils colorWithHexString:label_blackgroud_color];
    CGRect frame = self.bottomLabel.frame;
    frame.origin.y = self.contentView.frame.size.height - frame.size.height;
    self.bottomLabel.frame = frame;
}

#pragma mark --添加图片 设置
-(void)initAddImageWrapper
{
    self.addImageLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.addImageWrapper.userInteractionEnabled = YES;
    imageViewArray = [[NSMutableArray alloc] init];
}
//查看大图
-(void)viewBigImage:(UIGestureRecognizer *) recognizer{
    EvaluationImageViewController *eivc = [[EvaluationImageViewController alloc] init];
    UIImageView *currentImgView = (UIImageView *)recognizer.view;
    eivc.evaluationImg = [currentImgView image];
    self.currentImgInx = currentImgView.tag-940;
    [self.navigationController pushViewController:eivc animated:YES];
}

-(UIImage *)compressImage:(UIImage *)image
{
    UIImage *newImage;
    if (image.size.width >= image.size.height) {
        newImage = [UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(640, 640/image.size.width*image.size.height)];
    }else
    {
        newImage = [UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(960/image.size.height * image.size.width, 960)];
    }
    return newImage;
    
}

//渲染添加评价图片区域
-(void) renderAddEvaluationImgWrapper
{
    //尝试删除所有的ImageView除添加的图片的按钮
    for (UIImageView *imgView in imageViewArray) {
        [imgView removeFromSuperview];
    }
    [imageViewArray removeAllObjects];
    //遍历图片数据添加ImageView并完成布局
    int i = 0;
    float x = 0;
    for (UIImage *img in self.imageArray) {
        //新建评价图片
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        //为图片设置布局
        x = general_padding+i*(image_width+space_width);
        CGRect frame = CGRectMake(x, self.addImageBtn.frame.origin.y, image_width, image_height);
        imgView.frame = frame;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 5.0;
        imgView.layer.borderWidth = 1.0;
        //imgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        //为图片增加手势
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewBigImage:)];
        imgView.tag = 940+i;
        [imgView addGestureRecognizer:tap];
        
        //添加图片视图到容器中
        [self.addImageWrapper addSubview:imgView];
        //添加图片视图到视图数组中
        [imageViewArray addObject:imgView];
        i++;
    }
    CGRect frame = self.addImageBtn.frame;
    frame.origin.x = x + image_width + space_width;
    if (self.imageArray.count == 0) {
        frame.origin.x = general_padding;
    }
    self.addImageBtn.frame = frame;
}

- (IBAction)addImage:(id)sender{
    if (self.imageArray.count < 4) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
        [actionSheet showInView:self.view];
    }else
    {
        [self.view makeToast:@"最多只能添加4张图片" duration:1.0 position:[NSValue valueWithCGPoint:self.addImageWrapper.center]];
    }
    
    [MobClick event:log_event_name_share_to_sina_weibo];
}

#pragma mark --actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 1){
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc]init];
      
        picker.maximumNumberOfSelection = 4 - self.imageArray.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.imageArray addObject:[self compressImage:image]];
    [self renderAddEvaluationImgWrapper];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0; i < assets.count; i++) {
        ALAsset *alAsset = [assets objectAtIndex:i];
        ALAssetRepresentation* representation = [alAsset defaultRepresentation];
        //获取资源图片的高清图,之后压缩
        [self.imageArray addObject:[self compressImage:[UIImage imageWithCGImage:[representation fullResolutionImage]]]];
    }
    
    [self renderAddEvaluationImgWrapper];
    [self dismissViewControllerAnimated:YES completion:nil];
}

 - (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.title = @"相册";
    if ([viewController.navigationItem.rightBarButtonItem.title isEqualToString:@"Cancel"]) {
        [viewController.navigationItem.rightBarButtonItem setTitle:@"取消"];
    }else if([viewController.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"]){
        [viewController.navigationItem.rightBarButtonItem setTitle:@"完成"];
    }
    //设置导航栏的字体和大小
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor],
                                                                         UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0 blue:0 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:bigger_font_size],
                                                                         UITextAttributeFont,
                                                                     nil]];

}


-(void)deleteEvaluationImage:(NSNotification *)note
{
    //从图片数组中删除图片
    [self.imageArray removeObjectAtIndex:self.currentImgInx];
    [self renderAddEvaluationImgWrapper];
    
    [MobClick event:log_event_name_delete_evaluation_image];
}
#pragma mark --监听键盘
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:TextViewDefineText]) {
        textView.text = @"";
    }
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.3];

    CGRect frame = self.contentView.frame;
    frame.origin.y -= textView_rise_width;
    self.contentView.frame = frame;
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = TextViewDefineText;
    }
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.3];
  
    CGRect frame = self.contentView.frame;
    frame.origin.y += textView_rise_width;
    self.contentView.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.evaluationTextView resignFirstResponder];
}

-(NSString *)getAverageScore
{
    int score = 0;
    NSMutableString * heart = [[NSMutableString alloc]init];
    for (int i = 0; i < score; i++) {
        [heart appendString:@"[心]"];
    }
    return heart;
}

//压缩图片
-(UIImage *)cutImageForImageBtn:(UIImage*)image
{
    CGRect rect ;
    if (image.size.width > image.size.height) {
        rect = CGRectMake((image.size.width - image.size.height ) / 2, 0, image.size.height, image.size.height);
    }else
    {
        rect = CGRectMake(0 , (image.size.height - image.size.width ) / 2, image.size.width, image.size.width);
    }
    UIImage * result = [UIImage getSubImage:image rect:rect];
    return result;
}

-(NSString *)getPageName{
    return page_name_evaluation;
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setRightSwipeGestureAndAdaptive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
