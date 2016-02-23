//
//  DPGameLivingBaseVC.m
//  DacaiProject
//
//  Created by sxf on 14/12/5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLivingBaseVC.h"
#import "DPGameLivingBaseVC+content.h"
#import "FrameWork.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPImageLabel.h"
#import "DPLiveDataCenterViewController.h"
#import "DPNodataView.h"
#import "DPWebViewController.h"
static NSArray *jcTypeNames = @[ @"竞彩足球", @"竞彩篮球", @"北京单场", @"胜负彩" ];
@interface DPGameLivingBaseVC () {
@private
    UIView *_tabBarView;
    DPCollapseTableView *_livingTable;
    DPCollapseTableView *_overTable;
    DPCollapseTableView *_nostartTable;
    DPCollapseTableView *_focusTable;
    UIScrollView *_scrollView;
    UILabel *_guanzhuLabel;
    UIView *_titleMenu;
    DPNavigationTitleButton *_titleButton;
    UIButton *_issueButton;
    BOOL _requestCount;       //是否切换彩种请求
    NSInteger _gameliveCmdId; //赛事请求
    NSInteger _guanzhuCmdId;  //关注请求
    NSInteger _ret;    //请求状态
    DPNodataView *_noDataView ;
    
}
@property (nonatomic, strong) NSMutableArray *competitionList;
@property (nonatomic, strong, readonly) DPNodataView *noDataView ;

@end

@implementation DPGameLivingBaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _guanzhuTotal = 0;
        _tabSelectedIndex = 0;
        _gameSelectedIndex = 0;
        _scoreInstance = CFrameWork::GetInstance()->GetScoreLive();

        _imageCache = [[AFImageDiskCache alloc] init];
        _imageQueue = [[NSOperationQueue alloc] init];
        _imageQueue.maxConcurrentOperationCount = 1;
        _requestCount = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _scoreInstance->SetDelegate(self);
    self.eventView.hidden=NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.eventView.hidden=YES;

}
- (void)dealloc {
    REQUEST_CANCEL(_gameliveCmdId);
    REQUEST_CANCEL(_guanzhuCmdId);
    _scoreInstance->StopServices();
    _scoreInstance->Clear();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 适配

    self.view.backgroundColor = UIColorFromRGB(0xf5f1e9);

    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }

    //    [self.view addSubview:self.noDataImgView];
    //    self.noDataImgView.hidden = YES;
    //    [self.noDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.view);
    //        make.centerY.equalTo(self.view).offset(- 50);
    //    }];

    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onNavLeft:)]];
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.scrollView];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(35);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self tabarViewbulidLayout];
    [self.view sendSubviewToBack:self.scrollView];
    [self.scrollView addSubview:self.livingTable];
    [self.scrollView addSubview:self.overTable];
    [self.scrollView addSubview:self.nostartTable];
    [self.scrollView addSubview:self.focusTable];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, kScreenHeight * 4);
    [self.livingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [self.overTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.livingTable.mas_right);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);

    }];
    [self.nostartTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.overTable.mas_right);
       make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);

    }];
    [self.focusTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.nostartTable.mas_right);
        make.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);

    }];

    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.tabBarView.userInteractionEnabled = YES;

    [self pvt_navigationViewLayout];
    [self.navigationController.view addSubview:self.eventView];
    [self.eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(97, 0, 0, 0));

    }];

    // Do any additional setup after loading the view.

    _scoreInstance->SetGameType([self gameTypeIndex]);
    _gameliveCmdId = _scoreInstance->Net_Refresh();
    [self showHUD];
    _scoreInstance->StartServices();

    __weak DPGameLivingBaseVC *weakSelf = self;
    __block __typeof(_scoreInstance) weakscoreInstance = _scoreInstance;

    [self.livingTable addPullToRefreshWithActionHandler:^{
        weakscoreInstance->SetGameType([weakSelf gameTypeIndex]);
         __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_gameliveCmdId,weakscoreInstance->Net_Refresh());
    }];
    [self.overTable addPullToRefreshWithActionHandler:^{
        weakscoreInstance->SetGameType([weakSelf gameTypeIndex]);
         __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_gameliveCmdId,weakscoreInstance->Net_Refresh());

    }];
    [self.nostartTable addPullToRefreshWithActionHandler:^{
        weakscoreInstance->SetGameType([weakSelf gameTypeIndex]);
         __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_gameliveCmdId,weakscoreInstance->Net_Refresh());
    }];
    [self.focusTable addPullToRefreshWithActionHandler:^{
        weakscoreInstance->SetGameType([weakSelf gameTypeIndex]);
         __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_guanzhuCmdId,weakscoreInstance->Net_RefreshAttention());
    }];
    
    [self pvt_startTimer];
}

- (GameTypeId)gameTypeIndex {
    switch (_gameSelectedIndex) {
        case 0:
            return GameTypeJcNone;
        case 1:
            return GameTypeLcNone;
        case 2:
            return GameTypeBdNone;
        case 3:
            return GameTypeZcNone;
        default:
            break;
    }
    return GameTypeJcNone;
}


