//
//  DPprojectDetailSprotContentCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPprojectDetailSprotContentCell.h"
@interface DPprojectDetailSprotContentCell () {
    //    UIView          * _contentBgView;
    NSMutableArray *_subRowViews;
    DPProjectDetailContentTitleView *_titleInfoView;
    DPProjectDetailSProtSpfView *_spfView;
    DPProjectDetailSProtSpfView *_rqspfView;
    DPProjectDetailSportBfView *_bfView;
    DPProjectDetailSportBfView *_zjqView;
    DPProjectDetailSportBfView *_bqcView;
    DPProjectDetailSportBfView *_sxdsView;

    DPProjectDetailSProtDxfView *_dxfView;
    DPProjectDetailSProtDxfView *_sfView;
    DPProjectDetailSProtDxfView *_rqsfView;
    DPProjectDetailSportBfView *_sfcView;
    UIView *_bottomLineView;
    BOOL _expand;
}

@end
@implementation DPprojectDetailSprotContentCell
@dynamic spfView;
@dynamic rqspfView;
@dynamic bfView;
@dynamic zjqView;
@dynamic bqcView;
@dynamic sxdsView;
@dynamic bottomLineView;
@synthesize titleInfoView;
+ (CGFloat)heightWithLineCount:(NSUInteger)lineCount {
    return lineCount * 30;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        _subRowViews = [[NSMutableArray alloc] initWithCapacity:5];
        UIView *topLineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.83 blue:0.80 alpha:1.0]];
        [self.contentView addSubview:topLineView];
       
        [self.contentView addSubview:self.bottomLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(- 10);
            make.height.equalTo(@1);
        }];
//        self.bottomLineView.backgroundColor = [UIColor redColor];
        self.bottomLineView.hidden = YES;

        // 先隐藏所有视图
        [self.contentView addSubview:self.titleInfoView];
        self.titleInfoView.backgroundColor = [UIColor clearColor];
        [self.titleInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@30);
        }];
    
        
    }
    return self;
    _expand = YES;
}

