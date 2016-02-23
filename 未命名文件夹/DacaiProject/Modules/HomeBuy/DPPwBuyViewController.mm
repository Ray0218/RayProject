//
//  DPPwBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <SevenSwitch/SevenSwitch.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPPwBuyViewController.h"
#import "DPHistoryTendencyCell.h"
#import "DPSdBuyCell.h"
#import "FrameWork.h"
#import "DPToast.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DPDigitalCommon.h"
#define TrendDragHeight 250

@interface DPPwBuyViewController () <UITableViewDelegate, UITableViewDataSource, DPSdBuyCellDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate> {
@private
    UIView *_drawedView;
    UILabel *_drawedLabel;
    UILabel *_endTimeLabel;

    UITableView *_trendView;

    UITableView *_tableView;
    UIView *_controlView;
    TTTAttributedLabel *_bonusLabel;
    SevenSwitch *_missSwitch;

    UIView *_submitView;
    UILabel *_zhushuLabel;
    NSLayoutConstraint *_tableConstraint;

    CPick5 *_pick5Instance;
    int _pwNumber[50];
}

@property (nonatomic, strong, readonly) UIView *drawedView;
@property (nonatomic, strong, readonly) UILabel *drawedLabel;
@property (nonatomic, strong, readonly) UILabel *endTimeLabel;

@property (nonatomic, strong, readonly) UITableView *trendView;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *controlView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *bonusLabel;
@property (nonatomic, strong, readonly) SevenSwitch *missSwitch;

@property (nonatomic, strong, readonly) UIView *submitView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *tableConstraint;

@property (nonatomic, assign) BOOL showHistory;
@property (nonatomic, strong) UILabel *zhushuLabel; //注数
@end

@implementation DPPwBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pick5Instance = CFrameWork::GetInstance()->GetPick5();

        for (int i = 0; i < 50; i++) {
            _pwNumber[i] = 0;
        }
        self.targetIndex = -1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_DigitalBetRefreshNofify object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf9f8ee); //[UIColor dp_flatBackgroundColor];
    self.navigationItem.title = @"排列五";

    UIView *contentView = self.view;

    [contentView addSubview:self.drawedView];
    [contentView addSubview:self.trendView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.submitView];

    [self.drawedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@25);
    }];
    [self.trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.drawedView.mas_bottom);
        make.bottom.equalTo(self.submitView.mas_top);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.drawedView.mas_bottom);
        make.bottom.equalTo(self.submitView.mas_top);
    }];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@45);
    }];

    [self pvt_navigationDidLoad];
    [self pvt_drawedViewDidLoad];
    [self pvt_submitViewDidLoad];
    [self pvt_controlViewDidLoad];

    [self pvt_reloadBonusLabel];
    
    if (self.targetIndex >= 0) {
        int num[50];
        int note;
        _pick5Instance->GetTarget(self.targetIndex, num, num + 10, num + 20, num + 30, num + 40, note);
        memcpy(_pwNumber, num, sizeof(int) * 50);
    }
    
    [self refreshNotify];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self calculateZhushu];
    [self.tableView reloadData];
    [self pvt_reloadBonusLabel];
    [self canBecomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)pvt_navigationDidLoad {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
}

- (void)pvt_drawedViewDidLoad {
    UILabel *drawedCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"上期开奖: ";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    UILabel *endTimeCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"当前期停售时间: ";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });

    UIView *contentView = self.drawedView;

    [contentView addSubview:drawedCommentLabel];
    [contentView addSubview:self.drawedLabel];
    [contentView addSubview:endTimeCommentLabel];
    [contentView addSubview:self.endTimeLabel];
    self.drawedLabel.font = [UIFont dp_systemFontOfSize:12.0];
    self.drawedLabel.textColor = [UIColor dp_flatRedColor];
    self.endTimeLabel.font = [UIFont dp_systemFontOfSize:12.0];
    self.endTimeLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    [drawedCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
    }];
    [self.drawedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(drawedCommentLabel.mas_right);
    }];
    [endTimeCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(endTimeCommentLabel.mas_right);
    }];
}

