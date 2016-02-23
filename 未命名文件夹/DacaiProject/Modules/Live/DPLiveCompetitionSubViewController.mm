//
//  DPLiveCompetitionSubViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveCompetitionSubViewController.h"
#import "DPLiveDataCenterViews.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPImageLabel.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"

@interface DPLiveCompetitionSubViewController () {
@private
    BOOL _sectionCollapse[4];
    CFootballCenter *_dateCenter;
    UILabel* _signlLabel ;
    NSInteger _compRow ;//赛事行数
    NSInteger _techRow ;//技术统计行数
    NSInteger _playerFirstRow ;//首发行数
    NSInteger _playSecRow ;//替补行数
}

@property(nonatomic,strong,readonly)UILabel* signlLabel ;

@end


@implementation DPLiveCompetitionSubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_COMPETITION] object:nil];
        
        _dateCenter = CFrameWork::GetInstance()->GetFootballCenter();
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
//        tableView.tableFooterView = ({
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//            view.backgroundColor = [UIColor clearColor];
//            view;
//        });
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
    
    _compRow = _techRow = _playerFirstRow = _playSecRow = 0 ;
    self.tableView.tableFooterView= self.signlLabel ;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_COMPETITION] object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DPLog(@"tableView == %@  contentOffset==%f   contentInset===%f",self.tableView,self.tableView.contentOffset.y,self.tableView.contentInset.top) ;
    
}

#pragma mark - event

- (void)Notify:(NSNotification *)notify {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _compRow = _dateCenter->GetEventCount()<=0?0:_dateCenter->GetEventCount() ;
        _techRow = _dateCenter->GetStatisticsCount()<=0?0:_dateCenter->GetStatisticsCount() ;
        _playerFirstRow = MAX(_dateCenter->GetStartPlayerCount(true), _dateCenter->GetStartPlayerCount(false))<=0?0:MAX(_dateCenter->GetStartPlayerCount(true), _dateCenter->GetStartPlayerCount(false)) ;
        _playSecRow = MAX(_dateCenter->GetBenchPlayerCount(true), _dateCenter->GetBenchPlayerCount(false))<=0?0:MAX(_dateCenter->GetBenchPlayerCount(true), _dateCenter->GetBenchPlayerCount(false)) ;
        
        [self.tableView reloadData];
        
//        self.tableView.tableFooterView= self.signlLabel ;
    }) ;
   
}

- (void)pvt_onHeader:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    _sectionCollapse[section] = !_sectionCollapse[section];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade] ;
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sectionCollapse[section]) {
        return 0;
    }
    
    switch (section) {
        case 0: // 赛事实况
//            return 1;
            return _compRow>0?_compRow+2:1 ;
        case 1: // 技术统计
            return _techRow+1;
        case 2: // 首发阵容 
        {
            
            if (_playerFirstRow == 0) {
                return 1;
            } else {
                return _playerFirstRow + 1;
            }

//            int count = MAX(_dateCenter->GetStartPlayerCount(true), _dateCenter->GetStartPlayerCount(false));
//            
//            if (count == 0) {
//                return 1;
//            } else {
//                return count + 1;
//            }
        }
        case 3: // 替补阵容
        {
            if (_playSecRow == 0) {
                return 1;
            } else {
                return _playSecRow;
            }

//            int count = MAX(_dateCenter->GetBenchPlayerCount(true), _dateCenter->GetBenchPlayerCount(false));
//            
//            if (count == 0) {
//                return 1;
//            } else {
//                return count;
//            }
        }
        default:
            return 0;
    }
}

