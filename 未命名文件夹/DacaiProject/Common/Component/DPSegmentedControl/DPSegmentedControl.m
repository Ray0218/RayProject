//
//  DPSegmentedControl.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSegmentedControl.h"


@implementation DPSegmentedContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_indicator = [[UIView alloc] init]];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [self initWithFrame:CGRectZero]) {
        [self setItems:items];
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperlayer];
    }];
    
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:items.count];
    NSMutableArray *layers = [NSMutableArray arrayWithCapacity:items.count - 1];
    
    for (int i = 0; i < items.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = items[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.highlightedTextColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.userInteractionEnabled = NO;
        [self addSubview:label];
        [labels addObject:label];
        
        if (i > 0) {
            CALayer *layer = [CALayer layer];
            [self.layer addSublayer:layer];
            [layers addObject:layer];
        }
    }
    
    _labels = labels;
    _layers = layers;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    if (self.labels.count > 0) {
        CGFloat boundsWidth = CGRectGetWidth(self.bounds);
        CGFloat boundsHeight = CGRectGetHeight(self.bounds);
        CGFloat width = floorf((boundsWidth - self.labels.count + 1) / self.labels.count);
        int count = (boundsWidth - self.labels.count + 1) - self.labels.count * width;
        
        CGFloat x = 0;
        
        for (int i = 0; i < self.labels.count; i++) {
            UILabel *label = self.labels[i];
            label.frame = CGRectMake(x, 0, width + (i < count ? 1 : 0), boundsHeight);
            label.highlighted = i == self.selectedIndex;
            
            
            if (i < self.layers.count) {
                CALayer *layer = self.layers[i];
                layer.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 1, boundsHeight);
            }
            
            x += width + (i < count ? 1 : 0) + 1;
        }

        self.indicator.frame = [self.labels[self.selectedIndex] frame];
    } else {
        self.indicator.frame = CGRectZero;
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        CALayer *layer = i < self.layers.count ? self.layers[i] : nil;
        
        if (CGRectContainsPoint(label.frame, point)) {
            self.selectedIndex = i;
            break;
        }
        if (CGRectContainsPoint(layer.frame, point)) {
            self.selectedIndex = i;
            break;
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    
        UIControl *control = (id)self.superview;
    
        [control sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

@interface DPSegmentedControl () {
@private
    UIColor *tintColor_;
}
@property (nonatomic, strong) NSArray *items;

@end

@implementation DPSegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super initWithFrame:CGRectZero]) {
        [self _initialize];
        [self.containerView setItems:items];
        [self addSubview:self.containerView];
        [self setTintColor:[UIColor blueColor]];
    }
    return self;
}

- (void)_initialize {
    _containerView = [[DPSegmentedContainer alloc] init];
    _containerView.layer.borderWidth = 1;
    _containerView.layer.cornerRadius = 3;
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor blueColor];
}

- (void)layoutSubviews {
    self.containerView.frame = self.bounds;
    
}

- (void)setTintColor:(UIColor *)tintColor {
    if (IOS_VERSION_7_OR_ABOVE) {
        [super setTintColor:tintColor];
    } else {
        tintColor_ = tintColor;
    }
    
    [self.containerView.layer setBorderColor:self.tintColor.CGColor];
    [self.containerView.indicator setBackgroundColor:self.tintColor];
    [self.containerView.layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        obj.backgroundColor = self.tintColor.CGColor;
    }];
    [self.containerView.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        obj.textColor = self.tintColor;
    }];
}

- (UIColor *)tintColor {
    if (IOS_VERSION_7_OR_ABOVE) {
        return [super tintColor];
    } else {
        return tintColor_;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.containerView.selectedIndex = selectedIndex;
    
}

- (NSInteger)selectedIndex {
    return self.containerView.selectedIndex;
}

@end
