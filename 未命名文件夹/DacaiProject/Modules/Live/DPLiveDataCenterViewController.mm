//
//  DPLiveDataCenterViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveDataCenterViewController.h"
#import "DPLiveDataCenterHeaderView.h"
#import "DPLiveCompetitionSubViewController.h"
#import "DPLiveAnalysisSubViewController.h"
#import "DPLivePointSubViewController.h"
#import "DPLiveOddsPositionSubViewController.h"
#import "DPLiveBreakevenSubViewController.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"

#import "DPLiveLCOddsPositTableViewController.h"
#import "DPLiveLCPointTableViewController.h"
#import "DPLiveLCAnalysisTableViewController.h"
#import "DPLiveLCCompetionTableViewController.h"
@interface DPLiveDataCenterViewController () <ModuleNotify> {
@private
    
    CBasketballCenter *_basketCenter ;
    CFootballCenter *_dataCenter;
    GameTypeId _gameType  ;
    
    
    DPLiveDataCenterHeaderView *_encounterView;

    DPLiveCompetitionSubViewController *_competitionViewController;
    DPLiveAnalysisSubViewController *_analysisViewController;
    DPLivePointSubViewController *_pointViewController;
    DPLiveOddsPositionSubViewController *_oddsPositionViewController;
    DPLiveBreakevenSubViewController *_breakevenViewController;
    
    
    DPLiveLCCompetionTableViewController *_competitionLCViewController;
    DPLiveLCAnalysisTableViewController *_analysisLCViewController;
    DPLiveLCPointTableViewController *_pointLCViewController;
    DPLiveLCOddsPositTableViewController *_oddsLCPositionViewController;
    NSMutableArray* _baseViewControllers ;
    
    
    NSInteger _defaultIndex ;
    NSInteger _comptionNet ;//赛事请求状态
    NSInteger _anasysNet ;//分析请求状态
    NSInteger _poinNet ;//积分请求状态
    NSInteger _oddsNet ;//赔盘请求状态
    NSInteger _breakNet ;//盈亏请求状态
    NSInteger _headNet ;//头部数据刷新
    
    
//    NSInteger _matchId ;

}

@property (nonatomic, strong, readonly) UIView *lineView;
@property (nonatomic, strong, readonly) DPLiveDataCenterHeaderView *encounterView;
@property (nonatomic, strong, readonly) DPLiveCompetitionSubViewController *competitionViewController;
@property (nonatomic, strong, readonly) DPLiveAnalysisSubViewController *analysisViewController;
@property (nonatomic, strong, readonly) DPLivePointSubViewController *pointViewController;
@property (nonatomic, strong, readonly) DPLiveOddsPositionSubViewController *oddsPositionViewController;
@property (nonatomic, strong, readonly) DPLiveBreakevenSubViewController *breakevenViewController;

@property (nonatomic, strong, readonly) DPLiveLCOddsPositTableViewController *oddsLCPositionViewController;
@property (nonatomic, strong, readonly) DPLiveLCPointTableViewController *pointLCViewController;
@property (nonatomic, strong, readonly) DPLiveLCAnalysisTableViewController *analysisLCViewController;
@property (nonatomic, strong, readonly) DPLiveLCCompetionTableViewController *competitionLCViewController;



@end



@implementation DPLiveDataCenterViewController


-(instancetype)initWithGameType:(GameTypeId)type withDefaultIndex:(NSInteger)index withMatchId:(NSInteger)matchId{

    self = [super initWithNibName:nil bundle:nil];
    g_matchId = 0 ;
    g_matchId = matchId ;
    
    g_awayName = g_homeName =@"" ;
    _oddsNet = _comptionNet = _anasysNet = _poinNet= _breakNet=_headNet =g_oddsFirst=g_oddsSecond=g_oddsThird= -1 ;
    
    if (self) {
        // Custom initialization
        
        _gameType = type ;
        _defaultIndex = index ;
        _encounterView = [[DPLiveDataCenterHeaderView alloc] initWithGameType:type];

        if (type == GameTypeLcNone) {
            _basketCenter = CFrameWork::GetInstance()->GetBasketballCenter() ;
            _basketCenter ->SetDelegate(self) ;
        }else{
            _dataCenter = CFrameWork::GetInstance()->GetFootballCenter();
            _dataCenter->SetDelegate(self);
        }
        
    }
    return self;

}

