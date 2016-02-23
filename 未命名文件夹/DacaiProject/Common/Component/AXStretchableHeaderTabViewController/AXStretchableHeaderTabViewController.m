//
//  AXStretchableHeaderTabViewController.m
//  Pods
//

#import "AXStretchableHeaderTabViewController.h"

static NSString *const AXStretchableHeaderTabViewControllerSelectedIndexKey = @"selectedIndex";

@interface AXStretchableHeaderTabViewController ()

@end

@implementation AXStretchableHeaderTabViewController {
    CGFloat _headerViewTopConstraintConstant;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // MEMO:
    // An inherited class does not load xib file.
    // So, this code assigns class name of AXStretchableHeaderTabViewController clearly.
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shouldBounceHeaderView = YES;
        
        _containerView = [[UIScrollView alloc] init];
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.showsHorizontalScrollIndicator = NO;
        
        _tabBar = [[AXTabBar alloc] init];
        _tabBar.delegate = self;
        _tabBar.backgroundColor =[UIColor colorWithRed:15/255.0 green:49/255.0 blue:108/255.0 alpha:0.7];
        _tabBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tabBar sizeToFit];
    CGRect frame= _tabBar.frame ;
    frame.size.height = 37 ;
    _tabBar.frame = frame ;
    [self.view addSubview:_containerView];
    [self.view addSubview:_tabBar];
}

- (void)dealloc {
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
        if (scrollView) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
        [viewController removeFromParentViewController];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _containerView.frame = self.view.bounds;
    _headerView.topConstraint.constant = _headerViewTopConstraintConstant + _containerView.contentInset.top;
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), _headerView.maximumOfHeight + _containerView.contentInset.top);
    
    [self layoutHeaderViewAndTabBar];
    [self layoutViewControllers];
}

#pragma mark - Property

- (UIViewController *)selectedViewController {
    return _viewControllers[_selectedIndex];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    NSInteger newIndex = [_viewControllers indexOfObject:selectedViewController];
    if (newIndex == NSNotFound) {
        return;
    }
    if (newIndex != _selectedIndex) {
        [self changeSelectedIndex:newIndex];
    }
}

- (void)setHeaderView:(AXStretchableHeaderView *)headerView {
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        _headerView = headerView;
        _headerViewTopConstraintConstant = _headerView.topConstraint.constant;
        [self.view addSubview:_headerView];
        [self.view bringSubviewToFront:_tabBar];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers withDefaultIndex:(NSInteger)index {

    if ([_viewControllers isEqualToArray:viewControllers] == NO) {
        // Remove views in old view controllers
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            [viewController.view removeFromSuperview];
            UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
            if (scrollView) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            }
            [viewController removeFromParentViewController];
        }];
        
        // Assign new view controllers
        _viewControllers = [viewControllers copy];
        
        // Add views in new view controllers
        NSMutableArray *tabItems = [NSMutableArray array];
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            [_containerView addSubview:viewController.view];
            UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
            if (scrollView) {
                [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                
            }
            [self addChildViewController:viewController];
            [tabItems addObject:viewController.tabBarItem];
        }];
        [_tabBar setItems:tabItems];
        
        [self layoutViewControllers];
        
        // tab bar
        [_tabBar setSelectedItem:_tabBar.items[index]];
        if (_selectedIndex != index) {
            _selectedIndex = index ;
        }
        
       
//        if (_selectedIndex != 0) {
//
//            [self changeSelectedIndex:0];
//        }
    }

}



- (void)setViewControllers:(NSArray *)viewControllers {
    if ([_viewControllers isEqualToArray:viewControllers] == NO) {
        // Remove views in old view controllers
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            [viewController.view removeFromSuperview];
            UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
            if (scrollView) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            }
            [viewController removeFromParentViewController];
        }];

        // Assign new view controllers
        _viewControllers = [viewControllers copy];

        // Add views in new view controllers
        NSMutableArray *tabItems = [NSMutableArray array];
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            [_containerView addSubview:viewController.view];
            UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
            if (scrollView) {
                [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                
            }
            [self addChildViewController:viewController];
            [tabItems addObject:viewController.tabBarItem];
        }];
        [_tabBar setItems:tabItems];

        [self layoutViewControllers];

        // tab bar
        [_tabBar setSelectedItem:[_tabBar.items firstObject]];
        if (_selectedIndex != 0) {
            [self changeSelectedIndex:0];
        }
    }
}

#pragma mark - Layout

- (void)layoutHeaderViewAndTabBar {
    UIViewController *selectedViewController = self.selectedViewController;

    // Get selected scroll view.
    UIScrollView *scrollView = [self scrollViewWithSubViewController:selectedViewController];
    
    if (scrollView) {
        // Set header view frame
        CGFloat headerViewHeight = _headerView.maximumOfHeight - (scrollView.contentOffset.y + scrollView.contentInset.top);
        
        headerViewHeight = MAX(headerViewHeight, _headerView.minimumOfHeight);
        if (_headerView.bounces == NO) {
            headerViewHeight = MIN(headerViewHeight, _headerView.maximumOfHeight);
        }
        _headerView.frame = CGRectMake(CGRectGetMinX(_headerView.frame), CGRectGetMinY(_headerView.frame), CGRectGetWidth(_headerView.frame), headerViewHeight + _containerView.contentInset.top);
        // Set scroll view indicator insets
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(_tabBar.frame) - _containerView.contentInset.top, 0.0, scrollView.contentInset.bottom, 0.0);
    } else {
        // Set header view frame
        _headerView.frame = CGRectMake(CGRectGetMinX(_headerView.frame), CGRectGetMinY(_headerView.frame), CGRectGetWidth(_headerView.frame), _headerView.maximumOfHeight + _containerView.contentInset.top);
    }

    // Tab bar
    CGFloat tabBarY = (_headerView ? CGRectGetMaxY(_headerView.frame) : _containerView.contentInset.top);
    _tabBar.frame = CGRectMake(0, tabBarY, CGRectGetWidth(_tabBar.frame), CGRectGetHeight(_tabBar.frame));
}

