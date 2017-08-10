

#import "SegmentContainerController.h"
#import "SegmentScrollMenuView.h"

static const CGFloat kYSLScrollMenuViewHeight = 40;

@interface SegmentContainerController () <UIScrollViewDelegate, YSLScrollMenuViewDelegate>

@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) SegmentScrollMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *childControllers_Temp;

@end

@implementation SegmentContainerController

- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self) {
        
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
        
        _topBarHeight = topBarHeight;
        _titles = [[NSMutableArray alloc] init];
        _childControllers = [[NSMutableArray alloc] init];
        _childControllers_Temp = [[NSMutableArray alloc] init];
        //_childControllers = [controllers mutableCopy];
        _childControllers_Temp = [controllers mutableCopy];
        
        NSMutableArray *titles = [NSMutableArray array];
        for (UIViewController *vc in _childControllers_Temp) {
            [titles addObject:[vc valueForKey:@"title"]];
        }
        _titles = [titles mutableCopy];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ContentScrollview setup
    _contentScrollView = [[UIScrollView alloc]init];
    _contentScrollView.frame = CGRectMake(0, _topBarHeight + kYSLScrollMenuViewHeight, self.view.frame.size.width, self.view.frame.size.height - (_topBarHeight + kYSLScrollMenuViewHeight));
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    [self.view addSubview:_contentScrollView];
   
    
//    // ContentViewController setup
//    for (int i = 0; i < self.childControllers.count; i++) {
//        id obj = [self.childControllers objectAtIndex:i];
//        if ([obj isKindOfClass:[UIViewController class]]) {
//            UIViewController *controller = (UIViewController*)obj;
//            CGFloat scrollWidth = _contentScrollView.frame.size.width;
//            CGFloat scrollHeght = _contentScrollView.frame.size.height;
//            controller.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeght);
//            [_contentScrollView addSubview:controller.view];
//        }
//    }
    
        // ContentViewController setup
    
    for (int i = 0; i < self.childControllers_Temp.count; i++) {
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.userInteractionEnabled = YES;
        CGFloat scrollWidth = _contentScrollView.frame.size.width;
        CGFloat scrollHeght = _contentScrollView.frame.size.height;
        controller.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeght);
        [_contentScrollView addSubview:controller.view];
        [self.childControllers addObject: controller];
    }
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * self.childControllers.count, _contentScrollView.frame.size.height);
    
    [self addToScrollView:self.currentIndex];
    
    // meunView
    _menuView = [[SegmentScrollMenuView alloc]initWithFrame:CGRectMake(0, _topBarHeight, self.view.frame.size.width, kYSLScrollMenuViewHeight)];
    _menuView.backgroundColor = [UIColor greenColor];
    _menuView.delegate = self;
    _menuView.viewbackgroudColor = self.menuBackGroudColor;
    _menuView.itemfont = self.menuItemFont;
    _menuView.itemTitleColor = self.menuItemTitleColor;
    _menuView.itemIndicatorColor = self.menuIndicatorColor;
    _menuView.scrollView.scrollsToTop = NO;
    [_menuView setItemTitleArray:self.titles];
    [self.view addSubview:_menuView];
    [_menuView setShadowView];
    
    [self scrollMenuViewSelectedIndex:self.currentIndex];
}

- (void)addToScrollView:(NSInteger)index
{
    id obj = [self.childControllers_Temp objectAtIndex:index];
    if ([obj isKindOfClass:[UIViewController class]]) {
        
        UIViewController *controller = (UIViewController*)obj;
        
        BOOL isContain = [_contentScrollView.subviews containsObject: controller.view];
        
        if (!isContain)
        {
            UIViewController *controller = (UIViewController*)obj;
            CGFloat scrollWidth = _contentScrollView.frame.size.width;
            CGFloat scrollHeght = _contentScrollView.frame.size.height;
            controller.view.frame = CGRectMake(index * scrollWidth, 0, scrollWidth, scrollHeght);
            controller.view.tag = index;
            
            [_contentScrollView addSubview:controller.view];
            [_childControllers replaceObjectAtIndex:index withObject:obj];
        }
    }
    
}
#pragma mark -- private

- (void)setChildViewControllerWithCurrentIndex:(NSInteger)currentIndex
{
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = self.childControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            if (i == currentIndex) {
                
                [controller willMoveToParentViewController:self];
                [self addChildViewController:controller];
                [controller beginAppearanceTransition:YES animated:YES];
                
                [controller endAppearanceTransition];
                [controller didMoveToParentViewController:self];
               
            } else {
                
                [controller willMoveToParentViewController:self];
                [controller beginAppearanceTransition:NO animated:YES];
                [controller removeFromParentViewController];
                
                [controller endAppearanceTransition];
                [controller didMoveToParentViewController:self];
                
            }
        }
    }
}
#pragma mark -- YSLScrollMenuView Delegate

- (void)scrollMenuViewSelectedIndex:(NSInteger)index
{
    [_contentScrollView setContentOffset:CGPointMake(index * _contentScrollView.frame.size.width, 0.) animated:YES];
    
    // item color
    [_menuView setItemTextColor:self.menuItemTitleColor
           seletedItemTextColor:self.menuItemSelectedTitleColor
                   currentIndex:index];
    
    [self addToScrollView: index];
    
    [self setChildViewControllerWithCurrentIndex:index];
    
    if (index == self.currentIndex) { return; }
    self.currentIndex = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
}

#pragma mark -- ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat oldPointX = self.currentIndex * scrollView.frame.size.width;
    CGFloat ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.frame.size.width;
    
    BOOL isToNextItem = (_contentScrollView.contentOffset.x > oldPointX);
    NSInteger targetIndex = (isToNextItem) ? self.currentIndex + 1 : self.currentIndex - 1;
    
    CGFloat nextItemOffsetX = 1.0f;
    CGFloat currentItemOffsetX = 1.0f;
    
    nextItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * targetIndex / (_menuView.itemViewArray.count - 1);
    currentItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * self.currentIndex / (_menuView.itemViewArray.count - 1);
    
    if (targetIndex >= 0 && targetIndex < self.childControllers.count) {
        // MenuView Move
        CGFloat indicatorUpdateRatio = ratio;
        if (isToNextItem) {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * 1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currentIndex];
        } else {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * -1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndex = scrollView.contentOffset.x / _contentScrollView.frame.size.width;
    
    if (currentIndex == self.currentIndex) { return; }
    self.currentIndex = currentIndex;
    
    // item color
    [_menuView setItemTextColor:self.menuItemTitleColor
           seletedItemTextColor:self.menuItemSelectedTitleColor
                   currentIndex:currentIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
    
    [self addToScrollView: currentIndex];
    [self setChildViewControllerWithCurrentIndex:self.currentIndex];
}

@end