- (void)tabarViewbulidLayout {
    UIView *bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.82 green:0.81 blue:0.73 alpha:1];
        view;
    });
    [self.tabBarView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.height.equalTo(@0.5);
    }];

    NSInteger width = UIScreen.mainScreen.bounds.size.width / 4;
    UIButton *firstButon = nil;
    NSArray *tabBarNames = @[ @"比赛中", @"已结束", @"未开始", @"关注" ];
    for (int i = 0; i < 4; i++) {
         UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        //        [button setBackgroundImage:dp_AccountImage(@"winclock.png") forState:UIControlStateSelected];
        [button setTitle:tabBarNames[i] forState:UIControlStateNormal];
        [button setTag:i + tabbuttonTag];
        [button setSelected:i == 0];
        [button addTarget:self action:@selector(pvt_onTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
        [self.tabBarView addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tabBarView);
            make.bottom.equalTo(self.tabBarView);
            make.left.equalTo(@(i * width));
            make.width.equalTo(@(width));
        }];

        if (i == 0) {
            firstButon = button;
        }
    }

    // 选中箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:dp_AccountImage(@"已选中状态.png")];
    [self.tabBarView addSubview:arrow];

    if (firstButon != nil) {
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(firstButon);
            make.bottom.equalTo(self.tabBarView);
        }];
    }

    [self.tabBarView addSubview:self.guanzhuLabel];
    [self.guanzhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView).offset(3);
        make.height.equalTo(@15);
        make.left.equalTo(self.view.mas_right).offset(-27);
        make.width.equalTo(@23);
    }];
    self.guanzhuLabel.hidden = !_guanzhuTotal;
}
- (void)pvt_navigationViewLayout {
    //标题
    [self.navigationItem setTitleView:self.titleButton];
    [self.titleButton setTitleText:jcTypeNames[_gameSelectedIndex]];
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];

    //右侧 期号选择
    [self.issueButton setFrame:CGRectMake(0, 0, 75, 27)];
    //右侧 筛选
    //    UIColor *tintColor=[UIColor dp_flatWhiteColor];
    //     UIColor *highlightedColor = [UIColor colorWithRed:tintColor.dp_red green:tintColor.dp_green blue:tintColor.dp_blue alpha:0.4];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setTitle:@"筛选" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
    button.layer.borderColor = [UIColor dp_flatWhiteColor].CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(pvt_filter) forControlEvents:UIControlEventTouchUpInside];
    self.filterButton = button;
    [button setFrame:CGRectMake(0, 0, 36, 27)];

    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.issueButton];
        item1.style = UIBarButtonItemStylePlain;
        item1.tintColor = [UIColor dp_flatWhiteColor];
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button];
        item2.style = UIBarButtonItemStylePlain;
         item2.tintColor = [UIColor dp_flatWhiteColor];
        @[item2, item1];
    });
}
#pragma mark - table view's data source and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (((_tabSelectedIndex == 3) && (_scoreInstance->GetAttentionCount() < 1)) ||
        ((_tabSelectedIndex != 3) && (_scoreInstance->GetMatchCount(_tabSelectedIndex + 1) < 1))) {
        return kScreenHeight - 100;
    }
    if (_gameSelectedIndex == 1) {
        return 105;
    }
    return 93;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tabSelectedIndex == 3) {
        return MAX(0, _scoreInstance->GetAttentionCount());
    }
    return MAX(0, _scoreInstance->GetMatchCount(_tabSelectedIndex + 1));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView contentCellForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_gameSelectedIndex == 1) {
        return 110;
    }
    vector<int> time;
    vector<string> player;
    vector<int> event;
    vector<int> isHome;
    _scoreInstance->GetMatchFootballEvent(_tabSelectedIndex + 1, indexPath.row, time, player, event, isHome);
    float total = isHome.size() > 0 ? isHome.size() : 3;
    return 64 + 5 + 30 * total; //隐藏赛事分析按钮
}

- (UITableViewCell *)tableView:(UITableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView contentExpandCellForRowAtIndexPath:indexPath];
}

