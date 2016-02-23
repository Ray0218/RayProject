//
//  DProjectDetailFollowHeaderCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailFollowHeaderCell.h"

@interface DProjectDetailFollowHeaderCell () {
@private
    UILabel *_conditionLabel;
    UIImageView *_arrowView;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation DProjectDetailFollowHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidlayout];
    }
    return self;
}
- (void)bulidlayout {

    UIView *view = self.contentView;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"追号内容";
    titleLabel.textColor = UIColorFromRGB(0x3f3f3f);
    titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
    _titleLabel = titleLabel;
    [view addSubview:titleLabel];
    [view addSubview:self.conditionLabel];
    [view addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@9.5);
        make.centerY.equalTo(view);
        make.height.equalTo(@6.5);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowView.mas_right).offset(2);
        make.width.equalTo(@140);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];

    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@140);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];

    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHandleTap)]];
}
- (void)setConditionLabelText:(int)textType stopMoney:(int)stopMoney {
    switch (textType) {
        case 1:
            self.conditionLabel.text = @"中奖后停止追号";
            break;
        case 2:
            self.conditionLabel.text = @"全部追号完成后停止";
            break;
        case 3:
            self.conditionLabel.text = [NSString stringWithFormat:@"累计中出%d元停止", stopMoney];
            break;
        case 4:
            self.conditionLabel.text = @"追号开始前号码开出则停止";
            break;
        default:
            break;
    }
}
- (UILabel *)conditionLabel {
    if (_conditionLabel == nil) {
        _conditionLabel = [[UILabel alloc] init];
        _conditionLabel.backgroundColor = [UIColor clearColor];
        _conditionLabel.textColor = UIColorFromRGB(0x3f3f3f);
        _conditionLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _conditionLabel.textAlignment = NSTextAlignmentRight;
        _conditionLabel.text = @"";
    }
    return _conditionLabel;
}
- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.image = dp_ProjectImage(@"content_down.png");
    }
    return _arrowView;
}
- (void)setFollowIssues:(int)followIssues
{
    if (followIssues > 0) {
        _titleLabel.text = [NSString stringWithFormat:@"追号内容（共%d期）", followIssues];
        _followIssues = followIssues;
    }
}
- (void)_onHandleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapFollowHeaderCell:)]) {
        [self.delegate tapFollowHeaderCell:self];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_expand) {
        self.arrowView.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
    } else {
        self.arrowView.transform = CGAffineTransformIdentity;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DProjectDetailFollowTitleCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidlayout];
    }
    return self;
}
- (void)bulidlayout {

    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];

    UILabel *label1 = [self createlable:@"期号" titleColor:UIColorFromRGB(0x948f94) titleFont:[UIFont dp_systemFontOfSize:11.0] alignment:NSTextAlignmentLeft];
    UILabel *label2 = [self createlable:@"倍数" titleColor:UIColorFromRGB(0x948f94) titleFont:[UIFont dp_systemFontOfSize:11.0] alignment:NSTextAlignmentCenter];
    UILabel *label3 = [self createlable:@"状态" titleColor:UIColorFromRGB(0x948f94) titleFont:[UIFont dp_systemFontOfSize:11.0] alignment:NSTextAlignmentRight];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@((view.frame.size.width-20)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.equalTo(@((view.frame.size.width-20)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@((view.frame.size.width-20)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
}

- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.text = title;
    lable.textAlignment = alignment;
    return lable;
}

@end

@interface DProjectDetailFollowListCell () {
@private
    UILabel *_issueLabel;
    UILabel *_beishulabel;
    UILabel *_stateLabel;
    UIImageView *_arrowView;
}

@property (nonatomic, strong) UILabel *issueLabel;
@property (nonatomic, strong) UILabel *beishulabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end
@implementation DProjectDetailFollowListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidlayout];
    }
    return self;
}
- (void)bulidlayout {

    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];

    [view addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@9.5);
        make.centerY.equalTo(view);
        make.height.equalTo(@6.5);
    }];
    [view addSubview:self.issueLabel];
    [view addSubview:self.beishulabel];
    [view addSubview:self.stateLabel];
    [self.issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowView.mas_right).offset(5);
        make.width.equalTo(@((view.frame.size.width-35)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.beishulabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.equalTo(@((view.frame.size.width-35)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@((view.frame.size.width-35)/3));
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    self.lineView = vLine1;
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];

    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHandleTap)]];
}
- (UILabel *)issueLabel {
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.textColor = UIColorFromRGB(0x948f94);
        _issueLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _issueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _issueLabel;
}
- (UILabel *)beishulabel {
    if (_beishulabel == nil) {
        _beishulabel = [[UILabel alloc] init];
        _beishulabel.backgroundColor = [UIColor clearColor];
        _beishulabel.textColor = UIColorFromRGB(0x948f94);
        _beishulabel.font = [UIFont dp_systemFontOfSize:11.0];
        _beishulabel.textAlignment = NSTextAlignmentCenter;
    }
    return _beishulabel;
}
- (UILabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.textColor = UIColorFromRGB(0x948f94);
        _stateLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
}
- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.image = dp_ProjectImage(@"content_down.png");
    }
    return _arrowView;
}
- (void)setIssueLabelText:(NSString *)string {
    [self.issueLabel setText:string];
}

