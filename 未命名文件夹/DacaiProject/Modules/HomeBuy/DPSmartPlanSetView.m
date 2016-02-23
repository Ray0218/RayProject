//
//  DPSmartPlanSetView.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSmartPlanSetView.h"
#import "DPKeyboardCenter.h"
#import "DPVerifyUtilities.h"
#define kHeadFootCommonH 40
#define kLeftCommonEdge 20
#define kCommonFontSize 14
#define kButtonTagBase 50
#define kTextFieldHeightPlus 5
#define kTextFieldTagBase 100
#define kCheckBtnTagBase 30
@interface DPSmartPlanSetView ()<UIGestureRecognizerDelegate, UITextFieldDelegate, DPKeyboardCenterDelegate>
{
    NSMutableArray          *_checkBtns;
    NSMutableArray          *_numFields;
    NSMutableArray          *_textFields;
    UIView                  *_contentView;
    UIView                  *_warningView;
    UITextField             *_selectedField;
    UITextField             *_issueLabel;       // 期数
    UITextField             *_timesLabel;       // 倍数
    BOOL                    _showWarning; // 是否显示警告
}
@end
@implementation DPSmartPlanSetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        
        DPKeyboardCenter *center = [DPKeyboardCenter defaultCenter];
        [center addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
        [self _initialize];
        [self buildUI];
    }
    return self;
}
- (void)_initialize
{
    _checkBtns = [NSMutableArray arrayWithCapacity:3];
//    _numberChangeBtns = [NSMutableArray arrayWithCapacity:4];
    _numFields = [NSMutableArray arrayWithCapacity:2];
    _textFields = [NSMutableArray arrayWithCapacity:5];
//    _keyBoardShow = NO;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
      [[DPKeyboardCenter defaultCenter]removeListener:self];
    }
}
- (void)buildUI
{

    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#faf9f2"];
    _contentView = contentView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(planSetCoverTap)];
    [_contentView addGestureRecognizer:tap];
    tap.delegate = self;
    
    UIView *headView = ({
        UIView *view= [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    UIView * middleView = ({
        UIView *view= [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });

    UIView * optionView = ({
        UIView *view= [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    UIView *warningView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_colorFromHexString:@"#faf9f2"];
        view.hidden = YES;
        view;
    });
    _warningView = warningView;
    [self addSubview:warningView];
    [self addSubview:contentView];
    [contentView addSubview:headView];
    [contentView addSubview:middleView];
    [contentView addSubview:optionView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(@290);
            make.height.equalTo(@300);
    }];
    
    [warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.height.equalTo(@25);
        make.left.equalTo(contentView);
        make.top.equalTo(contentView.mas_bottom);
    }];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@kHeadFootCommonH);
    }];
    
    [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@kHeadFootCommonH);
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(optionView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(headView.mas_bottom);
    }];
    
    [self buildWarningView:warningView];
    [self buildheadView:headView];
    [self buildmiddleView:middleView];
    [self buildoptionView:optionView];


}
- (void)buildWarningView:(UIView *)warningView
{
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#cdccc6"];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor dp_flatRedColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.text = @"您的盈利率设置过大, 无法达到预期, 请重新设置";
    [warningView addSubview:label];
    [warningView addSubview:topLine];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(warningView).offset(15);
        make.centerY.equalTo(warningView);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warningView);
        make.left.equalTo(warningView);
        make.right.equalTo(warningView);
        make.height.equalTo(@0.5);
    }];
}
- (void)buildheadView:(UIView *)headView
{
    UIView *tipView = [[UIView alloc]init];
    tipView.backgroundColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
    
    UILabel *headLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"修改追号方案";
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:17];
        label;
    });
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#cdccc6"];
    
    [headView addSubview:tipView];
    [headView addSubview:headLabel];
    [headView addSubview:bottomLine];
    UIView *contentView = headView;
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kLeftCommonEdge);
        make.centerY.equalTo(contentView);
        make.height.equalTo(@5);
        make.width.equalTo(@5);
    }];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.mas_right).offset(5);
        make.centerY.equalTo(tipView);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
   

}
- (void)buildmiddleView:(UIView *)middleView
{
    UIView *issueView = [[UIView alloc]init];
    issueView.backgroundColor = [UIColor clearColor];
    issueView.tag = kButtonTagBase + 0;
    
    UIView *timesView = [[UIView alloc]init];
    timesView.backgroundColor = [UIColor clearColor];
    timesView.tag = kButtonTagBase + 2;
    
    UIView *gainView = [[UIView alloc]init];
    gainView.backgroundColor = [UIColor clearColor];
    gainView.tag = kTextFieldTagBase + 0;
    
    UIView *gainScaleView = [[UIView alloc]init];
    gainScaleView.backgroundColor = [UIColor clearColor];
    gainScaleView.tag = kTextFieldTagBase + 1;
    
    UIView *foreGainView = [[UIView alloc]init];
    foreGainView.backgroundColor = [UIColor clearColor];
    foreGainView.tag = kTextFieldTagBase + 2;
    
    UIView *nextGainView = [[UIView alloc]init];
    nextGainView.backgroundColor = [UIColor clearColor];
    nextGainView.tag = kTextFieldTagBase + 4;
    
    NSArray *viewArray = @[issueView, timesView, gainView, gainScaleView, foreGainView, nextGainView];
    [middleView addSubview:issueView];
    [middleView addSubview:timesView];
    [middleView addSubview:gainView];
    [middleView addSubview:gainScaleView];
    [middleView addSubview:foreGainView];
    [middleView addSubview:nextGainView];
    
    for (int i = 0; i < viewArray.count; i++) {
        
        UIView *view = viewArray[i];
        UIView *upView = i ? viewArray[i - 1] : middleView;
        UIView *downView = i == viewArray.count - 1 ? nil : viewArray[i + 1];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.top.equalTo(upView);
                make.height.equalTo(downView);
            }else{
                make.top.equalTo(upView.mas_bottom);
                make.height.equalTo(upView);
            }
            make.left.equalTo(middleView);
            make.width.equalTo(middleView);
            
            if (i == viewArray.count - 1) {
                make.bottom.equalTo(middleView).offset(- 5);
            }else{
                 make.bottom.equalTo(downView.mas_top);
            }
        }];
    }
    
    [self buildSetViewWithTitle:@"连续追号" topic:@"期" target:issueView fieldText:@"10"];
    [self buildSetViewWithTitle:@"初始倍数" topic:@"倍" target:timesView fieldText:@"1"];
    
    [self buildGainViewWithTitle1:@"全程最低盈利" title2:@"元" title3:nil target:gainView];
    [self buildGainViewWithTitle1:@"全程最低盈利率" title2:@"%" title3:nil target:gainScaleView];
    [self buildGainViewWithTitle1:@"前" title2:@"期最低盈利率" title3:@"%" target:foreGainView];
    [self buildLastGainViewWithTitle1:@"之后最低盈利率" title2:@"%" target:nextGainView];
    
}
- (void)buildSetViewWithTitle:(NSString *)title topic:(NSString *)topic target:(UIView *)target fieldText:(NSString *)Text
{
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        label.textColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
        label.font = [UIFont dp_systemFontOfSize:16];
        label;
    });
    
    UILabel *topicLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = topic;
        label.textColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
        label.font = [UIFont dp_systemFontOfSize:kCommonFontSize];
        label;
    });
    
    UIImageView *changeView = [[UIImageView alloc]initWithImage:dp_DigitLotteryResizeImage(@"smartFollowBox.png")];
    changeView.userInteractionEnabled = YES;
    changeView.backgroundColor = [UIColor clearColor];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setImage:dp_DigitLotteryImage(@"minus.png") forState:UIControlStateNormal];
    [minus addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchDown];
    minus.tag = target.tag + 0;
