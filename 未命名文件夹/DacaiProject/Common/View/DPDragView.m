//
//  DPDragView.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDragView.h"

@interface DPDragView () <UIScrollViewDelegate> {
@private
    UIScrollView *_scrollView;
    UIImageView *_leftView;
    UIImageView *_rightView;
}

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIImageView *leftView;
@property (nonatomic, strong, readonly) UIImageView *rightView;

@property (atomic, assign) BOOL lockFrame;

@end

@implementation DPDragView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(18, 0, self.bounds.size.width - 36, self.bounds.size.height);
    self.leftView.frame = CGRectMake(8, self.bounds.size.height / 2 - 5, 6, 10);
    self.rightView.frame = CGRectMake(self.bounds.size.width - 14, self.bounds.size.height / 2 - 5, 6, 10);
    
    [self setLockFrame:YES];
    [self.customView setFrame:CGRectMake(0, (self.dp_height - self.customView.dp_height) / 2, self.customView.dp_width, self.customView.dp_height)];
    [self setLockFrame:NO];
    
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL leftHidden = YES;
    BOOL rightHidden = YES;
    
    do {
        if (self.scrollView.contentSize.width < self.scrollView.bounds.size.width) {
            break;
        }
        
        if (self.scrollView.contentOffset.x > 0) {
            leftHidden = NO;
        }
        
        if (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width < self.scrollView.contentSize.width) {
            rightHidden = NO;
        }
        
    } while (NO);
    
    self.leftView.hidden = leftHidden;
    self.rightView.hidden = rightHidden;
}

- (void)setCustomView:(UIView *)customView {
    if (_customView) {
        DPAssert(_customView.superview);
        
        [_customView removeObserver:self forKeyPath:@"frame"];
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    [_customView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    
    [self.scrollView addSubview:customView];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc {
    [_customView removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.lockFrame) {
        [self.scrollView setContentSize:CGSizeMake(self.customView.bounds.size.width, self.scrollView.bounds.size.height)];
        [self scrollViewDidScroll:self.scrollView];
        [self setLockFrame:YES];
        [self.customView setFrame:CGRectMake(0, (self.dp_height - self.customView.dp_height) / 2, self.customView.dp_width, self.customView.dp_height)];
        [self setLockFrame:NO];
    }
}

#pragma mark - getter, setter

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIImageView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIImageView alloc] init];
        _leftView.image = dp_CommonImage(@"left_arrow.png");
    }
    return _leftView;
}

- (UIImageView *)rightView {
    if (_rightView == nil) {
        _rightView = [[UIImageView alloc] init];
        _rightView.image = dp_CommonImage(@"right_arrow.png");
    }
    return _rightView;
}

@end
