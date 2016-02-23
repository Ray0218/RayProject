//
//  DPLiveOddsPositionSubViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveOddsPositionSubViewController.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPSegmentedControl.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"
#import "DPLiveOddsPositionDetailVC.h"

@interface DPLiveOddsPositionSubViewController (){
@private
    CFootballCenter *_dateCenter;
    UILabel* _signlLabel ;
    NSInteger _rowNumber ; //行数

}

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,strong,readonly)UILabel* signlLabel ;

@end

@implementation DPLiveOddsPositionSubViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_ODDSHANDICAP ] object:nil];
        
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
        DPNoInsetOffsetTableView *view = [[DPNoInsetOffsetTableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        view.sectionOffset = -85;
        view;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.type = 1 ;
    self.title = @"赔盘";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rowNumber = 0 ;
    self.tableView.tableFooterView= self.signlLabel ;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_rowNumber>0) {
        return _rowNumber;
    }else
        return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45+30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_rowNumber <=0) {
        return 150 ;
    }
    
    return 30 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
        
    static NSString *HeaderIdentifier = @"Header";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        view.contentView.backgroundColor = [UIColor clearColor];
        view.backgroundView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColorFromRGB(0xF4F3EF) ;
            view;
        });
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[@"欧赔", @"亚盘", @"大小球"]];
        seg.selectedIndex = self.type-1 ;
        [seg setTintColor:[UIColor colorWithRed:0.49 green:0.45 blue:0.32 alpha:1]];

        [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:seg];
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(7.5) ;
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            make.centerX.equalTo(view);
        }];
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
        headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
        headView.textColors = [UIColor dp_colorFromRGB:0x817e7c] ;
        headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60],[NSNumber numberWithFloat:120],[NSNumber numberWithFloat:130], nil] ;
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];

        headView.tag = 999 ;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(seg.mas_bottom).offset(7.5) ;