#define CompetionCEllTag 1234

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
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
            headView.tag =CompetionCEllTag+1 ;
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
            _noDataImgLabel.tag = CompetionCEllTag+2 ;
            _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
            _noDataImgLabel.image = dp_SportLiveImage(@"nodataImgSmall.png") ;
            _noDataImgLabel.imagePosition = DPImagePositionLeft ;
            _noDataImgLabel.text = @"暂无数据" ;
            _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
            }] ;

        }
        
        DPImageLabel*imgLab= (DPImageLabel*)[cell.contentView viewWithTag:CompetionCEllTag+2] ;
        if (_techRow<=0) {
            imgLab.hidden = NO ;
            return cell ;
        }else
            imgLab.hidden = YES ;
        
        DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CompetionCEllTag+1] ;
        NSString* firstStr = @"主队   " ;NSString *secondStr = @"   客队";
        NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr, nil] ;
        [cellView setTitles:titlesAray];
        
        return  cell ;
        
    }
    switch (indexPath.section) {
        case 0: {//赛事实况
            
            if (indexPath.row == 0) {
                static NSString *nameAndTimeIdentitifers = @"nameAndTimeIdentitifers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameAndTimeIdentitifers];
                if (cell == nil ) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameAndTimeIdentitifers];
                    cell.backgroundColor = [UIColor clearColor] ;
                    cell.contentView.backgroundColor = [UIColor clearColor] ;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    
                    DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
                    headView.textColors = UIColorFromRGB(0x6F6B68) ;
                    
                    headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
                    NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:103],[NSNumber numberWithFloat:103], nil] ;
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
                    headView.tag =CompetionCEllTag+5 ;
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
                    _noDataImgLabel.tag = CompetionCEllTag+6 ;
                    _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
                    _noDataImgLabel.image = dp_SportLiveImage(@"nodataImgSmall.png") ;
                    _noDataImgLabel.imagePosition = DPImagePositionLeft ;
                    _noDataImgLabel.text = @"暂无数据" ;
                    _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
                    [cell.contentView addSubview:_noDataImgLabel];
                    [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
                    }] ;
                    
                }
                
                DPImageLabel*imgLab= (DPImageLabel*)[cell.contentView viewWithTag:CompetionCEllTag+6] ;
                if (_compRow<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else
                    imgLab.hidden = YES ;
                
                DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:CompetionCEllTag+5] ;
                NSString* firstStr = @"主队" ;NSString *secondStr = @"时间" ;  NSString *thirdStr = @"客队";
                NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondStr,thirdStr, nil] ;
                [cellView setTitles:titlesAray];
                
                return  cell ;
            }else if (indexPath.row == _compRow+1){
                
                static NSString *HeaderFootIndentifier = @"HeaderFootIndentifier";
                UITableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:HeaderFootIndentifier];
                if (celll == nil) {
                    celll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderFootIndentifier];
                    celll.backgroundColor = [UIColor clearColor] ;
                    celll.contentView.backgroundColor = [UIColor clearColor] ;
                    UIView *bottomView = ({
                        UIView *view = [[UIView alloc] init];
                        view.backgroundColor = [UIColor clearColor];
                        
                        NSArray *subViews = @[[[DPImageLabel alloc] init],
                                              [[DPImageLabel alloc] init],
                                              [[DPImageLabel alloc] init],
                                              [[DPImageLabel alloc] init],
                                              [[DPImageLabel alloc] init],
                                              [[DPImageLabel alloc] init]];
                        
                        static NSString *LabelImages[] = { @"进球.png", @"点球.png", @"乌龙.png", @"黄牌.png", @"红牌.png", @"黄红.png", };
                        static NSString *LabelTitles[] = { @"进球", @"点球", @"乌龙", @"黄牌", @"红牌", @"两黄变红", };
                        
                        [subViews enumerateObjectsUsingBlock:^(DPImageLabel *obj, NSUInteger idx, BOOL *stop) {
                            obj.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.54 alpha:1];
                            obj.font = [UIFont dp_systemFontOfSize:11];
                            obj.imagePosition = DPImagePositionLeft;
                            obj.spacing = 2;
                            obj.image = dp_SportLiveImage(LabelImages[idx]);
                            obj.text = LabelTitles[idx];
                            [view addSubview:obj];
                        }];
                        [[subViews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(view).offset(10);
                            make.centerY.equalTo(view);
                        }];
                        [subViews dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
                            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(obj1.mas_right).offset(5);
                                make.centerY.equalTo(obj1);
                            }];
                        }];
                        view;
                    });
                    
                    [celll.contentView addSubview:bottomView];
                    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(celll.contentView);
                        make.right.equalTo(celll.contentView);
                        make.top.equalTo(celll.contentView);
                        make.height.equalTo(@30);
                    }];
                    
                }
                
                return celll ;
                
                
            }
            
            
            static NSString *LiveCellIdentitifer = @"LiveCellIdentitifer";
            DPLiveCompetitionLiveContentCell *cell = [tableView dequeueReusableCellWithIdentifier:LiveCellIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionLiveContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LiveCellIdentitifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (indexPath.row == _compRow) {
                cell.bottomView.hidden = NO ;
            }else{
                cell.bottomView.hidden = YES ;
            }
            
            int code=0, time=0, isHome=0;
            string player;
            _dateCenter->GetEventItem(indexPath.row-1, code, player, time, isHome);
            
            DPImageLabel *homeLabel = cell.liveView.homeLabel ;
            DPImageLabel *awayLabel = cell.liveView.awayLabel;
            // 1:进球, 2:红牌, 3:黄牌, 6:进球不算, 7:点球, 8:乌龙, 9:红牌(2黄牌->红牌)
            const NSDictionary *imageMapping = @{ @1:@"进球.png",
                                                  @7:@"点球.png",
                                                  @8:@"乌龙.png",
                                                  @3:@"黄牌.png",
                                                  @2:@"红牌.png",
                                                  @9:@"黄红.png", };
            
            UIImage *image = dp_SportLiveImage(imageMapping[@(code)]);
            
            cell.liveView.timeLabel.text = [NSString stringWithFormat:@"%d'", time];
                if (isHome) {
                    homeLabel.superview.hidden = NO;
                    awayLabel.superview.hidden = YES;
                    homeLabel.text = [NSString stringWithUTF8String:player.c_str()];
                    homeLabel.image = image;
                } else {
                    homeLabel.superview.hidden = YES;
                    awayLabel.superview.hidden = NO;
                    awayLabel.text = [NSString stringWithUTF8String:player.c_str()];
                    awayLabel.image = image;
                }
            return cell;
        }

        case 1:{ //技术统计
            
            static NSString *TechCellIdentitifer = @"TechCellIdentitifer";
            DPLiveCompetitionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:TechCellIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionStateCell alloc] initWithItemWithArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:116.25],[NSNumber numberWithFloat:77.5],[NSNumber numberWithFloat:116.25], nil] reuseIdentifier:TechCellIdentitifer withHigh:30];
            }
            string name, homeText, awayText;
            int homeCount=0, awayCount=0;
            _dateCenter->GetStatisticsItem(indexPath.row-1, name, homeCount, awayCount, homeText, awayText);
            
            NSArray* titlesArray = [NSArray arrayWithObjects:[NSString stringWithUTF8String:homeText.c_str()],[NSString stringWithUTF8String:name.c_str()], [NSString stringWithUTF8String:awayText.c_str()],nil] ;
            [cell.cellView setTitles:titlesArray];
            
            int count = _dateCenter->GetStatisticsCount();
            if (count == indexPath.row) {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor ;
            }else{
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            }
            
            
            UIView *homeBar = cell.homeBar ;
            UIView *awayBar = cell.awayBar ;
            [cell.homeBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == homeBar) {
                    obj.constant = 116.25 * homeCount / (homeCount+awayCount);
                    *stop = YES;
                }
            }];
            [cell.awayBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == awayBar) {
                    obj.constant = 116.255 * awayCount / (homeCount+awayCount);
                    *stop = YES;
                }
            }];
            
            
            return cell;
            
        }
        case 2: { //首发阵容
            if (indexPath.row == 0) {
                static NSString *PlayerHeaderCell = @"PlayerHeaderCell";
                DPLiveCompetitionPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerHeaderCell];
                if (cell == nil) {
                    cell = [[DPLiveCompetitionPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerHeaderCell];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell buildTitle];
                    DPImageLabel* _noDataImgLabel  = [[DPImageLabel alloc]init];
                    _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
                    _noDataImgLabel.hidden = YES ;
                    _noDataImgLabel.layer.borderWidth = 0.5 ;
                    _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
                    _noDataImgLabel.tag = CompetionCEllTag+3 ;
                    _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
                    _noDataImgLabel.image = dp_SportLiveImage(@"nodataImgSmall.png") ;
                    _noDataImgLabel.imagePosition = DPImagePositionLeft ;
                    _noDataImgLabel.text = @"暂无数据" ;
                    _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
                    [cell.contentView addSubview:_noDataImgLabel];
                    [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
                    }] ;

                }

                DPImageLabel*imgLab= (DPImageLabel*)[cell.contentView viewWithTag:CompetionCEllTag+3] ;
                if (_playerFirstRow<=0) {
                    imgLab.hidden = NO ;
                    return cell ;
                }else
                    imgLab.hidden = YES ;
                
                string homeFormation, awayFormation;
                _dateCenter->GetFormation(homeFormation, awayFormation);
                cell.homePlayerLabel.text = [NSString stringWithUTF8String:homeFormation.c_str()];
                cell.awayPlayerLabel.text = [NSString stringWithUTF8String:awayFormation.c_str()];
                return cell;
            } else {
                
                static NSString *PlayerCellIdentitifer = @"PlayerCellIdentitifer";
                DPLiveCompetitionPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentitifer];
                if (cell == nil) {
                    cell = [[DPLiveCompetitionPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerCellIdentitifer];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell buildLayout];
                }
                
                int homeNumber=0, awayNumber=0;
                string homePlayer, awayPlayer;
                if (_dateCenter->GetStartPlayerItem(indexPath.row - 1, true, homeNumber, homePlayer) >= 0) {
                    cell.homeImageLabel.hidden = cell.homePlayerLabel.hidden = NO;
                    
                    if (homePlayer.size() == 0) {
                        cell.homeImageLabel.text = @"?";
                        cell.homePlayerLabel.text = nil;
                    } else {
                        cell.homeImageLabel.text = [NSString stringWithFormat:@"%@", homeNumber>0?[NSString stringWithFormat:@"%d",homeNumber]:@"?"];
                        cell.homePlayerLabel.text = [NSString stringWithUTF8String:homePlayer.c_str()];
                    }
                } else {
                    cell.homeImageLabel.hidden = cell.homePlayerLabel.hidden = YES;
                }
                
                if (_dateCenter->GetStartPlayerItem(indexPath.row - 1, false, awayNumber, awayPlayer) >= 0) {
                    cell.awayImageLabel.hidden = cell.awayPlayerLabel.hidden = NO;
                    
                    if (awayPlayer.size() == 0) {
                        cell.awayImageLabel.text = @"?";
                        cell.awayPlayerLabel.text = nil;
                    } else {
                        cell.awayImageLabel.text = [NSString stringWithFormat:@"%@", awayNumber>0?[NSString stringWithFormat:@"%d",awayNumber]:@"?"];
                        cell.awayPlayerLabel.text = [NSString stringWithUTF8String:awayPlayer.c_str()];
                    }
                } else {
                    cell.awayImageLabel.hidden = cell.awayPlayerLabel.hidden = YES;
                }

                return cell;
            }
        }
        case 3: { //替补阵容
            static NSString *BenchPlayerIdentitifer = @"BenchPlayerIdentitifer";
            DPLiveCompetitionPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:BenchPlayerIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BenchPlayerIdentitifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell buildLayout];
                
                DPImageLabel* _noDataImgLabel  = [[DPImageLabel alloc]init];
                _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
                _noDataImgLabel.hidden = YES ;
                _noDataImgLabel.layer.borderWidth = 0.5 ;
                _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
                _noDataImgLabel.tag = CompetionCEllTag+4 ;
                _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
                _noDataImgLabel.image = dp_SportLiveImage(@"nodataImgSmall.png") ;
                _noDataImgLabel.imagePosition = DPImagePositionLeft ;
                _noDataImgLabel.text = @"暂无数据" ;
                _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
                [cell.contentView addSubview:_noDataImgLabel];
                [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
                }] ;

                
            }
            
            DPImageLabel*imgLab= (DPImageLabel*)[cell.contentView viewWithTag:CompetionCEllTag+4] ;
            if (_playSecRow<=0) {
                imgLab.hidden = NO ;
                return cell ;
            }else
                imgLab.hidden = YES ;
            
            
            int homeNumber=0, awayNumber=0;
            string homePlayer, awayPlayer;
            if (_dateCenter->GetBenchPlayerItem(indexPath.row, true, homeNumber, homePlayer) >= 0) {
                cell.homeImageLabel.hidden = cell.homePlayerLabel.hidden = NO;
                
                if (homePlayer.size() == 0) {
                    cell.homeImageLabel.text = @"?";
                    cell.homePlayerLabel.text = nil;
                } else {
                    cell.homeImageLabel.text = [NSString stringWithFormat:@"%@", homeNumber>0?[NSString stringWithFormat:@"%d",homeNumber]:@"?"];
                    cell.homePlayerLabel.text = [NSString stringWithUTF8String:homePlayer.c_str()];
                }
            } else {
                cell.homeImageLabel.hidden = cell.homePlayerLabel.hidden = YES;
            }
            
            if (_dateCenter->GetBenchPlayerItem(indexPath.row, false, awayNumber, awayPlayer) >= 0) {
                cell.awayImageLabel.hidden = cell.awayPlayerLabel.hidden = NO;
                
                if (awayPlayer.size() == 0) {
                    cell.awayImageLabel.text = @"?";
                    cell.awayPlayerLabel.text = nil;
                } else {
                    cell.awayImageLabel.text = [NSString stringWithFormat:@"%@", awayNumber>0?[NSString stringWithFormat:@"%d",awayNumber]:@"?"];
                    cell.awayPlayerLabel.text = [NSString stringWithUTF8String:awayPlayer.c_str()];
                }
            } else {
                cell.awayImageLabel.hidden = cell.awayPlayerLabel.hidden = YES;
            }
            return cell;
        }
            break;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (_compRow == 0) {
                return 35 ;
            }else if (indexPath.row == 0||indexPath.row == _compRow+1){
                return 30 ;
            }
            return 31.5 ;
        }
        case 1: {
            if (_dateCenter->GetStatisticsCount()<=0) {
                return 35 ;
            }
        }break ;
        case 2:{
            if (MAX(_dateCenter->GetStartPlayerCount(true), _dateCenter->GetStartPlayerCount(false))<=0) {
                return 35 ;
            }
        
        }break ;
        case 3:{
            if ( MAX(_dateCenter->GetBenchPlayerCount(true), _dateCenter->GetBenchPlayerCount(false))<=0) {
                return 35 ;
            }
        }
            break ;
        default:
            return 0;
    }
    return 30 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    static NSString *HeaderTitles[] = { @"赛事实况", @"技术统计", @"首发阵容", @"替补阵容" };
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

