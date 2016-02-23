//
//  DPLoadingView.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLoadingView.h"

#define kLoadingViewDuration    0.4

@interface DPLoadingView () {
    
}

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *loadLabel;
@property (nonatomic, strong, readonly) UILabel *indicateLabel;
@property (nonatomic, assign) NSInteger timerCount;

@end

@implementation DPLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
        [self addSubview:self.textLabel];
        [self addSubview:self.loadLabel];
        [self addSubview:self.indicateLabel];
        [self setTag:kLoadingViewTag];
    }
    return self;
}

- (void)_initialize {
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor colorWithRed:0.53 green:0.45 blue:0.39 alpha:1];
    _textLabel.text = @"加载中";
    _textLabel.font = [UIFont dp_systemFontOfSize:23];
    
    _loadLabel = [[UILabel alloc] init];
    _loadLabel.backgroundColor = [UIColor clearColor];
    _loadLabel.textColor = [UIColor colorWithRed:0.53 green:0.45 blue:0.39 alpha:1];
    _loadLabel.text = @"LOADING";
    _loadLabel.font = [UIFont dp_systemFontOfSize:10];
    
    _indicateLabel = [[UILabel alloc] init];
    _indicateLabel.backgroundColor = [UIColor clearColor];
    _indicateLabel.textColor = [UIColor colorWithRed:0.53 green:0.45 blue:0.39 alpha:1];
    _indicateLabel.font = [UIFont dp_systemFontOfSize:10];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTimer) object:nil];
    
    if (newSuperview) {
        [self performSelector:@selector(updateTimer) withObject:nil afterDelay:kLoadingViewDuration];
    }
}

- (void)layoutSubviews {
    self.textLabel.frame = CGRectMake((self.dp_width - self.textLabel.dp_intrinsicWidth) / 2, (self.dp_height - self.textLabel.dp_intrinsicHeight - self.loadLabel.dp_intrinsicHeight) / 2, self.textLabel.dp_intrinsicWidth, self.textLabel.dp_intrinsicHeight);
    self.loadLabel.frame = CGRectMake((self.dp_width - self.loadLabel.dp_intrinsicWidth) / 2 - 3, (self.dp_height + self.textLabel.dp_intrinsicHeight - self.loadLabel.dp_intrinsicHeight) / 2, self.loadLabel.dp_intrinsicWidth, self.loadLabel.dp_intrinsicHeight);
    self.indicateLabel.frame = CGRectMake((self.dp_width + self.loadLabel.dp_intrinsicWidth) / 2 - 3, (self.dp_height + self.textLabel.dp_intrinsicHeight - self.loadLabel.dp_intrinsicHeight) / 2, 20, self.loadLabel.dp_intrinsicHeight);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(MAX(self.textLabel.dp_intrinsicWidth, self.loadLabel.dp_intrinsicWidth + 5), self.textLabel.dp_intrinsicHeight + self.loadLabel.dp_intrinsicHeight);
}

- (void)updateTimer {
    static NSString *IndicateText[] = { @"", @".", @"..", @"..."};
    self.timerCount = (self.timerCount + 1) % 4;
    
    _indicateLabel.text = IndicateText[self.timerCount];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTimer) object:nil];
    [self performSelector:@selector(updateTimer) withObject:nil afterDelay:kLoadingViewDuration];
}

@end
