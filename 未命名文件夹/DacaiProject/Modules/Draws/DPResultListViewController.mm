//
//  DPResultListViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPResultListViewController.h"
#import "FrameWork.h"
#import "DPResultListViews.h"
#import "DPImageLabel.h"
#import "DPNavigationTitleButton.h"
#import "DPNavigationMenu.h"
#import "DPCalendarView.h"
#import "XTBlurView.h"
#import "DPCollapseTableView.h"
#import "DPResultZcDetailViewController.h"
#import "DPPokerView.h"

#import "DPWF3DTicketTransferVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPSevenLuckTransferVC.h"
#import "DPRank3TransferVC.h"
#import "DPRank5TransferVC.h"
#import "DPSevenStartransferVC.h"
#import "DPElevnSelectFiveVC.h"
#import "DPElevnSelectFiveTransferVC.h"
#import "DPQuick3LotteryVC.h"
#import "DPQuick3transferVC.h"
#import "DPPksBuyViewController.h"
#import "DPPoker3transferVC.h"
#import "DPJczqBuyViewController.h"
#import "DPBdBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPSfcViewController.h"
#import "DPZcNineViewController.h"
#import "DPNodataView.h"
#import "../../Common/View/DPWebViewController.h"

@interface DPResultListViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    ModuleNotify,
    DPNavigationMenuDelegate,
    DPCalendarViewDelegate,
    UIGestureRecognizerDelegate,
    DPResultGameNameViewDelegate
> {
@private
    DPCollapseTableView *_tableView;
    CLotteryResult *_resultInstance;
    DPNavigationTitleButton *_titleButton;
    DPNavigationMenu *_menu;
    UILabel *_gameNameLabel;
    DPCalendarView *_calendarView;
    DPResultGameNameView *_gameNameView;
    UIButton * _touZhuButton ;
    UIButton* _touZhuRJButton;
    
    NSInteger _cmdId;
    //无数据提示图
    DPNodataView *_noDataView ;
    
    UIView *_headView ;


}

@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@property (nonatomic, assign) GameTypeId internalGameType;
@property (nonatomic, assign) NSInteger internalGameIndex;
@property (nonatomic, strong) NSArray *internalGameTitles;
@property (nonatomic, strong) NSDictionary *internalMapping;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong, readonly) UIButton *touZhuButton ;
@property (nonatomic, strong, readonly) UIButton *touZhuRJButton ;

@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) UILabel *gameNameLabel;
@property (nonatomic, strong, readonly) DPCalendarView *calendarView;
@property (nonatomic, strong, readonly) DPResultGameNameView *gameNameView;

@end

@implementation DPResultListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _resultInstance = CFrameWork::GetInstance()->GetLotteryResult();
        _resultInstance->SetDelegate(self);
    }
    return self;
}

