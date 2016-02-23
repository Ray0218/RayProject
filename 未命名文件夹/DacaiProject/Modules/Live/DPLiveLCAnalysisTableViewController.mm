//
//  DPLiveLCAnalysisTableViewController.m
//  DacaiProject
//
//  Created by Ray on 14/12/8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveLCAnalysisTableViewController.h"
#import "DPLiveDataCenterViews.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"


@interface DPLiveLCAnalysisTableViewController ()
{
@private
    BOOL _sectionCollapse[3];
    CBasketballCenter *_dateCenter;
    UILabel* _signlLabel ;
    
    NSInteger _historyAgainstCount ;//历史行数
    NSInteger _homeAgainstCount ; //主队行数
    NSInteger _homeFutureAgainstCount ;//未来行数

}
@property(nonatomic,strong,readonly)UILabel* signlLabel ;


@end

@implementation DPLiveLCAnalysisTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_AGAINST] object:nil];
        
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
        DPNoInsetOffsetTableView *view = [[DPNoInsetOffsetTableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        //        view.sectionOffset = -185;
        view.sectionOffset = -85;
        
        view;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_AGAINST] object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.title = @"分析";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyAgainstCount = 0 ;
    _homeAgainstCount = 0 ;
    _homeFutureAgainstCount = 0 ;
    self.tableView.tableFooterView= self.signlLabel ;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    _sectionCollapse[section] = !_sectionCollapse[section];
//    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)Notify:(NSNotification *)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _historyAgainstCount = _dateCenter->GetHistoryAgainstCount()<=0?0:_dateCenter->GetHistoryAgainstCount() ;
        _homeAgainstCount = _dateCenter->GetHomeAgainstCount()<=0?0:_dateCenter->GetHomeAgainstCount();
        _homeFutureAgainstCount = _dateCenter->GetHomeFutureAgainstCount()<=0?0:_dateCenter->GetHomeFutureAgainstCount() ;
        
        
        [self.tableView reloadData];
        
//        self.tableView.tableFooterView= self.signlLabel ;
    }) ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    

    if (_sectionCollapse[section] ) {
        return 0;
    }
    switch (section) {
        case 0:
            return  _historyAgainstCount<=0?1:_historyAgainstCount+2;
        case 1:
            return  _homeAgainstCount<=0?1:_homeAgainstCount+_dateCenter->GetAwayAgainstCount() +4 ;
        case 2:
            return _homeFutureAgainstCount<=0?1:_dateCenter->GetHomeFutureAgainstCount()+_dateCenter->GetAwayFutureAgainstCount() +4 ;
        default:
            return 0;
    }

//    switch (section) {
//        case 0:
//            return  _dateCenter->GetHistoryAgainstCount()<=0?1:_dateCenter->GetHistoryAgainstCount()+2;
//        case 1:
//            return  _dateCenter->GetHomeAgainstCount()<=0?1:_dateCenter->GetHomeAgainstCount()+_dateCenter->GetAwayAgainstCount() +4 ;
//        case 2:
//            return _dateCenter->GetHomeFutureAgainstCount()<=0?1:_dateCenter->GetHomeFutureAgainstCount()+_dateCenter->GetAwayFutureAgainstCount() +4 ;
//        default:
//            return 0;
//    }
}

