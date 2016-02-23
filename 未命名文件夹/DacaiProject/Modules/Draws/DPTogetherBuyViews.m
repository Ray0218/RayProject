//
//  DPTogetherBuyViews.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPTogetherBuyViews.h"
#import <MDHTMLLabel/MDHTMLLabel.h>
#import "DPImageLabel.h"

#define kDengjiViewBaseTag 80
#define kDengjiLabelTag 60
@interface DPTogetherBuyCell () {
@private
    UIView      *_dengjiView;
}
@property (nonatomic, strong, readonly)UIView *dengjiView;
@end

@implementation DPTogetherBuyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _initialize];
        [self buildLayout];
    }
    return self;
}

- (void)_initialize {
    _gameTypeLabel = [[UILabel alloc] init];
    _gameTypeLabel.backgroundColor = [UIColor clearColor];
    _gameTypeLabel.textColor    = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
    _gameTypeLabel.font = [UIFont dp_systemFontOfSize:11];
    
    _subscriptionLabel = [[UILabel alloc] init];
    _subscriptionLabel.backgroundColor = [UIColor clearColor];
    _subscriptionLabel.textColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    _subscriptionLabel.font = [UIFont dp_regularArialOfSize:35];
    
    _guaranteeLabel = [[DPImageLabel alloc] init];
    _guaranteeLabel.backgroundColor = [UIColor clearColor];
    _guaranteeLabel.textColor = [UIColor colorWithRed:0.98 green:0.44 blue:0 alpha:1];
    _guaranteeLabel.imagePosition = DPImagePositionLeft;
    _guaranteeLabel.font = [UIFont dp_regularArialOfSize:10];
    _guaranteeLabel.spacing = 1;
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.textColor = [UIColor dp_flatBlackColor];
    _userNameLabel.font = [UIFont dp_systemFontOfSize:12];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.backgroundColor = [UIColor clearColor];
    _amountLabel.textColor = [UIColor dp_flatBlackColor];
    _amountLabel.font = [UIFont dp_systemFontOfSize:14];
    
    _surplusLabel = [[UILabel alloc] init];
    _surplusLabel.backgroundColor = [UIColor clearColor];
    _surplusLabel.textColor = [UIColor dp_flatRedColor];
    _surplusLabel.font = [UIFont dp_systemFontOfSize:14];
    
    
    _arrowView = [[UIImageView alloc]initWithImage:dp_TogetherBuyImage(@"jtx.png")];
    _arrowView.backgroundColor = [UIColor clearColor] ;
    
    
    
    _turnoutLabel = [[UILabel alloc] init];
    _turnoutLabel.backgroundColor = [UIColor clearColor];
    _turnoutLabel.textColor = [UIColor dp_flatBlackColor];
    _turnoutLabel.font = [UIFont dp_systemFontOfSize:14];
}