-(void)setCurrentViewControl:(NSInteger)index{

    if (self.selectedIndex != index) {
        [self.containerView setContentOffset:(CGPoint){(float)index*320, self.containerView.contentOffset.y } animated:NO];
        self.selectedIndex  = index ;
        self .selectedViewController = [self.viewControllers objectAtIndex:index] ;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (_gameType == GameTypeLcNone) {
        _basketCenter ->SetDelegate(self) ;
    }else{
        _dataCenter->SetDelegate(self);
    }


   
}

-(void)dealloc{
    if (_gameType == GameTypeLcNone) {
        _basketCenter->Clear() ;
    }else{
        _dataCenter->Clear() ;
    }

}
-(void)pvt_refresh{

    _oddsNet = _comptionNet = _anasysNet = _poinNet= _breakNet=_headNet =g_oddsFirst=g_oddsSecond=g_oddsThird  -1 ;
    [self requestDataWithIndex:self.selectedIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_CommonImage(@"reload.png") target:self action:@selector(pvt_refresh)];

    
//    self.containerView.directionalLockEnabled = YES  ;
    
 
    _lineView = [[UIView alloc] init];
    _lineView.userInteractionEnabled = NO;

    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    self.headerView = self.encounterView;
    

    [self.view addSubview:self.lineView];
    
    
    self.containerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight) ;
    if (_gameType == GameTypeLcNone) {
        
        _lineView.backgroundColor = UIColorFromRGB(0x3B2512);
        self.tabBar.backgroundColor =[UIColor colorWithRed:112/255.0 green:84/255.0 blue:67/255.0 alpha:0.7];
        _headNet = _basketCenter->Net_RefreshMatchInfo(g_matchId) ;
         _baseViewControllers=[NSMutableArray arrayWithArray:@[self.competitionLCViewController, self.analysisLCViewController, self.pointLCViewController, self.oddsLCPositionViewController]];
        
        
    }else{
        _lineView.backgroundColor =[UIColor colorWithRed:0.27 green:0.56 blue:0.89 alpha:1];
        self.tabBar.backgroundColor =[UIColor colorWithRed:15/255.0 green:49/255.0 blue:108/255.0 alpha:0.7];

            _headNet = _dataCenter->RefreshMatchInfo(g_matchId) ;
        
        _baseViewControllers=[NSMutableArray arrayWithArray:@[self.competitionViewController, self.analysisViewController, self.pointViewController, self.oddsPositionViewController, self.breakevenViewController]];

    }
    [self setViewControllers:_baseViewControllers withDefaultIndex:_defaultIndex] ;
    [self requestDataWithIndex:_defaultIndex];
    self.containerView.contentOffset = CGPointMake(_defaultIndex*kScreenWidth, 0) ;
    
    
}
-(void)requestDataWithIndex:(NSInteger)index{

    if (_gameType == GameTypeLcNone) {
        
        if (_headNet<0) {
            _headNet = _basketCenter->Net_RefreshMatchInfo(g_matchId) ;
        }
        switch (index) {
            case 0:
                if (_comptionNet<0) {
                    _comptionNet = _basketCenter->Net_RefreshCompetition(g_matchId);
                }
                break;
            case 1:
                if (_anasysNet<0) {
                    _anasysNet = _basketCenter->Net_RefreshAgainstList(g_matchId) ;
                }
                break;
            case 2:
                if (_poinNet<0) {
                    _poinNet = _basketCenter->Net_RefreshScoreboard(g_matchId) ;
                }
                break;
            case 3:
                if (_oddsNet<0) {
                    _oddsNet = _basketCenter->Net_RefreshOddsHandicap(g_matchId);
                }
                break;
            default:
                break;
        }
        
    }else{
        
        if (_headNet<0) {
            _headNet = _dataCenter->RefreshMatchInfo(g_matchId) ;
        }
        switch (index) {
            case 0:
                if (_comptionNet<0) {
                    _comptionNet = _dataCenter->RefreshComeptition(g_matchId);
                }
                break;
            case 1:
                if (_anasysNet<0) {
                    _anasysNet = _dataCenter->RefreshAnalysis(g_matchId);
                }
                break;
            case 2:
                if (_poinNet<0) {
                    _poinNet = _dataCenter->RefreshStandings(g_matchId);
                }
                break;
            case 3:
                if (_oddsNet<0) {
                    g_oddsFirst =
                    _oddsNet = _dataCenter->RefreshOddsHandicap(g_matchId, 1) ;
                }
                break;
            case 4:
                if (_breakNet<0) {
                    _breakNet = _dataCenter->RefreshBreakeven(g_matchId);
                }
                break;
            default:
                break;
        }
        
    }

}

