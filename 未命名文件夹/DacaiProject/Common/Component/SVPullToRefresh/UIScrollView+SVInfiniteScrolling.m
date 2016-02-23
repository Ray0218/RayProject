//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"

static CGFloat const SVInfiniteScrollingViewHeight = 60;

@interface SVInfiniteScrollingDotView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end



@interface SVInfiniteScrollingView ()

@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);

@property (nonatomic, strong) SVActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) SVInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end


@interface SVInfiniteLoadingView : UIView
@property (nonatomic, strong) SVActivityIndicatorView *indicatorView;
@end

@implementation SVInfiniteLoadingView
- (instancetype)init {
    if (self = [super init]) {
        SVActivityIndicatorView *indicator = [[SVActivityIndicatorView alloc] initWithActivityIndicatorStyle:SVActivityIndicatorViewStyleRed];
        UILabel *label = [[UILabel alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载更多...";
        label.font = [UIFont dp_systemFontOfSize:14];
        label.textColor = [UIColor dp_flatBlackColor];
        
        [indicator sizeToFit];
        [label sizeToFit];
        [self setFrame:CGRectMake(0, 0,
                                  CGRectGetWidth(indicator.frame) + CGRectGetWidth(label.frame) + 5,
                                  MAX(CGRectGetHeight(indicator.frame), CGRectGetHeight(label.frame)))];
        [indicator setFrame:CGRectMake(0, 0, CGRectGetWidth(indicator.frame), CGRectGetHeight(self.frame))];
        [label setFrame:CGRectMake(CGRectGetMaxX(indicator.frame) + 5, 0, CGRectGetWidth(label.frame), CGRectGetHeight(self.frame))];
        [self addSubview:indicator];
        [self addSubview:label];
        
        self.indicatorView = indicator;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self.indicatorView startAnimating];
    }
}

@end


#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if(!self.infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight)];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
        
        SVInfiniteLoadingView *loadingView = [[SVInfiniteLoadingView alloc] init];
        [view setCustomView:loadingView forState:SVInfiniteScrollingStateTriggered];
        [view setCustomView:loadingView forState:SVInfiniteScrollingStateLoading];
        [view setCustomView:({
            UILabel *label = [[UILabel alloc] init];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"已无更多数据"];
            [label setFont:[UIFont dp_systemFontOfSize:14]];
            [label setTextColor:[UIColor lightGrayColor]];
            [label sizeToFit];
            label;
        }) forState:SVInfiniteScrollingStateStopped];
    }
}

- (void)triggerInfiniteScrolling {
    self.infiniteScrollingView.state = SVInfiniteScrollingStateTriggered;
    [self.infiniteScrollingView startAnimating];
}

- (void)setInfiniteScrollingView:(SVInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (SVInfiniteScrollingView *)infiniteScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
    
    if(!showsInfiniteScrolling) {
      if (self.infiniteScrollingView.isObserving) {
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
        [self.infiniteScrollingView resetScrollViewContentInset];
        self.infiniteScrollingView.isObserving = NO;
      }
    }
    else {
      if (!self.infiniteScrollingView.isObserving) {
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
        self.infiniteScrollingView.isObserving = YES;
          
        [self.infiniteScrollingView setNeedsLayout];
        self.infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.infiniteScrollingView.bounds.size.width, SVInfiniteScrollingViewHeight);
      }
    }
}

- (BOOL)showsInfiniteScrolling {
    return !self.infiniteScrollingView.hidden;
}

@end


#pragma mark - SVInfiniteScrollingView
@implementation SVInfiniteScrollingView

// public properties
@synthesize infiniteScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = SVActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVInfiniteScrollingStateStopped;
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsInfiniteScrolling) {
          if (self.isObserving) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [scrollView removeObserver:self forKeyPath:@"contentSize"];
            self.isObserving = NO;
          }
        }
    }
}

- (void)layoutSubviews {
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset + SVInfiniteScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    // 去掉动画效果, 修正数据少时, infinite移动动画
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
                         self.scrollView.contentInset = contentInset;
//                     }
//                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {    
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight);
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != SVInfiniteScrollingStateLoading && self.enabled) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffsetThreshold = scrollViewContentHeight-self.scrollView.bounds.size.height;
        
        if(!self.scrollView.isDragging && self.state == SVInfiniteScrollingStateTriggered)
            self.state = SVInfiniteScrollingStateLoading;
        else if(contentOffset.y > scrollOffsetThreshold && self.state == SVInfiniteScrollingStateStopped && self.scrollView.isDragging)
            self.state = SVInfiniteScrollingStateTriggered;
        else if(contentOffset.y < scrollOffsetThreshold  && self.state != SVInfiniteScrollingStateStopped)
            self.state = SVInfiniteScrollingStateStopped;
    }
}

#pragma mark - Getters

- (SVActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[SVActivityIndicatorView alloc] initWithActivityIndicatorStyle:SVActivityIndicatorViewStyleRed];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (SVActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(SVInfiniteScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVInfiniteScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    
    self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(SVActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)triggerRefresh {
    self.state = SVInfiniteScrollingStateTriggered;
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)startAnimating{
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)stopAnimating {
    self.state = SVInfiniteScrollingStateStopped;
}

- (void)setState:(SVInfiniteScrollingState)newState {
    
    if(_state == newState) {
        if (newState == SVInfiniteScrollingStateStopped) {
            id customView = [self.viewForState objectAtIndex:SVInfiniteScrollingStateStopped];
            BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
            if (!hasCustomView) {
                return;
            }
            if ([customView superview] != self) {
                [self addSubview:customView];
            }
            CGRect viewBounds = [customView bounds];
            CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
            [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        }
        return;
    }
    
    SVInfiniteScrollingState previousState = _state;
    _state = newState;
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    if(hasCustomView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
    else {
        CGRect viewBounds = [self.activityIndicatorView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        
        switch (newState) {
            case SVInfiniteScrollingStateStopped:
                [self.activityIndicatorView stopAnimating];
                break;
                
            case SVInfiniteScrollingStateTriggered:
                [self.activityIndicatorView startAnimating];
                break;
                
            case SVInfiniteScrollingStateLoading:
                [self.activityIndicatorView startAnimating];
                break;
        }
    }
    
    if(previousState == SVInfiniteScrollingStateTriggered && newState == SVInfiniteScrollingStateLoading && self.infiniteScrollingHandler && self.enabled)
        self.infiniteScrollingHandler();
}

@end