- (void)updateConstraints {
    NSMutableArray *views = [NSMutableArray array];

    for (NSNumber *index in self.gameTypeArray) {
        switch ([index intValue]) {
            case GameTypeJcSpf:
                [views addObject:self.spfView];
                break;
            case GameTypeJcRqspf:
            case GameTypeBdRqspf:
                [views addObject:self.rqspfView];
                break;
            case GameTypeJcZjq:
            case GameTypeBdZjq:
                [views addObject:self.zjqView];
//                self.zjqView.titleLabel.text = @"";
                break;
            case GameTypeJcBqc:
            case GameTypeBdBqc:
                [views addObject:self.bqcView];
//                self.bqcView.titleLabel.text = @"";
                break;
            case GameTypeJcBf:
            case GameTypeBdBf:
                [views addObject:self.bfView];
//                self.bfView.titleLabel.text = @"";
                break;
            case GameTypeBdSxds:
                [views addObject:self.sxdsView];
                break;
            case GameTypeLcSf:
                [views addObject:self.sfView];
                break;
            case GameTypeLcRfsf:
                [views addObject:self.rqsfView];
                break;
            case GameTypeLcDxf:
                [views addObject:self.dxfView];
                break;
            case GameTypeLcSfc:
                [views addObject:self.sfcView];
                break;
            default:
                break;
        }
    }
    // 先隐藏所有视图
    for (UIView *view in _subRowViews) {
        view.hidden = ![views containsObject:view];
    }

    [views.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.titleInfoView.mas_bottom);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];

    [views dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(obj1);
            make.left.equalTo(obj1);
            make.right.equalTo(obj1);
            make.top.equalTo(obj1.mas_bottom);
        }];
    }];

    //    for (int i=0; i<views.count; i++) {
    //       UIView *view=[views objectAtIndex:i];
    //        BOOL isViewShow=NO;
    //        for (int i=0; i<_subRowViews.count; i++) {
    //            if ([view isEqual:[_subRowViews objectAtIndex:i]]) {
    //                isViewShow=YES;
    //            }
    //        }
    //
    //        [self addSubview:view];
    //        [view mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.left.equalTo(self.contentView);
    //                make.right.equalTo(self.contentView);
    //               make.top.equalTo(self.titleInfoView.mas_bottom).offset(30*i);
    //                make.height.equalTo(@30);
    //            }];
    //        }

    [super updateConstraints];
}
-(UIView *)bottomLineView{
    if (_bottomLineView==nil) {
         _bottomLineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.83 blue:0.80 alpha:1.0]];
    }
    return _bottomLineView;
}
- (DPProjectDetailContentTitleView *)titleInfoView {
    if (_titleInfoView == nil) {
        _titleInfoView = [[DPProjectDetailContentTitleView alloc] init];
    }
    return _titleInfoView;
}
- (DPProjectDetailSProtSpfView *)spfView {
    if (_spfView == nil) {
        _spfView = [[DPProjectDetailSProtSpfView alloc] init];
        [self.contentView addSubview:_spfView];
        [_subRowViews addObject:_spfView];
    }
    return _spfView;
}
- (DPProjectDetailSProtSpfView *)rqspfView {
    if (_rqspfView == nil) {
        _rqspfView = [[DPProjectDetailSProtSpfView alloc] init];
        [self.contentView addSubview:_rqspfView];
        [_subRowViews addObject:_rqspfView];
    }
    return _rqspfView;
}
- (DPProjectDetailSportBfView *)bfView {
    if (_bfView == nil) {
        _bfView = [[DPProjectDetailSportBfView alloc] init];
        [self.contentView addSubview:_bfView];
        [_subRowViews addObject:_bfView];
    }
    return _bfView;
}
- (DPProjectDetailSportBfView *)zjqView {
    if (_zjqView == nil) {
        _zjqView = [[DPProjectDetailSportBfView alloc] init];
        [self.contentView addSubview:_zjqView];
        [_subRowViews addObject:_zjqView];
    }
    return _zjqView;
}
- (DPProjectDetailSportBfView *)bqcView {
    if (_bqcView == nil) {
        _bqcView = [[DPProjectDetailSportBfView alloc] init];
        [self.contentView addSubview:_bqcView];
        [_subRowViews addObject:_bqcView];
    }
    return _bqcView;
}
- (DPProjectDetailSportBfView *)sxdsView {
    if (_sxdsView == nil) {
        _sxdsView = [[DPProjectDetailSportBfView alloc] init];
        [self.contentView addSubview:_sxdsView];
        [_subRowViews addObject:_sxdsView];
    }
    return _sxdsView;
}

- (DPProjectDetailSProtDxfView *)dxfView {
    if (_dxfView == nil) {
        _dxfView = [[DPProjectDetailSProtDxfView alloc] init];
        [self.contentView addSubview:_dxfView];
        [_subRowViews addObject:_dxfView];
    }
    return _dxfView;
}
- (DPProjectDetailSProtDxfView *)sfView {
    if (_sfView == nil) {
        _sfView = [[DPProjectDetailSProtDxfView alloc] init];
        [self.contentView addSubview:_sfView];
        [_subRowViews addObject:_sfView];
    }
    return _sfView;
}
- (DPProjectDetailSProtDxfView *)rqsfView {
    if (_rqsfView == nil) {
        _rqsfView = [[DPProjectDetailSProtDxfView alloc] init];
        [self.contentView addSubview:_rqsfView];
        [_subRowViews addObject:_rqsfView];
    }
    return _rqsfView;
}