#pragma mark -DPGameLiveJczqCell
- (void)openGameLiveInfoForCell:(DPGameLiveJczqCell *)cell {
    DPCollapseTableView *tableView = [self selectedTableView:_tabSelectedIndex];
    NSIndexPath *modelIndex = [tableView modelIndexForCell:cell];
    [cell analysisViewIsExpand:[tableView isExpandAtModelIndex:modelIndex]];
    [cell.contentView didMoveToSuperview];
    [tableView toggleCellAtModelIndex:modelIndex animation:NO];
    //    DPgameLiveJCInfoCell *modeCell = [tableView cellForRowAtModelIndex:modelIndex expand:[tableView isExpandAtModelIndex:modelIndex]];
    //    [modeCell.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
    //        if (obj.firstItem == modeCell && obj.firstAttribute == NSLayoutAttributeTop) {
    //            obj.constant = -10;
    //            [self.view setNeedsUpdateConstraints];
    //            [self.view setNeedsLayout];
    //
    //            [self.view layoutIfNeeded];
    //
    //            *stop = YES;
    //        }
    //    }];
}
- (void)openGameLiveEVentForCell:(DPGameLiveJczqCell *)cell {

    NSIndexPath *indexPath = [[self selectedTableView:_tabSelectedIndex] modelIndexForCell:cell];
    int matchid = 0;
    _scoreInstance->GetMatchId(_tabSelectedIndex + 1, indexPath.row, matchid);
    GameTypeId gameid = GameTypeZcNone;
    if (_gameSelectedIndex == 1) {
        gameid = GameTypeLcNone;
    }
    DPLiveDataCenterViewController *vc = [[DPLiveDataCenterViewController alloc] initWithGameType:gameid withDefaultIndex:0 withMatchId:matchid];
    bool attention = false;
    string orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo;
    _scoreInstance->GetMatchBaseInfo(_tabSelectedIndex + 1, indexPath.row, attention, orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo);
    if (competitionName.c_str() > 0) {
        vc.title = [NSString stringWithUTF8String:competitionName.c_str()];
    }
    [self.navigationController pushViewController:vc animated:YES];
    //    [self presentViewController:[UINavigationController dp_controllerWithRootViewController:vc] animated:YES completion:nil];
}
//关注
- (void)guanzhuGameLiveInfoForCell:(DPGameLiveJczqCell *)cell button:(UIButton *)button matchId:(NSInteger)matchId {
    if (_tabSelectedIndex == 3) {
        NSIndexPath *indexPath = [self.focusTable indexPathForCell:cell];
        NSIndexPath *modelIndex = [self.focusTable modelIndexForCell:cell];
        [self.focusTable closeCellAtModelIndex:modelIndex animation:NO];
        _scoreInstance->Net_Attention(matchId, NO, YES);

            [self.focusTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           _guanzhuTotal= _scoreInstance->GetAttentionCount();
            self.guanzhuLabel.text = [NSString stringWithFormat:@"%d", _guanzhuTotal];
            self.guanzhuLabel.hidden = !_guanzhuTotal;
        if (_guanzhuTotal==0) {
            [self upDateForNodataView:_ret];
        }
        return;
    }
    int index = _scoreInstance->Net_Attention(matchId, button.selected);
    if (index < 0) {
        [[DPToast makeText:@"请打开推送设置"] show];
        return;
    }
    if (button.selected) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = dp_GameLiveImage(@"guanzhuselected.png");
        imageView.center = [button convertPoint:CGPointMake(button.frame.size.width / 2, button.frame.size.height / 2) toView:self.view];
        [self.view addSubview:imageView];
        [UIView animateWithDuration:0.2 animations:^{
            imageView.center = CGPointMake(300, 10);
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
        if (_tabSelectedIndex>0) {
             [[DPToast makeText:@"您关注的比赛将会在开赛前推送通知”"] show];
        }
       
    }

    _guanzhuTotal = button.selected ? _guanzhuTotal + 1 : _guanzhuTotal - 1;
    _guanzhuTotal = MAX(0, _guanzhuTotal);
    self.guanzhuLabel.text = [NSString stringWithFormat:@"%d", _guanzhuTotal];
    self.guanzhuLabel.hidden = !_guanzhuTotal;
}

- (void)pvt_onNavTitle {
    [self pvt_titleMenuAt:_gameSelectedIndex + TitleMenuContentTag + 1];
    [self.titleButton turnArrow];
    [self.navigationController.view addSubview:self.titleMenu];
    [UIView animateWithDuration:0.2 animations:^{
        self.titleMenu.alpha = 1;
    }];
}
- (void)pvt_titleMenuAt:(NSInteger)index {
    UIView *backView = (UIView *)[self.titleMenu viewWithTag:TitleMenuContentTag];
    for (UIView *view in backView.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    UIView *imageView = (UIView *)[self.titleMenu viewWithTag:index];
    imageView.backgroundColor = UIColorFromRGB(0xf4f0e8);
}

- (void)pvt_onNavDropDown:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.view.tag >= 0) {
        if (_gameSelectedIndex != tapGestureRecognizer.view.tag - TitleMenuContentTag - 1) {
            if (tapGestureRecognizer.view.tag - TitleMenuContentTag - 1 != 3) {
                self.filterButton.hidden = NO;
            } else {
                self.filterButton.hidden = YES;
            }
        }
        _gameSelectedIndex = tapGestureRecognizer.view.tag - TitleMenuContentTag - 1;
        [self pvt_titleMenuAt:tapGestureRecognizer.view.tag];
        [self.titleButton setTitleText:jcTypeNames[_gameSelectedIndex]];
        _scoreInstance->SetGameType([self gameTypeIndex]);
        _requestCount = YES;
        REQUEST_CANCEL(_gameliveCmdId);
        _gameliveCmdId = _scoreInstance->Net_Refresh();
        if (_gameliveCmdId>=0) {
            [self showHUD];
        }
        
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.titleMenu.alpha = 0;
    } completion:^(BOOL finished) {
        [self.titleMenu removeFromSuperview];
    }];

    [self.titleButton restoreArrow];
}

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _titleButton.titleColor = [UIColor dp_flatWhiteColor];
    }
    return _titleButton;
}

