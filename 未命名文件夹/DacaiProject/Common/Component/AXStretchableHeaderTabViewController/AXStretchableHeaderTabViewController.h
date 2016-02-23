//
//  AXStretchableHeaderTabViewController.h
//  Pods
//

#import <UIKit/UIKit.h>
#import "AXStretchableHeaderView.h"
#import "AXTabBar.h"

@class AXStretchableHeaderTabViewController;

@protocol AXStretchableSubViewControllerViewSource <NSObject>
@optional
- (UIScrollView *)stretchableSubViewInSubViewController:(id)subViewController;
@end

@interface AXStretchableHeaderTabViewController : UIViewController <UIScrollViewDelegate, AXTabBarDelegate>
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong) AXStretchableHeaderView *headerView;
//@property (nonatomic, strong, readonly) AXTabBar *tabBar;
@property (nonatomic, strong) AXTabBar *tabBar;

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, assign) BOOL shouldBounceHeaderView;

// Layout
- (void)layoutHeaderViewAndTabBar;
- (void)layoutViewControllers;
- (void)layoutSubViewControllerToSelectedViewController;

- (void)changeSelectedIndex:(NSInteger)selectedIndex ;
- (void)setViewControllers:(NSArray *)viewControllers withDefaultIndex:(NSInteger)index ;

@end