//    [_numberChangeBtns addObject:minus];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [plus setImage:dp_DigitLotteryImage(@"plus.png") forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchDown];
    plus.tag = target.tag + 1;
//    [_numberChangeBtns addObject:plus];

    
//    UITextField *numberLabel = [[UILabel alloc]init];
//    numberLabel.backgroundColor = [UIColor clearColor];
//    numberLabel.text = Text;
//    numberLabel.textColor = [UIColor dp_colorFromHexString:@"333333"];
//    numberLabel.font = [UIColor dp_colorFromHexString:@"333333"]
//    
    UITextField *numberField = ({
        UITextField *field = [[UITextField alloc]init];
        field.backgroundColor = [UIColor clearColor];
        field.textColor = [UIColor dp_colorFromHexString:@"333333"];
        field.font = [UIFont dp_systemFontOfSize:15];
        field.textAlignment = NSTextAlignmentCenter;
        field.text = Text;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.delegate = self;
        field;
    });
    
    if (_numFields.count == 0) {
        _issueLabel = numberField;
    }else{
        _timesLabel = numberField;
    }
    [_numFields addObject:numberField];
    
    UIView *contentView = target;
    [contentView addSubview:titleLabel];
    [contentView addSubview:topicLabel];
    [contentView addSubview:changeView];
    [changeView addSubview:minus];
    [changeView addSubview:plus];
    [changeView addSubview:numberField];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kLeftCommonEdge);
        make.centerY.equalTo(contentView);
    }];
    
    [changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(5);
        make.centerY.equalTo(contentView);
        make.height.equalTo(titleLabel);
        make.width.equalTo(@100);
    }];
    
    [minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeView).offset(4);
        make.centerY.equalTo(changeView);
    }];
    
    [plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeView).offset(- 4);
        make.centerY.equalTo(changeView);
    }];
    
    [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(changeView);
        make.centerX.equalTo(changeView);
        make.height.equalTo(changeView).offset(-2);
        make.width.equalTo(@50);
    }];
    
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeView.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
}
- (void)buildoptionView:(UIView *)optionView
{
    UIButton *confirmBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确认" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor dp_colorFromHexString:@"#7e6b5a"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor dp_colorFromHexString:@"#e7161a"]];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    UIButton *cancelBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#7e6b5a"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#ffffff"] forState:UIControlStateHighlighted];
//        [button setBackgroundColor:[UIColor dp_colorFromHexString:@"#7e6b5a"]];
        [button addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#cdccc6"];
    
    [optionView addSubview:confirmBtn];
    [optionView addSubview:cancelBtn];
    [optionView addSubview:topLine];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(optionView);
        make.top.equalTo(optionView);
//        make.bottom.equalTo(optionView);
        make.right.equalTo(cancelBtn.mas_left);
        make.width.equalTo(cancelBtn);
        make.height.equalTo(optionView);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right);
        make.top.equalTo(optionView);
        //        make.bottom.equalTo(optionView);
        make.right.equalTo(optionView);
        make.height.equalTo(optionView);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optionView);
        make.left.equalTo(optionView);
        make.right.equalTo(optionView);
        make.height.equalTo(@0.5);
    }];
}