- (void)pvt_controlViewDidLoad {
    UIView *contentView = self.view;

    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.84 blue:0.76 alpha:1];
        view;
    });
    UIButton *indicateButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateNormal];
        [button setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(pvt_onTrend) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 20, 5)];
        button;
    });
    [contentView addSubview:line];
    [contentView addSubview:indicateButton];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.tableView);
        make.height.equalTo(@0.5);
    }];
    [indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];

    contentView = self.controlView;

    UILabel *missCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"遗漏";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.37 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:10];
        label;
    });

    [contentView addSubview:self.bonusLabel];
    [contentView addSubview:missCommentLabel];
    [contentView addSubview:self.missSwitch];

    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.missSwitch.mas_bottom).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.left.equalTo(contentView).offset(10);
    }];
    [missCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [missCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.missSwitch.mas_left).offset(-3);
            make.centerY.equalTo(contentView).offset(-12);
        }];
    }];
    [self.missSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(8);
        make.right.equalTo(contentView).offset(-20);
        make.width.equalTo(@52);
        make.height.equalTo(@25);
    }];
    UIButton *randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    randomButton.backgroundColor = [UIColor clearColor];
    [randomButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"randomSharkoff.png")] forState:UIControlStateNormal];
    [randomButton addTarget:self action:@selector(digitalDataRandom) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:randomButton];
    [randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.missSwitch);
        make.left.equalTo(contentView).offset(-1);
        make.height.equalTo(@27);
        make.width.equalTo(@111);
    }];

    self.tableView.tableHeaderView = self.controlView;
    self.trendView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.8 alpha:1];
        view;
    });
}

- (void)pvt_submitViewDidLoad {
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.84 blue:0.76 alpha:1];
        view;
    });
    UIButton *deleteButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:dp_CommonImage(@"delete001_21.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onClear) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIImageView *submitImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"sumit001_24.png")];
        imageView;
    });

    UIView *contentView = self.submitView;

    [contentView addSubview:deleteButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:self.zhushuLabel];
    [contentView addSubview:submitImageView];
    [contentView addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@55);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(deleteButton.mas_right);
        make.right.equalTo(contentView);
    }];
    [self.zhushuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton).offset(10);
        make.centerY.equalTo(submitButton);
    }];
    [submitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-15);
    }];
}

//
- (void)pvt_reloadBonusLabel {
    NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:@"5位全中，奖金100000元"];
        NSRange numberRange2 = [[bonusString string] rangeOfString:@"100000" options:NSCaseInsensitiveSearch];

    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] CGColor] range:NSMakeRange(0, bonusString.length)];
    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:numberRange2];

    [self.bonusLabel setText:bonusString];
}
- (void)pvt_onClear {
    for (int i = 0; i < 50; i++) {
        _pwNumber[i] = 0;
    }
    [self.tableView reloadData];
    [self calculateZhushu];
}
// event
- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 菜单

- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];
    
    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[@"开奖公告", @"玩法介绍", @"帮助"]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view);
    }];
    
    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
        tap.delegate = self;
        tap;
    })];
}

- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(NSInteger)index {
    [dropDownList.superview removeFromSuperview];
    
    UIViewController *viewController;
    
    switch (index) {
        case 0: {   // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = GameTypePw;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypePw)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;

                viewController;
            });
        }
            break;
        case 2: {   // 帮助
            viewController = [[DPHelpWebViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_onSwitch {
    [self.tableView reloadData];
}

- (void)pvt_onTrend {
    if (self.showHistory) {
        self.tableConstraint.constant = 0;
    } else {
        self.tableConstraint.constant = TrendDragHeight;
    }

    self.showHistory = self.tableConstraint.constant == TrendDragHeight;

    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)pvt_onSubmit {
    if ([self ballSelectedTotal:_pwNumber beginIndex:0] < 1) {
        [[DPToast makeText:@"万位至少选择一个号码"] show];
        return;
    }
    if ([self ballSelectedTotal:_pwNumber beginIndex:10] < 1) {
        [[DPToast makeText:@"千位至少选择一个号码"] show];
        return;
    }
    if ([self ballSelectedTotal:_pwNumber beginIndex:20] < 1) {
        [[DPToast makeText:@"百位至少选择一个号码"] show];
        return;
    }
    if ([self ballSelectedTotal:_pwNumber beginIndex:30] < 1) {
        [[DPToast makeText:@"十位至少选择一个号码"] show];
        return;
    }
    if ([self ballSelectedTotal:_pwNumber beginIndex:40] < 1) {
        [[DPToast makeText:@"个位至少选择一个号码"] show];
        return;
    }
    int index = -1;
    if (self.targetIndex < 0) {
        index = _pick5Instance->AddTarget(_pwNumber, _pwNumber + 10, _pwNumber + 20, _pwNumber + 30, _pwNumber + 40);
    } else {
        index = _pick5Instance->ModifyTarget(self.targetIndex, _pwNumber, _pwNumber + 10, _pwNumber + 20, _pwNumber + 30, _pwNumber + 40);
    }
    if (index >= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[DPToast makeText:@"提交失败"] show];
}
//判断当前选中几个球
- (int)ballSelectedTotal:(int[])num beginIndex:(int)beginIndex {
    int selectedTotal = 0;
    for (int i = beginIndex; i < beginIndex + 10; i++) {
        if (num[i] == 1) {
            selectedTotal = selectedTotal + 1;
        }
    }
    return selectedTotal;
}
- (void)calculateZhushu {
    int zhushu = _pick5Instance->NotesCalculate(_pwNumber, _pwNumber + 10, _pwNumber + 20, _pwNumber + 30, _pwNumber + 40);
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元", zhushu, 2 * zhushu];
}

#pragma mark - getter, setter
- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = [UIColor whiteColor];
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _zhushuLabel;
}
- (UIView *)drawedView {
    if (_drawedView == nil) {
        _drawedView = [[UIView alloc] init];
        _drawedView.backgroundColor = [UIColor clearColor];
    }
    return _drawedView;
}

- (UILabel *)drawedLabel {
    if (_drawedLabel == nil) {
        _drawedLabel = [[UILabel alloc] init];
        _drawedLabel.backgroundColor = [UIColor clearColor];
    }
    return _drawedLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _endTimeLabel;
}

- (UITableView *)trendView {
    if (_trendView == nil) {
        _trendView = [[UITableView alloc] init];
        _trendView.delegate = self;
        _trendView.dataSource = self;
        _trendView.backgroundColor = [UIColor clearColor];
        _trendView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trendView.allowsSelection = NO;
    }
    return _trendView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    return _tableView;
}

- (UIView *)controlView {
    if (_controlView == nil) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}

- (TTTAttributedLabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[TTTAttributedLabel alloc] init];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:11];
        _bonusLabel.lineBreakMode = NSLineBreakByClipping;
        _bonusLabel.numberOfLines = 0;
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.userInteractionEnabled = NO;
    }
    return _bonusLabel;
}