- (UIView *)titleMenu {
    if (_titleMenu == nil) {
        NSArray *imageNameArray = [NSArray arrayWithObjects:@"jczq.png", @"jclq.png", @"bjdc.png", @"sfc.png", nil];
        UIView *backgroudView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
        backgroudView.backgroundColor = [UIColor clearColor];
        backgroudView.tag = -1;
        backgroudView.alpha = 0;

        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                                                     CGRectGetHeight(self.navigationController.view.frame) - CGRectGetHeight(self.view.frame),
                                                                     CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame))];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        coverView.tag = -1;
        coverView.userInteractionEnabled = NO;

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(coverView.frame),
                                                                    CGRectGetMinY(coverView.frame),
                                                                    CGRectGetWidth(coverView.frame),
                                                                    90)];

        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = TitleMenuContentTag;

        [backgroudView addSubview:coverView];
        [backgroudView addSubview:backView];

        // 95, 45
        float backwidth = kScreenWidth / 4;
        for (int i = 0; i < 4; i++) {

            UIView *kview = [UIView dp_viewWithColor:[UIColor clearColor]];
            [kview setTag:TitleMenuContentTag + 1 + i];
            kview.backgroundColor = [UIColor clearColor];
            [kview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];
            [backView addSubview:kview];
            UIImageView *view = [[UIImageView alloc] init];
            [view setUserInteractionEnabled:YES];
            //            [view setTag:i];
            //            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];
            [view setImage:dp_ProjectImage(imageNameArray[i])];
            [view setHighlightedImage:dp_ProjectImage(imageNameArray[i])];
            [kview addSubview:view];

            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorFromRGB(0x333333);
            label.highlightedTextColor = [UIColor dp_flatRedColor];
            label.font = [UIFont dp_systemFontOfSize:12.0];
            label.text = jcTypeNames[i];

            label.textAlignment = NSTextAlignmentCenter;
            [kview addSubview:label];

            [kview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backView).offset(backwidth*i);
                make.width.equalTo(@(backwidth));
                make.top.equalTo(backView);
                make.bottom.equalTo(backView);
            }];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(kview);
                make.width.equalTo(@24);
                make.top.equalTo(kview).offset(22);
                make.height.equalTo(@24);
            }];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kview);
                make.right.equalTo(kview);
                make.top.equalTo(view.mas_bottom).offset(5);
                make.height.equalTo(@20);
            }];

            if (i != 3) {
                UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xd5d5d5)];
                [kview addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0.5);
                    make.right.equalTo(kview);
                    make.top.equalTo(kview);
                    make.bottom.equalTo(kview);
                }];
            }
        }

        [backgroudView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];

        _titleMenu = backgroudView;
    }
    return _titleMenu;
}

#pragma mark - DPNavigationMenuDelegate
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    if (menu == self.titleMenu) {
        [self.titleButton setTitleText:jcTypeNames[index]];
    }
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    if (menu == self.titleMenu) {
        [self.titleButton restoreArrow];
    }
}