- (void)setGameType:(GameTypeId)gameType {
    switch (gameType) {
        case GameTypeJcNone:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeJcSpf:
            _gameType = GameTypeJcNone;
            
            self.internalGameType = (gameType == GameTypeJcNone || gameType == GameTypeJcHt) ? GameTypeJcSpf : gameType;
            self.internalGameTitles = @[@"胜平负", @"让球胜平负", @"比分", @"总进球", @"半全场"];
            self.internalMapping = @{@0: @(GameTypeJcSpf),
                                     @1: @(GameTypeJcRqspf),
                                     @2: @(GameTypeJcBf),
                                     @3: @(GameTypeJcZjq),
                                     @4: @(GameTypeJcBqc),};
            break;
        case GameTypeBdNone:
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdZjq:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
            _gameType = GameTypeBdNone;
            
            self.internalGameType = gameType == GameTypeBdNone ? GameTypeBdRqspf : gameType;
            self.internalGameTitles = @[@"胜平负", @"比分", @"总进球", @"上下单双", @"半全场"];
            self.internalMapping = @{@0: @(GameTypeBdRqspf),
                                     @1: @(GameTypeBdBf),
                                     @2: @(GameTypeBdZjq),
                                     @3: @(GameTypeBdSxds),
                                     @4: @(GameTypeBdBqc),};
            break;
        case GameTypeLcNone:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _gameType = GameTypeLcNone;
            
            self.internalGameType = (gameType == GameTypeLcNone || gameType == GameTypeLcHt) ? GameTypeLcSf : gameType;
            self.internalGameTitles = @[@"胜负", @"让分胜负", @"大小分", @"胜分差"];
            self.internalMapping = @{@0: @(GameTypeLcSf),
                                     @1: @(GameTypeLcRfsf),
                                     @2: @(GameTypeLcDxf),
                                     @3: @(GameTypeLcSfc),};
            break;
        default:
            _gameType = gameType;
            
            self.internalGameType = gameType;
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.gameType) {
        case GameTypeBdNone:
        case GameTypeJcNone:
        case GameTypeLcNone: {
            self.internalGameIndex = [[[self.internalMapping allKeysForObject:@(self.internalGameType)] firstObject] integerValue];
            self.titleButton.titleText = self.internalGameTitles[self.internalGameIndex];
            self.navigationItem.titleView = self.titleButton;
            [self.touZhuButton setTitle:[NSString stringWithFormat:@"%@投注",self.internalGameTitles[self.internalGameIndex]] forState:UIControlStateNormal];
            
           
            _headView = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
                UIView *titleView = [[UIView alloc] init];
                titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.87 alpha:1];
                UILabel *label1 = [[UILabel alloc] init];
                UILabel *label2 = [[UILabel alloc] init];
                UILabel *label3 = [[UILabel alloc] init];
                UILabel *label4 = [[UILabel alloc] init];
                label1.backgroundColor = label2.backgroundColor = label3.backgroundColor = label4.backgroundColor = [UIColor clearColor];
                label1.textColor = label2.textColor = label3.textColor = label4.textColor = [UIColor dp_flatBlackColor];
                label1.font = label2.font = label3.font = label4.font = [UIFont dp_systemFontOfSize:12];
                label1.textAlignment = label2.textAlignment = label3.textAlignment = label4.textAlignment = NSTextAlignmentCenter;
                label2.layer.borderColor = label3.layer.borderColor = [UIColor colorWithRed:0.87 green:0.86 blue:0.82 alpha:1].CGColor;
                label2.layer.borderWidth = label3.layer.borderWidth = 0.5;
                label1.text = @"赛事";
                label2.text = self.gameType == GameTypeLcNone ? @"客队" : @"主队";
                label3.text = @"彩果\n比分";
                label4.text = self.gameType == GameTypeLcNone ? @"主队" : @"客队";
                label3.numberOfLines = 0;
                [titleView addSubview:label1];
                [titleView addSubview:label2];
                [titleView addSubview:label3];
                [titleView addSubview:label4];
                [view addSubview:self.gameNameLabel];
                [view addSubview:titleView];
                [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@75);
                    make.left.equalTo(titleView);
                }];
                [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@85);
                    make.left.equalTo(label1.mas_right);
                }];
                [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@75);
                    make.left.equalTo(label2.mas_right).offset(-0.5);
                }];
                [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@85);
                    make.left.equalTo(label3.mas_right);
                }];
                
                [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.top.equalTo(view);
                    make.height.equalTo(@28);
                }];
                [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.top.equalTo(self.gameNameLabel.mas_bottom);
                    make.bottom.equalTo(view);
                }];
                
                UIView *line1 = [[UIView alloc] init];
                UIView *line2 = [[UIView alloc] init];
                line1.backgroundColor = [UIColor colorWithRed:0.81 green:0.8 blue:0.78 alpha:1];
                line2.backgroundColor = [UIColor colorWithRed:0.87 green:0.86 blue:0.82 alpha:1];
                [view addSubview:line1];
                [view addSubview:line2];
                [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.height.equalTo(@0.5);
                    make.top.equalTo(titleView);
                }];
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.height.equalTo(@0.5);
                    make.bottom.equalTo(titleView);
                }];
                
                view;
            });
            
            self.tableView.tableHeaderView = _headView ;
            [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
            
            UIBarButtonItem *gamesItem = [UIBarButtonItem dp_itemWithTitle:@"往期" target:self action:@selector(pvt_onGames)];
//            UIBarButtonItem *shareItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(pvt_onShare)];
            
            self.navigationItem.rightBarButtonItem = gamesItem;
        }
            break;
        case GameTypeZcNone:
            self.title = @"胜负彩(任九)开奖公告";
            [self.touZhuButton setTitle:@"胜负彩投注" forState:UIControlStateNormal];
            [self.touZhuRJButton setTitle:@"任九投注" forState:UIControlStateNormal];

            break;
        case GameTypeSd:
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeJxsyxw:
        case GameTypeNmgks:
        case GameTypeSdpks:
            self.title = [dp_GameTypeFullName(self.gameType) stringByAppendingString:@"开奖公告"];
            [self.touZhuButton setTitle:[NSString stringWithFormat:@"%@投注",dp_GameTypeFullName(self.gameType)] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isFromClickMore) {
            make.edges.equalTo(self.view) ;
        }else {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 50, 0)) ;
        }
    }];
    
    if (self.gameType != GameTypeJcNone &&
        self.gameType != GameTypeLcNone &&
        self.gameType != GameTypeBdNone) {
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_resultInstance) weakInstance = _resultInstance;
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.tableView.showsInfiniteScrolling = NO;
            weakInstance->RefreshList(0, true);
        }];
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            weakInstance->RefreshList();
        }];
        self.tableView.showsInfiniteScrolling = NO;
    }
    
    [self showHUD];
    _resultInstance->SetGameType(self.internalGameType);
    _resultInstance->RefreshList();
    
    if (self.isFromClickMore) {
        return ;
    }
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor =[UIColor dp_colorFromRGB:0xDAD5CC];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom) ;
        make.width.equalTo(self.view) ;
        make.centerX.equalTo(self.view) ;
        make.height.equalTo(@0.5) ;
    }];
    
    if (self.gameType == GameTypeZcNone) {
        [self.view addSubview:self.touZhuButton];
        [self.view addSubview:self.touZhuRJButton] ;
        [self.touZhuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(5) ;
            make.bottom.equalTo(self.view).offset(-5) ;
            make.left.equalTo(self.view).offset(5) ;
            make.width.equalTo(@((self.view.frame.size.width-15)*0.5)) ;
        }];
        
        [self.touZhuRJButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view).offset(-5) ;
            //            make.left.equalTo(self.view).offset(5) ;
            make.right.equalTo(self.view).offset(-5) ;
            make.width.equalTo(@((self.view.frame.size.width-15)*0.5)) ;
            
            make.top.equalTo(lineView.mas_bottom).offset(5) ;
        }];
    }else{
        [self.view addSubview:self.touZhuButton];
        [self.touZhuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view).offset(-5) ;
            make.left.equalTo(self.view).offset(5) ;
            make.right.equalTo(self.view).offset(-5) ;
            make.top.equalTo(lineView.mas_bottom).offset(5) ;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController dp_applyGlobalTheme];

    _resultInstance->SetDelegate(self);
    
    if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
        self.noDataView.noDataState = DPNoDataNoworkNet ;
        self.tableView.tableHeaderView = self.noDataView ;
        [self dismissHUD];
        return ;
    }else{
        self.tableView.tableHeaderView = _headView ;
    }

}

