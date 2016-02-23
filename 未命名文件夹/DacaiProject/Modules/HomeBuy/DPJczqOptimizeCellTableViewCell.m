//
//  DPJczqOptimizeCellTableViewCell.m
//  DacaiProject
//
//  Created by Ray on 14/11/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqOptimizeCellTableViewCell.h"
#import "DPVerifyUtilities.h"

@interface DPJczqOptimizeCellTableViewCell ()<UITextFieldDelegate>
{
    UITextField *_numberField  ;
}

@end

@implementation DPJczqOptimizeCellTableViewCell
@dynamic numberField ;

- (void)awakeFromNib {
    // Initialization code
}

-(void)buildLayout{

    UIView* contentView = self.contentView ;
    
    UIImageView *changeView = [[UIImageView alloc]initWithImage:dp_DigitLotteryResizeImage(@"smartFollowBox.png")];
    changeView.userInteractionEnabled = YES;
    changeView.backgroundColor = [UIColor clearColor];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    minus.backgroundColor = [UIColor clearColor] ;
    [minus setImage:dp_DigitLotteryImage(@"minus.png") forState:UIControlStateNormal];
    [minus addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchDown];
    minus.tag = 1000 ;
    [minus setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)] ;
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.backgroundColor = [UIColor clearColor] ;
    [plus setImage:dp_DigitLotteryImage(@"plus.png") forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchDown];
    plus.tag = 1001 ;
    [plus setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)] ;

    
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    
    [changeView addSubview:minus];
    [changeView addSubview:self.numberField];
    [changeView addSubview:plus];
    [contentView addSubview:self.awardLabel];
    [contentView addSubview:changeView];
    [contentView addSubview:lineView];
    
    UILabel* yuanLabel =({
        UILabel* label =  [[UILabel alloc]init];
        label.text = @"元" ;
        label.textColor = UIColorFromRGB(0x333333) ;
        label.font = [UIFont dp_systemFontOfSize:13.0f] ;
        label.backgroundColor = [UIColor clearColor] ;
        label ;
    }) ;
    [contentView addSubview:yuanLabel];
    
    
    
    [changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10) ;
        make.centerY.equalTo(contentView) ;
        make.width.equalTo(@140) ;
    }] ;
    
    
    [minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeView).offset(3) ;
        make.centerY.equalTo(changeView.mas_centerY) ;
        make.width.equalTo(@30) ;
        make.height.equalTo(@40);
    }];
    
    [plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeView).offset(-3) ;
        make.centerY.equalTo(changeView.mas_centerY) ;
        make.width.equalTo(@30) ;
        make.height.equalTo(@40);
    }] ;
    
    
    
    [self.numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minus.mas_right);
        make.centerY.equalTo(changeView.mas_centerY) ;
//        make.right.equalTo(plus.mas_left) ;
        make.width.equalTo(@74) ;
    }];
    
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeView.mas_right).offset(5) ;
        make.centerY.equalTo(contentView) ;
//        make.right.equalTo(contentView) ;
        make.width.lessThanOrEqualTo(@150) ;
    }];
    
    
   [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardLabel.mas_right) ;
        make.centerY.equalTo(contentView) ;
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView) ;
        make.left.equalTo(contentView) ;
        make.width.equalTo(contentView) ;
        make.height.equalTo(@0.5) ;
    }] ;
    
    
   }




-(UITextField*)numberField
{
    
    if (_numberField == nil) {
        _numberField = ({
            UITextField *field = [[UITextField alloc]init];
            field.backgroundColor = [UIColor clearColor];
            field.textColor = [UIColor dp_colorFromHexString:@"333333"];
            field.font = [UIFont dp_systemFontOfSize:15];
            field.textAlignment = NSTextAlignmentCenter;
            field.keyboardType = UIKeyboardTypeNumberPad;
            field.delegate = self;
            field.text = @"1" ;
            field.inputAccessoryView = ({
                UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
                line.bounds = CGRectMake(0, 0, 0, 0.5f);
                
                line;
            });
            [field addTarget:self action:@selector(changeFieldCount:) forControlEvents:UIControlEventEditingChanged];

            field;
        });
        
    }

    return _numberField ;
}



-(void)changeFieldCount:(UITextField*)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changnum:OptimizeCell:)]) {
        [self.delegate changnum:self.numberField.text OptimizeCell:self];
    }
    
}
#pragma mark buttonClick
- (void)minOrPlusBtnClick:(UIButton *)sender
{

    NSInteger issue = [self.numberField.text integerValue] ;
        switch (sender.tag - 1000) {
        case  0:
            issue --;
            break;
        case 1:
            issue ++;
            break;
       
            default:
            break;
    }
    
    if (issue<0) {
        return ;
    }
//    else if (issue>250000){
//        issue = 250000 ;
//        [[DPToast makeText:@"最大值不能超过250000"]show];
//
//    }
    _lastNum = [self.numberField.text integerValue];//保存改变前的数据
    
    self.numberField.text = [NSString stringWithFormat:@"%d",issue] ;
    [self changeFieldCount:self.numberField];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lastNum = 0 ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    _lastNum = [textField.text integerValue];//保存改变前的数据
    
//     NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
//    if ([newString intValue] >250000) {
//        newString = @"250000";
//        textField.text = @"250000";
//        [[DPToast makeText:@"最大值不能超过250000"]show];
//        [self changeFieldCount:textField];
//
//        return NO ;
//
//    }
    
    return  YES ;
}