#pragma mark - getter
- (UIView *)tabBarView {
    if (_tabBarView == nil) {
        _tabBarView = [[UIView alloc] init];
        _tabBarView.backgroundColor = [UIColor whiteColor];
    }
    return _tabBarView;
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (DPCollapseTableView *)livingTable {
    if (_livingTable == nil) {
        _livingTable = [[DPCollapseTableView alloc] init];
        _livingTable.zOrder = DPTableViewZOrderAsec;
        _livingTable.delegate = self;
        _livingTable.dataSource = self;
        _livingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _livingTable.backgroundColor = [UIColor clearColor];
    }
    return _livingTable;
}

- (DPCollapseTableView *)overTable {
    if (_overTable == nil) {
        _overTable = [[DPCollapseTableView alloc] init];
        _overTable.zOrder = DPTableViewZOrderAsec;
        _overTable.delegate = self;
        _overTable.dataSource = self;
        _overTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _overTable.backgroundColor = [UIColor clearColor];
    }
    return _overTable;
}
- (DPCollapseTableView *)nostartTable {
    if (_nostartTable == nil) {
        _nostartTable = [[DPCollapseTableView alloc] init];
        _nostartTable.zOrder = DPTableViewZOrderAsec;
        _nostartTable.delegate = self;
        _nostartTable.dataSource = self;
        _nostartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _nostartTable.backgroundColor = [UIColor clearColor];
    }
    return _nostartTable;
}
- (DPCollapseTableView *)focusTable {
    if (_focusTable == nil) {
        _focusTable = [[DPCollapseTableView alloc] init];
        _focusTable.delegate = self;
        _focusTable.dataSource = self;
        _focusTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _focusTable.backgroundColor = [UIColor clearColor];
    }
    return _focusTable;
}
- (UILabel *)guanzhuLabel {
    if (_guanzhuLabel == nil) {
        _guanzhuLabel = [[UILabel alloc] init];
        _guanzhuLabel.backgroundColor = [UIColor dp_flatRedColor];
        _guanzhuLabel.layer.cornerRadius = 7;
        _guanzhuLabel.layer.masksToBounds = YES;
        _guanzhuLabel.clipsToBounds = YES;
        _guanzhuLabel.text = [NSString stringWithFormat:@"%d", _guanzhuTotal];
        _guanzhuLabel.textColor = [UIColor dp_flatWhiteColor];
        _guanzhuLabel.textAlignment = NSTextAlignmentCenter;
        _guanzhuLabel.font = [UIFont dp_regularArialOfSize:10.0];
    }
    return _guanzhuLabel;
}
- (UIButton *)issueButton {
    if (_issueButton == nil) {
        _issueButton = [[UIButton alloc] init];
        [_issueButton setBackgroundColor:[UIColor clearColor]];
        [_issueButton setTitle:@"" forState:UIControlStateNormal];
        [_issueButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        _issueButton.layer.borderColor = [UIColor dp_flatWhiteColor].CGColor;
        _issueButton.layer.borderWidth = 1;
        [_issueButton setImage:dp_GameLiveImage(@"issueup.png") forState:UIControlStateNormal];
        [_issueButton setImage:dp_GameLiveImage(@"issuedown.png") forState:UIControlStateSelected];
        [_issueButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
        [_issueButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [_issueButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_issueButton addTarget:self action:@selector(pvt_issue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _issueButton;
}
- (DPGameLiveEventView *)eventView {
    if (_eventView == nil) {
        _eventView = [[DPGameLiveEventView alloc] init];
        _eventView.backgroundColor = [UIColor clearColor];
        _eventView.userInteractionEnabled = NO;
    }
    return _eventView;
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        __weak __typeof(self) weakSelf = self;
        __block CScoreLive *weak_scoreInstance = _scoreInstance;
        
        [_noDataView setClickBlock:^(BOOL setOrUpDate){
            if (setOrUpDate) {
                DPWebViewController *webView = [[DPWebViewController alloc]init];
                webView.title = @"网络设置";
                NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
                NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSURL *url = [[NSBundle mainBundle] bundleURL];
                DPLog(@"html string =%@, url = %@ ", str, url);
                [webView.webView loadHTMLString:str baseURL:url];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                weak_scoreInstance->Net_Refresh();
                [weakSelf showHUD];
            }
            
        }];
    }
    return _noDataView ;
}

//- (UIImageView *)noDataImgView {
//    if (_noDataImgView == nil) {
//        _noDataImgView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"zcNoData.png")];
//    }
//    return _noDataImgView;
//}
- (NSMutableArray *)competitionList {
    if (_competitionList == nil) {
        _competitionList = [NSMutableArray array];
    }
    return _competitionList;
}
- (void)pvt_onNavLeft:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pvt_issue {

    vector<string> gameNames;
    _scoreInstance->GetGameNames(gameNames);
    if (gameNames.size() < 1) {
        //        [[DPToast makeText:@"暂无数据"] show];
        return;
    }
    self.issueButton.selected = YES;
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];

    NSMutableArray *gameList = [NSMutableArray arrayWithCapacity:gameNames.size()];
    for (int i = 0; i < gameNames.size(); i++) {
        NSString *dateString = [NSString stringWithUTF8String:gameNames[i].c_str()];
        if (_gameSelectedIndex != 3) {
            NSDate *date = [NSDate dp_dateFromString:dateString withFormat:@"YYYY-MM-dd"];
            dateString = [date dp_stringWithFormat:@"MM-dd"];
        } else {
            dateString = [NSString stringWithFormat:@"%@期", dateString];
        }
        [gameList addObject:dateString];
    }
    DPIssueSelectedView *dropDownList = [[DPIssueSelectedView alloc] initWithItems:gameList selectIndex:_issueSelectedIndex];
    dropDownList.delegate = self;
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.issueButton);
        make.top.equalTo(self.issueButton.mas_bottom);
        make.height.equalTo(@(gameNames.size()*40+5));
        make.width.equalTo(@90);
    }];

    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
        tap.delegate = self;
        tap;
                                    })];
}
- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
    self.issueButton.selected = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPIssueSelectedView *)dropDownList selectedAtIndex:(NSInteger)index {
    [dropDownList.superview removeFromSuperview];
    self.issueButton.selected = NO;
    _issueSelectedIndex = index;
    vector<string> gameNames;
    _scoreInstance->GetGameNames(gameNames);
    NSString *currentIssue = [NSString stringWithUTF8String:gameNames[index].c_str()];
    if (_gameSelectedIndex != 3) {
        NSDate *date = [NSDate dp_dateFromString:currentIssue withFormat:@"YYYY-MM-dd"];
        currentIssue = [date dp_stringWithFormat:@"MM-dd"];
    } else {
        currentIssue = [NSString stringWithFormat:@"%@期", currentIssue];
    }

    [self.issueButton setTitle:currentIssue forState:UIControlStateNormal];
    _scoreInstance->SetGameIndex(index);
    [[self selectedTableView:_tabSelectedIndex] closeAllCells];
    [self upDateForNodataView:_ret];
    [[self selectedTableView:_tabSelectedIndex] reloadData];
    //    if (_tabSelectedIndex == 3) {
    //        self.noDataImgView.hidden = _scoreInstance->GetAttentionCount() < 1 ? NO : YES;
    //    } else {
    //        self.noDataImgView.hidden = _scoreInstance->GetMatchCount(_tabSelectedIndex + 1) < 1 ? NO : YES;
    //    }
}