- (void)dealloc {
    _resultInstance->CleanupList();
}

#pragma mark - event 

- (void)pvt_onNavTitle {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.internalGameIndex];
    [self.menu show];
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onGames {
    if (self.gameType == GameTypeBdNone && _resultInstance->GetListGameCount() == 0) {
        return;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
    tapGestureRecognizer.delegate = self;
    
    XTBlurView * coverView = [[XTBlurView alloc] init];
    coverView.blurRadius = 10;
    coverView.saturationDelta = 1.1;
    coverView.alpha = 0;
    [coverView addGestureRecognizer:tapGestureRecognizer];
    [self.navigationController.view addSubview:coverView];
   
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
    switch ([DPDeviceUtilities deviceVersion]) {
        case iPhone4:
        case iPad1:
            [NSThread sleepForTimeInterval:0.45];
            break;
        case iPhone4S:
        case iPad2:
            [NSThread sleepForTimeInterval:0.25];
            break;
        default:
            break;
    }
    
    if (self.gameType == GameTypeLcNone || self.gameType == GameTypeJcNone) {
        string gameName;
        _resultInstance->GetListCurrentGameName(gameName);
        NSDate *date = [NSDate dp_dateFromString:[NSString stringWithUTF8String:gameName.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd];
        
        [coverView addSubview:self.calendarView];
        [self.calendarView setSelectedDate:date];
        [self.calendarView setToday:[NSDate dp_date]];
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IOS_VERSION_7_OR_ABOVE) {
                make.edges.insets(UIEdgeInsetsMake(20, 0, 0, 0));
            } else {
                make.edges.equalTo(coverView);
            }
        }];
    } else {
        string gameName;
        _resultInstance->GetListCurrentGameName(gameName);
        int selected = [[NSString stringWithUTF8String:gameName.c_str()] integerValue];
        for (int i = 0; i < _resultInstance->GetListGameCount(); i++) {
            int gameName, gameId;
            _resultInstance->GetListGameId(i, gameId, gameName);
            if (selected == gameName) {
                selected = i;
            }
        }
        [self.gameNameView setSelectedIndex:selected];
        [coverView addSubview:self.gameNameView];
        [self.gameNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IOS_VERSION_7_OR_ABOVE) {
                make.edges.insets(UIEdgeInsetsMake(80, 0, 0, 0));
            } else {
                make.edges.insets(UIEdgeInsetsMake(60, 0, 0, 0));
            }
        }];
        
        UIView* bgv = [[UIView alloc]init];
        bgv.backgroundColor = [UIColor dp_flatRedColor] ;
        [coverView addSubview:bgv];
        [bgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(coverView) ;
            if (IOS_VERSION_7_OR_ABOVE) {
                make.height.equalTo(@70) ;
            } else {
                make.height.equalTo(@50);
            }
            make.width.equalTo(coverView);
            make.left.equalTo(coverView) ;
        }];

    }
    
    [UIView animateWithDuration:0.2 animations:^{
        coverView.alpha = 1;
    }];
}

