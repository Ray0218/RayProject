//
//  DPJcdgBuyVC.m
//  DacaiProject
//
//  Created by jacknathan on 14-11-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJcdgBuyVC.h"
#import "DPCollapseTableView.h"
#import "DPJcdgTableViewCell.h"
#import "FrameWork.h"
#import "DPRedPacketViewController.h"
#import "DPAccountViewControllers.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPQuick3transferVC.h"
#import "DPJczqOptimizeViewControl.h"
#import "DPNodataView.h"
#import "DPWebViewController.h"

@interface DPJcdgBuyVC () <
    DPCollapseTableViewDataSource,
    DPCollapseTableViewDelegate,
    DPJcdgTeamsViewDelegate,
    ModuleNotify,
    DPJcdgGameBasicCellDelegate,
    DPJcdgPullCellDelegate,
    DPRedPacketViewControllerDelegate,
    DPJcdgNoDataCelldelegate
> {
    CLotteryJczq *_lotteryJczq;
    int _gameCount; // 比赛场次
    int _curGameIndex; // 当前比赛
    DPCollapseTableView *_tableView;
    NSMutableArray *_visibleGamesTypeArray;
    NSLayoutConstraint *_uperConstraint;
//    NSLayoutConstraint *_navBgConstraint;
    NSMutableDictionary *_timesDict;
    CGPoint _contentOffset;
    GameTypeId _bonusBetterGameType; // 优化投注当前玩法内容

    NSInteger _payMultiple;
    NSInteger _payNote;
    NSInteger _payGameType;
    
    DPNodataView *_noDataView ;

}
@property (nonatomic, strong, readonly)DPCollapseTableView *tableView;
@property (nonatomic, strong)DPJcdgTeamsView  *teamsView;
@property (nonatomic, strong) UIView *uperView;
@property (nonatomic, strong, readonly) NSLayoutConstraint *uperConstraint;
@property (nonatomic, strong, readonly) NSLayoutConstraint *navBgConstraint;
@property (nonatomic, strong, readonly) NSMutableDictionary *timesDict; // 用户设置的倍数
@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@end

@implementation DPJcdgBuyVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _lotteryJczq = CFrameWork::GetInstance()->GetLotteryJczq();
        _lotteryJczq -> SetDelegate(self);
        
        _gameCount = - 1;
        _curGameIndex = 0;
        _bonusBetterGameType = GameTypeJcSpf;
        _visibleGamesTypeArray = [NSMutableArray arrayWithCapacity:4];
        if (IOS_VERSION_7_OR_ABOVE) {
            self.extendedLayoutIncludesOpaqueBars = YES;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
     return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController dp_applyGlobalTheme];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _lotteryJczq->SetDelegate(self);
    _lotteryJczq -> SetProjectBuyType(3);
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lotteryJczq -> NSingleList();
    
    self.title = @"单关固定";
    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#184d7f"];

    UIView *uperView = [[UIView alloc]init];
    uperView.backgroundColor = [UIColor clearColor];
    uperView.clipsToBounds = YES;
    self.uperView = uperView;
    
    DPJcdgTeamsView *teamsView = [[DPJcdgTeamsView alloc]init];
    teamsView.delegate = self;
    
    UIView *navView = [[UIView alloc]init];
    navView.clipsToBounds = YES;
    navView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:uperView];
    [self.view addSubview:navView];
    [uperView addSubview:teamsView];
  
    self.teamsView = teamsView;
    teamsView.backgroundColor = [UIColor dp_colorFromHexString:@"#184d7f"];
//        teamsView.backgroundColor = [UIColor yellowColor];
    
    [uperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom);
        make.left.equalTo(self.view);
        make.height.equalTo(@110);
        make.right.equalTo(self.view);
    }];
    
    [teamsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(uperView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uperView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_viewTap:)];
    [self.view addGestureRecognizer:tap];
    