- (DPProjectDetailSportBfView *)sfcView {
    if (_sfcView == nil) {
        _sfcView = [[DPProjectDetailSportBfView alloc] init];
        [self.contentView addSubview:_sfcView];
        [_subRowViews addObject:_sfcView];
    }
    return _sfcView;
}
-(void)changeBottomLineHeight:(int)height{
//    static BOOL expand = YES;
//    height = expand ? height : 10;
//        [self.contentView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop){
//        if (constraint.firstItem == self.bottomLineView && constraint.firstAttribute == NSLayoutAttributeBottom) {
//            
//            constraint.constant = height;
//            *stop = YES;
//        }
//    }];
//    self.bottomLineView.hidden = NO;
//    
//    [self.contentView setNeedsLayout];
//     [self.contentView layoutIfNeeded];
//    expand = !expand;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@implementation DPProjectDetailContentTitleView
@synthesize changLabel = _changLabel;
@synthesize homeLabel = _homeLabel, awayLabel = _awayLabel;
@synthesize homeNumberLabel = _homeNumberLabel, awayNumberLabel = _awayNumberLabel;
@synthesize danView = _danView;
@synthesize timeLabel = _timeLabel;
@synthesize midVslabel = _midVslabel;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}
- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.changLabel];
    [self addSubview:self.homeLabel];
    [self addSubview:self.homeNumberLabel];
    [self addSubview:self.awayNumberLabel];
    [self addSubview:self.awayLabel];
    [self addSubview:self.danView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.midVslabel];
    [self.changLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.danView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changLabel.mas_right).offset(3);
        make.width.equalTo(@18);
        make.centerY.equalTo(self);
        make.height.equalTo(@18);
    }];
    [self.midVslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(10);
        make.width.equalTo(@30);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.danView.mas_right);
        make.right.equalTo(self.midVslabel.mas_left).offset(-10);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.homeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@20);
        make.right.equalTo(self.homeLabel.mas_left).offset(-2) ;
        make.height.equalTo(@20);
        make.bottom.equalTo(self).offset(-4);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midVslabel.mas_right).offset(10);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    
       [self.awayNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@20);
        make.left.equalTo(self.awayLabel.mas_right).offset(2) ;
        make.height.equalTo(@20);
        make.bottom.equalTo(self).offset(-4);
    }];

    
}