- (void)pvt_onShare {
    
}

- (void)pvt_onCover:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UIView *view =[sender view];
        [UIView animateWithDuration:0.3 animations:^{
            [view setAlpha:0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    } else if ([sender isKindOfClass:[UIView class]]) {
        [UIView animateWithDuration:0.3 animations:^{
            [sender setAlpha:0];
        } completion:^(BOOL finished) {
            [sender removeFromSuperview];
        }];
    }
}

#pragma mark - table view's data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return  _resultInstance->GetListCount();
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsGameTypeJc(self.internalGameType) || IsGameTypeBd(self.internalGameType) || IsGameTypeLc(self.internalGameType)) {
        static NSString *CellIdentifier = @"Cell";
        DPSportsResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSportsResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell buildLayout:self.gameType == GameTypeLcNone]; // 篮彩主客相反
        }
        
        int homeScore, awayScore;
        string competition, orderNumber, startTime, homeTeam, awayTeam, result, regulatedValue;
        _resultInstance->GetListTarget(indexPath.row, competition, orderNumber, startTime, homeTeam, awayTeam, homeScore, awayScore, result, regulatedValue);
        
        cell.competitionLabel.text = [NSString stringWithUTF8String:competition.c_str()];
        cell.orderNumberLabel.text = [NSString stringWithUTF8String:orderNumber.c_str()];
        cell.startTimeLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:startTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm];
        
        // 大小分(总分)
        if (self.internalGameType == GameTypeLcDxf) {
            cell.resultLabel.text = [NSString stringWithFormat:@"%@(%@)", [NSString stringWithUTF8String:result.c_str()], [NSString stringWithUTF8String:regulatedValue.c_str()]];
        } else {
            cell.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
        }
        // 让球, 让分
        
        cell.awayLabel.text = [NSString stringWithUTF8String:awayTeam.c_str()];
        if (self.internalGameType == GameTypeLcRfsf || self.internalGameType == GameTypeJcRqspf || self.internalGameType == GameTypeBdRqspf) {
            NSString *homeName = [NSString stringWithUTF8String:homeTeam.c_str()];
            NSString *regulated = [NSString stringWithUTF8String:regulatedValue.c_str()];
            
            if (regulated.integerValue == 0) {
                cell.homeLabel.text = homeName;
            } else {
                UIColor *colors = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
                if (regulated.floatValue < 0) {
                    colors = [UIColor dp_flatBlueColor];
                    regulated = [NSString stringWithFormat:@"(%@)", regulated];
                } else {
                    colors = [UIColor dp_flatRedColor];
                    regulated = [NSString stringWithFormat:@"(+%@)", regulated];
                }
                [cell.homeLabel setText:[homeName stringByAppendingString:regulated] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange range = NSMakeRange(homeName.length, regulated.length);
                    UIFont *font = [UIFont dp_regularArialOfSize:10];
                    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
                    if (fontRef) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
                        CFRelease(fontRef);
                    }
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[colors CGColor] range:range];
                    return mutableAttributedString;
                }];
            }
        } else {
            cell.homeLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
        }
        // 篮彩主客相反
        if (self.gameType == GameTypeLcNone) {
            cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", awayScore, homeScore];
        } else {
            cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", homeScore, awayScore];
        }
        // 彩果色值
        switch (self.internalGameType) {
            case GameTypeLcSf: case GameTypeLcRfsf:
            case GameTypeJcRqspf: case GameTypeJcSpf:
            case GameTypeBdRqspf:
                if (([cell.resultLabel.text rangeOfString:@"胜"]).location != NSNotFound) {
                    cell.resultView.backgroundColor = [UIColor colorWithRed:0.97 green:0.79 blue:0.76 alpha:1];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.76 green:0.32 blue:0.32 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.76 green:0.32 blue:0.32 alpha:1];
                } else if (([cell.resultLabel.text rangeOfString:@"负"]).location != NSNotFound) {
                    cell.resultView.backgroundColor = [UIColor colorWithRed:0.82 green:0.99 blue:0.81 alpha:1];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.13 green:0.37 blue:0.07 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.13 green:0.37 blue:0.07 alpha:1];
                } else {
                    cell.resultView.backgroundColor = [UIColor clearColor];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
                }
                break;
            case GameTypeJcBf: case GameTypeJcBqc: case GameTypeJcZjq:
            case GameTypeBdBf: case GameTypeBdBqc: case GameTypeBdZjq: case GameTypeBdSxds:
            case GameTypeLcSfc: case GameTypeLcDxf:
                cell.resultView.backgroundColor = [UIColor dp_flatWhiteColor];
                cell.scoreLabel.textColor = [UIColor dp_flatRedColor];
                cell.resultLabel.textColor = [UIColor dp_flatRedColor];
                break;
            default:
                break;
        }
        return cell;
        
    } else {
        NSString *CellIdentifier = (indexPath.row == 0 ? @"Cell0" : @"Cell");
        DPNumberResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPNumberResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell layoutWithType:self.internalGameType prettyStyle:indexPath.row == 0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (self.gameType == GameTypeJxsyxw || self.gameType == GameTypeSdpks || self.gameType == GameTypeNmgks) {
                cell.arrowView.hidden = YES;
            }
        }
        
        int result[15], gameName, gameId;
        string drawTime;
        _resultInstance->GetListTarget(indexPath.row, result, gameName, gameId, drawTime);
        
        cell.gameNameLabel.text = [NSString stringWithFormat:@"第%d期", gameName];
        cell.drawTimeLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:drawTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
        cell.arrowView.highlighted = [tableView isExpandAtModelIndex:indexPath];
        
        switch (self.internalGameType) {
            case GameTypeSsq:
            case GameTypeQlc:
            case GameTypeDlt:
            case GameTypeJxsyxw: {
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    label.text = [NSString stringWithFormat:@"%02d", result[i]];
                }
            }
                break;
            case GameTypeSd: {
                // 设置试机号
                cell.preResultLabel.text = [NSString stringWithFormat:@"%d  %d  %d", result[3], result[4], result[5]];
                // 只有试机号没有奖号时隐藏
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    label.hidden = result[0] < 0;
                }
            }
            case GameTypePs:
            case GameTypePw:
            case GameTypeQxc:
            case GameTypeZcNone: {
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    label.text = [NSString stringWithFormat:@"%d", result[i]];
                }
            }
                break;
            case GameTypeNmgks: {
                if (indexPath.row == 0) {
                    const NSDictionary *imageMapping = @{ @0: @"", @1: @"ks1.png", @2: @"ks2.png", @3: @"ks3.png", @4: @"ks4.png", @5: @"ks5.png", @6: @"ks6.png", };
                    for (int i = 0; i < cell.drawItems.count; i++) {
                        UIImageView *imageView = cell.drawItems[i];
                        imageView.image = dp_ResultImage(imageMapping[@(result[i])]);
                    }
                } else {
                    for (int i = 0; i < cell.drawItems.count; i++) {
                        UILabel *label = cell.drawItems[i];
                        label.text = [NSString stringWithFormat:@"%d", result[i]];
                    }
                }
            }
                break;
            case GameTypeSdpks: {
                if (indexPath.row == 0) {
                    for (int i = 0; i < cell.drawItems.count; i++) {
                        DPPokerView *poker = cell.drawItems[i];
                        poker.number = result[i];
                        poker.type = result[i + 3];
                    }
                } else {
                    for (int i = 0; i < cell.drawItems.count; i++) {
                        const NSDictionary *textMapping = @{ @0: @"", @1: @"A", @2: @"2", @3: @"3", @4: @"4", @5: @"5", @6: @"6", @7: @"7", @8: @"8", @9: @"9", @10: @"10", @11: @"J", @12: @"Q", @13: @"K", };
                        const NSDictionary *imageMapping = @{ @0: @"", @1: @"pks1.png", @2: @"pks2.png", @3: @"pks3.png", @4: @"pks4.png", };
                        UIColor *color = (result[i + 3] <= 2 ? [UIColor colorWithRed:0.84 green:0.16 blue:0.16 alpha:1] : [UIColor dp_flatBlackColor]);
                        DPImageLabel *label = cell.drawItems[i];
                        label.text = textMapping[@(result[i])];
                        label.textColor = color;
                        label.image = dp_ResultImage(imageMapping[@(result[i + 3])]);
                    }
                }
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(DPCollapseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameType == GameTypeJcNone || self.gameType == GameTypeLcNone || self.gameType == GameTypeBdNone ||
        self.gameType == GameTypeJxsyxw || self.gameType == GameTypeSdpks || self.gameType == GameTypeNmgks) {
        return;
    }
    
    BOOL expand = NO;
    NSIndexPath *modelIndex = [tableView modelIndexFromTableIndex:indexPath expand:&expand];
    
    if (!expand) {
        NSIndexPath *indexPath = tableView.expandModelIndexs.firstObject;
        if (indexPath && indexPath != modelIndex) {
            DPNumberResultListCell *cell = (DPNumberResultListCell *)[tableView cellForRowAtModelIndex:indexPath expand:NO];
            cell.arrowView.highlighted = NO;
        }
        
        BOOL isexpande = [tableView isExpandAtModelIndex:modelIndex];
        [tableView toggleCellAtModelIndex:modelIndex animation:YES];
    
        if (!isexpande) {
            NSIndexPath *newIndexPath = [tableView tableIndexFromModelIndex:tableView.expandModelIndexs.firstObject expand:NO];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        DPNumberResultListCell *cell = (DPNumberResultListCell *)[tableView cellForRowAtModelIndex:modelIndex expand:NO];
        cell.arrowView.highlighted = [tableView isExpandAtModelIndex:modelIndex];
    }
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsGameTypeJc(self.internalGameType) || IsGameTypeBd(self.internalGameType) || IsGameTypeLc(self.internalGameType)) {
        return 35;
    }
    return 60;
//    return indexPath.row == 0 ? 60 : 50;
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeSsq:
        case GameTypeQxc:
            return 250;
        case GameTypeQlc:
            return 275;
        case GameTypeDlt:
            return 375;
        case GameTypeSd:
        case GameTypePs:
            return 175;
        case GameTypePw:
            return 125;
        case GameTypeZcNone:
            return 275 + 40;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InfoCell";
    DPNumberResultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPNumberResultInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setGameType:self.gameType];
        
        __weak DPCollapseTableView *weakTableView = tableView;
        __weak DPResultListViewController *weakSelf = self;
        __block CLotteryResult *weakResultInstance = _resultInstance;
        [cell buildLayout:^(DPNumberResultInfoCell *cell) {
            NSIndexPath *indexPath = [weakTableView modelIndexForCell:cell];
            int gameName, gameId; string drawTime;
            weakResultInstance->GetListTarget(indexPath.row, NULL, gameName, gameId, drawTime);
            
            DPResultZcDetailViewController *viewController = [[DPResultZcDetailViewController alloc] init];
            viewController.gameId = gameId;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }];
    }
    
    int count = self.gameType == GameTypeZcNone ? 2 : 1;
    for (int i = 0; i < count; i++) {
        int globalAmount, globalSurplus, winCount[15] = { 0 }, winAmt[15] = { 0 };
        _resultInstance->GetListTargetInfo(indexPath.row, globalAmount, globalSurplus, winCount, winAmt, i);
        
        DPResultInfoGirdView *titleView = cell.titleList[i];
        DPResultInfoGirdView *detailView = cell.detailList[i];
        
        [titleView setTitle:[NSString stringWithFormat:@"%d", globalAmount] forRow:1 column:0];
        [titleView setTitle:[NSString stringWithFormat:@"%d", globalSurplus] forRow:1 column:1];
        
        for (int i = 0; i < 15; i++) {
            [detailView setTitle:[NSString stringWithFormat:@"%d", winCount[i]] forRow:i + 1 column:1];
            [detailView setTitle:[NSString stringWithFormat:@"%d", winAmt[i]] forRow:i + 1 column:2];
        }
    }
    
    return cell;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.gameType == GameTypeLcNone || self.gameType == GameTypeJcNone) {
        CGPoint point = [touch locationInView:self.calendarView];
        CGSize size = self.calendarView.contentSize;
        if (CGRectContainsPoint(CGRectMake(0, 0, size.width, size.height), point)) {
            return NO;
        }
    } else {
        CGPoint point = [touch locationInView:self.gameNameView];
        CGFloat height = 43 * ((_resultInstance->GetListGameCount() - 1) / 3 + 1);
        if (CGRectContainsPoint(CGRectMake(0, 0, 320, height), point)) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - DPNavigationMenuDelegate
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    self.internalGameIndex = index;
    self.internalGameType = (GameTypeId)[self.internalMapping[@(index)] integerValue];
    _resultInstance->SetGameType(self.internalGameType);
    _resultInstance->RefreshList();
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
    [self.touZhuButton setTitle:[NSString stringWithFormat:@"%@投注",self.menu.items[self.menu.selectedIndex]] forState:UIControlStateNormal];
}

