//
//  DPLiveLCCompetionTableViewController.m
//  DacaiProject
//
//  Created by Ray on 14/12/8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveLCCompetionTableViewController.h"
#import "DPLiveDataCenterHeaderView.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPLiveDataCenterViews.h"

#define CEllTag 1111

@interface DPLiveLCCompetionTableViewController (){
@private
    BOOL _sectionCollapse[5];
    CBasketballCenter *_dateCenter;
    UILabel* _signlLabel ;
    
    NSInteger _topScoRow ;//最高分行数
    NSInteger _techRow ;//技术统计行数
    NSInteger _playerRow ;//阵容行数
    

}
@property(nonatomic,strong,readonly)UILabel* signlLabel ;


@end



@implementation DPLiveLCCompetionTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_COMPETITION] object:nil];
        
        _dateCenter = CFrameWork::GetInstance()->GetBasketballCenter();
    }
    return self;
}

-(UILabel*)signlLabel{
    
    if (_signlLabel== nil) {
        _signlLabel= [[UILabel alloc] initWithFrame:CGRectMake(-5, 0, kScreenWidth-20, 20)];
        _signlLabel.textAlignment = NSTextAlignmentRight;
        _signlLabel.backgroundColor = [UIColor clearColor];
        _signlLabel.font =[UIFont dp_systemFontOfSize:12.0];
        _signlLabel.textColor = UIColorFromRGB(0xADABA9) ;
        _signlLabel.text = kSignalLanguage ;
        
    }
    return _signlLabel ;
    
}


- (void)loadView {
    self.tableView = ({
        DPNoInsetOffsetTableView *tableView = [[DPNoInsetOffsetTableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        //        tableView.sectionOffset = -185;
        tableView.sectionOffset = -85;
                tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.title = @"赛事";
    self.view.backgroundColor = [UIColor clearColor];
    _topScoRow = 0 ;
    _techRow = 0 ;
    _playerRow = 0 ;
    self.tableView.tableFooterView= self.signlLabel ;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_COMPETITION] object:nil];
}

#pragma mark - event

- (void)Notify:(NSNotification *)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _topScoRow =_dateCenter->GetMatchTopCount()<=0?0:_dateCenter->GetMatchTopCount() ;
        _techRow = _dateCenter->GetHustleScoreCount()<=0?0:_dateCenter->GetHustleScoreCount() ;
        
        NSInteger firstCell = _dateCenter->GetPlayerCount(1)>0?_dateCenter->GetPlayerCount(1)+1:0 ;
        NSInteger secondCell = _dateCenter->GetPlayerCount(2)>0?_dateCenter->GetPlayerCount(2)+1:0 ;
        
        _playerRow = _dateCenter->GetPlayerCount(1)<=0?0:(firstCell+secondCell) ;
        
        [self.tableView reloadData];
//        self.tableView.tableFooterView= self.signlLabel ;
    }) ;
}