- (void)buildLayout {
    UIView *leftView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIView *rightView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:dp_TogetherBuyImage(@"cell_line@2x.png")];
    
    [self.contentView addSubview:leftView];
    [self.contentView addSubview:rightView];
    [self.contentView addSubview:separatorLine];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@75);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(self.contentView);
    }];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView.mas_bottom);
    }];
    
    // left view
    
    UILabel *percentLabel = [[UILabel alloc] init];
    percentLabel.textColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    percentLabel.font = [UIFont dp_regularArialOfSize:10];
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.text = @"%";
    
    [leftView addSubview:self.gameTypeLabel];
    [leftView addSubview:self.subscriptionLabel];
    [leftView addSubview:percentLabel];
    [leftView addSubview:self.guaranteeLabel];
    
    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.bottom.equalTo(self.subscriptionLabel.mas_top).offset(2);
    }];
    [self.subscriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.centerY.equalTo(leftView).offset(2);
    }];
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subscriptionLabel.mas_right);
        make.bottom.equalTo(self.subscriptionLabel).offset(-3);
    }];
    [self.guaranteeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.equalTo(self.subscriptionLabel.mas_bottom).offset(-3);
    }];
    
    self.gameTypeLabel.text = @"双色球";
    self.subscriptionLabel.text = @"75";
    self.guaranteeLabel.text = @"20%";
    self.guaranteeLabel.image = dp_TogetherBuyImage(@"guarantee.png");
    
    // right view
    
    UIImageView *separatorImageLine = ({
        [[UIImageView alloc] initWithImage:dp_TogetherBuyImage(@"separator.png")];
    });
    UIImageView *peopleImageView = ({
        [[UIImageView alloc] initWithImage:dp_TogetherBuyImage(@"people.png")];
    });
    
    
    UILabel *amountPlaceholder = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.73 green:0.67 blue:0.6 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.text = @"方案金额";
        label;
    });
    UILabel *surplusPlaceholder = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.73 green:0.67 blue:0.6 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.text = @"可认购";
        label;
    });
    UILabel *turnoutPlaceholder = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.73 green:0.67 blue:0.6 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.text = @"参与人数";
        label;
    });
    
    [rightView addSubview:separatorImageLine];
    [rightView addSubview:peopleImageView];
    [rightView addSubview:self.userNameLabel];
    [rightView addSubview:amountPlaceholder];
    [rightView addSubview:surplusPlaceholder];
    [rightView addSubview:turnoutPlaceholder];
    [rightView addSubview:self.amountLabel];
    [rightView addSubview:self.surplusLabel];
    [rightView addSubview:self.turnoutLabel];
    [rightView addSubview:self.arrowView];
    [rightView addSubview:self.dengjiView];
    [separatorImageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView).offset(28);
        make.left.equalTo(rightView).offset(10);
        make.right.equalTo(rightView).offset(-5);
    }];
    [peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(separatorImageLine.mas_bottom).offset(-10);
        make.left.equalTo(rightView).offset(5);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peopleImageView);
        make.left.equalTo(peopleImageView.mas_right).offset(2);
    }];
    
    [self.dengjiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightView).offset(- 10);
        make.centerY.equalTo(peopleImageView);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
    
    [amountPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView).offset(20);
        make.top.equalTo(separatorImageLine.mas_bottom).offset(5);
    }];
    [surplusPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView);
        make.top.equalTo(separatorImageLine.mas_bottom).offset(5);
    }];
    [turnoutPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightView).offset(-20);
        make.top.equalTo(separatorImageLine.mas_bottom).offset(5);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(amountPlaceholder);
        make.top.equalTo(amountPlaceholder.mas_bottom).offset(2);
    }];
    [self.surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(surplusPlaceholder);
        make.top.equalTo(surplusPlaceholder.mas_bottom).offset(2);
    }];
    
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.surplusLabel.mas_right).offset(2) ;
        make.centerY.equalTo(self.surplusLabel) ;
        make.width.equalTo(@13) ;
        make.height.equalTo(@13) ;
    }];
    [self.turnoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(turnoutPlaceholder);
        make.top.equalTo(turnoutPlaceholder.mas_bottom).offset(2);
    }];
    
    self.userNameLabel.text = @"勇敢的心";
    self.amountLabel.text = @"12304";
    self.surplusLabel.text = @"123";
    self.turnoutLabel.text = @"2";
}
- (UIView *)dengjiView
{
    if (_dengjiView == nil) {
        _dengjiView = [[UIView alloc]init];
        _dengjiView.backgroundColor = [UIColor clearColor];
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        UIView *foreView = _dengjiView;
        for (int i = 3; i >= 0 ; i--) {
            NSString *imageName = [NSString stringWithFormat:@"dengji%d.png", i + 1];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:dp_ProjectImage(imageName)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.tag = kDengjiViewBaseTag + i;
            [_dengjiView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 3) {
                    make.right.equalTo(foreView);
                }else{
                    make.right.equalTo(foreView.mas_left).offset(- 2);
                }
                make.centerY.equalTo(_dengjiView);
            }];
            foreView = imageView;
            
            UIImageView *backImageView = [[UIImageView alloc] initWithImage:dp_ProjectImage(@"textback.png")];
            [imageView addSubview:backImageView];
            UILabel *label = ({
                UILabel *textLabel = [[UILabel alloc] init];
                textLabel.text = @"1";
                textLabel.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0.11 alpha:1];
                textLabel.backgroundColor = [UIColor clearColor];
                textLabel.font = [UIFont systemFontOfSize:9];
                textLabel.textAlignment = NSTextAlignmentRight;
                textLabel.tag = kDengjiLabelTag;
                textLabel;
            });
            [imageView addSubview:label];
             [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(imageView);
                make.bottom.equalTo(imageView);
                make.width.equalTo(@9);
                make.height.equalTo(@9);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(backImageView);
                make.width.equalTo(@7);
                make.height.equalTo(@7);
            }];

        }
    }
    return _dengjiView;
}
- (void)setDengjiArray:(NSArray *)dengjiArray
{
    _dengjiArray = dengjiArray;
    
    if (dengjiArray.count != 4) {
        DPLog(@"等级数据不全");
        return;
    }
    
    int viewTag = 3;
    for (int i = 3; i >= 0; i--) {
        int number = [dengjiArray[i] intValue];
        if (number > 0) {
            UIImageView *imageView = (UIImageView *)[self.dengjiView viewWithTag:viewTag + kDengjiViewBaseTag];
            UILabel *textLabel = (UILabel *)[imageView viewWithTag:kDengjiLabelTag];
            imageView.hidden = NO;
            NSString *imageName = [NSString stringWithFormat:@"dengji%d.png", i + 1];
            imageView.image = dp_ProjectImage(imageName);
            textLabel.text = [NSString stringWithFormat:@"%d", number];
            viewTag --;
        }
    }
    for (int i = 0; i < viewTag + 1; i++) {
        UIImageView *imageView = (UIImageView *)[self.dengjiView viewWithTag:i + kDengjiViewBaseTag];
        imageView.hidden = YES;
    }
}
@end