-(void)stopChangeNum{

    self.numberField.text = [NSString stringWithFormat:@"%d",_lastNum] ;
}

-(MDHTMLLabel*)awardLabel{

    if (_awardLabel == nil) {
        _awardLabel = [[MDHTMLLabel alloc] init];
        [_awardLabel setNumberOfLines:1];
        [_awardLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_awardLabel setBackgroundColor:[UIColor clearColor]];
        [_awardLabel setTextAlignment:NSTextAlignmentLeft];
        [_awardLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _awardLabel.userInteractionEnabled=NO;
        _awardLabel.text = @"dddd" ;
        _awardLabel.htmlText =  [NSString stringWithFormat:@"<font color=\"#333333\">%@</font><font color=\"#e7161a\">%d</font>", @"注,奖金:", 1900];
    }
    
    return _awardLabel ;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface DPJczqOptimizeTextCell ()
{
    UIImageView* _rightImg ;
}

@end

@implementation DPJczqOptimizeTextCell

@dynamic rightImg ;

-(UIImageView*)rightImg{

    if (_rightImg == nil) {
        
        UIImage* norImg = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_down.png"] customBlock:^UIImage *(UIImage *image) {
            return [image dp_imageWithTintColor:[UIColor colorWithRed:0.71 green:0.67 blue:0.53 alpha:1]];
        } tag:@"brown_color"];
        
        UIImage* higImg = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_up.png"] customBlock:^UIImage *(UIImage *image) {
            return [image dp_imageWithTintColor:[UIColor colorWithRed:0.71 green:0.67 blue:0.53 alpha:1]];
        } tag:@"brown_color"];

        _rightImg =[[UIImageView alloc]initWithImage:norImg highlightedImage:higImg];

    
    }
    return _rightImg ;
}

-(void)analysisViewIsExpand:(BOOL)isExpand{
    if (isExpand) {
        self.rightImg.highlighted = NO ;
    }else{
        self.rightImg.highlighted = YES ;
        
    }
}


-(void)buildLayout{

    UIView* contentView = self.contentView ;
    contentView.userInteractionEnabled  =YES ;
    
    UIImageView* rightImg = self.rightImg ;
    
    UIView*tapView = [UIView dp_viewWithColor:[UIColor clearColor]] ;
    [contentView addSubview:rightImg];
    [contentView addSubview:self.matchLabel];
    [contentView addSubview:tapView];


    
    [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10) ;
        make.right.equalTo(contentView).offset(-40) ;
        make.bottom.equalTo(contentView) ;
    }] ;

    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15) ;
        make.bottom.equalTo(self.matchLabel.mas_bottom) ;
    }] ;
    
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.matchLabel.mas_right).offset(-30) ;
        make.centerY.equalTo(contentView) ;
        make.height.equalTo(contentView) ;
        make.right.equalTo(contentView) ;
    }];
    
    [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
}

- (void)pvt_onMatchInfo {
    
    self.rightImg.highlighted = !self.rightImg.highlighted ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jczqOptimizeInfo:)]) {
        [self.delegate jczqOptimizeInfo:self];
    }
}


-(UILabel*)matchLabel{

    if (_matchLabel == nil) {
        _matchLabel = [[UILabel alloc]init];
        _matchLabel.numberOfLines = 0 ;
        _matchLabel.backgroundColor = [UIColor clearColor] ;
        _matchLabel.font = [UIFont dp_systemFontOfSize:12] ;
        _matchLabel.textColor = [UIColor dp_colorFromRGB:0x7E6B5B] ;
    }
    
    return _matchLabel ;
}

@end

@interface DPJczqOptimizeAnalysisCell (){
    @private
//    BOOL _hasLoaded;

}

@end
@implementation DPJczqOptimizeAnalysisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        _sessionArray = [[NSMutableArray alloc]init];
        _homeArray=[[NSMutableArray alloc]init];
        _awayArray =[[NSMutableArray alloc]init];
        _contentArray = [[NSMutableArray alloc]init];
    }
    return self;
}