- (void)pvt_onHeader:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    _sectionCollapse[section] = !_sectionCollapse[section];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_sectionCollapse[section]) {
        return 0;
    }
    
    switch (section) {
        case 0: // 比赛事件
            return 3;
        case 1: // 各项高分
            return _topScoRow+1 ;
        case 2: // 技术统计
            return _techRow+1 ;
        case 3: //阵容
        {
//            NSInteger firstCell = _dateCenter->GetPlayerCount(1)>0?_dateCenter->GetPlayerCount(1)+1:0 ;
//            NSInteger secondCEll = _dateCenter->GetPlayerCount(2)>0?_dateCenter->GetPlayerCount(2)+1:0 ;
            return _playerRow+1 ;
        
        }
        default:
            return 0;
    }

    return 0 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0 ) {
        
        if (indexPath.section == 0) {
            BOOL overTime =NO;
            int homeScore[5]={0},awayScore[5]={0} ;
            int count = _dateCenter->GetMatchPoint(homeScore, awayScore) ;
            if (count==5) {
                overTime = YES ;
            }else
                overTime = NO ;
            
            if (overTime) {
                static NSString *completeIdentitifersOverHead = @"completeIdentitifersOverHead";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersOverHead];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersOverHead];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:YES withHigh:30 withWidth:kScreenWidth-10];
                    headView.textColors = UIColorFromRGB(0x6F6B68) ;
                    headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:90],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    NSArray* titlesAray  =[NSArray arrayWithObjects: @"   ", @"第1节",@"第2节",@"第3节",@"第4节",@"加时", nil] ;
                    [headView setTitles:titlesAray];
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
               
                return  cell ;
                
            }else{
                static NSString *completeIdentitifersHead = @"completeIdentitifersHead";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersHead];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersHead];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:YES withHigh:30 withWidth:kScreenWidth-10];
                    headView.textColors = UIColorFromRGB(0x6F6B68) ;
                    headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:106],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    NSArray* titlesAray  =[NSArray arrayWithObjects: @"   ", @"第1节",@"第2节",@"第3节",@"第4节", nil] ;
                    [headView setTitles:titlesAray];
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }

                return  cell ;
                
            }

        }
        static NSString *nameIdentitifers = @"nameIdentitifers";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameIdentitifers];
        if (cell == nil ) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameIdentitifers];
            cell.backgroundColor = [UIColor clearColor] ;
            cell.contentView.backgroundColor = [UIColor clearColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
            headView.textColors = UIColorFromRGB(0x6F6B68) ;
            
            headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
            NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:155],[NSNumber numberWithFloat:155], nil] ;
            [headView createHeaderWithWidthArray:arr whithHigh:35 withSeg:NO];
            headView.tag = CEllTag+3 ;
            [cell.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView) ;
                make.left.equalTo(cell.contentView).offset(5) ;
                make.height.equalTo(@30);
                make.right.equalTo(cell.contentView).offset(-5);
            }];
            
            DPImageLabel* _noDataImgLabel  = [[DPImageLabel alloc]init];
            _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
            _noDataImgLabel.hidden = YES ;
            _noDataImgLabel.layer.borderWidth = 0.5 ;
            _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            _noDataImgLabel.tag = CEllTag+7 ;
            _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
            _noDataImgLabel.image = dp_SportLiveImage(@"baskNo.png") ;
            _noDataImgLabel.imagePosition = DPImagePositionLeft ;
            _noDataImgLabel.text = @"暂无数据" ;
            _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
            }] ;

            
        }
        
        DPImageLabel*imgLab= (DPImageLabel*)[cell.contentView viewWithTag:CEllTag+7] ;
        switch (indexPath.section) {
            case 1:{
                if (_topScoRow <=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else
                    imgLab.hidden = YES ;
            }
                break;
            case 2:{
                if (_techRow<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else
                    imgLab.hidden = YES ;
            }break ;
            case 3:{
                if (_playerRow<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else
                    imgLab.hidden = YES ;
            }break ;
            default:
                break;
        }
        string homeName ,awayName ;
        _dateCenter->GetMatchTeamName(homeName, awayName) ;
        if ([g_homeName isEqualToString:@""]||[g_awayName isEqualToString:@""]) {
            g_homeName = [NSString stringWithUTF8String:homeName.c_str()] ;
            g_awayName = [NSString stringWithUTF8String:awayName.c_str()] ;
        }
        
        DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+3] ;
        NSString* firstStr =[NSString stringWithFormat:@"%@(客)",[NSString stringWithUTF8String:awayName.c_str()]] ;// @"快船(客)" ;
        NSString *secondStr =[NSString stringWithFormat:@"%@(主)",[NSString stringWithUTF8String:homeName.c_str()]] ;// @"湖人(主)";
        NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr, nil] ;
        [cellView setTitles:titlesAray];
        
        return  cell ;

    }
    
    
    switch (indexPath.section) {
       
        case 0:{ //比赛事件
            
            string homeName ,awayName ;
            _dateCenter->GetMatchTeamName(homeName, awayName) ;
            
            BOOL overTime =NO;
            int homeScore[5]={0},awayScore[5]={0} ;
            int count = _dateCenter->GetMatchPoint(homeScore, awayScore) ;
            if (count==5) {
                overTime = YES ;
            }else
                overTime = NO ;
            if (overTime) {
                static NSString *completeIdentitifersOver = @"completeIdentitifersOver";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersOver];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersOver];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
                    headView.textColors = UIColorFromRGB(0x6F6B68) ;
                    headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:90],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44],[NSNumber numberWithFloat:44], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.tag = CEllTag+1 ;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+1] ;
                NSString* firstStr,*secondStr ,*thirdStr,*fourStr,*fivStr ,*sixStr;
                if (indexPath.row == 1) {
                    firstStr = [NSString stringWithFormat:@"%@(主)",[NSString stringWithUTF8String:homeName.c_str()]] ;//@"圣约韩璐(主)";
                    secondStr = count<=0?@"-":[NSString stringWithFormat:@"%d",homeScore[0]];
                    thirdStr = count<=1?@"-":[NSString stringWithFormat:@"%d",homeScore[1]];
                    fourStr = count<=2?@"-":[NSString stringWithFormat:@"%d",homeScore[2]];
                    fivStr = count<=3?@"-":[NSString stringWithFormat:@"%d",homeScore[3]];
                    sixStr = count<=4?@"-":[NSString stringWithFormat:@"%d",homeScore[4]];
                }else{
                    firstStr = [NSString stringWithFormat:@"%@(客)",[NSString stringWithUTF8String:awayName.c_str()]] ;//@"圣约韩璐(主)";
                    secondStr = count<=0?@"-":[NSString stringWithFormat:@"%d",awayScore[0]];
                    thirdStr = count<=1?@"-":[NSString stringWithFormat:@"%d",awayScore[1]];
                    fourStr = count<=2?@"-":[NSString stringWithFormat:@"%d",awayScore[2]];
                    fivStr = count<=3?@"-":[NSString stringWithFormat:@"%d",awayScore[3]];
                    sixStr = count<=4?@"-":[NSString stringWithFormat:@"%d",awayScore[4]];
                }
                
                
                NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr,thirdStr,fourStr,fivStr,sixStr, nil] ;
                [cellView setTitles:titlesAray];
                
                return  cell ;

            }else{
                static NSString *completeIdentitifers = @"completeIdentitifers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifers];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifers];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
                    headView.textColors = UIColorFromRGB(0x6F6B68) ;
                    headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:106],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.tag = CEllTag+2 ;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+2] ;
                NSString* firstStr,*secondStr ,*thirdStr,*fourStr,*fivStr ;
                if (indexPath.row == 1) {
                    firstStr =[NSString stringWithFormat:@"%@(主)",[NSString stringWithUTF8String:homeName.c_str()]] ;// @"圣约韩璐(主)";
                    secondStr = count<=0?@"-":[NSString stringWithFormat:@"%d",homeScore[0]];
                    thirdStr = count<=1?@"-":[NSString stringWithFormat:@"%d",homeScore[1]];
                    fourStr = count<=2?@"-":[NSString stringWithFormat:@"%d",homeScore[2]];
                    fivStr = count<=3?@"-":[NSString stringWithFormat:@"%d",homeScore[3]];
                }else{
                    firstStr =[NSString stringWithFormat:@"%@(客)",[NSString stringWithUTF8String:awayName.c_str()]] ;// @"圣约韩璐(主)";
                    secondStr = count<=0?@"-":[NSString stringWithFormat:@"%d",awayScore[0]];
                    thirdStr = count<=1?@"-":[NSString stringWithFormat:@"%d",awayScore[1]];
                    fourStr = count<=2?@"-":[NSString stringWithFormat:@"%d",awayScore[2]];
                    fivStr = count<=3?@"-":[NSString stringWithFormat:@"%d",awayScore[3]];

                }
                
                NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr,thirdStr,fourStr,fivStr, nil] ;
                [cellView setTitles:titlesAray];
                
                return  cell ;

            }

            
        }
        case 1:{ //各项高分
            
            static NSString *scoreIdentitifers = @"scoreIdentitifers";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreIdentitifers];
            if (cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scoreIdentitifers];
                cell.backgroundColor = [UIColor clearColor] ;
                cell.contentView.backgroundColor = [UIColor clearColor] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
                headView.textColors = UIColorFromRGB(0x6F6B68) ;
                headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:110],[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:110], nil] ;
                [headView createHeaderWithWidthArray:arr whithHigh:30 withSegIndexArray:[NSArray arrayWithObjects:@"0",@"1",@"1",@"0",@"0", nil]];
                [headView setBgColors:[NSArray arrayWithObjects:[UIColor dp_flatWhiteColor],[UIColor dp_flatWhiteColor],UIColorFromRGB(0xF4F3EF),[UIColor dp_flatWhiteColor],[UIColor dp_flatWhiteColor], nil]] ;

                headView.tag = CEllTag+4 ;
                [cell.contentView addSubview:headView];
                [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView) ;
                    make.left.equalTo(cell.contentView).offset(5) ;
                    make.height.equalTo(@30);
                    make.right.equalTo(cell.contentView).offset(-5);
                }];
            }
            
            string title,homePlayer,awayPlayer,homeTop,awayTop;
            _dateCenter->GetMatchTopItem(indexPath.row-1, title, homePlayer, awayPlayer, homeTop, awayTop) ;
            
            DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+4] ;
            NSString* firstStr,*secondStr ,*thirdStr,*fourStr,*fivStr ;
            
            firstStr = [NSString stringWithUTF8String:homePlayer.c_str()] ;
            secondStr = [NSString stringWithUTF8String:homeTop.c_str()];
            thirdStr = [NSString stringWithUTF8String:title.c_str()] ;
            fourStr = [NSString stringWithUTF8String:awayTop.c_str()];
            fivStr = [NSString stringWithUTF8String:awayPlayer.c_str()] ;
           
            NSArray* titlesAray  =[NSArray arrayWithObjects: fivStr,fourStr,thirdStr,secondStr,firstStr, nil] ;
            [cellView setTitles:titlesAray];
            
            return  cell ;

        }
        case 2:{ //技术统计
            
            static NSString *CellIdentitifer = @"StatCell";
            DPLiveCompetitionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionStateCell alloc] initWithItemWithArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:116.25],[NSNumber numberWithFloat:77.5],[NSNumber numberWithFloat:116.25], nil] reuseIdentifier:CellIdentitifer withHigh:30];
            }
            
            
            string title, homeStat, awayStat;
            int homeRatio=0,awayRatio=0 ;
            _dateCenter->GetHustleScoreItem(indexPath.row-1, title, homeStat, awayStat, homeRatio, awayRatio);
            
            NSArray* titlesArray = [NSArray arrayWithObjects:[NSString stringWithUTF8String:awayStat.c_str()],[NSString stringWithUTF8String:title.c_str()], [NSString stringWithUTF8String:homeStat.c_str()],nil] ;
            [cell.cellView setTitles:titlesArray];
            
            int count = _dateCenter->GetHustleScoreCount();
            if (count == indexPath.row) {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor ;
            }else{
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            }
            
            
            UIView *homeBar = cell.homeBar ;
            UIView *awayBar = cell.awayBar ;
            [cell.homeBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == homeBar) {
                    obj.constant = 116.25 * awayRatio / (homeRatio+awayRatio);
                    *stop = YES;
                }
            }];
            [cell.awayBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == awayBar) {
                    obj.constant = 116.25 * homeRatio / (homeRatio+awayRatio);
                    *stop = YES;
                }
            }];

        
            return cell;
            
        }

        case 3:{
           int firstCell = _dateCenter->GetPlayerCount(1) ;
//            int secondCell = _dateCenter -> GetPlayerCount(2) ;
            if (indexPath.row == 1 || indexPath.row == firstCell+2) {
           
                static NSString *PlayerTitleIdent = @"PlayerTitleIdent";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerTitleIdent];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerTitleIdent];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
                    headView.textColors = [UIColor dp_flatBlackColor];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:155],[NSNumber numberWithFloat:155], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.backgroundColor = UIColorFromRGB(0xF9F9F9) ;
                    
                    headView.tag = CEllTag+5 ;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+5] ;
                NSString* firstStr = @"正选" ;
                NSString *secondStr = @"正选" ;
                if (indexPath.row == 1) {
                    firstStr = @"正选" ;
                    secondStr = @"正选" ;
                }else if(indexPath.row == firstCell+2){
                    firstStr = secondStr = @"后备" ;
                }
                
                
                NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr, nil] ;
                [cellView setTitles:titlesAray];
                
                return  cell ;

            }else{
            
                static NSString *PlayerIdentifer = @"PlayerIdentifer";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerIdentifer];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerIdentifer];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:104], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                    [headView settitleColors:[NSArray arrayWithObjects:UIColorFromRGB(0x6F6B68),[UIColor dp_flatBlackColor],UIColorFromRGB(0x6F6B68),[UIColor dp_flatBlackColor], nil]]; ;
                    
                    headView.tag = CEllTag+6 ;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView) ;
                        make.left.equalTo(cell.contentView).offset(5) ;
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                int type ,index;
                if (indexPath.row<_dateCenter->GetPlayerCount(1)+2) {
                    type = 1 ;index = indexPath.row-2 ;
                }else if (indexPath.row<_dateCenter->GetPlayerCount(2)+1+_dateCenter->GetPlayerCount(1)+2){
                    type=2 ;index = indexPath.row-3-_dateCenter->GetPlayerCount(1);
                }
                
                string homePlayer,awayPlayer,homePos,awayPos ;
                _dateCenter->GetPlayerItem(type, index, homePlayer, awayPlayer, homePos, awayPos) ;
                
                DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CEllTag+6] ;
                NSString* firstStr =[NSString stringWithUTF8String:homePos.c_str()] ;// @"后卫" ;
                NSString *secondStr =[NSString stringWithUTF8String:homePlayer.c_str()] ;// @"乔丹" ;
                NSString *thirdStr =[NSString stringWithUTF8String:awayPos.c_str()] ;// @"前锋" ;
                NSString *fourStr = [NSString stringWithUTF8String:awayPlayer.c_str()];//@"罗纳尔多" ;
                
                NSArray* titlesAray  =[NSArray arrayWithObjects: thirdStr,fourStr,firstStr,secondStr, nil] ;
                [cellView setTitles:titlesAray];
                
                return  cell ;

            }
        
        }
        default:
            break;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 1:
            if (_topScoRow<=0) {
                return 35 ;
            }
            break;
        case 2:{
            if (_techRow<=0) {
                return 35 ;
            }
        }break ;
        case 3:{
            if (_playerRow<=0) {
                return 35 ;
            }
        }break ;
        default:
            break;
    }
    return 30;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    
    static NSString *HeaderTitles[] = {@"比赛事件", @"各项高分", @"技术统计", @"阵容" };
    static NSString *HeaderIndentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIndentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIndentifier];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeader:)]];
    }
    view.titleLabel.text = HeaderTitles[section];
    view.tag = section;
    view.arrowView.highlighted = _sectionCollapse[section];
    view.lineView.highlighted = _sectionCollapse[section];
    return view;
}



@end