- (void)pvt_filter {
    vector<string> competitions;
    vector<string> currCompetition;
    _scoreInstance->GetCompetitionFilter(competitions, currCompetition);

    if (competitions.size() == 0) {
        return;
    }

    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor dp_coverColor];
    coverView.alpha = 0;
    [self.navigationController.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];

    DPSportFilterView *filterView = [[DPSportFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [filterView setDelegate:self];
    [coverView addSubview:filterView];

    NSMutableArray *competitionsList = [NSMutableArray arrayWithCapacity:competitions.size()];
    NSMutableArray *currCompetitionList = [NSMutableArray arrayWithCapacity:competitions.size()];
    for (int i = 0; i < competitions.size(); i++) {
        [competitionsList addObject:[NSString stringWithUTF8String:competitions[i].c_str()]];
    }
    for (int i = 0; i < currCompetition.size(); i++) {
        [currCompetitionList addObject:[NSString stringWithUTF8String:currCompetition[i].c_str()]];
    }
    [filterView addGroupWithTitle:@"赛事选择" allItems:competitionsList selectedItems:currCompetitionList];
    [filterView.collectionView layoutIfNeeded];
    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(coverView).offset(40).priorityHigh();
        make.bottom.lessThanOrEqualTo(coverView).offset(-20).priorityHigh();
        make.left.equalTo(coverView);
        make.right.equalTo(coverView);
        make.height.equalTo(@(filterView.collectionView.contentSize.height + 40)).priorityLow();
        make.centerY.equalTo(coverView);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        coverView.alpha = 1;
    }];
}
#pragma mark - DPSportFilterViewDelegate

- (void)cancelFilterView:(DPSportFilterView *)filterView {
    [UIView animateWithDuration:0.3 animations:^{
        [filterView.superview setAlpha:0];
    } completion:^(BOOL finished) {
        [filterView.superview removeFromSuperview];
    }];
}

- (void)filterView:(DPSportFilterView *)filterView allGroups:(NSArray *)allGroups selectedGroups:(NSArray *)selectedGroups {
    [self cancelFilterView:filterView];

    NSMutableArray *competitionList = nil;

    competitionList = [selectedGroups firstObject];
    [self.competitionList removeAllObjects];
    [self.competitionList addObjectsFromArray:competitionList];

    [self pvt_resetFilterInfo];
    [[self selectedTableView:_tabSelectedIndex] closeAllCells];
    [self upDateForNodataView:_ret];
    [[self selectedTableView:_tabSelectedIndex] reloadData];
    //    if (_tabSelectedIndex != 3) {
    //        self.noDataImgView.hidden = _scoreInstance->GetMatchCount(_tabSelectedIndex + 1) < 1 ? NO : YES;
    //    }
}
- (void)pvt_resetFilterInfo {
    NSMutableArray *competitionList = nil;

    vector<string> competition;
    vector<string> currCompetition;
    _scoreInstance->GetCompetitionFilter(competition, currCompetition);
    competitionList = [NSMutableArray arrayWithCapacity:competition.size()];
    for (int i = 0; i < competition.size(); i++) {
        [competitionList addObject:[NSString stringWithUTF8String:competition[i].c_str()]];
    }
    //    int *selectedComeptition = (int *)alloca(sizeof(int) * competition.size());
    vector<string> selectedComeptition;
    for (int i = 0; i < competition.size(); i++) {
        if ([self.competitionList containsObject:competitionList[i]]) {
            NSString *string = competitionList[i];
            selectedComeptition.push_back(string.UTF8String);
        }

        //        selectedComeptition[i] = [self.competitionList containsObject:competitionList[i]];
    }
    _scoreInstance->SetCompetitionFilter(selectedComeptition);
}
- (void)pvt_reloadFilterInfo {
    vector<string> competition;
    vector<string> currCompetition;
    _scoreInstance->GetCompetitionFilter(competition, currCompetition);

    [self.competitionList removeAllObjects];
    for (int i = 0; i < currCompetition.size(); i++) {
        [self.competitionList addObject:[NSString stringWithUTF8String:currCompetition[i].c_str()]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        _tabSelectedIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        [self.scrollView scrollRectToVisible:CGRectMake(_tabSelectedIndex * width, 0, width, 1) animated:YES];
        [self changeTabIndex:_tabSelectedIndex];

        if (_tabSelectedIndex == 3) {

            REQUEST_CANCEL(_guanzhuCmdId);
            _guanzhuCmdId = _scoreInstance->Net_RefreshAttention();
            [self showHUD];
            return;
        }
        [[self selectedTableView:_tabSelectedIndex] closeAllCells];
        [self upDateForNodataView:_ret];
        [[self selectedTableView:_tabSelectedIndex] reloadData];
        //        self.noDataImgView.hidden = _scoreInstance->GetMatchCount(_tabSelectedIndex + 1) < 1 ? NO : YES;
    }
}
- (void)changeTabIndex:(NSInteger)index {
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:tabbuttonTag + i];
        if (i == index) {
            button.selected = YES;
            UIView *superView = [button superview];
            UIImageView *arrow = nil;
            for (id sub in self.tabBarView.subviews) {
                if ([sub isKindOfClass:[UIImageView class]]) {
                    arrow = sub;
                }
            }
            [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.bottom.equalTo(superView);
            }];
        } else {
            button.selected = NO;
        }
    }
}
- (void)pvt_onTabBar:(UIButton *)button {
    if (button.isSelected) {
        return;
    }
    _tabSelectedIndex = button.tag - tabbuttonTag;
    [self changeScrollView:_tabSelectedIndex];
    [self upDateForNodataView:_ret];
    //    self.noDataImgView.hidden = _scoreInstance->GetMatchCount(_tabSelectedIndex + 1) < 1 ? NO : YES;
}
- (void)changeScrollView:(NSInteger)index {
    UIButton *button = (UIButton *)[self.tabBarView viewWithTag:tabbuttonTag + index];
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(_tabSelectedIndex * width, 0) animated:YES];
    [self.view setNeedsLayout];
    [self.view needsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
     [self.view layoutIfNeeded];
    //移动scrollView视图
//    [UIView animateWithDuration:0.1 animations:^{
//        [self.view layoutIfNeeded];
//    }];

    UIView *superView = [button superview];
    UIImageView *arrow = nil;
    for (id sub in self.tabBarView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            [sub setSelected:NO];
        } else if ([sub isKindOfClass:[UIImageView class]]) {
            arrow = sub;
        }
    }
    [button setSelected:YES];
    [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(superView);
    }];
    
    if (_tabSelectedIndex == 3) {
        REQUEST_CANCEL(_guanzhuCmdId);
        _guanzhuCmdId = _scoreInstance->Net_RefreshAttention();
        if (_guanzhuCmdId>=0) {
            [self showHUD];
        }
        
        return;
    }
    [[self selectedTableView:_tabSelectedIndex] closeAllCells];
    [[self selectedTableView:_tabSelectedIndex] reloadData];
}

