//
//  DPRedPacketViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRedPacketViewController.h"
#import "MDHTMLLabel.h"
#import "FrameWork.h"
#import "DPRedPacketView.h"
#import "DPTogetherBuySetController.h"
#import "DPSmartFollowVC.h"
#import "DPSmartPlanSetView.h"
#import "DPRechargeToPayVC.h"
#import "DPAppParser.h"

#define kPageWidth 85.0f
#define kPageHeight 122.0f

@interface DPRedPacketViewController () <UIScrollViewDelegate> {
}

@property (nonatomic, strong, readonly) UILabel *gameTypeLabel;
@property (nonatomic, strong, readonly) UILabel *gameNameLabel;

@property (nonatomic, strong, readonly) UILabel *projectAmtLabel;
@property (nonatomic, strong, readonly) UILabel *redPacketAmtLabel;
@property (nonatomic, strong, readonly) UILabel *realPayAmtLabel;
@property (nonatomic, strong, readonly) UILabel *balanceLabel;

@property (nonatomic, strong, readonly) UIView *pickerView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) UIImageView *redElpArrowView;
@property (nonatomic, strong, readonly) UIButton *leftArrowButton;
@property (nonatomic, strong, readonly) UIButton *rightArrowButton;

@property (nonatomic, strong) NSArray *redElpViews;
@property (nonatomic, assign) int gameIssueInt;
@property(nonatomic,assign)int  lastGame;
@end

@implementation DPRedPacketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
   [self.navigationController dp_applyGlobalTheme];
    self.navigationItem.title = @"确认支付";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];

    [self _initialize];
    [self _buildLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.leftArrowButton.hidden = scrollView.contentOffset.x <= 0;
    self.rightArrowButton.hidden = scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.bounds.size.width);
}