- (void)buildGainViewWithTitle1:(NSString *)title1 title2:(NSString *)title2 title3:(NSString *)title3 target:(UIView *)target
{
    UIButton *check = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:dp_DigitLotteryImage(@"circleSelected.png") forState:UIControlStateSelected];
        [button setImage:dp_DigitLotteryImage(@"circleUnSelected.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchDown];
        button.tag = kCheckBtnTagBase + _checkBtns.count;
        button;
    });
    
    if (_checkBtns.count == 1) {
        check.selected = YES;
    }
    [_checkBtns addObject:check];

    UILabel *label1 = [self createCommonLabel];
    UILabel *label2 = [self createCommonLabel];
    UILabel *label3 = [self createCommonLabel];
    
    label1.text = title1;
    label2.text = title2;
    label3.text = title3;
   
    UITextField *textfield1 = [self createCommonTextField];
    UITextField *textfield2 = [self createCommonTextField];
    [_textFields addObject:textfield1];
    [_textFields addObject:textfield2];
    
    if (title3 == nil || title3.length <= 0) {
        textfield1.text = @"30";
    }else{
        textfield1.text = @"5";
        textfield2.text = @"50";
    }
    textfield1.tag = target.tag + 0;
    textfield2.tag = target.tag + 1;
    
    UIView *contentView = target;
    [contentView addSubview:check];
    [contentView addSubview:label1];
    [contentView addSubview:label2];
    [contentView addSubview:label3];
    [contentView addSubview:textfield1];
    [contentView addSubview:textfield2];

    NSNumber * fieldWidth = [NSNumber numberWithFloat:50.0f];
    if (title3 == nil || title3.length == 0) {
        fieldWidth = [NSNumber numberWithFloat:70.0f];
    }
    
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(kLeftCommonEdge);
        make.centerY.equalTo(contentView);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(check.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
    
    [textfield1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.centerY.equalTo(contentView);
        make.width.equalTo(fieldWidth);
        make.height.equalTo(label1).offset(kTextFieldHeightPlus);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textfield1.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
    
    [textfield2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(5);
        make.centerY.equalTo(contentView);
        make.width.equalTo(fieldWidth);
        make.height.equalTo(label1).offset(kTextFieldHeightPlus);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textfield2.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
    
    if (title3 == nil || title3.length == 0) {
        [textfield2 removeFromSuperview];
        [_textFields removeObject:textfield2];
        [label3 removeFromSuperview];
    }
    
}
- (void)buildLastGainViewWithTitle1:(NSString *)title1 title2:(NSString *)title2 target:(UIView *)target
{
    UILabel *label1 = [self createCommonLabel];
    label1.text = title1;
    UILabel *label2 = [self createCommonLabel];
    label2.text = title2;
    
    UITextField *textField = [self createCommonTextField];
    textField.tag = target.tag + 0;
    textField.text = @"20";
    
    UIView *contentView = target;
    [contentView addSubview:label1];
    [contentView addSubview:label2];
    [contentView addSubview:textField];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView);
        make.width.equalTo(@50);
        make.height.equalTo(label1).offset(kTextFieldHeightPlus);
    }];
    
    [_textFields addObject:textField];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
    
    
}
- (UITextField *)createCommonTextField
{
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor dp_colorFromHexString:@"#ffffff"];
    textField.layer.borderWidth = 0.5f;
    textField.layer.cornerRadius = 3.0f;
    textField.layer.borderColor = [[UIColor dp_colorFromHexString:@"#dad5cc"] CGColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = [UIFont dp_systemFontOfSize:13];
    textField.leftView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.bounds = CGRectMake(0, 0, 5, 5);
        view;
    });
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    return textField;
 
}
- (UILabel *)createCommonLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont dp_systemFontOfSize:kCommonFontSize];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
    return label;
}