//    self.navigationController.navigationBarHidden = YES;

    // 自定义navgation

    
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"竞彩单关模糊弹框002.jpg")];
    UIButton *leftBtn = ({
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dp_leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"单关固定";
        label.font = [UIFont dp_systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label;
    });
    
    [navView addSubview:bgImgView];
    [navView addSubview:leftBtn];
    [navView addSubview:titleLabel];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(navView);
//        make.right.equalTo(navView);
////        make.bottom.equalTo(navView);
//        make.top.equalTo(navView);
        make.edges.equalTo(navView);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(5);
        make.centerY.equalTo(navView.mas_bottom).offset(- 22);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.centerY.equalTo(leftBtn);
    }];
    
    for (NSLayoutConstraint *constraint in navView.constraints) {
        if (constraint.firstItem == bgImgView && constraint.firstAttribute == NSLayoutAttributeTop) {
            _navBgConstraint = constraint;
            break;
        }
    }
    
     [self showHUD];
//    ILTranslucentView *blurView = [[ILTranslucentView alloc]init];
//    blurView.translucentAlpha = 0.7;
//    blurView.translucentStyle = UIBarStyleDefault;
//    blurView.translucentTintColor = [UIColor blackColor];
//    
//    [self.view addSubview:blurView];
//    [blurView setFrame:CGRectMake(0, 150, 320, 100)];
//    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(123);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.equalTo(@60);
//    }];
    
}
- (void)dp_viewTap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_gameCount == -1) {
        return 0;
    }
    if (_gameCount == 0) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(DPCollapseTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_gameCount <= 0) {
        return 1;
    }
        [_visibleGamesTypeArray removeAllObjects];
        int gamesTypes[4] = {GameTypeJcRqspf, GameTypeJcSpf, GameTypeJcZjq, GameTypeJcBf};
        for (int i = 0; i < 4; i++) {
            int result = _lotteryJczq -> IsSingleGameVisible(_curGameIndex, gamesTypes[i]);
//            if (result) [self.timesDict setObject:[NSString stringWithFormat:@"%d", 5] forKey:[NSNumber numberWithInt:gamesTypes[i]]];
            if (result) [_visibleGamesTypeArray addObject:[NSNumber numberWithInt:gamesTypes[i]]];
        }