//            make.left.equalTo(view).offset(5) ;
//            make.height.equalTo(@30);
//            make.right.equalTo(view).offset(-5);
            
            make.top.equalTo(seg.mas_bottom).offset(7.5) ;
            make.centerX.equalTo(view) ;
            make.width.equalTo(@310) ;
            make.height.equalTo(@30) ;
        }];
        
    }
    
    DPLiveOddsHeaderView* headView = (DPLiveOddsHeaderView*)[view viewWithTag:999] ;
    if (self.type == 1) {
        [headView setTitles:[NSArray arrayWithObjects:@"公司", @"初始赔率",@"最新赔率",nil]];
    }else  {
        [headView setTitles:[NSArray arrayWithObjects:@"公司", @"初始盘口",@"即时盘口",nil]];
    }
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cell_Reuse = @"cell_Reuse" ;
    DPLiveOddsPositionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse] ;
    if (cell == nil) {
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60],[NSNumber numberWithFloat:35],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:35],[NSNumber numberWithFloat:35],[NSNumber numberWithFloat:55],[NSNumber numberWithFloat:40], nil] ;
        cell = [[DPLiveOddsPositionSubCell alloc]initWithWidArray:arr reuseIdentifier:cell_Reuse withHigh:30];
        
    }
    if (_rowNumber<=0) {
        cell.noDataImgLabel.hidden = NO ;
        return cell ;
    }else
        cell.noDataImgLabel.hidden = YES ;
    
    
    string companyName,initOdds[3],currOdds[3];
    int trends[3]={0} ;
    _dateCenter->GetOddsHandicapItem(self.type, indexPath.row, companyName, initOdds, currOdds, trends) ;
    
    NSString* firstStr = [NSString stringWithUTF8String:companyName.c_str()] ;// [NSString stringWithFormat:@"<font size = 11 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:companyName.c_str()]];
    NSString* secondtStr = [NSString stringWithFormat:@"<font size = 10 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:initOdds[0].c_str()]];
    NSString* secondtStr2 = [NSString stringWithFormat:@"<font size = 10 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:initOdds[1].c_str()]];
    NSString* secondtStr3 = [NSString stringWithFormat:@"<font size = 10 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:initOdds[2].c_str()]];

    
    
    NSString* arrowStr1 = trends[0]>0?@"↑":trends[0]<0?@"↓":@"" ;
    NSString* arrowStr2 = trends[1]>0?@"↑":trends[1]<0?@"↓":@"" ;
    NSString* arrowStr3 = trends[2]>0?@"↑":trends[2]<0?@"↓":@"" ;
    
    NSString* strColor1 = trends[0]>0?@"#dc2804":trends[0]<0?@"#3456A4":@"#2F2F2F" ;
    NSString* strColor2 = trends[1]>0?@"#dc2804":trends[1]<0?@"#3456A4":@"#2F2F2F" ;
    NSString* strColor3 = trends[2]>0?@"#dc2804":trends[2]<0?@"#3456A4":@"#2F2F2F" ;
    
    
    NSString* thirdStr = [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor1, [NSString stringWithUTF8String:currOdds[0].c_str()],arrowStr1];
    NSString* thirdStr2 = [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor2,[NSString stringWithUTF8String:currOdds[1].c_str()],arrowStr2];
    NSString* thirdStr3 = [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor3,[NSString stringWithUTF8String:currOdds[2].c_str()],arrowStr3];
    NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondtStr,secondtStr2,secondtStr3,thirdStr,thirdStr2,thirdStr3, nil] ;
    
    [cell.itemView setTitles:titlesAray] ;
    
    if (indexPath.row%2 == 0) {
        cell.itemView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff] ;
    }else
        cell.itemView.backgroundColor = [UIColor dp_colorFromRGB:0xf7f4ef] ;
    
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    DPLiveOddsPositionDetailVC * vc =[[DPLiveOddsPositionDetailVC alloc]initWIthGameType:GameTypeZcNone withSelectIndex:self.type companyIndx:indexPath.row withMatchId:g_matchId];
//    vc.defaultIndexPath = indexPath ;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    
    if (self.type != seg.selectedIndex+1) {
        [self setType:(seg.selectedIndex+1)];
        switch (self.type) {
            case 1:{
                if (g_oddsFirst >0) {
                    _rowNumber = _dateCenter->GetOddsHandicapCount(self.type);
                    [self.tableView reloadData];
                }else
                    g_oddsFirst = _dateCenter->RefreshOddsHandicap(g_matchId, self.type) ;
            }
                break;
                case 2:{
                    if (g_oddsSecond >0) {
                        _rowNumber = _dateCenter->GetOddsHandicapCount(self.type) ;
                        [self.tableView reloadData];
                    }else
                        g_oddsSecond = _dateCenter->RefreshOddsHandicap(g_matchId, self.type) ;
                }break ;
                case 3:{
                    if (g_oddsThird >0) {
                        _rowNumber = _dateCenter->GetOddsHandicapCount(self.type) ;
                        [self.tableView reloadData];
                    }else
                        g_oddsThird = _dateCenter->RefreshOddsHandicap(g_matchId, self.type) ;
                }
                break ;
            default:
                break;
        }
    }

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_ODDSHANDICAP ] object:nil];
}

- (void)Notify:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.tableView.tableFooterView= self.signlLabel ;
        _rowNumber = _dateCenter->GetOddsHandicapCount(self.type)<=0?0:_dateCenter->GetOddsHandicapCount(self.type) ;
         [self.tableView reloadData];

    });
    
    
}
@end


@implementation DPLiveOddsPositionSubCell

-(instancetype)initWithWidArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height{

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        self.itemView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:height  withWidth:kScreenWidth-10];
        self.itemView.numberOfLabLines = 2 ;
        self.itemView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        self.itemView.textColors = UIColorFromRGB(0x535353) ;
        [self.itemView createHeaderWithWidthArray:widArray whithHigh:height withSegIndexArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], nil]] ;
        [self.contentView addSubview:self.itemView];
        
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;
        
        
        UIImageView* imgView = [[UIImageView alloc]init];
        imgView.image = dp_ResultImage(@"arrow_right.png") ;
        [self.itemView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@12);
            
            make.centerY.equalTo(self.itemView);
            make.right.equalTo(self.itemView.mas_right).offset(-2);
        }] ;

        _noDataImgLabel  = [[DPImageLabel alloc]init];
        _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _noDataImgLabel.hidden = YES ;
        _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
        _noDataImgLabel.image = dp_SportLiveImage(@"noDdataImg.png") ;
        _noDataImgLabel.imagePosition = DPImagePositionTop ;
        _noDataImgLabel.text = @"暂无数据" ;
        _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        [self.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;
        

        
        
    }
    
    return self ;
}


@end