-(void)changeSelectedIndex:(NSInteger)selectedIndex{
    
    [super changeSelectedIndex:selectedIndex];
    
    [self requestDataWithIndex:selectedIndex];
    
    return ;

    

}


- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)layoutHeaderViewAndTabBar {
    [super layoutHeaderViewAndTabBar];
    
    self.headerView.frame = CGRectMake(self.headerView.dp_x, self.headerView.dp_y, self.headerView.dp_width, self.headerView.dp_height + self.tabBar.dp_height);
    self.lineView.frame = CGRectMake(self.tabBar.dp_x, self.tabBar.dp_y - 1, self.tabBar.dp_width, 1);
}

-(DPLiveCompetitionSubViewController*)competitionViewController{
    
    if (_competitionViewController == nil) {
        _competitionViewController = [[DPLiveCompetitionSubViewController alloc]init];
    }
    return _competitionViewController ;
}

-(DPLiveAnalysisSubViewController*)analysisViewController{
    if (_analysisViewController == nil) {
        _analysisViewController = [[DPLiveAnalysisSubViewController alloc] init] ;
    }
    return _analysisViewController ;
}

-(DPLivePointSubViewController*)pointViewController{
    
    if (_pointViewController == nil) {
        _pointViewController = [[DPLivePointSubViewController alloc] init];
        
    }
    return _pointViewController ;
}

-(DPLiveOddsPositionSubViewController*)oddsPositionViewController{
    if (_oddsPositionViewController == nil) {
        _oddsPositionViewController = [[DPLiveOddsPositionSubViewController alloc] init];
    }
    return _oddsPositionViewController ;
}

-(DPLiveBreakevenSubViewController*)breakevenViewController{
    
    if (_breakevenViewController == nil) {
        _breakevenViewController = [[DPLiveBreakevenSubViewController alloc] init];
    }
    
    return _breakevenViewController ;
}

-(DPLiveLCCompetionTableViewController*)competitionLCViewController{
    
    if (_competitionLCViewController == nil) {
        _competitionLCViewController = [[DPLiveLCCompetionTableViewController alloc]init];
        
    }
    return _competitionLCViewController ;
}
-(DPLiveLCAnalysisTableViewController*)analysisLCViewController{
    
    if (_analysisLCViewController == nil) {
        _analysisLCViewController = [[DPLiveLCAnalysisTableViewController alloc]init];
        
    }
    return _analysisLCViewController ;
}

-(DPLiveLCPointTableViewController*)pointLCViewController{
    if (_pointLCViewController == nil) {
        _pointLCViewController = [[DPLiveLCPointTableViewController alloc]init];
        
    }
    return _pointLCViewController ;
}
-(DPLiveLCOddsPositTableViewController*)oddsLCPositionViewController{
    if (_oddsLCPositionViewController == nil) {
        _oddsLCPositionViewController = [[DPLiveLCOddsPositTableViewController alloc]init];
        
    }
    return _oddsLCPositionViewController ;
}



#pragma mark - Notify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
        switch (cmdtype) {
            case FOOTBALLCENTER_MATCHINFO:
            case BASKETBALL_MATCHIFO:
                [[NSNotificationCenter defaultCenter] postNotificationName:kLiveDataNotifyName object:nil];
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"kLiveDataNotifyName%d",cmdtype] object:nil];
                break;
        }
        

    });
}



@end

