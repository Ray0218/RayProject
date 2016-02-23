//
//  DPLotteryResultViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryResultViewController.h"
#import "DPResultListViewController.h"
#import "DPLotteryResultCell.h"
#import "FrameWork.h"
#import "DPCalendarView.h"
#import "DPPokerView.h"
#import "SVPullToRefresh.h"

@interface DPLotteryResultViewController () <ModuleNotify, UITableViewDelegate, UITableViewDataSource> {
@private
    CLotteryResult *_resultInstance;
    UITableView *_tableView;
    NSInteger _cmdId;
}

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation DPLotteryResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _resultInstance = CFrameWork::GetInstance()->GetLotteryResult();
        _resultInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开奖公告";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onHome)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak __typeof(self) weakSelf = self;
    __block __typeof(_resultInstance) weakInstance = _resultInstance;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.pullToRefreshView stopAnimating];
        [strongSelf showHUD];
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weakInstance->RefreshHome());
    }];
    [self.tableView.pullToRefreshView setDelay:0.15];
    
    [self showHUD];
    _cmdId = _resultInstance->RefreshHome();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _resultInstance->SetDelegate(self);
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 75;
        _tableView.separatorColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - event

- (void)pvt_onHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    
    _resultInstance->CleanupHome();
}

#pragma mark - table view's data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int gameType, result[15], gameName, homeScore, awayScore;
    string drawTime, homeTeam, awayTeam, gameNameStr;
    _resultInstance->GetHomeTarget(indexPath.row, gameType);
    _resultInstance->GetHomeTarget(indexPath.row, result, gameName, drawTime);
    _resultInstance->GetHomeTarget(indexPath.row, homeTeam, awayTeam, homeScore, awayScore, gameNameStr);
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", gameType];
    DPLotteryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPLotteryResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell buildLayout];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell layoutWithGameType:(GameTypeId)gameType];
        
        switch (gameType) {
            case GameTypeBdNone:
                cell.gameTypeLabel.text = @"北京单场";
                break;
            case GameTypeJcNone:
                cell.gameTypeLabel.text = @"竞彩足球";
                break;
            case GameTypeLcNone:
                cell.gameTypeLabel.text = @"竞彩篮球";
                break;
            case GameTypeZcNone:
                cell.gameTypeLabel.text = @"胜负彩/任选九";
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
                cell.gameTypeLabel.text = dp_GameTypeFullName((GameTypeId)gameType);
                break;
            default:
                break;
        }
    }
    
    if (gameType == GameTypeBdNone || gameType == GameTypeJcNone) {
        cell.gameNameLabel.text = [[NSString stringWithUTF8String:gameNameStr.c_str()] stringByAppendingString:@"期"];//(gameType == GameTypeBdNone ? );
        cell.matchLabel.text = [NSString stringWithFormat:@"%@   %d:%d   %@", [NSString stringWithUTF8String:homeTeam.c_str()], homeScore, awayScore, [NSString stringWithUTF8String:awayTeam.c_str()]];
        [cell.matchLabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if (obj.firstItem == cell.matchLabel && obj.firstAttribute == NSLayoutAttributeWidth) {
                obj.constant = cell.matchLabel.intrinsicContentSize.width + 20;
            }
        }];

        return cell;
    }
    if (gameType == GameTypeLcNone) {
        cell.gameNameLabel.text = [[NSString stringWithUTF8String:gameNameStr.c_str()] stringByAppendingString:@"期"];//(gameType == GameTypeBdNone ? );
        cell.matchLabel.text = [NSString stringWithFormat:@"%@   %d:%d   %@", [NSString stringWithUTF8String:awayTeam.c_str()], awayScore, homeScore, [NSString stringWithUTF8String:homeTeam.c_str()]];
        [cell.matchLabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if (obj.firstItem == cell.matchLabel && obj.firstAttribute == NSLayoutAttributeWidth) {
                obj.constant = cell.matchLabel.intrinsicContentSize.width + 20;
            }
        }];
        
        return cell;
    }
    
    cell.gameNameLabel.text = [NSString stringWithFormat:@"%d期", gameName];
    cell.drawTimeLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:drawTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
    
    switch (gameType) {
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypeJxsyxw: {
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                label.text = [NSString stringWithFormat:@"%02d", result[i]];
            }
        }
            break;
        case GameTypeSd: {
            // 设置试机号
            cell.preResultLabel.text = [NSString stringWithFormat:@"%d  %d  %d", result[3], result[4], result[5]];
            // 只有试机号没有奖号时隐藏
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                label.hidden = result[0] < 0;
            }
        }
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeZcNone: {
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                label.text = [NSString stringWithFormat:@"%d", result[i]];
            }
        }
            break;
        case GameTypeNmgks: {
            for (int i = 0; i < cell.nmgks.count; i++) {
                const NSDictionary *imageMapping = @{ @0: @"", @1: @"ks1.png", @2: @"ks2.png", @3: @"ks3.png", @4: @"ks4.png", @5: @"ks5.png", @6: @"ks6.png", };
                UIImageView *imageView = cell.nmgks[i];
                imageView.image = dp_ResultImage(imageMapping[@(result[i])]);
            }
        }
            break;
        case GameTypeSdpks: {
            for (int i = 0; i < cell.sdpks.count; i++) {
                DPPokerView *poker = cell.sdpks[i];
                poker.number = result[i];
                poker.type = result[i + 3];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultInstance->GetHomeCount();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int gameType;
    _resultInstance->GetHomeTarget(indexPath.row, gameType);
    
    DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
    viewController.isFromClickMore = NO ;
    viewController.gameType = (GameTypeId)gameType;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ModuleNotify

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
}

@end
