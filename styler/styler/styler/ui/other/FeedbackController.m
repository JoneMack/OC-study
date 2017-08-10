//
//  FeedbackController.m
//  styler
//
//  Created by System Administrator on 13-6-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
/* */
#import "FeedbackController.h"
#import "FeedbackStore.h"
#import "StylerException.h"
#import "SessionMsg.h"
#import "PushProcessor.h"
#import "Toast+UIView.h"
#import "UIViewController+Custom.h"

@interface FeedbackController ()

@end
#define kOFFSET_FOR_KEYBOARD 216.0

@implementation FeedbackController
@synthesize header;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self initFeedbackTable];
    [self initInputView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFeedBackNotification) name:notification_name_receive_feedback_info object:nil];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_feedback navigationController:self.navigationController];
    [self.view addSubview:header];
}

-(void) initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    self.tapGr.cancelsTouchesInView = NO;
    self.tapGr.delegate = self;
    [self.view addGestureRecognizer:self.tapGr];
}

-(void) initInputView{
    CGRect inputViewFrame = self.inputView.frame;
    inputViewFrame.origin.y = self.view.frame.size.height - inputViewFrame.size.height;
    self.inputView.frame = inputViewFrame;
    self.feedbackIn.delegate = self;
    self.stayup = NO;
}

