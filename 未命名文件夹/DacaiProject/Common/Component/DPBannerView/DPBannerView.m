//
//  DPBannerView.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBannerView.h"

@protocol DPBannerScrollViewDelegate <UIScrollViewDelegate>
@optional
- (void)scrollViewDidBeginTracking:(UIScrollView *)scrollView;
- (void)scrollViewDidEndTracking:(UIScrollView *)scrollView;
@end

@interface DPBannerScrollView : UIScrollView {
@private
    struct {
        unsigned scrollViewDidBeginTracking : 1;
        unsigned scrollViewDidEndTracking : 1;
    } _bannerDelegateHas;
}
@end

@implementation DPBannerScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
}

- (void)setDelegate:(id<DPBannerScrollViewDelegate>)delegate {
    [super setDelegate:delegate];
    
    _bannerDelegateHas.scrollViewDidBeginTracking = [delegate respondsToSelector:@selector(scrollViewDidBeginTracking:)];
    _bannerDelegateHas.scrollViewDidEndTracking = [delegate respondsToSelector:@selector(scrollViewDidEndTracking:)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.panGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            if (_bannerDelegateHas.scrollViewDidEndTracking) {
                [(id<DPBannerScrollViewDelegate>)self.delegate scrollViewDidEndTracking:self];
            }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_bannerDelegateHas.scrollViewDidBeginTracking) {
        [(id<DPBannerScrollViewDelegate>)self.delegate scrollViewDidBeginTracking:self];
    }
}

@end

@interface DPBannerView () <UIScrollViewDelegate> {
@private
    NSInteger _currentIndex;
}

@property (nonatomic, assign) CGRect lastBounds;

@property (nonatomic, strong, readonly) DPBannerScrollView *scrollView;
@property (nonatomic, strong, readonly) UIImageView *preView;
@property (nonatomic, strong, readonly) UIImageView *curView;
@property (nonatomic, strong, readonly) UIImageView *nxtView;

@property (nonatomic, assign, readonly) NSInteger preIndex;
@property (nonatomic, assign, readonly) NSInteger curIndex;
@property (nonatomic, assign, readonly) NSInteger nxtIndex;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@end

@implementation DPBannerView
@dynamic index;
@dynamic preIndex;
@dynamic curIndex;
@dynamic nxtIndex;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self.scrollView addSubview:self.preView];
        [self.scrollView addSubview:self.curView];
        [self.scrollView addSubview:self.nxtView];
        [self addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
            tap;
        })];
        
        [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.duration];
    }
    return self;
}

- (void)pvt_onTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedAtIndex:)]) {
        [self.delegate bannerView:self didSelectedAtIndex:self.curIndex];
    }
}

- (void)layoutSubviews {
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 20, CGRectGetWidth(self.bounds), 20);
    
    if (!CGRectEqualToRect(self.lastBounds, self.bounds)) {
        self.lastBounds = self.bounds;
        
        // 调整图片大小
        CGRect frame = self.bounds;
        self.preView.frame = frame;
        frame.origin.x += CGRectGetWidth(frame);
        self.curView.frame = frame;
        frame.origin.x += CGRectGetWidth(frame);
        self.nxtView.frame = frame;
        
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(frame), 0);
    }
}

#pragma mark - 无限循环
- (void)reloadData {
    if (self.images.count) {
        self.preView.image = self.images[self.preIndex];
        self.curView.image = self.images[self.curIndex];
        self.nxtView.image = self.images[self.nxtIndex];
    } else {
        self.preView.image = self.curView.image = self.nxtView.image = nil;
    }
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    [self.pageControl setCurrentPage:_currentIndex];
}

- (void)autoSwitchBannerView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
    
    if (self.duration > 0) {
        if (self.images.count > 1) {
            [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * 2 + 1, 0) animated:YES];
        }
        [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.duration];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x < 0) {
        _currentIndex = self.preIndex;
    } else if (self.scrollView.contentOffset.x > CGRectGetWidth(self.bounds) * 2) {
        _currentIndex = self.nxtIndex;
    } else {
        return;
    }
    [self reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x / CGRectGetWidth(self.bounds);
    if (index == 0) {
        _currentIndex = self.preIndex;
    } else if (index == 2) {
        _currentIndex = self.nxtIndex;
    } else {
        return;
    }
    
    [self reloadData];
}

- (void)scrollViewDidBeginTracking:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
}

- (void)scrollViewDidEndTracking:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
    [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.duration];
}

#pragma mark - getter, setter

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
    [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.duration];
}

- (void)setIndex:(NSInteger)index {
    _currentIndex = index;
    [self reloadData];
}

- (NSInteger)index {
    return _currentIndex;
}

- (NSInteger)preIndex {
    return _currentIndex == 0 ? (self.images.count - 1) : (_currentIndex - 1);
}

- (NSInteger)curIndex {
    return _currentIndex;
}

- (NSInteger)nxtIndex {
    return _currentIndex == (self.images.count - 1) ? 0 : (_currentIndex + 1);
}

- (void)setImages:(NSArray *)images {
    _images = images;
    _currentIndex = 0;
    _scrollView.scrollEnabled = images.count > 1;
    _pageControl.numberOfPages = images.count;
    
    [self reloadData];
}

#pragma mark - initialize

- (void)_initialize {
    [self setBackgroundColor:[UIColor clearColor]];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    
    // view
    _scrollView = [[DPBannerScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.bounces = NO;
    
    _preView = [[UIImageView alloc] init];
    _curView = [[UIImageView alloc] init];
    _nxtView = [[UIImageView alloc] init];
    
    // loop
    _duration = 5.0f;
}

@end