#define AnalysisLCTag 6776
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int type = 0,index = 0,future= 0;
    switch (indexPath.section) {
        case 0:{
            type = 0;
            index = indexPath.row-2 ;
            future = 0 ;
        }
            break;
        case 1:{
            future = 0 ;
            if (indexPath.row<_homeAgainstCount+2) {
                type = 1;
                index = indexPath.row-2 ;
            }else{
                type = 2 ;
                index = indexPath.row-_dateCenter->GetHomeAgainstCount()-4 ;
            }
        }
            break;
        case 2:{
            future = 1 ;
            if (indexPath.row<_homeFutureAgainstCount+2) {
                type = 3 ;
                index = indexPath.row-2 ;
            }else{
                type = 4 ;
                index = indexPath.row-_dateCenter->GetHomeFutureAgainstCount()-4 ;
            }
        }
            break;
        default:
            break;
    }
    
    if (index == -2) {
        static NSString* headIdentifer = @"headIdentifer" ;
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:headIdentifer] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headIdentifer];
            cell.backgroundColor = [UIColor clearColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            MDHTMLLabel* textLab = [[MDHTMLLabel alloc]init];
            textLab.backgroundColor = [UIColor dp_flatWhiteColor] ;
            [cell.contentView addSubview:textLab];
            textLab.tag = AnalysisLCTag+1 ;
            textLab.layer.borderWidth = 0.5 ;
            textLab.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor;
            
            [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(5) ;
                make.right.equalTo(cell.contentView).offset(-5) ;
                make.centerY.equalTo(cell.contentView) ;
                make.height.equalTo(@23) ;
            }];
            
            DPImageLabel* _noDataImgLabel  = [[DPImageLabel alloc]init];
            _noDataImgLabel.font = [UIFont dp_systemFontOfSize:12] ;
            _noDataImgLabel.hidden = YES ;
            _noDataImgLabel.layer.borderWidth = 0.5 ;
            _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            _noDataImgLabel.tag = AnalysisLCTag+4 ;
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
        
        DPImageLabel* imgLab = (DPImageLabel*)[cell.contentView viewWithTag:AnalysisLCTag+4] ;
        switch (indexPath.section) {
            case 0:{
                if (_dateCenter->GetHistoryAgainstCount()<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else{
                    imgLab.hidden = YES ;
                }
            }
                break;
            case 1:{
                if (_dateCenter->GetHomeAgainstCount()<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else{
                    imgLab.hidden = YES ;
                }
                
            }break ;
            case 2:{
                if (_dateCenter->GetHomeFutureAgainstCount()<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else{
                    imgLab.hidden = YES ;
                }
            }break ;
            default:
                break;
        }

        
        MDHTMLLabel* lab =(MDHTMLLabel*)[cell.contentView viewWithTag:AnalysisLCTag+1] ;

        string teamName ;
        int totalWin=0,totalLoss=0,homeWin=0,homeLoss=0,bigPoint=0,smallPoint=0;
        if (indexPath.section == 0) {
            _dateCenter->GetHistoryAgainstInfo(teamName,totalWin, totalLoss, homeWin, homeLoss, bigPoint, smallPoint) ;
        }else if (indexPath.section == 1){
        
            if (indexPath.row == 0) {
                _dateCenter->GetHomeAgainstInfo(teamName,totalWin, totalLoss, homeWin, homeLoss, bigPoint, smallPoint) ;
            }else
                _dateCenter->GetAwayAgainstInfo(teamName,totalWin, totalLoss, homeWin, homeLoss, bigPoint, smallPoint) ;
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                _dateCenter->GetHomeFutureAgainstInfo(teamName) ;
                lab.htmlText = [NSString stringWithFormat:@"   <font size = 12 color=\"#272727\">%@</font>",[NSString stringWithUTF8String:teamName.c_str()]] ;
            }else{
                _dateCenter->GetAwayFutureAgainstInfo(teamName) ;
                lab.htmlText = [NSString stringWithFormat:@"   <font size = 12 color=\"#272727\">%@</font>",[NSString stringWithUTF8String:teamName.c_str()]] ;
            }
            
            return cell ;
        }

        lab.htmlText = [NSString stringWithFormat:@"   <font size = 12 color=\"#272727\">%@</font> <font size =10 color=\"#EA2D30\">%d胜</font><font size =10 color=\"#424F9C\">%d负</font>  <font size = 10 color=\"#7E725C\">主场</font> <font size =10 color=\"#EA2D30\">%d胜</font><font size =10 color=\"#424F9C\">%d负</font> <font size = 10 color=\"#7E725C\">大球</font><font size =10 color=\"#EA2D30\">%d</font> <font size = 10 color=\"#7E725C\">小球</font><font size =10 color=\"#424F9C\">%d</font>",[NSString stringWithUTF8String:teamName.c_str()],totalWin,totalLoss,homeWin,homeLoss,bigPoint,smallPoint] ;

        
        return cell ;
    }else if (index == -1){
        
        if (future == 1) {
            static NSString* futureComIdentifer = @"futureComIdentifer" ;
            UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:futureComIdentifer] ;
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:futureComIdentifer];
                cell.backgroundColor = [UIColor clearColor] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                DPLiveOddsHeaderView * nameView = [[DPLiveOddsHeaderView alloc]init];
                nameView.tag = AnalysisLCTag+2 ;
                nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
                nameView.titleFont = [UIFont dp_systemFontOfSize:12];
                [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:103],[NSNumber numberWithFloat:103], nil] whithHigh:30 withSeg:NO] ;
                nameView.backgroundColor = [UIColor dp_flatWhiteColor] ;
                [cell.contentView addSubview:nameView];
                
                [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                }];
            }
            DPLiveOddsHeaderView* nameView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:AnalysisLCTag+2] ;
            [nameView setTitles:[NSArray arrayWithObjects:@"赛事和时间",@"主队",@"客队", nil]] ;
            
            return cell ;
        }
        
        static NSString* headNameIdentifer = @"headNameIdentifer" ;
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:headNameIdentifer] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headNameIdentifer];
            cell.backgroundColor = [UIColor clearColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            DPLiveOddsHeaderView * nameView = [[DPLiveOddsHeaderView alloc]init];
            nameView.tag = AnalysisLCTag+3 ;
            nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
            nameView.titleFont = [UIFont dp_systemFontOfSize:12];
            [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:58],[NSNumber numberWithFloat:84], nil] whithHigh:30 withSeg:NO] ;
            nameView.backgroundColor = [UIColor dp_flatWhiteColor] ;
            [cell.contentView addSubview:nameView];
            
            [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
        DPLiveOddsHeaderView* nameView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:AnalysisLCTag+3] ;
        [nameView setTitles:[NSArray arrayWithObjects:@"赛事和时间",@"主队",@"比分",@"客队", nil]] ;
    
        return cell ;
    }
    
    if (future == 1) { //未来赛事表格
        static NSString* contentFuture = @"contentFuture" ;
        DPLiveAnalysisViewCell* cell = [tableView dequeueReusableCellWithIdentifier:contentFuture] ;
        if (cell == nil) {
            cell = [[DPLiveAnalysisViewCell alloc]initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:103],[NSNumber numberWithFloat:103], nil] reuseIdentifier:contentFuture withHight:30];
        }
        [cell.rootbgView  changeNumberOfLinesWithIndex:0 withNumber:2];
        
        string competitionName,time,homeName,awayName;
        if (indexPath.row == 2) {
            _dateCenter->GetHomeFutureAgainstItem(index, competitionName, time, homeName, awayName) ;
        }else
            _dateCenter->GetAwayFutureAgainstItem(index, competitionName, time, homeName, awayName) ;
        
        NSString* firstStr = [NSString  stringWithFormat:@"<font size =11 color=\"#5C5C5C\">%@</font><font size =8 color=\"#A2A2A2\">\n%@</font>",[NSString stringWithUTF8String:competitionName.c_str()],[NSDate dp_coverDateString:[NSString stringWithUTF8String:time.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd]] ;
        NSString* secondeStr = [NSString stringWithFormat:@"<font size =11 color=\"#5C5C5C\">%@</font>",[NSString stringWithUTF8String:homeName.c_str()]];
        NSString* fourStr= [NSString stringWithFormat:@"<font size =11 color=\"#5C5C5C\">%@</font>",[NSString stringWithUTF8String:awayName.c_str()]];
        NSArray* titleArray = [NSArray arrayWithObjects: firstStr,secondeStr,fourStr, nil] ;
        [cell.rootbgView setTitles:titleArray];
        return cell ;

    }
    
    //历史和近期战绩表格
    static NSString* contentIdentifier = @"contentIdentifier" ;
    DPLiveAnalysisViewCell* cell = [tableView dequeueReusableCellWithIdentifier:contentIdentifier] ;
    if (cell == nil) {
        cell = [[DPLiveAnalysisViewCell alloc]initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:58],[NSNumber numberWithFloat:84], nil] reuseIdentifier:contentIdentifier withHight:30];
        [cell.rootbgView  changeNumberOfLinesWithIndex:0 withNumber:2];

    }
  
    
    string competitionName,time,homeNames,awayNames  ;
    int homeScore=0,awayScore=0 ;
    
    NSString* homeTextColor= @"5C5C5C" ;
    NSString *awayTextColor = @"5C5C5C" ;
    
    if (indexPath.section == 1) {
        if (indexPath.row < _homeAgainstCount+2) {
            _dateCenter->GetHomeAgainstItem(index, competitionName, time, homeNames, awayNames, homeScore, awayScore) ;
            if ([[NSString stringWithUTF8String:homeNames.c_str()]isEqualToString:g_homeName]) {
                homeTextColor= homeScore>awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
            }
            if ([[NSString stringWithUTF8String:awayNames.c_str()]isEqualToString:g_homeName]) {
                awayTextColor= homeScore<awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
            }
        }else{
            _dateCenter->GetAwayAgainstItem(index, competitionName, time, homeNames, awayNames , homeScore, awayScore) ;
            if ([[NSString stringWithUTF8String:homeNames.c_str()]isEqualToString:g_awayName]) {
                homeTextColor= homeScore>awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
            }
            if ([[NSString stringWithUTF8String:awayNames.c_str()]isEqualToString:g_awayName]) {
                awayTextColor= homeScore<awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
            }
        }
    }else if (indexPath.section == 0){
        _dateCenter->GetHistoryAgainstItem(index, competitionName, time, homeNames , awayNames , homeScore, awayScore) ;
        if ([[NSString stringWithUTF8String:homeNames.c_str()]isEqualToString:g_homeName]) {
            homeTextColor= homeScore>awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
        }
        if ([[NSString stringWithUTF8String:awayNames.c_str()]isEqualToString:g_homeName]) {
            awayTextColor= homeScore<awayScore? @"EA2D30":homeScore == awayScore?@"5C5C5C":@"424F9C" ;
        }    }
    
   
    
    NSString* firstStr = [NSString  stringWithFormat:@"<font size =11 color=\"#535353\">%@</font><font size =8 color=\"#A2A2A2\">\n%@</font>",[NSString stringWithUTF8String:competitionName.c_str()],[NSDate dp_coverDateString:[NSString stringWithUTF8String:time.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd]] ;
    NSString* secondeStr = [NSString stringWithFormat:@"<font size =11 color=\"#%@\">%@</font>",homeTextColor,[NSString stringWithUTF8String:homeNames.c_str()]];
    NSString* thirdStr =[NSString stringWithFormat:@"<font size =11 color=\"#5C5C5C\">%@</font>",[NSString stringWithFormat:@"%d:%d", homeScore, awayScore]] ;
    NSString* fourStr= [NSString stringWithFormat:@"<font size =11 color=\"#%@\">%@</font>",awayTextColor, [NSString stringWithUTF8String:awayNames.c_str()]];
    NSArray* titleArray = [NSArray arrayWithObjects: firstStr,secondeStr,thirdStr,fourStr, nil] ;
    [cell.rootbgView setTitles:titleArray];
    return cell ;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//case 0:
//    return  _dateCenter->GetHistoryAgainstCount()<=0?1:_dateCenter->GetHistoryAgainstCount()+2;
//case 1:
//    return  _dateCenter->GetHomeAgainstCount()<=0?1:_dateCenter->GetHomeAgainstCount()+_dateCenter->GetAwayAgainstCount() +4 ;
//case 2:
//    return _dateCenter->GetHomeFutureAgainstCount()<=0?1:_dateCenter->GetHomeFutureAgainstCount()+_dateCenter->GetAwayFutureAgainstCount() +4 ;

    switch (indexPath.section) {
        case 0:{
            if (_dateCenter->GetHistoryAgainstCount()<=0) {
                return 35 ;
            }else if (indexPath.row == 0) {
                return 26 ;
            }
        }break ;
        case 1:{
            if (_dateCenter->GetHomeAgainstCount()<=0) {
                return 35 ;
            }else if (indexPath.row == 0 || indexPath.row == _dateCenter->GetHomeAgainstCount()+2) {
                return 26 ;
            }
        }break ;
        case 2:{
            if (_dateCenter->GetHomeFutureAgainstCount()<=0) {
                return 35 ;
            }else if (indexPath.row == 0 || indexPath.row == _dateCenter->GetHomeFutureAgainstCount()+2) {
                return 26 ;
            }
        }break ;
        default:
            break;
    }
    
    return 30 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderIdentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];
    }
    static NSString *HeaderTexts[] = { @"历史交锋", @"近期战绩", @"未来对阵" };
    view.titleLabel.text = HeaderTexts[section];
    view.tag = section;
    view.arrowView.highlighted = _sectionCollapse[section];
    view.lineView.highlighted = _sectionCollapse[section];

    return view;
}

@end