-(void) initFeedbackTable{
    CGRect feedbackTableFrame = CGRectMake(5, header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - header.frame.size.height - self.inputView.frame.size.height - general_padding);
    self.feedbackTable.frame = feedbackTableFrame;
    self.feedbackTable.delegate = self;
    self.feedbackTable.dataSource = self;
    self.feedbackTable.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    AppStatus *as = [AppStatus sharedInstance];
    PushProcessor * pushProcesser = [PushProcessor sharedInstance];

    [pushProcesser checkUnreadFeedbackPush];
    self.msgs = [NSMutableArray arrayWithObjects:[[SessionMsg alloc] init:0 txt:@"您好，我是客服猫猫，有什么需要帮助的请随时联系我。" createTime:nil], nil];
    
    if(as.feedbackSessionId<=0)
        return ;
    
    [[FeedbackStore sharedStore] getLastSessionMsg:^(NSArray *msgs, NSError *err) {
        self.msgs = [NSMutableArray arrayWithArray:msgs];
        [self.msgs insertObject:[[SessionMsg alloc] init:0 txt:@"您好，我是客服猫猫，有什么需要帮助的请随时联系我。" createTime:nil] atIndex:0];
        if (msgs == nil || msgs.count == 0) {
            return ;
        }
        [self.feedbackTable reloadData];
        if (self.feedbackTable.contentSize.height > self.feedbackTable.frame.size.height) {
            [self.feedbackTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.msgs.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        [[PushProcessor sharedInstance] checkUnreadFeedbackPush];
    } sessionId:as.feedbackSessionId refresh:[[PushProcessor sharedInstance] feedbackPushNum]>0?YES:NO];
    
}

-(void)receiveFeedBackNotification
{
    AppStatus *as = [AppStatus sharedInstance];
    if(as.feedbackSessionId<=0)
        return ;
    [[FeedbackStore sharedStore] getLastSessionMsg:^(NSArray *msgs, NSError *err)
     {
         self.msgs = [NSMutableArray arrayWithArray:msgs];
         [self.msgs insertObject:[[SessionMsg alloc] init:0 txt:@"您好，我是客服猫猫，有什么需要帮助的请随时联系我。" createTime:nil] atIndex:0];
        if (msgs == nil || msgs.count == 0) {
            return ;
        }
        [self.feedbackTable reloadData];
         if (self.feedbackTable.contentSize.height > self.feedbackTable.frame.size.height) {
             
             [self.feedbackTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.msgs.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
         }
        [[PushProcessor sharedInstance] checkUnreadFeedbackPush];
    } sessionId:as.feedbackSessionId refresh:[[PushProcessor sharedInstance] feedbackPushNum]>0?YES:NO];
}


#pragma mark - FeedbackTable delegate & datasource
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SessionMsg *msg = [self.msgs objectAtIndex:indexPath.row];
    UIFont *msgFont = [UIFont systemFontOfSize:14.0];
    CGSize size = CGSizeMake(210, 2000);
    CGSize msgSize = [msg.txt sizeWithFont:msgFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    float height = msgSize.height<=20?40:(msgSize.height+20);
    return height+10;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.msgs count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"feedbackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    SessionMsg *msg = [self.msgs objectAtIndex:indexPath.row];
    UILabel *msgLabel = [[UILabel alloc] init];
    
    msgLabel.text = msg.txt;
    UIFont *msgFont = [UIFont systemFontOfSize:default_font_size];
    msgLabel.font = msgFont;
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    msgLabel.numberOfLines = 0;
    
    CGSize size = CGSizeMake(210, 2000);
    CGSize msgSize = [msg.txt sizeWithFont:msgFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //用户
    if(msg.senderId > 0){
        UIImageView * avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(275, 0, 35, 35)];
        [avatarImageView.layer setCornerRadius:17.5];
        [avatarImageView.layer setMasksToBounds:YES];
        
        NSString * avatarUrl = [AppStatus sharedInstance].user.avatarUrl;
        [avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
        UIImage *bubble = [UIImage loadImageWithImageName:@"feedback_user"];
        UIEdgeInsets keepCorner = UIEdgeInsetsMake(19, 20, 14, 40);
        bubble = [bubble resizableImageWithCapInsets:keepCorner];
        
        UIImageView *bubbleIV = [[UIImageView alloc] initWithImage:bubble];
        float bubbleHeight = msgSize.height<=16.5?40:(msgSize.height+16.5);

        bubbleIV.frame = CGRectMake(self.feedbackTable.frame.size.width-msgSize.width-35 - 40, 0, msgSize.width+25, bubbleHeight);
        msgLabel.frame = CGRectMake(self.feedbackTable.frame.size.width-msgSize.width-25 - 40, 0, msgSize.width, bubbleHeight - 2);
        
        msgLabel.textColor = [ColorUtils colorWithHexString:white_text_color];
        [cell.contentView addSubview:avatarImageView];
        [cell.contentView addSubview:bubbleIV];
        [cell.contentView addSubview:msgLabel];
    }else{//客服
        UIImageView * avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 35, 35)];
        [avatarImageView.layer setCornerRadius:17.5];
        [avatarImageView.layer setMasksToBounds:YES];
        
        avatarImageView.image = [UIImage loadImageWithImageName:@"shishangmao_icon"];
        
        UIImage *bubble = [UIImage loadImageWithImageName:@"feedback_service"];
        UIEdgeInsets keepCorner = UIEdgeInsetsMake(19, 20, 14, 40);
        bubble = [bubble resizableImageWithCapInsets:keepCorner];
        
        UIImageView *bubbleIV = [[UIImageView alloc] initWithImage:bubble];
        float bubbleHeight = msgSize.height<=16.5?40:(msgSize.height+16.5);
        bubbleIV.frame = CGRectMake(45, 0, msgSize.width+25, bubbleHeight);
        msgLabel.frame = CGRectMake(60, 0, msgSize.width, bubbleHeight - 2);
        
        [cell.contentView addSubview:avatarImageView];
        [cell.contentView addSubview:bubbleIV];
        [cell.contentView addSubview:msgLabel];
    }
    return cell;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 过滤掉UIButton，也可以是其他类型
    if (gestureRecognizer == self.tapGr && [touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

-(void) viewTapped:(UITapGestureRecognizer *)sender{
    [self.feedbackIn resignFirstResponder];
}

#pragma mark Responding to keyboard events
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendFeedback];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.stayup = YES;
    [self setViewMoveUp:YES];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    if (![self.feedbackIn isFirstResponder]) {
        return;
    }
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size; //获取键盘高度
    self.inputView.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - self.inputView.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
    //设置滚动，OK
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.stayup = NO;
    [self setViewMoveUp:NO];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMoveUp:(BOOL)moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
        if (moveUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
            //rect.size.height += kOFFSET_FOR_KEYBOARD;
        
        if (self.stayup == YES) {
            self.feedbackTable.frame = CGRectMake(self.feedbackTable.frame.origin.x, self.feedbackTable.frame.origin.y, self.feedbackTable.frame.size.width, self.feedbackTable.frame.size.height - kOFFSET_FOR_KEYBOARD);
            self.inputView.frame = CGRectMake(self.inputView.frame.origin.x, self.inputView.frame.origin.y  - kOFFSET_FOR_KEYBOARD, self.inputView.frame.size.width, self.inputView.frame.size.height);
            if (self.feedbackTable.contentSize.height > self.feedbackTable.frame.size.height) {
                [self.feedbackTable setContentOffset:CGPointMake(0, self.feedbackTable.contentSize.height - self.feedbackTable.frame.size.height)];
            }
        }
    }
    else
    {
        if (self.stayup == NO) {
            self.feedbackTable.frame = CGRectMake(self.feedbackTable.frame.origin.x, self.feedbackTable.frame.origin.y, self.feedbackTable.frame.size.width, self.feedbackTable.frame.size.height + kOFFSET_FOR_KEYBOARD);
            self.inputView.frame = CGRectMake(self.inputView.frame.origin.x, self.view.frame.size.height - self.inputView.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
            if(self.feedbackTable.contentSize.height > self.feedbackTable.frame.size.height) {
                [self.feedbackTable setContentOffset:CGPointMake(0, self.feedbackTable.contentSize.height - self.feedbackTable.frame.size.height)];
            }
        }
    }
    [UIView commitAnimations];
}

- (void)sendFeedback {
    if (self.feedbackIn.text == nil || [self.feedbackIn.text isEqualToString:@""]) {
        return ;
    }
    
    AppStatus *as = [AppStatus sharedInstance];
    if (![as isConnetInternet]) {
        [self.view makeToast:@"网络异常，请稍后再试" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    [MobClick event:log_event_name_sender_feedback attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.feedbackIn.text, @"分享",nil]];
    FeedbackStore *feedbackStore = [FeedbackStore sharedStore];
    [feedbackStore sendFeedback:^(int sessionId, NSError *err) {
        if (err == nil) {
            as.feedbackSessionId = sessionId;
            [AppStatus saveAppStatus];
            
            SessionMsg *msg = [[SessionMsg alloc] init:[as.user.idStr intValue] txt:self.feedbackIn.text createTime:[NSDate date]];
            NSMutableArray *msgs = [[NSMutableArray alloc] initWithArray:self.msgs];
            [msgs addObject:msg];
            self.msgs = msgs;
            [self.feedbackTable reloadData];
            [self.feedbackTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.msgs.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            [[FeedbackStore sharedStore] getLastSessionMsg:^(NSArray *msgs, NSError *err) {
            } sessionId:as.feedbackSessionId refresh:YES];
            self.feedbackIn.text = @"";
        }else{
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
        [self.feedbackIn resignFirstResponder];
    } msg:self.feedbackIn.text];
}

-(NSString *)getPageName{
    return page_name_feedback;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFeedbackTable:nil];
    [self setInputView:nil];
    [self setFeedbackIn:nil];
    [self setBottomBg:nil];
    [self setInputView:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