//-(void)willMoveToSuperview:(UIView *)newSuperview{
//
//    [super willMoveToSuperview:newSuperview] ;
//    if (newSuperview) {
//        [self buildLayout];
//    }
//}
-(void)buildLayout{
    
    UIView* contentView = self.contentView ;
    UIImageView* arrowImage =  [[UIImageView alloc] initWithImage:dp_TogetherBuyImage(@"arrow.png")];
    
    UIView* bgView = ({
        UIView* view = [UIView dp_viewWithColor:[UIColor colorWithRed:0.19 green:0.25 blue:0.29 alpha:1]] ;
        view ;
    }) ;
    
    [contentView addSubview:arrowImage];
    [contentView addSubview:bgView] ;
    
    
    UILabel* sessionLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0x9BB0BF)];
    UILabel* homeLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0x9BB0BF)] ;
    UILabel *awayLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0x9BB0BF)] ;
    UILabel* contentLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0x9BB0BF)] ;
    sessionLabel.text = @"场次" ;
    homeLabel.text = @"主队";
    awayLabel.text = @"客队" ;
    contentLabel.text = @"投注内容" ;
    
    
    [bgView addSubview:sessionLabel];
    [bgView addSubview:homeLabel];
    [bgView addSubview:awayLabel];
    [bgView addSubview:contentLabel];
    
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView) ;
        make.right.equalTo(contentView).offset(-18.5) ;
        make.height.equalTo(@5) ;
        make.width.equalTo(@8) ;
    }] ;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arrowImage.mas_bottom) ;
        make.bottom.equalTo(contentView) ;
        make.left.equalTo(contentView) ;
        make.width.equalTo(contentView) ;
    }];
    
    [sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(-1) ;
        make.width.equalTo(bgView).multipliedBy(0.25) ;
        make.height.equalTo(@25) ;
        make.top.equalTo(bgView).offset(3) ;
    }] ;
    
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sessionLabel.mas_right).offset(-1) ;
        make.width.equalTo(bgView).multipliedBy(0.25) ;
        make.height.equalTo(@25) ;
        make.top.equalTo(bgView).offset(3) ;
    }] ;
    
    [awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeLabel.mas_right).offset(-1) ;
        make.width.equalTo(bgView).multipliedBy(0.25) ;
        make.height.equalTo(@25) ;
        make.top.equalTo(bgView).offset(3) ;
    }] ;

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(awayLabel.mas_right).offset(-1) ;
        make.right.equalTo(bgView).offset(1) ;
        make.height.equalTo(@25) ;
        make.top.equalTo(bgView).offset(3) ;
    }] ;


}



-(void)buildContentWithSportCount:(NSInteger)sportCount {

    for (int i=0,j = 1; i<sportCount; i++,j++) {
        UILabel* sessionLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0xFCFCFC)];
        UILabel* homeLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0xFCFCFC)] ;
        UILabel *awayLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0xFCFCFC)] ;
        UILabel *contentLabel = [self pvt_titleLabelFactoryWithTextColor:UIColorFromRGB(0xFCFCFC)] ;
//        MDHTMLLabel *contentLabel = ({
//        
//            MDHTMLLabel * label = [[MDHTMLLabel alloc]init];
//            label.textColor = UIColorFromRGB(0xFCFCFC) ;
//            label.textAlignment = NSTextAlignmentCenter ;
//            label ;
//        }) ;
        
        
        sessionLabel.text = @"场次" ;
        homeLabel.text = @"主队";
        awayLabel.text = @"客队" ;
//        contentLabel.htmlText =  [NSString stringWithFormat:@"<font size = 12 color=\"#FCFCFC\">%@</font><font size = 10 color=\"#FCFCFC\">%@</font>", @"胜", @"1:9"];
        contentLabel.text = @"投注内容";

        [_sessionArray addObject:sessionLabel];
        [_homeArray addObject:homeLabel];
        [_awayArray addObject:awayLabel];
        [_contentArray addObject:contentLabel];

        
        [self.contentView addSubview:sessionLabel];
        [self.contentView addSubview:homeLabel];
        [self.contentView addSubview:awayLabel];
        [self.contentView addSubview:contentLabel];
        
        [sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(-1) ;
            make.width.equalTo(self.contentView).multipliedBy(0.25) ;
            make.height.equalTo(@25) ;
            make.top.equalTo(self.contentView).offset(offSet+i*cellHigh-j) ;
        }] ;
        
        [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sessionLabel.mas_right).offset(-1) ;
            make.width.equalTo(self.contentView).multipliedBy(0.25) ;
            make.height.equalTo(@25) ;
            make.top.equalTo(self.contentView).offset(offSet+i*cellHigh-j) ;

        }] ;
        
        [awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(homeLabel.mas_right).offset(-1) ;
            make.width.equalTo(self.contentView).multipliedBy(0.25) ;
            make.height.equalTo(@25) ;
            make.top.equalTo(self.contentView).offset(offSet+i*cellHigh-j) ;

        }] ;
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(awayLabel.mas_right).offset(-1) ;
            make.right.equalTo(self.contentView).offset(1) ;
            make.height.equalTo(@25) ;
            make.top.equalTo(self.contentView).offset(offSet+i*cellHigh-j) ;

        }] ;
        
        
    }

}
- (UILabel *)pvt_titleLabelFactoryWithTextColor:(UIColor*)color
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = color ;//UIColorFromRGB(0x9BB0BF);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    label.layer.borderWidth = 1;
    return label;
}


@end
