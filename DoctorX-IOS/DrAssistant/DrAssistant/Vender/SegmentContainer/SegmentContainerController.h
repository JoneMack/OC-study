

#import "ContainerBaseViewController.h"

@protocol YSLContainerViewControllerDelegate <NSObject>

@optional
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller;

@end

@interface SegmentContainerController : ContainerBaseViewController

@property (nonatomic, weak) id <YSLContainerViewControllerDelegate> delegate;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong, readonly) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *childControllers;

@property (nonatomic, strong) UIFont  *menuItemFont;
@property (nonatomic, strong) UIColor *menuItemTitleColor;
@property (nonatomic, strong) UIColor *menuItemSelectedTitleColor;
@property (nonatomic, strong) UIColor *menuBackGroudColor;
@property (nonatomic, strong) UIColor *menuIndicatorColor;

- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;

@end