- (void)setBeishuLabelText:(NSString *)string {
    [self.beishulabel setText:string];
}
- (void)setStateLabelText:(NSString *)string {
    [self.stateLabel setText:string];

}
- (void)_onHandleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapFollowListCell:)]) {
        [self.delegate tapFollowListCell:self];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_expand) {
        self.arrowView.transform = CGAffineTransformMakeRotation(-M_PI * .5);
    } else {
        self.arrowView.transform = CGAffineTransformIdentity;
        
    }
}

@end

@implementation DProjectDetailFollowResultCell
@synthesize resultlabel = _resultlabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *trapView = [[UIImageView alloc] init];
    trapView.image = dp_ProjectImage(@"followback02.png");
    [view addSubview:trapView];
    [trapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(40);
        make.width.equalTo(@8);
        make.top.equalTo(view).offset(-7);
        make.height.equalTo(@7);
    }];
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = dp_ProjectImage(@"followback.png");
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(trapView.mas_bottom).offset(-2);
        make.height.equalTo(@24.5);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"开奖号码：";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_systemFontOfSize:11.0];
    label.textColor = UIColorFromRGB(0x948f94);
    [backView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.width.equalTo(@60);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [backView addSubview:self.resultlabel];
    [self.resultlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.right.equalTo(backView);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];

    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
}
#pragma mark--getter,setter
- (TTTAttributedLabel *)resultlabel {
    if (_resultlabel == nil) {
        _resultlabel = [[TTTAttributedLabel alloc] init];
        _resultlabel.backgroundColor = [UIColor clearColor];
        _resultlabel.font = [UIFont dp_systemFontOfSize:12.0];
        _resultlabel.textColor = UIColorFromRGB(0x2e2e2e);
        _resultlabel.textAlignment = NSTextAlignmentLeft;
        _resultlabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _resultlabel.userInteractionEnabled=NO;
    }
    return _resultlabel;
}
- (void)setResultLabelText:(NSString *)resultString lotteryType:(int)gameType {
    switch (gameType)
    {
        case GameTypeSd:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeNmgks:
        {
            
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:[self resultStringFromResult:resultString]];
            [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
            [self.resultlabel setText:hinstring];
        }
            break;
        case GameTypeSsq:
        case GameTypeDlt:
        {
            NSArray *array = [[resultString stringByReplacingOccurrencesOfString:@"," withString:@" "] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
            if (array.count == 2) {
                NSString *redString = [array objectAtIndex:0];
                NSString *blueString = [array objectAtIndex:1];
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", redString, blueString]];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, redString.length)];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:NSMakeRange(redString.length+1, blueString.length)];
                [self.resultlabel setText:hinstring];
            }
        }
            break;
        case GameTypeQlc:
        case GameTypeJxsyxw:
        {
            NSString *string=[resultString stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:string];
            [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
            [self.resultlabel setText:hinstring];
        }
            break;
        case GameTypeSdpks:
        {
        
        }
            break;
        default:
            break;
    }
}

-(NSString *)resultStringFromResult:(NSString *)nString
{
    NSString *resultString=@"";
    if (nString.length<1)
    {
        return resultString;
    }
    
    for (int i=0; i<nString.length; i++) {
        resultString=[NSString stringWithFormat:@"%@  %@",resultString,[nString substringWithRange:NSMakeRange(i, 1)]];
    }
    return resultString;

}
@end

@implementation DProjectDetailFollowResultPK3Cell
@synthesize imageLabel1  = _imageLabel1,imageLabel2  = _imageLabel2,imageLabel3  = _imageLabel3;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *trapView = [[UIImageView alloc] init];
    trapView.image = dp_ProjectImage(@"followback02.png");
    [view addSubview:trapView];
    [trapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(40);
        make.width.equalTo(@8);
        make.top.equalTo(view).offset(-7);
        make.height.equalTo(@7);
    }];
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = dp_ProjectImage(@"followback.png");
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(trapView.mas_bottom).offset(-2);
        make.height.equalTo(@24.5);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"开奖号码：";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_systemFontOfSize:11.0];
    label.textColor = UIColorFromRGB(0x948f94);
    [backView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.width.equalTo(@60);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [backView addSubview:self.imageLabel1];
    [backView addSubview:self.imageLabel2];
     [backView addSubview:self.imageLabel3];
    [self.imageLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.width.equalTo(@30);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [self.imageLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageLabel1.mas_right);
         make.width.equalTo(@30);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [self.imageLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageLabel2.mas_right);
         make.width.equalTo(@30);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
}
#pragma mark--getter,setter
-(DPImageLabel *)imageLabel1{
    if (_imageLabel1==nil) {
        _imageLabel1 = [[DPImageLabel alloc] init];
        _imageLabel1.spacing = 0.5;
        _imageLabel1.imagePosition = DPImagePositionLeft;
        _imageLabel1.backgroundColor = [UIColor clearColor];
        _imageLabel1.font = [UIFont dp_systemFontOfSize:9];
    }
    return _imageLabel1;
}
-(DPImageLabel *)imageLabel2{
    if (_imageLabel2==nil) {
        _imageLabel2 = [[DPImageLabel alloc] init];
        _imageLabel2.spacing = 0.5;
        _imageLabel2.imagePosition = DPImagePositionLeft;
        _imageLabel2.backgroundColor = [UIColor clearColor];
        _imageLabel2.font = [UIFont dp_systemFontOfSize:9];
    }
    return _imageLabel2;
}
-(DPImageLabel *)imageLabel3{
    if (_imageLabel3==nil) {
        _imageLabel3 = [[DPImageLabel alloc] init];
        _imageLabel3.spacing = 0.5;
        _imageLabel3.imagePosition = DPImagePositionLeft;
        _imageLabel3.backgroundColor = [UIColor clearColor];
        _imageLabel3.font = [UIFont dp_systemFontOfSize:9];
    }
    return _imageLabel3;
}
-(void)setResultLabelText:(NSString *)resultString
{
    if (resultString.length<11) {
        return;
    }
    NSString *colour = [[resultString componentsSeparatedByString:@"|"] objectAtIndex:0];
    NSString *number = [[resultString componentsSeparatedByString:@"|"] objectAtIndex:1];
    
    NSArray *colours = [colour componentsSeparatedByString:@","];
    NSArray *numbers = [number componentsSeparatedByString:@","];
    if ((colours.count<3)||(numbers.count<3)) {
        return;
    }
    NSArray *array=[NSArray arrayWithObjects:self.imageLabel1,self.imageLabel2,self.imageLabel3, nil];
    // s 黑桃  r 红桃 p 梅花 d 方块
    for (int i = 0; i < array.count; i++) {
        DPImageLabel *imageView = [array objectAtIndex:i];
        
        switch ([colours[i] characterAtIndex:0]) {
            case 'S':
                imageView.image = dp_ResultImage(@"pks1.png");
                imageView.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
                break;
            case 'R':
                imageView.image = dp_ResultImage(@"pks2.png");
                imageView.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
                break;
            case 'P':
                imageView.image = dp_ResultImage(@"pks3.png");
                imageView.textColor = [UIColor dp_flatBlackColor];
                break;
            case 'D':
                imageView.image = dp_ResultImage(@"pks4.png");
                imageView.textColor = [UIColor dp_flatBlackColor];
                break;
            default:
                imageView.textColor = [UIColor clearColor];
                break;
        }
        
        switch ([numbers[i] integerValue]) {
            case 1:
                imageView.text = @"A";
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                imageView.text = [NSString stringWithFormat:@"%d", [numbers[i] integerValue]];
                break;
            case 11:
                imageView.text = @"J";
                break;
            case 12:
                imageView.text = @"Q";
                break;
            case 13:
                imageView.text = @"K";
                break;
                
            default:
                break;
        }
    }


}
@end