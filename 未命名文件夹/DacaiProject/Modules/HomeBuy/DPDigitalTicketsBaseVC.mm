//
//  DPDigitalTicketsBaseVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#import "DPDigitalTicketsBaseVC.h"
#import "DPDigitalHistoryView.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#define TrendDragHeight  235


@interface DPDigitalTicketsBaseVC () <DPDropDownListDelegate>

{
@private
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
    UIView              *_bottomView;
    UIView *_drawedView;
     UIView *_controlView;
    SevenSwitch     *_sevenSwitch;

}
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) UIView *drawedView;
@property (nonatomic, strong, readonly) UIView *controlView;
@end

@implementation DPDigitalTicketsBaseVC
@synthesize tableView = _tableView;
@synthesize selctTypeView = _selctTypeView;
@synthesize lotteryType = _lotteryType;
@synthesize titleButton = _titleButton, menu = _menu;
@synthesize historyTableView=_historyTableView;
@synthesize tableConstraint=_tableConstraint;
@dynamic timeSpace;
@dynamic bottomView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_DigitalBetRefreshNofify object:nil];
}

- (void)refreshNotify {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 解析数据
        [self updataForMiss];
        [self pvt_reloadTimer];
        [self.tableView reloadData];
        [self.historyTableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOpenSwitch = YES;
    self.historyArray=[NSMutableArray array];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.cellDic = [NSMutableDictionary dictionary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
    [self buildLayout];
    
    if (!preferSwitchOn) {
        
        _sevenSwitch.on = preferSwitchOn;
        [self switchAction:_sevenSwitch];
    }
    
    [self refreshNotify];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self canBecomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
- (void)buildLayout {
    UIView *historyView = [[UIView alloc] init];
    historyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(26);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@235);
    }];
    [historyView addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.view addSubview:self.drawedView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@48);
    }];
    [self.drawedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@26);
    }];
    self.tableView.backgroundColor=[UIColor dp_flatWhiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drawedView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    [self layOutTopView];
    [self layOutBottomView];
    [self createYilouSwitch];

}
- (void)createYilouSwitch {
    
    SevenSwitch *sevSwitch=[[SevenSwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 8, 51, 22)];
    [sevSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    sevSwitch.inactiveColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    sevSwitch.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    sevSwitch.onTintColor = [UIColor dp_flatRedColor];
    sevSwitch.on = YES;
    sevSwitch.onImage=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouOpen.png")];
    sevSwitch.offImage=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouClose.png")];
    [sevSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.controlView addSubview:sevSwitch];
    _sevenSwitch = sevSwitch;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 82 - 23, 10, 30, 20)];
    label.text = @"遗漏";
    label.textColor = [UIColor dp_flatBlackColor];
    label.textAlignment=NSTextAlignmentRight;
    label.font = [UIFont dp_lightSystemFontOfSize:11.0];
    [self.controlView addSubview:label];
    
    UIButton *randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.digitalRandomBtn=randomButton;
    randomButton.frame=CGRectMake(-1, 5, 111, 27);
    randomButton.backgroundColor = [UIColor clearColor];
    [randomButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"randomSharkoff.png")] forState:UIControlStateNormal];
    [randomButton addTarget:self action:@selector(digitalDataRandom) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView addSubview:randomButton];
    self.tableView.tableHeaderView = self.controlView;
    
}
//顶部截止时间
- (void)layOutTopView {
    TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
    [hintLabel1 setNumberOfLines:0];
    [hintLabel1 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel1 setFont:[UIFont systemFontOfSize:10.0f]];
    [hintLabel1 setBackgroundColor:[UIColor clearColor]];
    [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
    [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
    hintLabel1.userInteractionEnabled=NO;
    self.deadlineTimeLab = hintLabel1;
    [self.view addSubview:hintLabel1];
    [self.deadlineTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(2);
        make.left.equalTo(self.view).offset(3);
//        make.width.equalTo(@205);
        make.height.equalTo(@22);

    }];
    TTTAttributedLabel *hintLabel2 = [[TTTAttributedLabel alloc] init];
    [hintLabel2 setNumberOfLines:0];
    [hintLabel2 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel2 setFont:[UIFont systemFontOfSize:10.0f]];
    [hintLabel2 setBackgroundColor:[UIColor clearColor]];
    [hintLabel2 setTextAlignment:NSTextAlignmentRight];
    [hintLabel2 setLineBreakMode:NSLineBreakByWordWrapping];
    hintLabel1.userInteractionEnabled=NO;
    self.bonusLab = hintLabel2;
    [self.view addSubview:hintLabel2];
    [self.bonusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(2);
//        make.left.equalTo(self.deadlineTimeLab.mas_right );
        make.right.equalTo(self.view).offset(-3);
        make.height.equalTo(@22);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:225.0 / 255 green:215.0 / 255 blue:195.0 / 255 alpha:1.0];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(26);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@"当期停售时间: --天--小时--分--秒"];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0,9)];
    [self.deadlineTimeLab setText:hintString1];
    
    
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.height.equalTo(@10.5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:225.0/255 green:215.0/255 blue:195.0/255 alpha:1.0];
    [backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    UIButton *kuangView=[UIButton buttonWithType:UIButtonTypeCustom];
    kuangView.backgroundColor=[UIColor clearColor];
    [kuangView setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateNormal];
    [kuangView setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateHighlighted];
    [kuangView addTarget:self action:@selector(pvt_onTrend) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:kuangView];
    [kuangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
        make.centerX.equalTo(backView);
        make.width.equalTo(@31.5);
    }];
}
//获得底层View
- (void)layOutBottomView {
    
    UIView *contentView = self.bottomView;
    
    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];
    
    // config control
    confirmButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    
    // bind event
    [cleanupButton addTarget:self action:@selector(pvt_onCleanup) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_submit) forControlEvents:UIControlEventTouchUpInside];
    
    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.zhushuLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];
    
    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@54);
    }];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"delete001_21.png")] forState:UIControlStateNormal];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right);
        make.right.equalTo(contentView);
    }];
    [self.zhushuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.centerY.equalTo(confirmButton);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - getter, setter

- (UIView *)drawedView {
    if (_drawedView == nil) {
        _drawedView = [[UIView alloc] init];
        _drawedView.backgroundColor = [UIColor clearColor];
    }
    return _drawedView;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
- (UITableView *)historyTableView {
    if (_historyTableView == nil) {
        _historyTableView = [[UITableView alloc] init];
        _historyTableView.backgroundColor = [UIColor clearColor];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.scrollEnabled=YES;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ([_historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_historyTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _historyTableView;
}


- (UIView *)controlView {
    if (_controlView == nil) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}
- (void)switchAction:(id)sender {
    SevenSwitch *switchView = (SevenSwitch *)sender;
    self.isOpenSwitch = switchView.on;
    [self.tableView reloadData];
    // 用户选择偏好
    preferSwitchOn = switchView.on;
    
//    DPLog(@"prefer========%d", preferSwitchOn);
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = [UIColor whiteColor];
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _zhushuLabel;
}
#pragma mark - logic

- (void)pvt_submit {
}
//清空数据
- (void)pvt_onCleanup {
    [self clearAllSelectedData];
    [self.tableView reloadData];

}
-(void)clearAllSelectedData{

    
}
- (void)pvt_onBack {
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
                viewController.gameType = (GameTypeId)self.lotteryType;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(self.lotteryType)]];
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

- (void)pvt_onTrend {
    if (self.showHistory) {
        self.tableConstraint.constant = 0;
    } else {
        self.tableConstraint.constant = TrendDragHeight;
    }
    
    self.showHistory = self.tableConstraint.constant == TrendDragHeight;
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)jumpToSelectPage:(int)row gameType:(int)gameType {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma make-UItabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.historyTableView){
        return 23.5;
    }
    NSArray *array = [self.ballDic objectForKey:@"total"];
    int ballTotal = 0;
    if (array.count > indexPath.row) {
        ballTotal = [[array objectAtIndex:indexPath.row] intValue];
    }
    return [self cellHeightForIndex:ballTotal indexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.historyTableView) {
        return 10;
    }

    return [[self.ballDic objectForKey:@"totalRow"] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d", indexPath.row, self.buyType];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
     
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];

        cell.backgroundColor = [UIColor dp_flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (float)cellHeightForIndex:(int)ballTotal indexPath:(NSIndexPath *)indexPath{
    int numOfEveryRow = self.view.frame.size.width / (int)(ballHeight + ballSpace);
    int rowTotalNum = ballTotal % numOfEveryRow == 0 ? ballTotal / numOfEveryRow : (ballTotal / numOfEveryRow + 1);
    float cellHeight = rowTotalNum * (ballHeight + ballSpace) + ballSpace + 20;
    return cellHeight;
}




#pragma mark -digitalBallDelegate

- (void)buyCell:(DPDigitalBallCell *)cell touchUp:(UIButton *)button{

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
    
//    self.showHistory = self.tableConstraint.constant == TrendDragHeight;
    
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

#pragma mark - getter, setter

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onExpandNav)]];
    }
    return _titleButton;
}

- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.items = self.titleArray;
    }
    return _menu;
}

- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.gameIndex];
    [self.menu show];
}
#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    [self reloadSelectTableView:(int)index];
    self.menu.selectedIndex = index;
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
    [self.tableView reloadData];
}

- (void)reloadSelectTableView:(int)titleIndex {
}

#pragma mark--
#pragma mark-- NumberCellDelegate
//当前界面在选号时不可滑动，cell来控制
- (void)tableViewScroll:(BOOL)stop {
    if (stop) {

        self.tableView.scrollEnabled = YES;

    } else {
        self.tableView.scrollEnabled = NO;
    }
}

-(void)UpDateRequestedData{

}

- (void)pvt_reloadTimer {
//    if (self.timeSpace == 0) {
//        // todo:
//        
//        DPLog(@"end: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//        
//        [self.tableView reloadData];
//        [self.historyTableView reloadData];
//        [self UpDateRequestedData];
//    }
    if (self.timeSpace > 0) {
        NSString *time = @"";
        int days = ((int)self.timeSpace) / (3600 * 24);
        int hours = (((int)self.timeSpace) - (3600 * 24) * days) / 3600;
        int mins = (((int)self.timeSpace) - (3600 * 24) * days - 3600 * hours) / 60;
        int seconds = ((int)self.timeSpace) - (3600 * 24) * days - 3600 * hours - 60 * mins;
        time = [NSString stringWithFormat:@"%02d天%02d时%02d分%02d秒", days, hours, mins, seconds];
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距本次投注截止 : %@", time]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, 9)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(10, time.length)];
        [self.deadlineTimeLab setText:hintString1];
    }
}