- (UILabel *)changLabel {
    if (_changLabel == nil) {
        _changLabel = [[UILabel alloc] init];
        _changLabel.backgroundColor = [UIColor clearColor];
        _changLabel.font = [UIFont dp_regularArialOfSize:11.0];
        _changLabel.textColor = UIColorFromRGB(0x333333);
        _changLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changLabel;
}
- (UILabel *)homeNumberLabel {
    if (_homeNumberLabel == nil) {
        _homeNumberLabel = [[UILabel alloc] init];
        _homeNumberLabel.backgroundColor = [UIColor clearColor];
        _homeNumberLabel.font = [UIFont dp_regularArialOfSize:9.0];
        _homeNumberLabel.textColor = UIColorFromRGB(0x958b7a);
        _homeNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _homeNumberLabel;
}
- (UILabel *)homeLabel {
    if (_homeLabel == nil) {
        _homeLabel = [[UILabel alloc] init];
        _homeLabel.backgroundColor = [UIColor clearColor];
        _homeLabel.font = [UIFont dp_regularArialOfSize:14.0];
        _homeLabel.textColor = UIColorFromRGB(0x282828);
        _homeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _homeLabel;
}
- (UILabel *)awayLabel {
    if (_awayLabel == nil) {
        _awayLabel = [[UILabel alloc] init];
        _awayLabel.backgroundColor = [UIColor clearColor];
        _awayLabel.font = [UIFont dp_regularArialOfSize:14.0];
        _awayLabel.text = @"";
        _awayLabel.textColor = UIColorFromRGB(0x282828);
        _awayLabel.textAlignment = NSTextAlignmentRight;
    }
    return _awayLabel;
}
- (UILabel *)awayNumberLabel {
    if (_awayNumberLabel == nil) {
        _awayNumberLabel = [[UILabel alloc] init];
        _awayNumberLabel.backgroundColor = [UIColor clearColor];
        _awayNumberLabel.font = [UIFont dp_regularArialOfSize:9.0];
        _awayNumberLabel.textColor = UIColorFromRGB(0x958b7a);
        _awayLabel.text = @"[12]";
        _awayNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _awayNumberLabel;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont dp_regularArialOfSize:12.0];

        _timeLabel.text = @"--";
        _timeLabel.textColor = [UIColor dp_flatRedColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UILabel *)midVslabel {
    if (_midVslabel == nil) {
        _midVslabel = [[UILabel alloc] init];
        _midVslabel.backgroundColor = [UIColor clearColor];
        _midVslabel.font = [UIFont dp_regularArialOfSize:13.0];
        _midVslabel.text = @"VS";
        _midVslabel.textColor = UIColorFromRGB(0x958b7a);
        _midVslabel.textAlignment = NSTextAlignmentCenter;
    }
    return _midVslabel;
}
- (UIButton *)danView {
    if (_danView == nil) {
        _danView = [[UIButton alloc] init];
        [_danView setTitle:@"胆" forState:UIControlStateNormal];
        [_danView setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [_danView setBackgroundImage:dp_SportLotteryImage(@"markselect.png") forState:UIControlStateNormal];
        [_danView.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
        _danView.userInteractionEnabled = NO;
    }
    return _danView;
}
@end

@implementation DPProjectDetailSProtSpfView
@synthesize sLabel = _sLabel;
@synthesize pLabel = _pLabel;
@synthesize fLabel = _fLabel;
@synthesize resultLabel = _resultLabel;
@synthesize titleLabel = _titleLabel;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}
- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:hline];
    UIView *vline1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline1];
    UIView *vline2 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline2];
    UIView *vline3 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline3];
    UIView *vline4 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline4];
    [self addSubview:self.sLabel];
    [self addSubview:self.pLabel];
    [self addSubview:self.fLabel];
    [self addSubview:self.resultLabel];
    [self addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.equalTo(@((kScreenWidth-90)/3));
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.pLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sLabel.mas_right);
       make.width.equalTo(@((kScreenWidth-90)/3));
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.fLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pLabel.mas_right);
        make.width.equalTo(@((kScreenWidth-90)/3));
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel.mas_right);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self);
    }];

    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel.mas_right);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _titleLabel.text = @"";
        _titleLabel.textColor = UIColorFromRGB(0x797979);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (DPImageLabel *)sLabel {
    if (_sLabel == nil) {
        _sLabel = [[DPImageLabel alloc] init];
        _sLabel.spacing = 0.5;
        _sLabel.textColor = UIColorFromRGB(0x666666);
        _sLabel.imagePosition = DPImagePositionLeft;
        _sLabel.backgroundColor = [UIColor clearColor];
        _sLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _sLabel;
}
- (DPImageLabel *)pLabel {
    if (_pLabel == nil) {
        _pLabel = [[DPImageLabel alloc] init];
        _pLabel.spacing = 0.5;
        _pLabel.textColor = UIColorFromRGB(0x666666);
        _pLabel.imagePosition = DPImagePositionLeft;
        _pLabel.backgroundColor = [UIColor clearColor];
        _pLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _pLabel;
}
- (DPImageLabel *)fLabel {
    if (_fLabel == nil) {
        _fLabel = [[DPImageLabel alloc] init];
        _fLabel.spacing = 0.5;
        _fLabel.textColor = UIColorFromRGB(0x666666);
        _fLabel.imagePosition = DPImagePositionLeft;
        _fLabel.backgroundColor = [UIColor clearColor];
        _fLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _fLabel;
}
- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _resultLabel.text = @"--";
        _resultLabel.textColor = [UIColor dp_flatRedColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}
@end

@implementation DPProjectDetailSportBfView
@synthesize titleLabel = _titleLabel;
@synthesize infoLabel = _infoLabel;
@synthesize resultLabel = _resultLabel;
@synthesize attLabel = _attLabel;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}
- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:hline];
    UIView *vline1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline1];
    UIView *vline2 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline2];
    [self addSubview:self.titleLabel];
   [self addSubview:self.infoLabel];
    [self addSubview:self.resultLabel];
    self.infoLabel.customView = self.attLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