#pragma mark - DPCalendarViewDelegate
- (BOOL)calendarView:(DPCalendarView *)calendarView shouldSelectedDate:(NSDate *)date {
    if ([date dp_timeIntervalSinceNow] <= 0) {
        return YES;
    } else {
        [[DPToast makeText:@"不可选择该日期!"] show];
        return NO;
    }
}

- (void)calendarView:(DPCalendarView *)calendarView didSelectedDate:(NSDate *)date {
    [self pvt_onCover:calendarView.superview];
    NSInteger gameId = [[date dp_stringWithFormat:@"YYYYMMdd"] integerValue];
    _resultInstance->RefreshList(gameId);
    [self showHUD];
}

#pragma mark - DPResultGameNameViewDelegate
- (NSString *)view:(DPResultGameNameView *)view titleAtIndex:(NSInteger)index {
    int gameId, gameName;
    _resultInstance->GetListGameId(index, gameId, gameName);
    return [NSString stringWithFormat:@"%d", gameName];
}

- (NSInteger)gameCountForView:(DPResultGameNameView *)view {
    return _resultInstance->GetListGameCount();
}

- (void)view:(DPResultGameNameView *)view didSelectedAtIndex:(NSInteger)index {
    [self pvt_onCover:view.superview];
    int gameId, gameName;
    _resultInstance->GetListGameId(index, gameId, gameName);
    _resultInstance->RefreshList(gameId);
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
            [self.tableView closeAllCells];
        }