@interface DPLiveCompetitionLiveContentView () {
@private
    NSInteger _rowCount;
}
@end

@implementation DPLiveCompetitionLiveContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];

    }
    return self;
}

-(void)buildLayout{
    UIImageView *homeView = [[UIImageView alloc] initWithImage:dp_SportLiveResizeImage(@"live_home.png")];
    UIImageView *awayView = [[UIImageView alloc] initWithImage:dp_SportLiveResizeImage(@"live_away.png")];
    
    DPImageLabel *timeLabel = [[DPImageLabel alloc] init];
    timeLabel.image = dp_SportLiveImage(@"live_time.png");
    timeLabel.textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
    timeLabel.font = [UIFont dp_regularArialOfSize:10];
    
    DPImageLabel *homeLabel = [[DPImageLabel alloc] init];
    homeLabel.imagePosition = DPImagePositionLeft;
    homeLabel.textColor = [UIColor colorWithRed:0.56 green:0.49 blue:0.31 alpha:1];
    homeLabel.font = [UIFont dp_systemFontOfSize:12];
    DPImageLabel *awayLabel = [[DPImageLabel alloc] init];
    awayLabel.imagePosition = DPImagePositionLeft;
    awayLabel.textColor = [UIColor colorWithRed:0.56 green:0.49 blue:0.31 alpha:1];
    awayLabel.font = [UIFont dp_systemFontOfSize:12];
    
    timeLabel.frame = CGRectMake(kScreenWidth / 2 - 11 - 5, 0, 21.5, 31.5);
    homeView.frame = CGRectMake(timeLabel.dp_minX - 135, timeLabel.dp_midY - 11.5, 130, 22.5);
    awayView.frame = CGRectMake(timeLabel.dp_maxX + 5, timeLabel.dp_midY - 11.5, 130, 22.5);
    
    [self addSubview:timeLabel];
    [self addSubview:homeView];
    [self addSubview:awayView];
    [homeView addSubview:homeLabel];
    [awayView addSubview:awayLabel];
    
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeView).offset(10);
        make.centerY.equalTo(homeView);
    }];
    [awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(awayView);
        make.left.equalTo(awayView).offset(10);
    }];
    
        
    _homeLabel = homeLabel;
    _awayLabel = awayLabel;
    _timeLabel = timeLabel;

}