- (void)layoutViewControllers {
    [self.view layoutSubviews];

    CGSize size = _containerView.bounds.size;

    CGFloat headerOffset = (_headerView ? _headerView.maximumOfHeight : 0.0);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(headerOffset + CGRectGetHeight(_tabBar.bounds), 0.0, _containerView.contentInset.top, 0.0);

    // Resize sub view controllers
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        CGRect newFrame = (CGRect){size.width * idx, 0.0, size};
        UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
        if (scrollView) {
            [viewController.view setFrame:newFrame];
            [scrollView setContentInset:contentInsets];
        } else {
            [viewController.view setFrame:UIEdgeInsetsInsetRect(newFrame, contentInsets)];
        }
    }];
    _containerView.contentSize = CGSizeMake(size.width * _viewControllers.count, 0);
}

- (void)layoutSubViewControllerToSelectedViewController {
    UIViewController *selectedViewController = [self selectedViewController];
    // Define selected scroll view
    UIScrollView *selectedScrollView = [self scrollViewWithSubViewController:selectedViewController];
    if (!selectedScrollView) {
        return;
    }

    // Define relative y calculator
    CGFloat (^calcRelativeY)(CGFloat contentOffsetY, CGFloat contentInsetTop) = ^CGFloat(CGFloat contentOffsetY, CGFloat contentInsetTop) {
        return _headerView.maximumOfHeight - _headerView.minimumOfHeight - (contentOffsetY + contentInsetTop);
    };

    // Adjustment offset or frame for sub views.
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        if (selectedViewController == viewController) {
            return;
        }
    
        UIScrollView *targetScrollView = [self scrollViewWithSubViewController:viewController];
        if ([targetScrollView isKindOfClass:[UIScrollView class]]) {
            // Scroll view
            // -> Adjust offset
            CGFloat relativePositionY = calcRelativeY(selectedScrollView.contentOffset.y, selectedScrollView.contentInset.top);//headerViewHeight - _headerView.minimumOfHeight;
            if (relativePositionY > 0) {
                // The header view's height is higher than minimum height.
                // -> Adjust same offset.
                [targetScrollView setContentOffset:selectedScrollView.contentOffset];
        
            } else {
                // The header view height is lower than minimum height.
                // -> Adjust top of scrollview, If target header view's height is higher than minimum height.
                CGFloat targetRelativePositionY = calcRelativeY(targetScrollView.contentOffset.y, targetScrollView.contentInset.top);
                if (targetRelativePositionY > 0) {
                    targetScrollView.contentOffset = CGPointMake(targetScrollView.contentOffset.x, -(CGRectGetMaxY(_tabBar.frame) - _containerView.contentInset.top));
                }
            }
        } else {
            // Not scroll view
            // -> Adjust frame to area at the bottom of tab bar.
            CGFloat y = CGRectGetMaxY(_tabBar.frame) - _containerView.contentInset.top;
            [targetScrollView setFrame:(CGRect){
                CGRectGetMinX(targetScrollView.frame), y,
                CGRectGetMinX(targetScrollView.frame), CGRectGetHeight(_containerView.frame) - y
            }];
        }
    }];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIViewController *selectedViewController = [self selectedViewController];
    
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = [self scrollViewWithSubViewController:selectedViewController];
        if (scrollView != object) {
            return;
        }
        [self layoutHeaderViewAndTabBar];
    }
}

#pragma mark - Scroll view delegate (tab view controllers)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self layoutSubViewControllerToSelectedViewController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        NSUInteger numberOfViewControllers = _viewControllers.count;
        NSInteger newSelectedIndex = round(scrollView.contentOffset.x / scrollView.contentSize.width * numberOfViewControllers);
        newSelectedIndex = MIN(numberOfViewControllers - 1, MAX(0, newSelectedIndex));
        if (_selectedIndex != newSelectedIndex) {
            [_tabBar setSelectedItem:_tabBar.items[newSelectedIndex]];
            [self changeSelectedIndex:newSelectedIndex];
        }
    }
}

#pragma mark - Tab bar delegate

- (BOOL)tabBar:(AXTabBar *)tabBar shouldSelectItem:(UITabBarItem *)item {
    [self layoutSubViewControllerToSelectedViewController];
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger newSelectedIndex = [[tabBar items] indexOfObject:item];
    if (_selectedIndex != newSelectedIndex) {
        [_containerView setContentOffset:(CGPoint) {newSelectedIndex * CGRectGetWidth(_containerView.bounds), _containerView.contentOffset.y } animated:YES];
        [self changeSelectedIndex:newSelectedIndex];
    }
}

#pragma mark - Private Method

- (UIScrollView *)scrollViewWithSubViewController:(UIViewController *)viewController {
    if ([viewController respondsToSelector:@selector(stretchableSubViewInSubViewController:)]) {
        return [(id<AXStretchableSubViewControllerViewSource>)viewController stretchableSubViewInSubViewController:viewController];
    } else if ([viewController.view isKindOfClass:[UIScrollView class]]) {
        return (id)viewController.view;
    } else {
        return nil;
    }
}

- (void)changeSelectedIndex:(NSInteger)selectedIndex {
    [self willChangeValueForKey:@"selectedIndex"];
    [self willChangeValueForKey:@"selectedViewController"];
    _selectedIndex = selectedIndex;
    [self didChangeValueForKey:@"selectedIndex"];
    [self didChangeValueForKey:@"selectedViewController"];
}

@end