#pragma mark buttonClick
- (void)minOrPlusBtnClick:(UIButton *)sender
{
    int issue = [[(UILabel *)_numFields[0] text] intValue];
    int times = [[(UILabel *)_numFields[1] text] intValue];
    switch (sender.tag) {
        case kButtonTagBase + 0:
            issue --;
            break;
        case kButtonTagBase + 1:
            issue ++;
            break;
        case kButtonTagBase + 2:
            times --;
            break;
        case kButtonTagBase + 3:
            times ++;
            break;
        default:
            break;
    }
    if (issue < 1) issue = 1;
    if (times < 1) times = 1;
    [(UILabel *)_numFields[0] setText:[NSString stringWithFormat:@"%d", issue]];
    [(UILabel *)_numFields[1] setText:[NSString stringWithFormat:@"%d", times]];
    
}
- (void)checkButtonClick:(UIButton *)sender
{
    for (UIButton *btn in _checkBtns) {
        btn.selected = btn == sender ? YES : NO;
    }
}

- (void)confirmButtonClick
{
    int line = 0;
    for (UIButton *checkBtn in _checkBtns) {
        if (checkBtn.selected == YES) {
            line = checkBtn.tag - kCheckBtnTagBase;
            break;
        }
    }
    _selectedLine = line;
    DPToast *toast = [DPToast makeText:@"请输入完整" color:DPToastColorRed];
    switch (line) {
        case 0:{
            UITextField *textField = _textFields[0];
            if ([self isTextFieldTextEmpty:textField]){
                [toast show];
                return;
            }
            _minGain = [textField.text intValue];
        }
        case 1:{
            UITextField *textField = _textFields[1];
            if ([self isTextFieldTextEmpty:textField]){
                [toast show];
                return;
            }
            _minGainScale = [textField.text intValue];
        }
        case 2:{
            if (_textFields.count < 4) return;
            UITextField *textField2 = _textFields[2];
            UITextField *textField3 = _textFields[3];
            UITextField *textField4 = _textFields[4];
            
            if ([self isTextFieldTextEmpty:textField2] || [self isTextFieldTextEmpty:textField3] || [self isTextFieldTextEmpty:textField4]) {
                [toast show];
                return;
            }
            _period =    [textField2.text intValue];
            _foreScale = [textField3.text intValue];
            _nextScale = [textField4.text intValue];
        }
            break;
        default:
            break;
    }
    _issue = [_issueLabel.text intValue];
    _times = [_timesLabel.text intValue];
    
    if (_textFields.count >= 5) {
         NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
        for (UITextField *textField in _textFields) {
            [array addObject:[NSNumber numberWithInt:textField.text.intValue]];
        }
        
        self.textFieldsDatas = array;
    }
 
    [self cancelButtonClick];
    
    if ([self.myDelegate respondsToSelector:@selector(userPreferSetdown:)]) {
        [self.myDelegate userPreferSetdown:self];
    }
}
- (BOOL)isTextFieldTextEmpty:(UITextField *)textField
{
    if (textField.text == nil || textField.text.length == 0) {
        return YES;
    }
    return NO;
}
- (void)cancelButtonClick
{
    [[DPToast sharedToast]dismiss];
//    [[DPKeyboardCenter defaultCenter]removeListener:self];
    [self removeFromSuperview];
}
- (void)planSetCoverTap
{
    [_selectedField resignFirstResponder];
}

