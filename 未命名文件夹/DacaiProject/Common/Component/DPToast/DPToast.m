//
//  DPToast.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPToast.h"
#import "DPKeyboardCenter.h"

#define kToastMargin    7
#define kToastSpacing   3

#define kToastBottomMetric  60

UIColor *DPToastColorRed;
UIColor *DPToastColorGreen;
UIColor *DPToastColorBlue;
UIColor *DPToastColorGray;
UIColor *DPToastColorYellow;

@interface DPToast () <DPKeyboardCenterDelegate> {
@private
}

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong) NSDate *triggerDate;

+ (instancetype)sharedToast;

@end

@implementation DPToast

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DPToastColorRed = [UIColor colorWithRed:1 green:0.18 blue:0.18 alpha:0.8];
        DPToastColorGreen = [UIColor colorWithRed:0.29 green:0.65 blue:0.46 alpha:0.8];
        DPToastColorBlue = [UIColor colorWithRed:0.21 green:0.67 blue:0.84 alpha:0.8];
//        DPToastColorGray = [UIColor colorWithRed:0.37 green:0.36 blue:0.36 alpha:0.8];
        DPToastColorGray = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        DPToastColorYellow = [UIColor colorWithRed:0.84 green:0.63 blue:0.11 alpha:0.8];
    });
}

+ (instancetype)sharedToast {
    static dispatch_once_t onceToken;
    static DPToast *sharedToast;
    dispatch_once(&onceToken, ^{
        sharedToast = [[DPToast alloc] init];
    });
    return sharedToast;
}

+ (instancetype)makeText:(NSString *)text {
    DPToast *sharedToast = [self sharedToast];
    [sharedToast makeText:text color:DPToastColorGray style:DPToastStyleDefault];
    return sharedToast;
}

+ (instancetype)makeText:(NSString *)text color:(UIColor *)color {
    DPToast *sharedToast = [self sharedToast];
    [sharedToast makeText:text color:color style:DPToastStyleDefault];
    return sharedToast;
}

+ (instancetype)makeText:(NSString *)text color:(UIColor *)color style:(DPToastStyle)stype {
    DPToast *sharedToast = [self sharedToast];
    [sharedToast makeText:text color:color style:stype];
    return sharedToast;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
        [self addSubview:self.backgroundView];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        
        [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
    }
    return self;
}

- (void)_initialize {
    _backgroundView = [[UIView alloc] init];
    _imageView = [[UIImageView alloc] init];
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.numberOfLines = 0;
    _textLabel.preferredMaxLayoutWidth = UIScreen.mainScreen.bounds.size.width - 50;
    
    self.backgroundView.layer.cornerRadius = 3;
    self.layer.cornerRadius = 3;
}

- (void)layoutSubviews {
    CGSize imageSize = self.imageView.image ? self.imageView.intrinsicContentSize : CGSizeZero;
    CGSize labelSize = self.textLabel.intrinsicContentSize;
    
    self.imageView.frame = CGRectMake(kToastMargin, (self.dp_height - imageSize.height) / 2, imageSize.width, imageSize.height);
    self.textLabel.frame = CGRectMake(self.imageView.dp_maxX + kToastSpacing, (self.dp_height - labelSize.height) / 2, labelSize.width, labelSize.height);
    self.backgroundView.frame = CGRectMake(1.5, 1.5, self.dp_width - 3, self.dp_height - 3);
}

- (CGSize)intrinsicContentSize {
    CGSize imageSize = self.imageView.image ? self.imageView.intrinsicContentSize : CGSizeZero;
    CGSize labelSize = self.textLabel.intrinsicContentSize;
    
    return CGSizeMake(imageSize.width + labelSize.width + kToastSpacing + kToastMargin * 2, MAX(imageSize.height, labelSize.height) + 10);
}

- (void)dismiss {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    if (self.textLabel.text.length == 0) {
        return;
    }
    if ([[DPKeyboardCenter defaultCenter] isKeyboardAppear]) {
        [self setFrame:CGRectMake((kScreenWidth - self.dp_intrinsicWidth) / 2, kScreenHeight - self.dp_intrinsicHeight - kToastBottomMetric - CGRectGetHeight(DPKeyboardCenter.defaultCenter.keyboardFrame), self.dp_intrinsicWidth, self.dp_intrinsicHeight)];
    } else {
        [self setFrame:CGRectMake((kScreenWidth - self.dp_intrinsicWidth) / 2, kScreenHeight - self.dp_intrinsicHeight - kToastBottomMetric, self.dp_intrinsicWidth, self.dp_intrinsicHeight)];
    }
    [self setNeedsLayout];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:1];
    }];
    
    self.triggerDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimeInterval timeInterval = [self.triggerDate timeIntervalSinceNow];
        if (timeInterval < -2.5 && self.superview) {
            [self dismiss];
        }
    });
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
}

- (void)tap {
    [self dismiss];
}

- (void)makeText:(NSString *)text color:(UIColor *)color style:(DPToastStyle)stype {
    switch (stype) {
        case DPToastStyleError:
            self.imageView.image = dp_CommonImage(@"error.png");
            break;
        case DPToastStyleCorrect:
            self.imageView.image = dp_CommonImage(@"correct.png");
            break;
        case DPToastStyleWarning:
            self.imageView.image = dp_CommonImage(@"warning.png");
            break;
        default:
            self.imageView.image = nil;
            break;
    }
    
    self.textLabel.text = text;
    self.backgroundColor = [UIColor colorWithRed:color.dp_red green:color.dp_green blue:color.dp_blue alpha:0.4];
    self.backgroundView.backgroundColor = color;
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - DPKeyboardCenterDelegate

- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd {
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        self.dp_y = CGRectGetMinY(frameEnd)- self.dp_intrinsicHeight - kToastBottomMetric;
    } completion:nil];
}

@end