//    return 2;
        return _visibleGamesTypeArray.count;
}
- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameTypeId gameType = (GameTypeId)[_visibleGamesTypeArray[indexPath.row] intValue];
    static NSString *cellID = @"expandCell_ID";
    DPJcdgPullCell *expandCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (expandCell == nil) {
        expandCell = [[DPJcdgPullCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        expandCell.delegate = self;
    }
    expandCell.gameType = gameType;

    NSString *timesText = (NSString *)[self.timesDict objectForKey:[NSNumber numberWithInt:gameType]];
    if (timesText.length == 0 || [timesText isEqualToString:@""]) {
        timesText = @"5";
    }

    [expandCell dp_reloadMoneyWithTimeTex:timesText gameIndex:_curGameIndex];
    
    return expandCell;
}
- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPLog(@"cellForRowAtIndexPath: %d %d", indexPath.section, indexPath.row);
    
    // 没有比赛时
    if(_gameCount <= 0){
        switch (indexPath.section) {
            case 0:{
                DPJcdgNoDateImgCell *imgCell = [tableView dequeueReusableCellWithIdentifier:@"noDataImgCellID"];
                if (imgCell == nil) {
                    imgCell = [[DPJcdgNoDateImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataImgCellID"];
                }
                return imgCell;
            }
                break;
            case 1:{
                bool isTonight, isJiaJiang, isStop;
                string titleKS, titleSsq, surplus;
                CLotteryCommon *lotteryCommon = CFrameWork :: GetInstance() -> GetLotteryCommon();
                lotteryCommon -> GetHomeEntryInfo(GameTypeSsq, titleSsq, isTonight, surplus, isJiaJiang, isStop);
                lotteryCommon -> GetHomeEntryInfo(GameTypeNmgks, titleKS, isTonight, surplus, isJiaJiang, isStop);
                DPJcdgNoDataCell *noDataCell = [tableView dequeueReusableCellWithIdentifier:@"noDataCellID"];
                
                NSString *ssqString = [NSString stringWithUTF8String:titleSsq.c_str()];
                NSString *ksString = [NSString stringWithUTF8String:titleKS.c_str()];
                
                if (noDataCell == nil) {
                    noDataCell = [[DPJcdgNoDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataCellID"];
                    noDataCell.delegate = self;
                }
            
                noDataCell.leftTitleLabel.text = ksString;
                noDataCell.rightTitleLabel.text = ssqString;
                return noDataCell;
            }
                break;
            default:
                return nil;
                break;
        }
        return nil;
    }
    // 有比赛时
    int gameType = [_visibleGamesTypeArray[indexPath.row] intValue];
    switch (gameType) {
        case GameTypeJcRqspf:
        case GameTypeJcSpf:{
            NSString *reuseID = @"resID_rqspf";
            DPjcdgTypeRqspfCell *spfCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (spfCell == nil) {
                spfCell = [[DPjcdgTypeRqspfCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, competitionName, endTime, orderName;
            int rqspf_sp[3], bf_sp[31], zjq_sp[8], bqc_sp[9], spf_sp[3], options[10], betProportion[6], rqs;

             _lotteryJczq -> GetSingleTargetInfo(_curGameIndex, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderName, competitionName, endTime, rqs);
            _lotteryJczq -> GetSingleTargetSpList(_curGameIndex, rqspf_sp, bf_sp, zjq_sp, bqc_sp, spf_sp);
            _lotteryJczq -> GetSingleTargetOption(_curGameIndex, gameType, options);
            _lotteryJczq -> GetSingleTargetAnalysis(_curGameIndex, betProportion);
            
            NSString *homeTeamNameS = [NSString stringWithUTF8String:homeTeamName.c_str()];
            NSString *awayTeamNameS = [NSString stringWithUTF8String:awayTeamName.c_str()];

            int res_sp[3];
            res_sp[0] = gameType == GameTypeJcRqspf ? rqspf_sp[0] : spf_sp[0];
            res_sp[1] = gameType == GameTypeJcRqspf ? rqspf_sp[1] : spf_sp[1];
            res_sp[2] = gameType == GameTypeJcRqspf ? rqspf_sp[2] : spf_sp[2];
            
            NSArray *betProArray = gameType == GameTypeJcSpf ? @[[NSNumber numberWithInt:betProportion[0]],
                                                                   [NSNumber numberWithInt:betProportion[1]],
                                                                   [NSNumber numberWithInt:betProportion[2]]] :
                                                                 @[[NSNumber numberWithInt:betProportion[3]],
                                                                   [NSNumber numberWithInt:betProportion[4]],
                                                                   [NSNumber numberWithInt:betProportion[5]]];
            
            float leftNum = [FloatTextForIntDivHundred(res_sp[0]) floatValue];
            float middleNum = [FloatTextForIntDivHundred(res_sp[1]) floatValue];
            float rightNum = [FloatTextForIntDivHundred(res_sp[2]) floatValue];
            
            _lotteryJczq -> GetSingleTargetRqs(_curGameIndex, rqs);
            NSString *leftName = [homeTeamNameS stringByAppendingString:[NSString stringWithFormat:@" 胜\n%.2f", leftNum]];
            if (gameType == GameTypeJcRqspf){
                NSString *rqsString = nil;
                if (rqs > 0) rqsString = [NSString stringWithFormat:@"+%d",rqs];
                if (rqs < 0) rqsString = [NSString stringWithFormat:@"-%d",-rqs];
                leftName = [homeTeamNameS stringByAppendingString:[NSString stringWithFormat:@"(%@)胜\n%.2f",rqsString ,leftNum]];
            }
            NSString *middleName = [NSString stringWithFormat:@"平局\n%.2f", middleNum];
            NSString *rightName = [awayTeamNameS stringByAppendingString:[NSString stringWithFormat:@" 胜\n%.2f", rightNum]];
            
            NSArray *optionArray = @[[NSNumber numberWithInt:options[0]],[NSNumber numberWithInt:options[1]],[NSNumber numberWithInt:options[2]]];
            spfCell.teamNames = @[leftName, middleName, rightName];
            spfCell.detailType = gameType == GameTypeJcRqspf ? KSpfTypeRqspf : KSpfTypeSpf;
            spfCell.defaultOption = optionArray;
            spfCell.delegate = self;
            spfCell.percents = betProArray;
            return spfCell;
        }
            break;
        case GameTypeJcZjq:{

            int rqspf_sp[3], bf_sp[31], zjq_sp[8], bqc_sp[9], spf_sp[3], options[10];
            _lotteryJczq -> GetSingleTargetSpList(_curGameIndex, rqspf_sp, bf_sp, zjq_sp, bqc_sp, spf_sp);
            _lotteryJczq -> GetSingleTargetOption(_curGameIndex, gameType, options);

            NSString *reuseID = @"resID_zjq";
            DPjcdgAllgoalCell *zjqCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (zjqCell == nil) {
                zjqCell = [[DPjcdgAllgoalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            NSArray *optionsArray = @[[NSNumber numberWithInt:options[0]],
                                      [NSNumber numberWithInt:options[1]],
                                      [NSNumber numberWithInt:options[2]],
                                      [NSNumber numberWithInt:options[3]],
                                      [NSNumber numberWithInt:options[4]],
                                      [NSNumber numberWithInt:options[5]],
                                      [NSNumber numberWithInt:options[6]],
                                      [NSNumber numberWithInt:options[7]]];
            NSArray *spArray = @[FloatTextForIntDivHundred(zjq_sp[0]),
                                 FloatTextForIntDivHundred(zjq_sp[1]),
                                 FloatTextForIntDivHundred(zjq_sp[2]),
                                 FloatTextForIntDivHundred(zjq_sp[3]),
                                 FloatTextForIntDivHundred(zjq_sp[4]),
                                 FloatTextForIntDivHundred(zjq_sp[5]),
                                 FloatTextForIntDivHundred(zjq_sp[6]),
                                 FloatTextForIntDivHundred(zjq_sp[7])];
            zjqCell.sp_Numbers = spArray;
            zjqCell.defaultOption = optionsArray;
            zjqCell.delegate = self;
            return zjqCell;
        }
            break;
        case GameTypeJcBf:{
            int rqs, options[10];
            _lotteryJczq -> GetSingleTargetOption(_curGameIndex, gameType, options);
            string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, competitionName, endTime, orderName;
            _lotteryJczq -> GetSingleTargetInfo(_curGameIndex, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderName, competitionName, endTime, rqs);
            NSString *homeTeamNameS = [NSString stringWithUTF8String:homeTeamName.c_str()];
            NSString *awayTeamNameS = [NSString stringWithUTF8String:awayTeamName.c_str()];

            NSArray *optionsArray = @[[NSNumber numberWithInt:options[0]],
                                      [NSNumber numberWithInt:options[1]],
                                      [NSNumber numberWithInt:options[2]],
                                      [NSNumber numberWithInt:options[3]],
                                      [NSNumber numberWithInt:options[4]],
                                      [NSNumber numberWithInt:options[5]],
                                      [NSNumber numberWithInt:options[6]],
                                      [NSNumber numberWithInt:options[7]],
                                      [NSNumber numberWithInt:options[8]]];
            
            NSString *reuseID = @"resID_bf";
            dpJcdgGuessWinCell *guessCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (guessCell == nil) {
                guessCell = [[dpJcdgGuessWinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
                guessCell.delegate = self;
            }
            guessCell.leftTeamNameLabel.text = homeTeamNameS;
            guessCell.rightTeamNameLabel.text = awayTeamNameS;
            guessCell.defaultOption = optionsArray;
            return guessCell;
        }
        default:
            return nil;
            break;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_gameCount <= 0 && section == 1) {
    
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *headerLabel = [[UILabel alloc]init];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = @"漫长等待, 不如玩下其他彩种";
        headerLabel.font = [UIFont dp_systemFontOfSize:12];
        headerLabel.textColor = [UIColor dp_flatWhiteColor];
        
        [headerView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(30);
            make.bottom.equalTo(headerView);
        }];
        return headerView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_gameCount <= 0) {
        if (indexPath.section == 0) return 200;
        if (indexPath.section == 1) return 50;
    }
    return 170;
}
- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_gameCount <= 0) {
        if (section == 0) return 0.00001;
       if (section == 1) return 25;
    }
    return 0;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DPLog(@"insert delete");
//}
#pragma mark - teamsViewDelegate
- (void)gamePageChangeFromPage:(int)oldPage toNewPage:(int)newPage
{
    DPLog(@"newpage===========%d", newPage);
    _curGameIndex = newPage;
    [self.timesDict removeAllObjects];
    [self.tableView closeAllCells];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    for (int i = 0; i < _visibleGamesTypeArray.count; i++) {
        int options[10] = {0};
        GameTypeId gameType = (GameTypeId)[_visibleGamesTypeArray[i] intValue];
        _lotteryJczq -> GetSingleTargetOption(_curGameIndex, gameType, options);
        int selected = NO;
        for (int i = 0; i < 10; i++) {
            if (options[i] > 0) {
                selected = YES;
                break;
            }
        }
        if(selected) [self.tableView toggleCellAtModelIndex:[NSIndexPath indexPathForRow:i inSection:0] animation:NO];
    }

}
#pragma mark basicCellDelegate
- (void)clickButtonWithCell:(DPJcdgGameTypeBasicCell *)cell gameType:(int)gameType index:(int)index isSelected:(BOOL)isSelected closeExpand:(BOOL)closeExpand
{
    _lotteryJczq -> SetSingleTargetOption(_curGameIndex, gameType, index, isSelected);
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    BOOL isNextAppend = NO;
    isNextAppend = [self.tableView isExpandAtModelIndex:modelIndex];
    DPLog(@"isNextAppend = %d", isNextAppend);
    if (isSelected) {
        if (!isNextAppend) {
            [self.tableView toggleCellAtModelIndex:modelIndex animation:NO];
//            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSIndexPath *indexPath = [self.tableView tableIndexFromModelIndex:modelIndex expand:NO];
            DPLog(@"change hou row = %d, sectio = %d", indexPath.row, indexPath.section);
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {

                DPJcdgPullCell *pullCell = (DPJcdgPullCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
                [pullCell dp_reloadMoneyWithTimeTex:nil gameIndex:_curGameIndex];
            }
        }
    }else{
        if (closeExpand) {
            [self.tableView toggleCellAtModelIndex:modelIndex animation:NO];
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                DPJcdgPullCell *pullCell = (DPJcdgPullCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
                [pullCell dp_reloadMoneyWithTimeTex:nil gameIndex:_curGameIndex];
            }
        }
    }
}
- (void)dpjcdgInfoButtonClick:(DPJcdgGameTypeBasicCell *)cell
{
    DPJcdgWarnView *warnView = [[DPJcdgWarnView alloc]init];
    NSString *gameTypeString = nil;
    NSString *titleString = nil;
    
    if ([cell isKindOfClass:[DPjcdgTypeRqspfCell class]]) {
        DPjcdgTypeRqspfCell *targetCell = (DPjcdgTypeRqspfCell *)cell;
        gameTypeString = targetCell.detailType == KSpfTypeRqspf ? @"让球胜平负" : @"胜平负";
        titleString = targetCell.detailType == KSpfTypeRqspf ? @"对指定的比赛场次在全场90分钟(含伤停补时)的主队和客队的胜平负结果进行投注" : @"对指定的比赛场次在全场90分钟(含伤停补时)的主队和客队的胜平负结果进行投注, 所选比赛均不让球";
    }else if ([cell isKindOfClass:[DPjcdgAllgoalCell class]]){
        gameTypeString = @"总进球";
        titleString = @"对指定的比赛场次在全场90分钟(含伤停补时)的主队和客队的总进球数结果进行投注。";
    }else if ([cell isKindOfClass:[dpJcdgGuessWinCell class]]){
        gameTypeString = @"猜赢球";
        titleString = @"竞猜本场全场比分,猜球队能赢几个球。\n主队胜1球: 包含1:0、2:1、3:2、胜其它。\n主队胜2球: 包含2:0、3:1、4:2、胜其它。\n主队胜3球: 包含3:0、4:1、5:2、胜其它。\n主队胜更多: 包含4:0、5:0、5:1、胜其它。\n两队平局: 包含0:0、1:1、2:2、3:3、平其它。\n客队胜1球: 包含0:1、1:2、2:3、负其它。\n客队胜2球: 包含0:2、1:3、2:4、负其它。\n客队胜3球: 包含0:3、1:4、2:5、负其它。\n客队胜更多: 包含0:4、0:5、1:5、负其它。";
    }
    warnView.gameTypeLabel.text = gameTypeString;
//    warnView.titleLabel.text = titleString;
    warnView.titleText = titleString;
    
    [self.view addSubview:warnView];
    [warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - pullCell delegate
- (void)pullCellCommit:(DPJcdgPullCell *)cell times:(int)times
{
    [cell.textField resignFirstResponder];
    
    _lotteryJczq -> SetMultiple(times);
    _lotteryJczq -> SetSingleSelectedTarget(_curGameIndex, cell.gameType);
    _lotteryJczq -> SetTogetherType(false);
    
    CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
    moduleInstance -> SetDelegate(self);
    
    int note = 0, minBonus = 0, maxBonus = 0;
    _lotteryJczq->GetSingleTargetAmount(_curGameIndex, cell.gameType, note, minBonus, maxBonus);
    _payGameType = cell.gameType;
    _payNote = note;
    _payMultiple = times;
    
    __weak __typeof(self) weakSelf = self;
    void(^block)(void) = ^() {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view.window showDarkHUD];
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(strongSelf);
        CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(strongSelf->_curGameIndex, 1, note * times * 2, 0);
    };
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        block();
    } else {
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)pullCellBonusBetterClick:(DPJcdgPullCell *)cell times:(NSString *)times
{
    _lotteryJczq -> SetSingleSelectedTarget(_curGameIndex, cell.gameType);
    
    _payGameType = cell.gameType ;
//    int count = _lotteryJczq->GetSelectedCount();
    [self.view endEditing:YES];
    
    _bonusBetterGameType = cell.gameType;
    [self.timesDict setObject:times forKey:@(cell.gameType)];
    int note = 0, minBonus = 0, maxBonus = 0;
    int result = _lotteryJczq -> GetSingleTargetAmount(_curGameIndex, cell.gameType, note, minBonus, maxBonus);
    if (result < 0) {
        [[DPToast makeText:@"请求失败, 请重试"] show];
        return;
    }
    if (note <2) {
        [[DPToast makeText:@"至少选择2个选项!"] show];
        return ;
    }
    [self showDarkHUD];

    _lotteryJczq->NetBalance() ;
}
- (void)pullCell:(DPJcdgPullCell *)cell endEditingWithText:(NSString *)text
{
    [self.timesDict setObject:text forKey:[NSNumber numberWithInt:cell.gameType]];
}
- (void)pullCell:(DPJcdgPullCell *)cell keyBoardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if (event == DPKeyboardListenerEventWillShow) {
        _contentOffset = self.tableView.contentOffset;
        CGFloat addHeight = 110;
        if ([[UIScreen mainScreen]bounds].size.height <= 480) {
            addHeight = 30;
        }
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) + addHeight, 0);
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
     
    }else if (event == DPKeyboardListenerEventWillHide){
        
        self.tableView.scrollEnabled = YES;
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            self.tableView.contentInset = _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
            [self.tableView setContentOffset:_contentOffset];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
#pragma mark - nodata cell delegate
- (void)noDataMoreGameIndex:(int)gameIndex
{
    self.navigationController.navigationBarHidden = NO;
    NSMutableArray *ctrls = self.navigationController.viewControllers.mutableCopy;
    [ctrls removeLastObject];
    if (gameIndex == 0) {
        [ctrls addObject:[[DPQuick3transferVC  alloc]init]];
    }else{
        [ctrls addObject:[[DPDoubleHappyTransferVC alloc]init]];
    }
      [self.navigationController setViewControllers:ctrls animated:YES];
    
    
}
- (void)dp_leftNavItemClick
{
    if (self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype
{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (cmdtype) {
                case JCZQ_SingleList:{
                    [self dismissHUD];
                    
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                    
                    if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
                        self.noDataView.noDataState= DPNoDataNoworkNet ;
                        [self.view addSubview:self.noDataView];
                        return ;
                    }else if (ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ){
                        self.noDataView.noDataState = DPNoDataWorkNetFail ;
                        [self.view addSubview:self.noDataView];

                        return ;
                    }
                    
//                    if (ret < 0){
//                        [[DPToast makeText:DPAccountErrorMsg(ret)] show];
//                        return;
//                    }
                    _gameCount = _lotteryJczq -> GetSingleTargetCount();
//                    _gameCount = 0;
                    [self.tableView reloadData];

                    for (int i = 0; i < _visibleGamesTypeArray.count; i++) {
                        GameTypeId gameType = (GameTypeId)[_visibleGamesTypeArray[i] intValue];
                        if (gameType == GameTypeJcRqspf || gameType == GameTypeJcSpf)
                            [self.tableView openCellAtModelIndex:[NSIndexPath indexPathForItem:0 inSection:0]];
                    }
                    [self rebulidTeamsCell];
                }
                    break;
                case ACCOUNT_RED_PACKET: {
                    [self dismissDarkHUD];
                    if (ret < 0) {
                        [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                        break;
                    }
                    DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                    viewController.gameTypeText = dp_GameTypeFirstName((GameTypeId)_payGameType);
                    viewController.projectAmount = _payNote * _payMultiple * 2;
                    viewController.delegate = self;
                    viewController.gameType = (GameTypeId)_payGameType;
                    viewController.isredPacket= CFrameWork::GetInstance()->GetAccount()->GetPayRedPacketCount() > 0;
                    viewController.delegate = self;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                    break;
                case JCZQ_Balance: {
                    [self dismissDarkHUD];
                    if (ret < 0) {
                        [self dismissDarkHUD];
                        [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                        break;
                    }
                    if(_lotteryJczq->GetBalanceCost()>2000000){
                        [[DPToast makeText:@"方案金额最大支持200万"]show];
                        return  ;
                    }
                    _lotteryJczq->SetProjectBuyType(4);
                    DPJczqOptimizeViewControl* vc = [[DPJczqOptimizeViewControl alloc]init];
                    vc.multipleField.text = [self.timesDict objectForKey:@(_bonusBetterGameType)] ;
                    vc.gameType = _bonusBetterGameType ;
                    vc.GameTypeText=dp_GameTypeFirstName((GameTypeId)_payGameType);
                    vc.passModeLabel.text = @"过关方式：单关";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
        });
}
- (void)rebulidTeamsCell
{
    if (_gameCount == 0) {
        for (NSLayoutConstraint *constraint in self.uperView.constraints) {
            if (constraint.firstItem == self.uperView && constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 110;
                break;
            }
        }
        [self.view bringSubviewToFront:self.tableView];
        self.tableView.bounces = NO;
        UIImageView *bgImgView = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"dgHeaderBg.jpg")];
        [self.teamsView removeFromSuperview];
        [self.uperView addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.uperView);
            make.right.equalTo(self.uperView);
            make.bottom.equalTo(self.uperView);
        }];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        return;
        
    }
    self.teamsView.gameCount = _gameCount;
            // 界面内容
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, competitionName, endTime, orderName, homeImg, awayImg, descString;
    int rqs;
    for (int i = 0; i < _gameCount; i++) {
        _lotteryJczq -> GetSingleTargetInfo(i, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderName, competitionName, endTime, rqs);
        _lotteryJczq -> GetSingleTargetImages(i, homeImg, awayImg, descString);
        NSString *homeTeamNameS = [NSString stringWithUTF8String:homeTeamName.c_str()];
        NSString *awayTeamNameS = [NSString stringWithUTF8String:awayTeamName.c_str()];
        NSString *homeTeamRankS = [NSString stringWithUTF8String:homeTeamRank.c_str()];
        NSString *awayTeamRankS = [NSString stringWithUTF8String:awayTeamRank.c_str()];
        NSString *competitionNameS = [NSString stringWithUTF8String:competitionName.c_str()];
        NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
        NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
        NSString *endTimeS=[NSString stringWithFormat:@"截止 %@%@",[date dp_weekdayNameSimple], [date dp_stringWithFormat:@"HH:mm"]];
//        NSString *endTimeS = [NSDate dp_coverDateString:[NSString stringWithUTF8String:endTime.c_str()] fromFormat:@"YYYY-MM-dd HH:mm:ss" toFormat:@"截止 HH:mm"];
        NSString *homeImgS = [NSString stringWithUTF8String:homeImg.c_str()];
        NSString *awayImgS = [NSString stringWithUTF8String:awayImg.c_str()];
        NSString *describString = [NSString stringWithUTF8String:descString.c_str()];
        [self.teamsView setSingleTeamWithIndex:i homeName:homeTeamNameS awayName:awayTeamNameS homeRank:homeTeamRankS awayRank:awayTeamRankS homeImg:homeImgS awayImg:awayImgS compitionName:competitionNameS endTime:endTimeS sugest:describString];
        }
    if (_gameCount > 1) self.teamsView.scrollView.contentOffset = CGPointMake([[UIScreen mainScreen]bounds].size.width, 0);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint contentOffset = self.tableView.contentOffset;
//    if (contentOffset.y > 0) {
//        
//        CGFloat constant = self.uperConstraint.constant - contentOffset.y;
////        CGFloat navBgConstant = self.navBgConstraint.constant - contentOffset.y;
//        if (constant <= -95) {
//            self.uperConstraint.constant = -95;
//            self.navBgConstraint.constant = -95;
//            self.tableView.bounces = YES;
//        }else{
//            self.uperConstraint.constant -= contentOffset.y;
//            self.navBgConstraint.constant -= contentOffset.y;
//            self.tableView.contentOffset = CGPointZero;
//        }
//    }else if(contentOffset.y < 0){
//        CGFloat constant = self.uperConstraint.constant - contentOffset.y;
//        if (constant < 0) {
//            self.uperConstraint.constant = constant;
//            self.navBgConstraint.constant = constant;
//            self.tableView.contentOffset = CGPointZero;
//        }else{
//            self.uperConstraint.constant = 0;
//            self.navBgConstraint.constant = 0;
//
////            self.tableView.bounces = NO;
//        }
//    }
////        [self.view setNeedsLayout];
////        [self.view layoutIfNeeded];
//    
//}
- (NSLayoutConstraint *)uperConstraint
{
    if (_uperConstraint == nil) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.uperView && constraint.firstAttribute == NSLayoutAttributeTop) {
                _uperConstraint = constraint;
                break;
            }
        }
    }
    return _uperConstraint;
}
//- (NSLayoutConstraint *)navBgConstraint
//{
//    if (_navBgConstraint == nil) {
//       
//    }
//}
- (DPCollapseTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc]init];
        _tableView.zOrder = DPTableViewZOrderAsec;
//        _tableView.zOrder = DPTableViewZOrderNone;
//        _tableView.backgroundColor = [UIColor dp_colorFromHexString:@"#184d7f"];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = YES;
//        _tableView.allowsSelection = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.clipsToBounds = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _tableView;
}

-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 65, kScreenWidth, 400)];
        _noDataView.gameType = GameTypeLcNone ;
        __weak __typeof(self) weakSelf = self;
        __block CLotteryJczq *weak_lotteryJczq =  _lotteryJczq;
        
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
                
                weak_lotteryJczq -> NSingleList();
            }
            
        }];
    }
    return _noDataView ;
}


- (NSMutableDictionary *)timesDict
{
    if (_timesDict == nil) {
        _timesDict = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _timesDict;
}

- (void)dealloc {
    _lotteryJczq->ClearSingleData();
}

- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (ret >= 0) {
        int buyType;
        string token;
        _lotteryJczq->GetWebPayment(buyType, token);
        
        NSString *urlString = kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        kAppDelegate.gotoHomeBuy = YES;
    }
}

@end