//        make.right.equalTo(self.resultLabel.mas_left);
       make.width.equalTo(@(kScreenWidth-90));
        make.centerY.equalTo(self);
        make.height.equalTo(@15);
    }];

    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self);
    }];

    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resultLabel.mas_left);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _titleLabel.text = @"";
        _titleLabel.textColor = UIColorFromRGB(0x797979);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (DPDragView *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[DPDragView alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
    }
    return _infoLabel;
}
- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont dp_regularArialOfSize:9];
        _resultLabel.text = @"--";
        _resultLabel.textColor = [UIColor dp_flatRedColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}
- (TTTAttributedLabel *)attLabel {
    if (_attLabel == nil) {
        _attLabel = [[TTTAttributedLabel alloc] init];
        _attLabel.backgroundColor = [UIColor clearColor];
        _attLabel.font = [UIFont dp_regularArialOfSize:14];
        _attLabel.textColor = [UIColor dp_flatRedColor];
        _attLabel.userInteractionEnabled=NO;
        _attLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    }
    return _attLabel;
}
@end

@implementation DPProjectDetailSProtDxfView
@synthesize titleLabel = _titleLabel;
@synthesize sLabel = _sLabel;
@synthesize fLabel = _fLabel;
@synthesize resultLabel = _resultLabel;
@synthesize rqLabel = _rqLabel;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}
- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:hline];
    UIView *vline1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline1];
    UIView *vline2 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline2];
    UIView *vline3 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline3];
    UIView *vline4 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
    [self addSubview:vline4];
    [self addSubview:self.sLabel];
    [self addSubview:self.fLabel];
    [self addSubview:self.resultLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rqLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.equalTo(@((kScreenWidth-90-50)/2));
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.rqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sLabel.mas_right);
        make.width.equalTo(@50);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.fLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rqLabel.mas_right);
        make.width.equalTo(@((kScreenWidth-90-50)/2));
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel.mas_right);
        make.width.equalTo(@45);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self);
    }];

    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];

    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rqLabel);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [vline3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLabel.mas_right).offset(-0.5);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _titleLabel.text = @"";
        _titleLabel.textColor = UIColorFromRGB(0x797979);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (DPImageLabel *)sLabel {
    if (_sLabel == nil) {
        _sLabel = [[DPImageLabel alloc] init];
        _sLabel.spacing = 0.5;
        _sLabel.imagePosition = DPImagePositionLeft;
        _sLabel.backgroundColor = [UIColor clearColor];
        _sLabel.font = [UIFont dp_systemFontOfSize:14];
        _rqLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _sLabel;
}
- (UILabel *)rqLabel {
    if (_rqLabel == nil) {
        _rqLabel = [[UILabel alloc] init];
        _rqLabel.backgroundColor = [UIColor clearColor];
        _rqLabel.font = [UIFont dp_regularArialOfSize:14.0];
        _rqLabel.text = @"";
        _rqLabel.textColor = UIColorFromRGB(0x333333);
        _rqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rqLabel;
}
- (DPImageLabel *)fLabel {
    if (_fLabel == nil) {
        _fLabel = [[DPImageLabel alloc] init];
        _fLabel.spacing = 0.5;
        _fLabel.imagePosition = DPImagePositionLeft;
        _fLabel.backgroundColor = [UIColor clearColor];
        _fLabel.font = [UIFont dp_systemFontOfSize:14];
        _rqLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _fLabel;
}
- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _resultLabel.text = @"--";
        _resultLabel.textColor = [UIColor dp_flatRedColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}
@end