//        [self dismissHUD];
        
        
        self.tableView.tableHeaderView = _headView ;
        NSInteger sectionCount = _resultInstance->GetListCount();
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState= DPNoDataNoworkNet ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet_]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState = DPNoDataWorkNetFail ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail_]show];
            }
        }else if (sectionCount <= 0){
            self.noDataView.noDataState = DPNoData ;
            self.tableView.tableHeaderView = self.noDataView ;
        }

        switch (self.gameType) {
            case GameTypeJcNone:
            case GameTypeLcNone: {
                string gameName;
                _resultInstance->GetListCurrentGameName(gameName);
                self.gameNameLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:gameName.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd toFormat:@"yyyy年MM月dd日  EEEE"];
            }
                break;
            case GameTypeBdNone: {
                string gameName;
                _resultInstance->GetListCurrentGameName(gameName);
                self.gameNameLabel.text = [NSString stringWithFormat:@"第%@期", [NSString stringWithUTF8String:gameName.c_str()]];
            }
                break;
            default:
                break;
        }
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        
        [self dismissHUD];

        if (self.tableView.infiniteScrollingView) {
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView setShowsInfiniteScrolling:YES];
        }
    });
}

#pragma mark - getter

-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        _noDataView.gameType = GameTypeLcNone ;
        __weak __typeof(self) weakSelf = self;
        __block CLotteryResult *weak_resultInstance= _resultInstance;
        
        [_noDataView setClickBlock:^(BOOL setOrUpDate){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
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
                REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weak_resultInstance->RefreshList());
            }
            
        }];
    }
    return _noDataView ;
}


- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.expandMutual = YES;
    }
    return _tableView;
}

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    }
    return _titleButton;
}

- (UIButton *)touZhuButton {
    if (_touZhuButton == nil) {
        _touZhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touZhuButton.backgroundColor = [UIColor dp_flatRedColor] ;
        _touZhuButton.titleLabel.font = [UIFont dp_boldSystemFontOfSize:14] ;
        [_touZhuButton addTarget:self action:@selector(pv_touZhu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touZhuButton;
}
- (UIButton *)touZhuRJButton {
    if (_touZhuRJButton == nil) {
        _touZhuRJButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touZhuRJButton.backgroundColor = [UIColor dp_flatRedColor] ;
        _touZhuRJButton.titleLabel.font = [UIFont dp_boldSystemFontOfSize:14] ;
        [_touZhuRJButton addTarget:self action:@selector(pv_touZhuRJ) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touZhuRJButton;
}

-(void)pv_touZhu{
    switch (self.gameType) {
        case GameTypeSd: {
            [self.navigationController pushViewController:[[DPWF3DTicketTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeSsq: {
            [self.navigationController pushViewController:[[DPDoubleHappyTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeDlt: {
            [self.navigationController pushViewController:[[DPBigHappyTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeQlc: {
            [self.navigationController pushViewController:[[DPSevenLuckTransferVC alloc] init] animated:YES];
        } break;
        case GameTypePs: {
            [self.navigationController pushViewController:[[DPRank3TransferVC alloc] init] animated:YES];
        } break;
        case GameTypePw: {
            [self.navigationController pushViewController:[[DPRank5TransferVC alloc] init] animated:YES];
        } break;
        case GameTypeQxc: {
            [self.navigationController pushViewController:[[DPSevenStartransferVC alloc] init] animated:YES];
        } break;
        case GameTypeJxsyxw: {
            DPElevnSelectFiveVC *vc = [[DPElevnSelectFiveVC alloc] init];
            DPElevnSelectFiveTransferVC *transVC = [[DPElevnSelectFiveTransferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeNmgks: {
            DPQuick3LotteryVC *vc = [[DPQuick3LotteryVC alloc] init];
            DPQuick3transferVC *transVC = [[DPQuick3transferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeSdpks: {
            DPPksBuyViewController *vc = [[DPPksBuyViewController alloc] init];
            DPPoker3transferVC *transVC = [[DPPoker3transferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeBdNone: {
            DPBdBuyViewController *bdVc = [[DPBdBuyViewController alloc] init];
            bdVc.gameType = self.internalGameType;
            [self.navigationController pushViewController:bdVc animated:YES];
        } break;
        case GameTypeLcNone: {
            DPJclqBuyViewController *vc = [[DPJclqBuyViewController alloc] init];
            vc.gameType = self.internalGameType;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case GameTypeJcNone: {
            DPJczqBuyViewController *vc = [[DPJczqBuyViewController alloc] init];
            vc.gameType = self.internalGameType;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case GameTypeZcNone: {
            [self.navigationController pushViewController:[[DPSfcViewController alloc] init] animated:YES];
        } break;
        case GameTypeZc9: {
            [self.navigationController pushViewController:[[DPZcNineViewController alloc] init] animated:YES];
        } break;
        default:
            break;
    }

}

-(void)pv_touZhuRJ {
    [self.navigationController pushViewController:[[DPZcNineViewController alloc] init] animated:YES];
}

- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.items = self.internalGameTitles;
    }
    return _menu;
}

- (UILabel *)gameNameLabel {
    if (_gameNameLabel == nil) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        _gameNameLabel.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1];
        _gameNameLabel.textAlignment = NSTextAlignmentCenter;
        _gameNameLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _gameNameLabel;
}

- (DPCalendarView *)calendarView {
    if (_calendarView == nil) {
        _calendarView = [[DPCalendarView alloc] init];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (DPResultGameNameView *)gameNameView {
    if (_gameNameView == nil) {
        _gameNameView = [[DPResultGameNameView alloc] init];
        _gameNameView.delegate = self;
    }
    return _gameNameView;
}

@end