#pragma mark - gesture代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:_contentView];
    for (UITextField *textField in _textFields) {
        CGRect fieldFrame = [_contentView convertRect:textField.bounds fromView:textField];
        if (CGRectContainsPoint(fieldFrame, location)) {
            return NO;
        }
    }
    
    [_selectedField resignFirstResponder];
    _selectedField = nil;
    
    return YES;
}
#pragma mark - textField代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    [[DPToast sharedToast]dismiss];
    if (textField == _issueLabel || textField == _timesLabel) {
        _selectedField = textField;
        return YES;
    }
    int checkBtnIndex = 0;
    switch (textField.tag) {
        case kTextFieldTagBase + 0:
            checkBtnIndex = 0;
            break;
        case kTextFieldTagBase + 1:
            checkBtnIndex = 1;
            break;
        default:
            checkBtnIndex = 2;
            break;
    }
    for (int i = 0 ; i < _checkBtns.count; i++) {
        UIButton *btn = _checkBtns[i];
        btn.selected = i == checkBtnIndex ? YES : NO;
    }
    
    _selectedField = textField;
//    [textField selectAll:self]; // 全选
//    [textField sel]
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int maxNum;
    NSString *warnString;
    if (textField == _issueLabel || textField == _textFields[2]) {
        maxNum = 100;
        warnString = @"期数最大不能超过100";
    }else if(textField == _timesLabel){
        maxNum = 1000;
        warnString = @"倍数最大不能超过1000";
    }else if (textField == _textFields[0]){
        maxNum = 1000;
        warnString = @"盈利金额最大不能超过1000";
    }else{
        maxNum = 1000;
        warnString = @"盈利率最大不能超过1000";
    }
    if (newString.intValue > maxNum) {
        [[DPToast makeText:warnString] show];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _selectedField = nil;
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] <= 0) {
        textField.text = @"1";
    }
}