@implementation DPTogetherBuyAppendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initialize];
        [self buildLayout];
    }
    return self;
}

- (void)_initialize {
    _amountField = [[UITextField alloc] init];
    _amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _amountField.backgroundColor = [UIColor dp_flatWhiteColor];
    _amountField.leftViewMode = UITextFieldViewModeAlways;
    _amountField.font = [UIFont dp_systemFontOfSize:12];
    _amountField.keyboardType = UIKeyboardTypeNumberPad;
    _amountField.leftView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        view;
    });
    _amountField.inputAccessoryView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.74 alpha:1];
        view.userInteractionEnabled = NO;
        view;
    });
}

- (void)buildLayout {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_TogetherBuyResizeImage(@"bg.png")];
    
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(-4, 0, 0, 0));
    }];
    
    UIButton *buyoutButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor colorWithRed:0.52 green:0.42 blue:0.26 alpha:1]];
        [button setTitle:@"全包" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button addTarget:self action:@selector(pvt_onBuyout) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *payButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"购  买" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button addTarget:self action:@selector(pvt_onPay) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.contentView addSubview:self.amountField];
    [self.contentView addSubview:buyoutButton];
    [self.contentView addSubview:payButton];
    
    [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@95);
    }];
    [buyoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountField.mas_right);
        make.top.equalTo(self.amountField);
        make.bottom.equalTo(self.amountField);
        make.width.equalTo(@33);
    }];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.amountField);
        make.bottom.equalTo(self.amountField);
        make.width.equalTo(@55);
    }];
}

- (void)pvt_onBuyout {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyoutTogetherBuyAppendCell:)]) {
        [self.delegate buyoutTogetherBuyAppendCell:self];
    }
}

- (void)pvt_onPay {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payTogetherBuyAppendCell:)]) {
        [self.delegate payTogetherBuyAppendCell:self];
    }
}

@end