- (DPCollapseTableView *)selectedTableView:(NSInteger)index {
    DPCollapseTableView *tableView = nil;
    switch (index) {
        case 0:
            tableView = self.livingTable;
            break;
        case 1:
            tableView = self.overTable;
            break;
        case 2:
            tableView = self.nostartTable;
            break;
        case 3:
            tableView = self.focusTable;
            break;

        default:
            break;
    }
    return tableView;
}

#pragma 倒计时
- (void)pvt_startTimer {
    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:1.0 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    [self.timer schedule];
    [self.timer fire];
}

- (void)pvt_stopTimer {
    [self.timer invalidate];
    [self setTimer:nil];
}

//倒计时
- (void)pvt_reloadTimer {
    if (_tabSelectedIndex != 0 && _tabSelectedIndex != 3) {
        return;
    }
    
    DPCollapseTableView *tableView = _tabSelectedIndex == 0 ? self.livingTable : self.focusTable;
    if (tableView.isDragging || tableView.isDecelerating) {
        return; // 拖动或者减速时不处理
    }
    for (int i = 0; i < tableView.visibleCells.count; i++) {
        if (_gameSelectedIndex == 1) {  // 篮球
            DPGameLiveLcCell *cell = tableView.visibleCells[i];
            if (![cell isKindOfClass:[DPGameLiveLcCell class]]) {
                return;
            }
            NSIndexPath *modelIndex = [tableView modelIndexForCell:cell];
            int matchStatus = 0, homeScore = 0, awayScore = 0, onTime = 0;
            _scoreInstance->GetMatchBasketInfo(_tabSelectedIndex + 1, modelIndex.row, matchStatus, homeScore, awayScore, onTime);
            if (matchStatus >= 1 && matchStatus <= 5) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                animation.duration = 0.4;
                animation.autoreverses = YES;
                animation.fromValue = @(1.0);
                animation.toValue = @(0.0);
                [cell.timedianLabel.layer addAnimation:animation forKey:@"changeAlpha"];
            }
        } else {    // 足球
            DPGameLiveJczqCell *cell = tableView.visibleCells[i];
            if (![cell isKindOfClass:[DPGameLiveJczqCell class]]) {
                return;
            }
            NSIndexPath *modelIndex = [tableView modelIndexForCell:cell];
            string startTime, halfStartTime; int matchStatus = 0;
            _scoreInstance->GetMatchFootballOnTime(_tabSelectedIndex + 1, modelIndex.row, startTime, halfStartTime, matchStatus);
            if (matchStatus == 11 || matchStatus == 31) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                animation.duration = 0.4;
                animation.autoreverses = YES;
                animation.fromValue = @(1.0);
                animation.toValue = @(0.0);
                [cell.timedianLabel.layer addAnimation:animation forKey:@"changeAlpha"];
                
                NSString *timeString = nil;
                // 比赛进行状态
                if (matchStatus == 11) {
                    NSInteger timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:[NSString stringWithUTF8String:startTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]];
                    timespan /= 60;
                    if (timespan < 0) {
                        timespan = 0;
                    }
                    timeString = timespan > 45 ? @"45+" : [NSString stringWithFormat:@"%d", timespan];
                } else {
                    NSInteger timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:[NSString stringWithUTF8String:halfStartTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]];
                    timespan /= 60;
                    if (timespan < 0) {
                        timespan = 0;
                    }
                    timeString = timespan > 45 ? @"90+" : [NSString stringWithFormat:@"%d", 45 + timespan];
                }
                if (![cell.beginTimeStatusLabel.text isEqualToString:timeString]) {    // 对时间变动做动画处理
                    CATransition *animation = [CATransition animation];
                    animation.duration = 0.3;
                    animation.type = kCATransitionFade;
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [cell.beginTimeStatusLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
                    cell.beginTimeStatusLabel.text = timeString;
                }
            }
        }
    }
}

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        if (cmdId == NOTIFY_LIVE_EVENT) {
            [[self selectedTableView:_tabSelectedIndex] closeAllCells];
            [[self selectedTableView:_tabSelectedIndex] reloadData];
            if (_gameSelectedIndex != 1) {
                [self.eventView trigger];
            }
            return;
        }
        [[self selectedTableView:_tabSelectedIndex].pullToRefreshView stopAnimating];

        if (cmdType == LIVE_ATTENTION) {
            return;
        }
        //获得期号
        int index = _scoreInstance->GetGameIndex();
        vector<string> gameNames;
        _scoreInstance->GetGameNames(gameNames);
        if (gameNames.size() > 0) {
            NSString *currentIssue = [NSString stringWithUTF8String:gameNames[index].c_str()];
            if (_gameSelectedIndex != 3) {
                NSDate *date = [NSDate dp_dateFromString:currentIssue withFormat:@"YYYY-MM-dd"];
                currentIssue = [NSString stringWithFormat:@"%@", [date dp_stringWithFormat:@"MM-dd"]];
            } else {
                currentIssue = [NSString stringWithFormat:@"%@期", currentIssue];
            }
            _issueSelectedIndex = index;
            [self.issueButton setTitle:currentIssue forState:UIControlStateNormal];
        }
        if (cmdType == LIVE_REF_ATTENTION) {
            [self dismissHUD];
            _ret=ret;
              _guanzhuTotal = _scoreInstance->GetAttentionCount();
            _guanzhuTotal = MAX(0, _guanzhuTotal);
            self.guanzhuLabel.text = [NSString stringWithFormat:@"%d", _guanzhuTotal];
            self.guanzhuLabel.hidden = !_guanzhuTotal;
            [[self selectedTableView:_tabSelectedIndex] closeAllCells];
            [self upDateForNodataView:ret];
           [[self selectedTableView:_tabSelectedIndex] reloadData];
            return;
        }
        if (cmdType == REFRESH) {
            [self dismissHUD];
             _ret=ret;
            _guanzhuTotal = _scoreInstance->GetAttentionCount();
            _guanzhuTotal = MAX(0, _guanzhuTotal);
            self.guanzhuLabel.text = [NSString stringWithFormat:@"%d", _guanzhuTotal];
            self.guanzhuLabel.hidden = !_guanzhuTotal;
            
           
       
           
            if (_requestCount) {
                [self upDataTableViewState];
                [self upDateForNodataView:ret];
                _requestCount = NO;
                return;
            }
            [self changeTabIndex:_tabSelectedIndex];
            [self changeScrollView:_tabSelectedIndex];
            [[self selectedTableView:_tabSelectedIndex] closeAllCells];
            [[self selectedTableView:_tabSelectedIndex] reloadData];
             [self upDateForNodataView:ret];
        }
    });
}