- (SevenSwitch *)missSwitch {
    if (_missSwitch == nil) {
        _missSwitch = [[SevenSwitch alloc] init];
        _missSwitch.onImage = dp_DigitLotteryImage(@"yilouOpen.png");
        _missSwitch.offImage = dp_DigitLotteryImage(@"yilouClose.png");
        _missSwitch.inactiveColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _missSwitch.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _missSwitch.onTintColor = [UIColor dp_flatRedColor];
        _missSwitch.on = YES ;
        [_missSwitch addTarget:self action:@selector(pvt_onSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _missSwitch;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor clearColor];
    }
    return _submitView;
}

- (NSLayoutConstraint *)tableConstraint {
    if (_tableConstraint == nil) {
        for (int i = 0; i < self.view.constraints.count; i++) {
            NSLayoutConstraint *constraint = self.view.constraints[i];
            if (constraint.firstItem == self.tableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                _tableConstraint = constraint;
                break;
            }
        }
    }
    return _tableConstraint;
}

#pragma mark - table's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendView) {
        return 25;
    }
    return self.missSwitch.isOn ? 110 : 86;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.trendView) {
        return 10;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendView) {
        NSString *CellIdentifier = @"TrendCell";
        DPHistoryTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPHistoryTendencyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier digitalType:GameTypePw];
        }

        cell.gameNameLab.highlighted = indexPath.row == 0;
        cell.ballView.highlighted = indexPath.row == 0;

        int result[5] = {0};
        int gameName = 0;
        
        int ret = _pick5Instance->GetHistory(indexPath.row, result, gameName) ;
//        if (_pick5Instance->GetHistory(indexPath.row, result, gameName) == 0) {
        cell.gameNameLab.text = gameName == 0 ? @"-期" : [NSString stringWithFormat:@"%d期", gameName];
        cell.gameInfoLab.text = ret == 1 ? @"正在开奖..." : [NSString stringWithFormat:@"%d  %d  %d  %d  %d", result[0], result[1], result[2], result[3], result[4]];
