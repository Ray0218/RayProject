//
//  DPNavigationMenu.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPNavigationMenu.h"

@interface DPNavigationMenuView : UIView {
@private
    NSMutableArray *_controls;
    NSMutableArray *_lines;
    
    UIView *_line1;
    UIView *_line2;
}

@property (nonatomic, weak) id<DPNavigationMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation DPNavigationMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _controls = [NSMutableArray array];
        _lines = [NSMutableArray array];
        
        _line1 = [UIView dp_viewWithColor:UIColorFromRGB(0x9c0201)];//[UIColor colorWithRed:0.73 green:0.05 blue:0.07 alpha:1]];
        _line2 = [UIView dp_viewWithColor:UIColorFromRGB(0x9c0201)];//[UIColor colorWithRed:0.73 green:0.05 blue:0.07 alpha:1]];
        
        [self addSubview:_line1];
        [self addSubview:_line2];
        
        self.backgroundColor = [UIColor dp_flatDarkRedColor];
    }
    return self;
}


- (void)setItems:(NSArray *)items {
    _items = items;
    
    int count = items.count;
    
    if (_controls.count > count) {
        [_controls removeObjectsInRange:NSMakeRange(count, _controls.count - count)];
    } else {
        for (int i = _controls.count; i < count; i++) {
            UIButton *button = [[UIButton alloc] init];
            
            [button setTitle:items[i] forState:UIControlStateNormal];
            [button setTitle:items[i] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithRed:1 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
            [button setImage:nil forState:UIControlStateNormal];
            [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kNavigationImageBundlePath, @"selected.png")] forState:UIControlStateSelected];
            [button setTag:i];
            [button addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [_controls addObject:button];
        }
    }
    
    count = (items.count - 1) / 3 + 1;
    if (_lines.count > count) {
        [_lines removeObjectsInRange:NSMakeRange(count, _lines.count - count)];
    } else {
        for (int i = _lines.count; i < count; i++) {
            UIView *view = [UIView dp_viewWithColor:UIColorFromRGB(0x9c0201)];//[UIColor colorWithRed:0.73 green:0.05 blue:0.07 alpha:1]];
            
            [self addSubview:view];
            [_lines addObject:view];
        }
    }
    
    self.selectedIndex = self.selectedIndex;
}

- (void)pvt_onClick:(UIButton *)button {
    DPNavigationMenu *menu = (DPNavigationMenu *)self.superview;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationMenu:selectedAtIndex:)]) {
        [self.delegate navigationMenu:menu selectedAtIndex:button.tag];
    }
    
    [self setSelectedIndex:button.tag];
    [menu hide];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.items.count == 2) {
        CGFloat width =  floorf(self.frame.size.width / 2.0);
        CGFloat height = floorf(self.frame.size.height);
        
        // 画横线
        [(UIView *)_lines[0] setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        // 画竖线
        [_line1 setFrame:CGRectMake(width, 0, 0.5, height)];
        [_line2 setFrame:CGRectMake(width, 0, 0.5, height)];
        
        [(UIButton *)_controls[0] setFrame:CGRectMake(0, 0, width, height)];
        [(UIButton *)_controls[1] setFrame:CGRectMake(width, 0, width, height)];
        
        return;
    }
    
    CGFloat width =  floorf(self.frame.size.width / 3.0);
    CGFloat height = floorf(self.frame.size.height / ((self.items.count - 1) / 3 + 1));
    
    for (int i = 0, x = 0, y = 0; i < _controls.count; i++) {
        // 画横线
        if (x == 0) {
            [(UIView *)_lines[y] setFrame:CGRectMake(0, y * height, self.frame.size.width, 0.5)];
        }
        // 画竖线
        if (y == 0) {
            if (x == 0) {
                [_line1 setFrame:CGRectMake(width, 0, 0.5, (_controls.count - 1) / 3 * height + height)];
            }
            if (x == 1) {
                [_line2 setFrame:CGRectMake(width * 2, 0, 0.5, (_controls.count - 1) / 3 * height + height)];
            }
        }
        UIButton *button = _controls[i];
        [button setFrame:CGRectMake(x * width, y * height, width, height)];
        
        if (++x > 2) {
            x = 0;
            y++;
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [_controls enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.selected = idx == selectedIndex;
        obj.titleLabel.font = obj.selected ? [UIFont dp_systemFontOfSize:14] : [UIFont dp_systemFontOfSize:12];
    }];
}

@end

@interface DPNavigationMenu () {
@private
    UIView *_coverView;
    DPNavigationMenuView *_menu;
}

@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong, readonly) DPNavigationMenuView *menu;

@end

@implementation DPNavigationMenu
@dynamic selectedIndex;
@dynamic menu;

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap:)]];
    }
    return self;
}

- (void)show {
    DPAssert(self.viewController != nil);
    
    self.alpha = 0;
    self.hidden = NO;
    
    UIViewController *viewController = self.viewController;
    
    if (self.superview == nil) {
        self.frame = viewController.view.window.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [viewController.view.window addSubview:self];
        
        self.coverView.frame = [viewController.view convertRect:viewController.view.bounds toView:viewController.view.window];
        self.coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.coverView];
        
        self.menu.frame = CGRectMake(CGRectGetMinX(self.coverView.frame), CGRectGetMinY(self.coverView.frame), CGRectGetWidth(self.coverView.frame), ((self.items.count - 1) / 3 + 1) * 40);
        self.menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.menu];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    self.alpha = 1;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
    if (self.viewController && [self.viewController respondsToSelector:@selector(dismissNavigationMenu:)]) {
        [self.viewController dismissNavigationMenu:self];
    }
}

- (void)setViewController:(UIViewController<DPNavigationMenuDelegate> *)viewController {
    _viewController = viewController;
    
    self.menu.delegate = viewController;
}

#pragma mark - setter, getter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.menu.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex {
    return self.menu.selectedIndex;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    self.menu.items = items;
    
    if (self.menu.superview) {
        self.menu.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewController.view.frame), ((self.items.count - 1) / 3 + 1) * 40);
        self.menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [UIView dp_viewWithColor:[UIColor dp_coverColor]];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

- (DPNavigationMenuView *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenuView alloc] init];
    }
    return _menu;
}

- (void)pvt_onHandleTap:(UITapGestureRecognizer *)tapRecognizer {
    [self hide];
}

@end
