//
//  DPSfcTabBarView.m
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSfcTabBarView.h"

@interface DPSfcTabBarView ()

@property (nonatomic, strong) NSArray *tabBarItems;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIImageView *arrowView;

@end
@implementation DPSfcTabBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTag:0];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        [leftButton setBackgroundImage:dp_SportLotteryImage(@"sfc001.png") forState:UIControlStateNormal];
        [leftButton setBackgroundImage:dp_SportLotteryImage(@"spfdiseable001.png") forState:UIControlStateDisabled];
        [leftButton setAdjustsImageWhenHighlighted:NO];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(20, 40, 0, 0)];

        [leftButton addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        self.leftZcBtn = leftButton;
        [self addSubview:leftButton];

        NSMutableAttributedString *curStr = [[NSMutableAttributedString alloc] initWithString:@"当前期"];
        [curStr addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.2 green : 0.2 blue : 0.2 alpha : 1] range:NSMakeRange(0, curStr.length)];
        NSMutableAttributedString *curStr2 = [[NSMutableAttributedString alloc] initWithString:@"当前期"];
        [curStr2 addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.89 green : 0.24 blue : 0.1 alpha : 1] range:NSMakeRange(0, curStr2.length)];
        [_leftZcBtn setAttributedTitle:curStr forState:UIControlStateNormal];
        [_leftZcBtn setAttributedTitle:curStr2 forState:UIControlStateSelected];

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTag:1];
        [rightButton setBackgroundColor:[UIColor clearColor]];

        [rightButton setBackgroundImage:dp_SportLotteryImage(@"sfc001.png") forState:UIControlStateNormal];
        [rightButton setBackgroundImage:dp_SportLotteryImage(@"spfdiseable001.png") forState:UIControlStateDisabled];
        [rightButton setAdjustsImageWhenHighlighted:NO];
        NSMutableAttributedString *preStr = [[NSMutableAttributedString alloc] initWithString:@"预售期"];
        [preStr addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.2 green : 0.2 blue : 0.2 alpha : 1] range:NSMakeRange(0, preStr.length)];
        NSMutableAttributedString *preStr2 = [[NSMutableAttributedString alloc] initWithString:@"预售期"];
        [preStr2 addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.89 green : 0.24 blue : 0.1 alpha : 1] range:NSMakeRange(0, preStr2.length)];
        [_rightZcBtn setAttributedTitle:preStr forState:UIControlStateNormal];
        [_rightZcBtn setAttributedTitle:preStr2 forState:UIControlStateSelected];

        [rightButton addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        self.rightZcBtn = rightButton;
        [self addSubview:rightButton];

        UIView *middleLine = [[UIView alloc] init];
        middleLine.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:middleLine];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(middleLine.mas_left).offset(0.25);
        }];

        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.left.equalTo(middleLine.mas_right).offset(-0.25);
        }];

        [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-0.75);
        }];

        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"sfcarrpw.png")];
        self.arrowView = imageView1;
        imageView1.backgroundColor = [UIColor clearColor];

        [self addSubview:imageView1];
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@15);
            make.height.equalTo(@6.5);
            make.centerX.equalTo(leftButton);
            make.bottom.equalTo(leftButton);
        }];

        leftButton.selected = YES;
        self.tabBarItems = @[ leftButton, rightButton ];
    }
    return self;
}
- (void)pvt_onClick:(UIButton *)button {
    //    button.selected=!button.selected;
    [self setSelectedIndex:button.tag withoutEvent:NO button:button];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex button:button {
    [self setSelectedIndex:selectedIndex withoutEvent:YES button:button];
}

- (void)changeCurrentData:(NSString *)strCur {
    if (strCur.length < 1) {
        NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:@"当前期"];
        [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xbbbbbb) range:NSMakeRange(0, ss.length)];
        [_leftZcBtn setAttributedTitle:ss forState:UIControlStateNormal];
        return;
    }
    NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:@"当前期"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@期)", strCur]];
    [ss appendAttributedString:str];
    [ss addAttribute:(NSString *)NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize : 11] range:NSMakeRange(3, str.length)];
    [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.2 green : 0.2 blue : 0.2 alpha : 1] range:NSMakeRange(0, ss.length)];

    [_leftZcBtn setAttributedTitle:ss forState:UIControlStateNormal];

    NSMutableAttributedString *sSelected = [[NSMutableAttributedString alloc] initWithString:@"当前期"];
    NSAttributedString *strSel = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@期)", strCur]];
    [sSelected appendAttributedString:strSel];
    [sSelected addAttribute:(NSString *)NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize : 11] range:NSMakeRange(3, strSel.length)];
    [sSelected addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.89 green : 0.24 blue : 0.1 alpha : 1] range:NSMakeRange(0, sSelected.length)];

    [_leftZcBtn setAttributedTitle:sSelected forState:UIControlStateSelected];
}

- (void)changePreData:(NSString *)strCur {
    if (strCur.length < 1) {
        NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:@"预售期"];
        [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xbbbbbb) range:NSMakeRange(0, ss.length)];
        [_rightZcBtn setAttributedTitle:ss forState:UIControlStateNormal];
        return;
    }

    NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:@"预售期"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@期)", strCur]];
    [ss appendAttributedString:str];
    [ss addAttribute:(NSString *)NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize : 11] range:NSMakeRange(3, str.length)];
    [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.2 green : 0.2 blue : 0.2 alpha : 1] range:NSMakeRange(0, ss.length)];

    [_rightZcBtn setAttributedTitle:ss forState:UIControlStateNormal];

    NSMutableAttributedString *sSelected = [[NSMutableAttributedString alloc] initWithString:@"预售期"];
    NSAttributedString *strSelect = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@期)", strCur]];
    [sSelected appendAttributedString:strSelect];
    [sSelected addAttribute:(NSString *)NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize : 11] range:NSMakeRange(3, strSelect.length)];
    [sSelected addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor colorWithRed : 0.89 green : 0.24 blue : 0.1 alpha : 1] range:NSMakeRange(0, sSelected.length)];

    [_rightZcBtn setAttributedTitle:sSelected forState:UIControlStateSelected];
}

- (void)updateConstraints {
    [self.indicateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CGRectGetMinX([self.tabBarItems[self.selectedIndex] frame])));
    }];

    [super updateConstraints];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withoutEvent:(BOOL)withoutEvent button:(UIButton *)button {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;

        [self.tabBarItems enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            button.selected = _selectedIndex == button.tag;

        }];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];

        [UIView animateWithDuration:0.2 animations:^{
            self.arrowView.center=CGPointMake(self.frame.size.width*(button.tag+0.5)/2,button.frame.size.height-3.25);
            [self layoutIfNeeded];

        }];

        if (!withoutEvent && self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:selectedAtIndex:)]) {
            [self.delegate tabBarView:self selectedAtIndex:_selectedIndex];
        }
    }
}

- (void)selectedItemChangeTo:(NSInteger)selectedIndex {

    UIButton *btn;
    if (selectedIndex == 0) {
        btn = self.leftZcBtn;
    } else {
        btn = self.rightZcBtn;
    }
    [self setSelectedIndex:selectedIndex withoutEvent:YES button:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