- (void)_initialize {
    _gameTypeLabel = [[UILabel alloc] init];
    _gameTypeLabel.backgroundColor = [UIColor clearColor];
    _gameTypeLabel.textColor = [UIColor dp_flatBlackColor];
    _gameTypeLabel.font = [UIFont dp_systemFontOfSize:15];

    _gameNameLabel = [[UILabel alloc] init];
    _gameNameLabel.backgroundColor = [UIColor clearColor];
    _gameNameLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _gameNameLabel.font = [UIFont dp_systemFontOfSize:11];

    _projectAmtLabel = [[UILabel alloc] init];
    _projectAmtLabel.backgroundColor = [UIColor clearColor];
    _projectAmtLabel.textColor = [UIColor dp_flatRedColor];
    _projectAmtLabel.font = [UIFont dp_systemFontOfSize:14];

    _redPacketAmtLabel = [[UILabel alloc] init];
    _redPacketAmtLabel.backgroundColor = [UIColor clearColor];
    _redPacketAmtLabel.textColor = [UIColor colorWithRed:0.05 green:0.5 blue:0.12 alpha:1];
    _redPacketAmtLabel.font = [UIFont dp_systemFontOfSize:14];

    _realPayAmtLabel = [[UILabel alloc] init];
    _realPayAmtLabel.backgroundColor = [UIColor clearColor];
    _realPayAmtLabel.textColor = [UIColor dp_flatRedColor];
    _realPayAmtLabel.font = [UIFont dp_systemFontOfSize:14];

    _balanceLabel = [[UILabel alloc] init];
    _balanceLabel.backgroundColor = [UIColor clearColor];
    _balanceLabel.textColor = [UIColor dp_flatRedColor];
    _balanceLabel.font = [UIFont dp_systemFontOfSize:14];

    _pickerView = [[UIView alloc] init];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.clipsToBounds = YES;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.delegate = self;

    _redElpArrowView = [[UIImageView alloc] initWithImage:dp_RedPacketImage(@"up.png") highlightedImage:dp_RedPacketImage(@"down.png")];

    _leftArrowButton = [[UIButton alloc] init];
    [_leftArrowButton setImage:dp_RedPacketImage(@"left.png") forState:UIControlStateNormal];
    [_leftArrowButton setAdjustsImageWhenHighlighted:NO];
    _rightArrowButton = [[UIButton alloc] init];
    [_rightArrowButton setImage:dp_RedPacketImage(@"right.png") forState:UIControlStateNormal];
    [_rightArrowButton setAdjustsImageWhenHighlighted:NO];

    [_leftArrowButton addTarget:self action:@selector(pvt_onTap:) forControlEvents:UIControlEventTouchUpInside];
    [_rightArrowButton addTarget:self action:@selector(pvt_onTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pvt_onTap:(UIButton *)button {
    if (button == _leftArrowButton) {
        for (int i = self.redElpViews.count - 1; i >= 0; i--) {
            UIView *view = self.redElpViews[i];
            if (CGRectGetMinX(view.frame) < self.scrollView.contentOffset.x) {
                [self.scrollView scrollRectToVisible:view.frame animated:YES];
                break;
            }
        }
    } else {
        for (int i = 0; i < self.redElpViews.count; i++) {
            UIView *view = self.redElpViews[i];
            if (CGRectGetMaxX(view.frame) > self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds)) {
                [self.scrollView scrollRectToVisible:view.frame animated:YES];
                break;
            }
        }
    }
}

- (void)_buildLayout {
    UIView *gameView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIView *projectAmtView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIView *redPacketView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIView *realPayView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIView *balanceView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UIButton *payButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"立即支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:18]];
        [button addTarget:self action:@selector(pvt_onPay) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    [self.view addSubview:gameView];
    [self.view addSubview:projectAmtView];
    if (self.isredPacket) {
        [self.view addSubview:redPacketView];
        [self.view addSubview:self.pickerView];
    }
    [self.view addSubview:realPayView];
    [self.view addSubview:balanceView];
    [self.view addSubview:payButton];

    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@38);
    }];
    [projectAmtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(gameView.mas_bottom);
        make.height.equalTo(@34);
    }];
    if (self.isredPacket) {
        [redPacketView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(projectAmtView.mas_bottom);
            make.height.equalTo(@34);
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(redPacketView.mas_bottom);
            make.height.equalTo(@(kPageHeight));
        }];
        [realPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.pickerView.mas_bottom);
            make.height.equalTo(@34);
        }];

    } else {
        [realPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(projectAmtView.mas_bottom);
            make.height.equalTo(@34);
        }];
    }

    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(realPayView.mas_bottom);
        make.height.equalTo(@34);
    }];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(balanceView.mas_bottom);
        make.height.equalTo(@33);
    }];

    UIView *separatorLine1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
        view;
    });
    UIView *separatorLine2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
        view;
    });
    UIView *separatorLine3 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.92 green:0.89 blue:0.84 alpha:1];
        view;
    });
    UIView *separatorLine4 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
        view;
    });
    UIView *separatorLine5 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
        view;
    });

    [projectAmtView addSubview:separatorLine1];
    if (self.isredPacket) {
        [redPacketView addSubview:separatorLine2];
        [self.pickerView addSubview:separatorLine3];
    }

    [realPayView addSubview:separatorLine4];
    [balanceView addSubview:separatorLine5];

    [separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectAmtView);
        make.left.equalTo(projectAmtView);
        make.right.equalTo(projectAmtView);
        make.height.equalTo(@0.5);
    }];
    if (self.isredPacket) {
        [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redPacketView);
        make.left.equalTo(redPacketView).offset(17);
        make.right.equalTo(redPacketView).offset(-17);
        make.height.equalTo(@0.5);
        }];
        [separatorLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerView);
        make.left.equalTo(self.pickerView).offset(17);
        make.right.equalTo(self.pickerView).offset(-17);
        make.height.equalTo(@0.5);
        }];
    }
    [separatorLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realPayView);
        make.left.equalTo(realPayView).offset(17);
        make.right.equalTo(realPayView).offset(-17);
        make.height.equalTo(@0.5);
    }];

    [separatorLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceView);
        make.left.equalTo(balanceView).offset(17);
        make.right.equalTo(balanceView).offset(-17);
        make.height.equalTo(@0.5);
    }];

    UILabel *projectAmtPlace = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:13];
        label.text = @"方案金额";
        label;
    });
    UILabel *redPacketPlace = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:13];
        label.text = @"使用红包";
        label;
    });
    UILabel *realPayPlace = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:13];
        label.text = @"实际应付";
        label;
    });
    UILabel *balancePlace = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:13];
        label.text = @"账户余额";
        label;
    });

    UILabel *projectAmtAppend = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text = @"元";
        label;
    });
    UILabel *redPacketAppend = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text = @"元";
        label;
    });
    UILabel *realPayAppend = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text = @"元";
        label;
    });
    UILabel *balanceAppend = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text = @"元";
        label;
    });

    [gameView addSubview:self.gameTypeLabel];
    [gameView addSubview:self.gameNameLabel];
    [projectAmtView addSubview:self.projectAmtLabel];
    [projectAmtView addSubview:projectAmtPlace];
    [projectAmtView addSubview:projectAmtAppend];
    if (self.isredPacket) {
        [redPacketView addSubview:self.redPacketAmtLabel];
        [redPacketView addSubview:redPacketPlace];
        [redPacketView addSubview:redPacketAppend];
        [redPacketView addSubview:self.redElpArrowView];
        [self.pickerView addSubview:self.scrollView];
        [self.pickerView addSubview:self.leftArrowButton];
        [self.pickerView addSubview:self.rightArrowButton];
    }
    [realPayView addSubview:self.realPayAmtLabel];
    [realPayView addSubview:realPayPlace];
    [realPayView addSubview:realPayAppend];
    [balanceView addSubview:self.balanceLabel];
    [balanceView addSubview:balancePlace];
    [balanceView addSubview:balanceAppend];

    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gameView);
        make.left.equalTo(gameView).offset(20);
    }];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gameTypeLabel);
        make.left.equalTo(self.gameTypeLabel.mas_right).offset(3);
    }];

    [projectAmtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(projectAmtView);
        make.left.equalTo(projectAmtView).offset(20);
    }];
    [projectAmtAppend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(projectAmtView);
        make.right.equalTo(projectAmtView).offset(-30);
    }];
    [self.projectAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(projectAmtAppend);
        make.right.equalTo(projectAmtAppend.mas_left);
    }];
    if (self.isredPacket) {
        [redPacketPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redPacketView);
        make.left.equalTo(redPacketView).offset(20);
        }];
        [redPacketAppend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redPacketView);
        make.right.equalTo(redPacketView).offset(-30);
        }];
        [self.redElpArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redPacketView);
        make.right.equalTo(redPacketView).offset(-8);
        }];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(3 * kPageWidth));
            make.height.equalTo(@(kPageHeight));
            make.top.equalTo(self.pickerView);
            make.centerX.equalTo(self.pickerView);
        }];
        [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pickerView).offset(-20);
            make.height.equalTo(@40);
            make.left.equalTo(self.view);
            make.right.equalTo(self.scrollView.mas_left);
        }];
        [self.rightArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pickerView).offset(-20);
            make.height.equalTo(@40);
            make.left.equalTo(self.scrollView.mas_right);
            make.right.equalTo(self.view);
        }];

        [self.redPacketAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redPacketView);
        make.right.equalTo(redPacketAppend.mas_left);
        }];
    }
    [realPayPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(realPayView);
        make.left.equalTo(realPayView).offset(20);
    }];
    [realPayAppend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(realPayView);
        make.right.equalTo(realPayView).offset(-30);
    }];
    [self.realPayAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(realPayAppend);
        make.right.equalTo(realPayAppend.mas_left);
    }];
    [balancePlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceView);
        make.left.equalTo(balanceView).offset(20);
    }];
    [balanceAppend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceView);
        make.right.equalTo(balanceView).offset(-30);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceAppend);
        make.right.equalTo(balanceAppend.mas_left);
    }];

    // 获取红包
    CAccount *instance = CFrameWork::GetInstance()->GetAccount();
    string realAmt;
    vector<int> identifier;
    vector<string> scope;
    vector<string> date;
    vector<int> curAmt;
    vector<int> origAmt;
    int count = instance->GetPayRedPacketInfo(realAmt, identifier, scope, date, curAmt, origAmt);
    //
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < count; i++) {
        DPRedPacketView *view = [[DPRedPacketView alloc] init];
        view.surplusLabel.htmlText = [NSString stringWithFormat:@"剩余<font color=\"#FF0000\">%d</font>元", curAmt[i]];
        view.limitLabel.text = [NSString stringWithUTF8String:scope[i].c_str()];
        view.validityLabel.text = [NSString stringWithUTF8String:date[i].c_str()];
        view.identifier = identifier[i];
        view.currentAmt = curAmt[i];
        view.tag = i;
        if (view.identifier == 0) {
            view.signLabel.text = nil;
            view.nameLabel.text = @"大彩币";
        } else {
            view.nameLabel.text = [NSString stringWithFormat:@"%d", origAmt[i]];
        }
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kPageWidth));
            make.height.equalTo(@(kPageHeight));
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
        }];
        [views addObject:view];

        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onSelected:)]];
    }
    [[views firstObject] setSelected:YES];
    [[views firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
    }];
    [views dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right);
        }];
    }];
    [[views lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView);
    }];

    //
    [redPacketView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onPicker)]];

    // 数据
    self.gameTypeLabel.text = self.gameTypeText;
    //    NSString *gameName = [self getGameNameTextBaseEntryType];
    self.gameNameText = [self setGameNameTextBaseEntryType];
    if (self.gameNameText != nil && self.gameNameText.length > 0) {
        self.gameNameLabel.text = self.gameNameText;
    }
    self.projectAmtLabel.text = [NSString stringWithFormat:@"%d", self.projectAmount];
    int redPayAmount = 0;
    if (self.isredPacket) {
        redPayAmount = MIN(self.projectAmount, curAmt[0]);
    }
    self.redPacketAmtLabel.text = [NSString stringWithFormat:@"-%d", redPayAmount];
    self.realPayAmtLabel.text = [NSString stringWithFormat:@"%d", self.projectAmount - redPayAmount];
    self.balanceLabel.text = realAmt.length() == 0 ? @"0" : [NSString stringWithUTF8String:realAmt.c_str()];
    self.redElpViews = views;
}