@end



#define kDPLiveCompetitionPlayerCellContentTag   20428
@implementation DPLiveCompetitionPlayerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.84 green:0.82 blue:0.8 alpha:1].CGColor;
        view.tag = kDPLiveCompetitionPlayerCellContentTag;
        
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5));
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));

        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:0.76 green:0.75 blue:0.73 alpha:1];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(-0.5);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)buildTitle {
    // initialize
    UIView *view = [self.contentView viewWithTag:kDPLiveCompetitionPlayerCellContentTag];
    view.backgroundColor = [UIColor clearColor];
    
    _homePlayerLabel = [[UILabel alloc] init];
    _homePlayerLabel.textColor = [UIColor colorWithRed:0.47 green:0.45 blue:0.45 alpha:1];
    _homePlayerLabel.font = [UIFont dp_boldSystemFontOfSize:14];
    _homePlayerLabel.backgroundColor = [UIColor clearColor];
    _homePlayerLabel.textAlignment = NSTextAlignmentCenter;
    
    _awayPlayerLabel = [[UILabel alloc] init];
    _awayPlayerLabel.textColor = [UIColor colorWithRed:0.47 green:0.45 blue:0.45 alpha:1];
    _awayPlayerLabel.font = [UIFont dp_boldSystemFontOfSize:14];
    _awayPlayerLabel.backgroundColor = [UIColor clearColor];
    _awayPlayerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.homePlayerLabel];
    [self.contentView addSubview:self.awayPlayerLabel];
    [self.homePlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.awayPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view.mas_centerX);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
}

