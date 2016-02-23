//
//  DPLotteryInfoDockView.m
//  资讯详情页面
//
//  Created by jacknathan on 14-9-11.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import "DPLotteryInfoDockView.h"
#define kArrowAnimTime 0.3f
#define kDockHeight 30

@interface DPLotteryInfoDockView()
{
    UIButton        *_selectedItem;     // Dock被选中按钮
    UIImageView     *_arrow;            // 按钮选中的箭头
    NSArray         *_dockItemArray;    // 所有选项按钮
}
@end
@implementation DPLotteryInfoDockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *recommendBtn = [self dockItemWithTitle:@"推荐" tag:0 target:self action:@selector(dockItemClick:) seperatorLine:YES];
        
        UIButton *hotBtn = [self dockItemWithTitle:@"公告" tag:1 target:self action:@selector(dockItemClick:) seperatorLine:YES];
        UIButton *classfiyBtn = [self dockItemWithTitle:@"分类" tag:2 target:self action:@selector(dockItemClick:) seperatorLine:NO];
        UIView *bottomLine = [[UIView alloc]init];
        UIImageView *arrow = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"sfcarrpwFull.png")];
        arrow.backgroundColor = [UIColor blackColor];
        [self addSubview:recommendBtn];
        [self addSubview:hotBtn];
        [self addSubview:classfiyBtn];
        [self addSubview:bottomLine];
        [self addSubview:arrow];
        
        _arrow = arrow;
        _dockItemArray = @[recommendBtn, hotBtn, classfiyBtn];
        
        UIView *superView = self;
        // 底部分割线
        bottomLine.backgroundColor = [UIColor redColor];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.bottom.equalTo(superView);
            make.height.equalTo(@1);
        }];
        
        // 推荐按钮
        [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(hotBtn.mas_left);
            make.top.equalTo(superView);
            make.bottom.equalTo(bottomLine.mas_top);
            make.width.equalTo(hotBtn);
            make.width.equalTo(classfiyBtn);
        }];
        
        // 热门按钮
        [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView);
            make.left.equalTo(recommendBtn.mas_right);
            make.bottom.equalTo(bottomLine.mas_top);
            make.right.equalTo(classfiyBtn.mas_left);
        }];
        
        // 分类按钮
        [classfiyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hotBtn.mas_right);
            make.right.equalTo(superView);
            make.top.equalTo(superView);
            make.bottom.equalTo(bottomLine.mas_top);
        }];
        
        // 选中的指示箭头
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.bottom.equalTo(bottomLine);
        }];

    }
    return self;
}

#pragma mark - 初始化dockButton按钮方法
- (UIButton *)dockItemWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action seperatorLine:(BOOL)seperatorLine
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    if (seperatorLine) {
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor = UIColorFromRGB(0xdad5cc);
        [btn addSubview:seperatorLine];
        
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn);
            make.left.equalTo(btn.mas_right);
            make.bottom.equalTo(btn.mas_bottom);
            make.width.equalTo(@0.5);
        }];
    }
    return btn;
}

#pragma mark - 选项卡按钮点击事件
- (void)dockItemClick:(UIButton *)sender
{
    [self selectedItemChangeTo:sender.tag isDelegateSend:NO];
}

#pragma mark 选项卡按钮选择状态变换
- (void)selectedItemChangeTo:(int)tag isDelegateSend:(BOOL)isDelegate
{
    UIButton *sender = _dockItemArray[tag];
    float arrowAnimTime = kArrowAnimTime; //动画时间
    if (_selectedItem == sender) {
        return;
    }
    
    if (_selectedItem == nil) { //初始化点击
        _selectedItem = sender;
        arrowAnimTime = 0;
    }else{
        _selectedItem.selected = NO;
        _selectedItem = sender;
    }
    _selectedItem.selected = YES;
    
    if (!isDelegate) {
        if ([self.delegate respondsToSelector:@selector(dockItemChangedtoTag:)]) {
            [self.delegate dockItemChangedtoTag:tag];
        }
    }
    
    [_arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_selectedItem);
        make.bottom.equalTo(self);
    }];
    
    [UIView animateWithDuration:arrowAnimTime animations:^{
        [self layoutIfNeeded];
    }];
}



@end