//没有数据时的显示
-(void)upDateForNodataView:(NSInteger)requestRet{
    self.livingTable.tableHeaderView = nil ;
    self.overTable.tableHeaderView = nil ;
    self.nostartTable.tableHeaderView = nil ;
    self.focusTable.tableHeaderView = nil;
    NSInteger total=0;
    if (_tabSelectedIndex==3) {
        total=_scoreInstance->GetAttentionCount();
    }else{
        total=_scoreInstance->GetMatchCount(_tabSelectedIndex+1);
    }
    if ([AFNetworkReachabilityManager sharedManager].reachable == NO) {
        if (total <= 0) {
            self.noDataView.noDataState = DPNoDataNoworkNet;
            
            [self selectedTableView:_tabSelectedIndex].tableHeaderView=self.noDataView;
        } else {
            [[DPToast makeText:kNoWorkNet_] show];
        }
    } else if (requestRet == ERROR_TimeOut || requestRet == ERROR_ConnectHostFail || requestRet == ERROR_NET || requestRet == ERROR_DATA) {
        if (total <= 0) {
            self.noDataView.noDataState  = DPNoDataWorkNetFail;
            [self selectedTableView:_tabSelectedIndex].tableHeaderView=self.noDataView;
        } else {
            [[DPToast makeText:kWorkNetFail_] show];
        }
    } else if (total <= 0) {
        self.noDataView.noDataState = DPNoData;
        [self selectedTableView:_tabSelectedIndex].tableHeaderView=self.noDataView;
    }

}

//切换彩种自动到有比赛的地方
- (void)upDataTableViewState {
    if ((_scoreInstance->GetMatchCount(1) < 1) && (_scoreInstance->GetMatchCount(3) > 0)) {
        _tabSelectedIndex = 2;
    } else if ((_scoreInstance->GetMatchCount(1) < 1) && (_scoreInstance->GetMatchCount(3) < 1) && (_scoreInstance->GetMatchCount(2) > 0)) {
        _tabSelectedIndex = 1;
    } else {
        _tabSelectedIndex = 0;
    }
    [self changeTabIndex:_tabSelectedIndex];
    [self changeScrollView:_tabSelectedIndex];
    [[self selectedTableView:_tabSelectedIndex] closeAllCells];
    [[self selectedTableView:_tabSelectedIndex] reloadData];
}

@end