-(void)upDataRequest{

}


#pragma mark- 摇一摇

//摇一摇功能
-(BOOL)canBecomeFirstResponder {
    if ((self.buyType==_DoubleColorBallDanType)||(self.buyType==_BigHappyBetBuyDanType)) {
        return NO;
    }
    return YES;
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    if ((self.buyType==_DoubleColorBallDanType)||(self.buyType==_BigHappyBetBuyDanType)) {
        return ;
    }
    if(motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self digitalDataRandom];
        
    }
}

- (void)digitalDataRandom {

}

- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random()%((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}
//得到滚存钱
-(NSString*)logogramForMoney:(int)money{
    if(money<=0){
     return @"-- 元";
    }
    NSString *string1=@"0";
    NSString *string2=@"元";
    if (money/100000000.0>=1) {
        string1=[NSString stringWithFormat:@"%.2f",money/100000000.0];
        string2=@"亿元";
    }else{
        if (money/10000.0>=1) {
            string1=[NSString stringWithFormat:@"%.2f",money/10000.0];
           string2=@"万元";
        }else {
            string1=[NSString stringWithFormat:@"%.2f",money/1.0];
        }
    }
    return [NSString stringWithFormat:@"%@ %@",string1,string2];

}
//判断当前选中几个球
-(int)ballSelectedTotal:(int[])num  danwei:(int)danwei total:(int)total{
    int  selectedTotal=0;
    for (int i=0; i<total; i++) {
        if (num[i]==danwei) {
            selectedTotal=selectedTotal+1;
        }
    }
    return selectedTotal;
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 解析数据
//        [self updataForMiss];
//        [self pvt_reloadTimer];
//        [self.tableView reloadData];
//        [self.historyTableView reloadData];
//    });
}

//更新遗漏值
- (void)updataForMiss {
}

@end