- (void)buildLayout {
    // initialize
    _homeImageLabel = [[DPImageLabel alloc] init];
    _homeImageLabel.image = dp_SportLiveImage(@"redclothes.png");
    _homeImageLabel.font = [UIFont dp_boldSystemFontOfSize:8];
    _homeImageLabel.textColor = [UIColor dp_flatWhiteColor];
    _homePlayerLabel = [[UILabel alloc] init];
    _homePlayerLabel.textColor = [UIColor dp_flatBlackColor];
    _homePlayerLabel.font = [UIFont dp_systemFontOfSize:12];
    _homePlayerLabel.backgroundColor = [UIColor clearColor];
    
    _awayImageLabel = [[DPImageLabel alloc] init];
    _awayImageLabel.image = dp_SportLiveImage(@"blueclothes.png");
    _awayImageLabel.font = [UIFont dp_boldSystemFontOfSize:8];
    _awayImageLabel.textColor = [UIColor dp_flatWhiteColor];
    _awayPlayerLabel = [[UILabel alloc] init];
    _awayPlayerLabel.textColor = [UIColor dp_flatBlackColor];
    _awayPlayerLabel.font = [UIFont dp_systemFontOfSize:12];
    _awayPlayerLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.homeImageLabel];
    [self.contentView addSubview:self.homePlayerLabel];
    [self.contentView addSubview:self.awayImageLabel];
    [self.contentView addSubview:self.awayPlayerLabel];
    [self.homeImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    [self.homePlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeImageLabel.mas_right).offset(6);
        make.centerY.equalTo(self.contentView);
    }];
    [self.awayImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
    [self.awayPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.awayImageLabel.mas_left).offset(-6);
        make.centerY.equalTo(self.contentView);
    }];
}

@end


@implementation DPLiveCompetitionLiveContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
       
        
        UIView *rightLine = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
        
        UIView *leftLine = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
                [self.contentView addSubview:rightLine];
        [self.contentView addSubview:leftLine];


        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView) ;
            make.width.equalTo(@0.5) ;
        }];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView) ;
            make.width.equalTo(@0.5) ;
        }];
        
               
        DPLiveCompetitionLiveContentView *liveView = [[DPLiveCompetitionLiveContentView alloc] initWithFrame:CGRectMake(5, 30, 310, 200)];
        liveView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:liveView];
        [liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)).priorityLow();
        }];
        
        UIView *bottomLab = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
        
        _liveView = liveView;
        [self.contentView addSubview:bottomLab];
        [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView) ;
            make.left.equalTo(self.contentView).offset(5);
            make.height.equalTo(@0.5) ;
        }];

        _bottomView = bottomLab ;
        
        
    }
    return self;
}


@end