//        } else {
//            cell.gameInfoLab.text = nil;
//            cell.gameNameLab.text = nil;
//        }

        return cell;
    }

    NSString *CellIdentifier = @"Cell";
    DPSdBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPSdBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];
    }
    cell.commentLabel.text = @[ @"万位", @"千位", @"百位", @"十位", @"个位" ][indexPath.row];

    for (int i = 0; i < 10; i++) {
        [cell.balls[i] setSelected:_pwNumber[indexPath.row * 10 + i]];
    }

    int miss[50] = {0};
    _pick5Instance->GetMiss(miss);
    int maxNum = 0 ;
    for (int i = indexPath.row*10; i<(indexPath.row*10+10); i++) {
        if (miss[i] >= maxNum) {
            maxNum = miss[i] ;
        }
    }

    
    for (int i = 0; i < cell.misses.count; i++) {
        UILabel *label = cell.misses[i];
        if (self.missSwitch.isOn) {
            if (miss[indexPath.row*10+i] == maxNum) {
                label.textColor = [UIColor dp_flatRedColor] ;
            }else{
                label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
            }
            label.text = [NSString stringWithFormat:@"%d", miss[indexPath.row * 10 + i]];
        } else {
            label.text = nil;
        }
    }
    
    int rowCount = [tableView numberOfRowsInSection:0];
    if (indexPath.row == rowCount - 1) {
        cell.footLine.hidden = NO;
    }else{
        cell.footLine.hidden = YES;
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isTracking) {
        //        if (scrollView.contentOffset.y < 0) {
        //            scrollView.contentOffset = CGPointZero;
        //        }
        return;
    }

    if (self.tableConstraint.constant - scrollView.contentOffset.y < 0) {
        self.tableConstraint.constant = 0;
    } else if (self.tableConstraint.constant - scrollView.contentOffset.y > TrendDragHeight) {
        self.tableConstraint.constant = TrendDragHeight;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.tableConstraint.constant = self.tableConstraint.constant - scrollView.contentOffset.y;
        scrollView.contentOffset = CGPointZero;
    }

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.showHistory) {
        self.tableConstraint.constant = self.tableConstraint.constant < TrendDragHeight - 20 ? 0 : TrendDragHeight;
    } else {
        self.tableConstraint.constant = self.tableConstraint.constant > 20 ? TrendDragHeight : 0;
    }

    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showHistory = self.tableConstraint.constant == TrendDragHeight;
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.showHistory) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}

#pragma mark - DPSdBuyCellDelegate
- (void)buyCell:(DPSdBuyCell *)cell touchDown:(UIButton *)button {
    self.tableView.scrollEnabled = NO;
}

- (void)buyCell:(DPSdBuyCell *)cell touchUp:(UIButton *)button {
    self.tableView.scrollEnabled = YES;

    if (button) {
        button.selected = !button.selected;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        _pwNumber[indexPath.row * 10 + button.tag] = button.selected;
    }
    [self calculateZhushu];
}
#pragma mark- 摇一摇

//摇一摇功能
-(BOOL)canBecomeFirstResponder {
    
    return YES;
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    if(motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self digitalDataRandom];
    }
}


//摇一摇
- (void)digitalDataRandom {
    int red[30] = {0};

    [self partRandom:1 total:SDNum target2:red];
    for (int i = 0; i < 10; i++) {
        _pwNumber[i] = red[i];
    }
    [self partRandom:1 total:SDNum target2:red];
    for (int i = 0; i < 10; i++) {
        _pwNumber[i + 10] = red[i];
    }

    [self partRandom:1 total:SDNum target2:red];
    for (int i = 0; i < 10; i++) {
        _pwNumber[i + 20] = red[i];
    }
    [self partRandom:1 total:SDNum target2:red];
    for (int i = 0; i < 10; i++) {
        _pwNumber[i + 30] = red[i];
    }

    [self partRandom:1 total:SDNum target2:red];
    for (int i = 0; i < 10; i++) {
        _pwNumber[i + 40] = red[i];
    }

    [self calculateZhushu];
    [self.tableView reloadData];
}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    for (int i = 0; i < total; i++) {
        target[i] = 0;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        NSLog(@"ssss=%d", [array[x] integerValue]);
        [array removeObjectAtIndex:x];
    }
}

#pragma mark - 倒计时

- (void)updateUIData {
    [self.tableView reloadData];
    [self.trendView reloadData];

    int gameName;
    string endTime;
    int globalSurplus;
    int results[5]={0};
    _pick5Instance->GetInfo(gameName, endTime, globalSurplus);
    int ret = _pick5Instance->GetHistory(0, results, gameName);
    if (ret == 0) {
        self.drawedLabel.text = [NSString stringWithFormat:@"%d %d %d %d %d",results[0],results[1],results[2],results[3],results[4]];
    } else {
        self.drawedLabel.text = @"正在开奖...";
    }
    NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    self.endTimeLabel.text =[date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
}

- (void)refreshNotify {
    int lastGameName, currGameName; string endTime;
    int status = _pick5Instance->GetGameStatus(lastGameName, currGameName, endTime);
    if (status != 1) {
        [self updateUIData];
    } else {
        DPLog(@"未获取到数据");
        
        self.drawedLabel.text = nil;
    }
}

- (NSInteger)timeSpace {
    return g_pwTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_pwTimeSpace = timeSpace;
}

@end