#pragma mark - keyboardCenter代理方法
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if (event == DPKeyboardListenerEventWillShow) {
        self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) + 20, 0);
        
        CGRect frame = [self convertRect:_selectedField.bounds fromView:_selectedField];
        CGRect showFrame = (CGRect){frame.origin, CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) + 20)};
        [self scrollRectToVisible:showFrame animated:YES];
      
    }else if (event == DPKeyboardListenerEventWillHide){

        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            self.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            self.contentSize = CGSizeZero;
        }];
        
    }
    
}
- (void)setOriginIssue:(int)originIssue
{
    _issueLabel.text = [NSString stringWithFormat:@"%d", originIssue];
    _originIssue = originIssue;
}

- (void)setOriginTimes:(int)originTimes
{
    _timesLabel.text = [NSString stringWithFormat:@"%d", originTimes];
    _originTimes = originTimes;
}
- (void)setTextFieldsDatas:(NSMutableArray *)textFieldsDatas
{
    for (int i = 0; i < 5; i++) {
        UITextField *textField = _textFields[i];
        textField.text = [textFieldsDatas[i] stringValue];
    }
    _textFieldsDatas = textFieldsDatas;
}
- (BOOL)isShowWarning
{
    return _showWarning;
}
- (void)setShowWarning:(BOOL)showWarning
{
    _warningView.hidden = !showWarning;
    _showWarning = showWarning;
}
- (void)dealloc
{
    [[DPKeyboardCenter defaultCenter] removeListener:self];
}
@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kSureViewCommonEdge 15
@interface DPSmartCountSureView ()
{
    UILabel *_wordsLabel;
//    sureViewConfirm  _confirmBlock;
}
@end

@implementation DPSmartCountSureView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidUI];
    }
    return self;
}
- (void)bulidUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
    
    UILabel *helloLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.text = @"尊敬的用户:";
        label.font = [UIFont dp_systemFontOfSize:15];
        label;
    });
    
    UIView *wordsView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_colorFromHexString:@"fff1f1"];
        view.layer.cornerRadius = 3.0f;
        view.layer.borderWidth = 0.8;
        view.layer.borderColor = [UIColor dp_colorFromHexString:@"fededd"].CGColor;
        view;
    });
    
    UILabel *wordsLable = ({
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor dp_colorFromHexString:@"333333"];
//        label.backgroundColor = [UIColor redColor];
        label.font = [UIFont dp_systemFontOfSize:13];
//        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    _wordsLabel = wordsLable;
    UIButton *confirmBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor dp_colorFromHexString:@"#e7161a"]];
        [button addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    [self addSubview:contentView];
    [contentView addSubview:helloLabel];
    [contentView addSubview:wordsView];
    [contentView addSubview:confirmBtn];
    [wordsView addSubview:wordsLable];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(self).offset(- 20);
        make.height.equalTo(@160);
    }];
    
    [helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kSureViewCommonEdge);
        make.top.equalTo(contentView).offset(kSureViewCommonEdge);
    }];

    [wordsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(contentView);
        make.left.equalTo(helloLabel);
        make.right.equalTo(contentView).offset(- kSureViewCommonEdge);
        make.top.equalTo(helloLabel.mas_bottom).offset(10);
        make.height.equalTo(@55);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helloLabel);
        make.right.equalTo(contentView).offset(- kSureViewCommonEdge);
//        make.top.equalTo(wordsView.mas_bottom).offset(10);
        make.height.equalTo(@35);
        make.bottom.equalTo(contentView).offset(- kSureViewCommonEdge);
    }];
    
    [wordsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wordsView).offset(5);
        make.top.equalTo(wordsView).offset(8);
        make.width.equalTo(wordsView).offset(- 10);

    }];
    
}
- (void)confirmBtnClick
{
    [self removeFromSuperview];
}

//- (void)setCurIssue:(NSString *)curIssue NextIssue:(NSString *)nextIssue
//{
//    _wordsLabel.text = [NSString stringWithFormat:@"%@期已经截止，现在初始期是%@期，请核对期号", curIssue, nextIssue];
//}
- (void)setAlertText:(NSString *)alertText
{
    _alertText = alertText;
    _wordsLabel.text = alertText;
}
@end