- (void)pvt_onPicker {
    [self.pickerView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstAttribute == NSLayoutAttributeHeight) {
            if (obj.constant == 0) {
                obj.constant = kPageHeight;
                self.redElpArrowView.highlighted = NO;
            } else {
                obj.constant = 0;
                self.redElpArrowView.highlighted = YES;
            }
            *stop = YES;
        }
    }];

    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)pvt_onSelected:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;

    if ([self.redElpViews[index] isSelected]) {
        [self.redElpViews[index] setSelected:NO];

        DPRedPacketView *view = [self.redElpViews firstObject];
        if ([view identifier] == 0) {
            [view setSelected:YES];
            [self.scrollView scrollRectToVisible:view.frame animated:YES];

            index = 0;
        } else {
            index = -1;
        }
    } else {
        [self.redElpViews enumerateObjectsUsingBlock:^(DPRedPacketView *obj, NSUInteger idx, BOOL *stop) {
            obj.selected = idx == index;
        }];

        [self.scrollView scrollRectToVisible:[self.redElpViews[index] frame] animated:YES];
    }

    int redPayAmount = 0;
    if (index >= 0) {
        DPRedPacketView *view = self.redElpViews[index];
        redPayAmount = MIN(self.projectAmount, view.currentAmt);
    }
    self.redPacketAmtLabel.text = [NSString stringWithFormat:@"-%d", redPayAmount];
    self.realPayAmtLabel.text = [NSString stringWithFormat:@"%d", self.projectAmount - redPayAmount];
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onPay {
    int identifier = 0;
    for (DPRedPacketView *view in self.redElpViews) {
        if (view.isSelected) {
            identifier = view.identifier;
            break;
        }
    }
    // 这里不会行程循环引用
    void (^goPayBlock)(UIAlertView * alertView, NSInteger buttonIndex) = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 1) {
            // 上个界面
            UIViewController *viewController = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
            // 如果是合买设置或者是智能追号, 上上个界面为中转界面
            if ([viewController isKindOfClass:[DPSmartFollowVC class]] || [viewController isKindOfClass:[DPTogetherBuySetController class]]) {
                viewController = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
            }
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
        
        if (self.buyType == 2) {
            CFrameWork::GetInstance()->GetAccount()->SetDelegate(self);
            if (CFrameWork::GetInstance()->GetAccount()->JoinBuy(self.rengouType, self.projectid, self.projectAmount, self.gameType, identifier)) {
                [self showDarkHUD];
            } else {
                [[DPToast makeText:@"下单失败"] show];
            }
            return;
        }
        if (self.lastGame != 0) {
            self.gameIssueInt = self.lastGame;
        }
        int ret = 0;
        switch (self.gameType) {
            case GameTypeSd:
                CFrameWork::GetInstance()->GetLottery3D()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLottery3D()->GoPay(identifier);
                break;
            case GameTypeSsq:
                CFrameWork::GetInstance()->GetDoubleChromosphere()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetDoubleChromosphere()->GoPay(identifier);
                break;
            case GameTypeQlc:
                CFrameWork::GetInstance()->GetSevenLuck()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetSevenLuck()->GoPay(identifier);
                break;
            case GameTypeDlt:
                CFrameWork::GetInstance()->GetSuperLotto()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetSuperLotto()->GoPay(identifier);
                break;
            case GameTypePs:
                CFrameWork::GetInstance()->GetPick3()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetPick3()->GoPay(identifier);
                break;
            case GameTypePw:
                CFrameWork::GetInstance()->GetPick5()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetPick5()->GoPay(identifier);
                break;
            case GameTypeQxc:
                CFrameWork::GetInstance()->GetSevenStar()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetSevenStar()->GoPay(identifier);
                break;
            case GameTypeBdNone:
            case GameTypeBdRqspf:
            case GameTypeBdSxds:
            case GameTypeBdZjq:
            case GameTypeBdBf:
            case GameTypeBdBqc:
            case GameTypeBdSf:
                CFrameWork::GetInstance()->GetLotteryBd()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLotteryBd()->GoPay(identifier);
                break;
            case GameTypeNmgks:
                CFrameWork::GetInstance()->GetQuickThree()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetQuickThree()->GoPay(identifier);
                break;
            case GameTypeSdpks:
                CFrameWork::GetInstance()->GetPokerThree()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetPokerThree()->GoPay(identifier);
                break;
            case GameTypeJxsyxw:
                CFrameWork::GetInstance()->GetJxsyxw()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetJxsyxw()->GoPay(identifier);
                break;
            case GameTypeJcNone:
            case GameTypeJcRqspf:
            case GameTypeJcBf:
            case GameTypeJcZjq:
            case GameTypeJcBqc:
            case GameTypeJcGJ:
            case GameTypeJcGYJ:
            case GameTypeJcHt:
            case GameTypeJcSpf:
                CFrameWork::GetInstance()->GetLotteryJczq()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLotteryJczq()->GoPay(identifier);
                break;
            case GameTypeLcNone:
            case GameTypeLcSf:
            case GameTypeLcRfsf:
            case GameTypeLcSfc:
            case GameTypeLcDxf:
            case GameTypeLcHt:
                CFrameWork::GetInstance()->GetLotteryJclq()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLotteryJclq()->GoPay(identifier);
                break;
            case GameTypeZc14:
                CFrameWork::GetInstance()->GetLotteryZc14()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLotteryZc14()->GoPay(identifier);
                break;
            case GameTypeZc9:
                CFrameWork::GetInstance()->GetLotteryZc9()->SetDelegate(self);
                ret = CFrameWork::GetInstance()->GetLotteryZc9()->GoPay(identifier);
                break;
            default:
                break;
        }
        if (ret >= 0) {
            [self showDarkHUD];
        } else {
            if(!IsGameTypeSport(self.gameType)){
                if (ret==ERROR_NO_DATA) {
                    [[DPToast makeText:@"未取到期号"] show];
                }else if(ret==ERROR_PARAMETER){
                    [[DPToast makeText:@"数据错误"] show];
                }
            }
        }
    };

    if (self.entryType == kEntryTypeFollow || self.entryType == kEntryTypeDefault) {
        int gameName = 0, globalPlus = 0;
        string endTime;
        bool needAlert = YES;
        switch (self.gameType) {
            case GameTypeSd: {
                CFrameWork::GetInstance()->GetLottery3D()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypeSsq: {
                CFrameWork::GetInstance()->GetDoubleChromosphere()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypeQlc: {
                CFrameWork::GetInstance()->GetSevenLuck()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypeDlt: {
                CFrameWork::GetInstance()->GetSuperLotto()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypePs: {
                CFrameWork::GetInstance()->GetPick3()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypePw: {
                CFrameWork::GetInstance()->GetPick5()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypeQxc: {
                CFrameWork::GetInstance()->GetSevenStar()->GetInfo(gameName, endTime, globalPlus);
            } break;
            case GameTypeNmgks: {
                CFrameWork::GetInstance()->GetQuickThree()->GetInfo(gameName, endTime);
            } break;
            case GameTypeSdpks: {
                CFrameWork::GetInstance()->GetPokerThree()->GetInfo(gameName, endTime);
            } break;
            case GameTypeJxsyxw: {
                CFrameWork::GetInstance()->GetJxsyxw()->GetInfo(gameName, endTime);
            } break;
            default: {
                needAlert = NO;
            } break;
        }
        
        self.lastGame = gameName;
        if (needAlert && self.gameIssueInt != 0 && gameName != self.gameIssueInt) {
            NSString *msg = [NSString stringWithFormat:@"%d期已截止, 当前在售期为%d期, 是否继续购买?", self.gameIssueInt, gameName];
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[ @"确定" ] handler:goPayBlock];
            return;
        }
    }
    goPayBlock(nil, 1);
}

- (NSString *)setGameNameTextBaseEntryType {
    int gameName = 0, globalPlus = 0, onScale = 0;
    self.gameIssueInt = 0;
    string endTime, deadLine;
    switch (self.entryType) {
        case kEntryTypeProject:
        case kEntryTypeTogetherBuy: {
            if ((int)self.gameType >= 120 && (int)self.gameType <= 135) {
                return nil;
            }
            self.gameIssueInt = [self.gameNameText intValue];
            return self.gameNameText;
        } break;
        case kEntryTypeFollow:
        case kEntryTypeDefault: {
            switch (self.gameType) {
                case GameTypeSd: {
                    CLottery3D *sd = CFrameWork::GetInstance()->GetLottery3D();
                    sd->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypeSsq: {
                    CDoubleChromosphere *ssq = CFrameWork::GetInstance()->GetDoubleChromosphere();
                    ssq->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypeQlc: {
                    CSevenLuck *qlc = CFrameWork::GetInstance()->GetSevenLuck();
                    qlc->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypeDlt: {
                    CSuperLotto *dlt = CFrameWork::GetInstance()->GetSuperLotto();
                    dlt->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypePs: {
                    CPick3 *p3 = CFrameWork::GetInstance()->GetPick3();
                    p3->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypePw: {
                    CPick5 *p5 = CFrameWork::GetInstance()->GetPick5();
                    p5->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypeQxc: {
                    CSevenStar *qxc = CFrameWork::GetInstance()->GetSevenStar();
                    qxc->GetInfo(gameName, endTime, globalPlus);
                } break;
                case GameTypeNmgks: {
                    CQuickThree *ks = CFrameWork::GetInstance()->GetQuickThree();
                    ks->GetInfo(gameName, endTime);
                } break;
                case GameTypeSdpks: {
                    CPokerThree *pk3 = CFrameWork::GetInstance()->GetPokerThree();
                    pk3->GetInfo(gameName, endTime);
                } break;
                case GameTypeJxsyxw: {
                    CJxsyxw *syxw = CFrameWork::GetInstance()->GetJxsyxw();
                    syxw->GetInfo(gameName, endTime);
                } break;
                case GameTypeBdNone:
                case GameTypeBdRqspf:
                case GameTypeBdSxds:
                case GameTypeBdZjq:
                case GameTypeBdBf:
                case GameTypeBdBqc:
                case GameTypeBdSf: {
                    CLotteryBd *Bd = CFrameWork::GetInstance()->GetLotteryBd();
                    Bd->GetInfo(gameName);
                } break;
                case GameTypeZc14: {
                    CLotteryZc14 *zc14 = CFrameWork::GetInstance()->GetLotteryZc14();
                    zc14->GetGameInfo(gameName, onScale, deadLine, globalPlus);
                } break;
                case GameTypeZc9: {
                    CLotteryZc9 *zc9 = CFrameWork::GetInstance()->GetLotteryZc9();
                    zc9->GetGameInfo(gameName, onScale, deadLine, globalPlus);
                } break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    if (gameName <= 0) {
        self.gameIssueInt = 0;
        return nil;
    }
    self.gameIssueInt = gameName;
    if (kEntryTypeFollow == self.entryType) {
        return nil;
    }
    return [NSString stringWithFormat:@"%d期", gameName];
}

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window dismissHUD];

        if (cmdType != GOPLAY && cmdType != ACCOUNT_JOINBUY) {
            return;
        }
        if (ret < 0) {
            if (cmdType == ACCOUNT_JOINBUY) {
                [[DPToast makeText:DPAccountErrorMsg(ret)] show];
            } else {
                [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
            }
            return;
        }
        if (cmdType == GOPLAY) {
            int type = 0;
            int orderId = 0, projectId = 0;
            int needAmt = 0;
            string realAmt;

            switch (self.gameType) {
                case GameTypeSd: {
                    CLottery3D *sd = CFrameWork::GetInstance()->GetLottery3D();
                    sd->GetPayInfo(type);
                    sd->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeSsq: {
                    CDoubleChromosphere *ssq = CFrameWork::GetInstance()->GetDoubleChromosphere();
                    ssq->GetPayInfo(type);
                    ssq->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeQlc: {
                    CSevenLuck *qlc = CFrameWork::GetInstance()->GetSevenLuck();
                    qlc->GetPayInfo(type);
                    qlc->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeDlt: {
                    CSuperLotto *dlt = CFrameWork::GetInstance()->GetSuperLotto();
                    dlt->GetPayInfo(type);
                    dlt->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypePs: {
                    CPick3 *p3 = CFrameWork::GetInstance()->GetPick3();
                    p3->GetPayInfo(type);
                    p3->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypePw: {
                    CPick5 *p5 = CFrameWork::GetInstance()->GetPick5();
                    p5->GetPayInfo(type);
                    p5->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypeQxc: {
                    CSevenStar *qxc = CFrameWork::GetInstance()->GetSevenStar();
                    qxc->GetPayInfo(type);
                    qxc->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypeNmgks: {
                    CQuickThree *ks = CFrameWork::GetInstance()->GetQuickThree();
                    ks->GetPayInfo(type);
                    ks->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeSdpks: {
                    CPokerThree *pk3 = CFrameWork::GetInstance()->GetPokerThree();
                    pk3->GetPayInfo(type);
                    pk3->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypeJxsyxw: {
                    CJxsyxw *syxw = CFrameWork::GetInstance()->GetJxsyxw();
                    syxw->GetPayInfo(type);
                    syxw->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeJcNone:
                case GameTypeJcRqspf:
                case GameTypeJcBf:
                case GameTypeJcZjq:
                case GameTypeJcBqc:
                case GameTypeJcGJ:
                case GameTypeJcGYJ:
                case GameTypeJcHt:
                case GameTypeJcSpf: {
                    CLotteryJczq *jczq = CFrameWork::GetInstance()->GetLotteryJczq();
                    jczq->GetPayInfo(type);
                    jczq->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;
                case GameTypeLcNone:
                case GameTypeLcSf:
                case GameTypeLcRfsf:
                case GameTypeLcSfc:
                case GameTypeLcDxf:
                case GameTypeLcHt: {
                    CLotteryJclq *jclq = CFrameWork::GetInstance()->GetLotteryJclq();
                    jclq->GetPayInfo(type);
                    jclq->GetNonPayment(orderId, projectId, needAmt, realAmt);
                } break;

                case GameTypeBdNone:
                case GameTypeBdRqspf:
                case GameTypeBdSxds:
                case GameTypeBdZjq:
                case GameTypeBdBf:
                case GameTypeBdBqc:
                case GameTypeBdSf: {
                    CLotteryBd *Bd = CFrameWork::GetInstance()->GetLotteryBd();
                    Bd->GetPayInfo(type);
                    Bd->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeZc14: {
                    CLotteryZc14 *zc14 = CFrameWork::GetInstance()->GetLotteryZc14();
                    zc14->GetPayInfo(type);
                    zc14->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                case GameTypeZc9: {
                    CLotteryZc9 *zc9 = CFrameWork::GetInstance()->GetLotteryZc9();
                    zc9->GetPayInfo(type);
                    zc9->GetNonPayment(orderId, projectId, needAmt, realAmt);

                } break;
                default:
                    break;
            }
            
            switch (type) {
                case 4: {
                    DPRechargeToPayVC *vc = [[DPRechargeToPayVC alloc] init];
                    vc.gameId = self.gameType;
                    vc.gameName = self.gameIssueInt;
                    vc.pid = orderId;
                    vc.projectId = projectId;
                    vc.needAmt = [NSString stringWithFormat:@"%d", needAmt];
                    vc.realAmt = [NSString stringWithUTF8String:realAmt.c_str()];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 1: {
                    if ([self.delegate respondsToSelector:@selector(pickView:notify:result:type:)]) {
                        [self.delegate pickView:self notify:cmdId result:ret type:cmdType];
                    }
                } break;
                case 5: {
                    [DPAppParser backToCenterRootViewController:YES];
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [av show];
                } break;
                default:
                    break;
            }
        } else if (cmdType == ACCOUNT_JOINBUY) {
            CAccount *account = CFrameWork::GetInstance()->GetAccount();
            int pid = 0, needAmt = 0, type = 0;
            string realAmt;
            account->GetJoinBuyPayInfo(type);
            switch (type) {
                case 4: {
                    account->GetJoinBuyNonPayment(pid, needAmt, realAmt);
                    
                    DPRechargeToPayVC *vc = [[DPRechargeToPayVC alloc] init];
                    vc.gameId = self.gameType;
                    vc.gameName = self.gameIssueInt;
                    vc.pid = pid;
                    vc.projectId = self.projectid;
                    vc.needAmt = [NSString stringWithFormat:@"%d", needAmt];
                    vc.realAmt = [NSString stringWithUTF8String:realAmt.c_str()];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 1: {
                    if ([self.delegate respondsToSelector:@selector(pickView:notify:result:type:)]) {
                        [self.delegate pickView:self notify:cmdId result:ret type:cmdType];
                    }
                } break;
                case 5: {
                    [DPAppParser backToCenterRootViewController:YES];
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [av show];
                } break;
                default:
                    break;
            }
        }
    });
}

@end
