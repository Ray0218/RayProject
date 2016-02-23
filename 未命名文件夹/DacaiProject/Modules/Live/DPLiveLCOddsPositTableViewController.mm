//
//  DPLiveLCOddsPositTableViewController.m
//  DacaiProject
//
//  Created by Ray on 14/12/8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveLCOddsPositTableViewController.h"
#import "DPSegmentedControl.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPScoreLiveDefine.h"
#import "FrameWork.h"
#import "DPLiveOddsPositionDetailVC.h"

@interface DPLiveLCOddsPositTableViewController (){
@private
    
    CBasketballCenter *_dateCenter;
    UILabel* _signlLabel ;
    NSInteger _rowNumber ; //行数

}

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,strong,readonly)UILabel* signlLabel ;


@end

@implementation DPLiveLCOddsPositTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_ODDSHANDICAP ] object:nil];
        
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_rowNumber <=0) {
        return 1 ;
    }
    return _rowNumber ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45+30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_rowNumber<=0) {
        return 150 ;
    }
    return 30 ;
}

#define OddsTag 99999
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(self.type == 1){
    
        static NSString *WinIdentifier = @"WinIdentifier";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WinIdentifier];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:WinIdentifier];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromRGB(0xF4F3EF) ;
                view;
            });
            DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[@"胜负", @"让分", @"大小"]];
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
            
            NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:102],[NSNumber numberWithFloat:104], nil] ;
            [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
            
            headView.tag = OddsTag+1 ;
            [view addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(seg.mas_bottom).offset(7.5) ;
                make.left.equalTo(view).offset(5) ;
                make.height.equalTo(@30);
                make.right.equalTo(view).offset(-5);
            }];
            
        }
        DPLiveOddsHeaderView* headView = (DPLiveOddsHeaderView*)[view viewWithTag:OddsTag+1] ;
        [headView setTitles:[NSArray arrayWithObjects:@"公司名",@"主负", @"主胜",nil]];
        
        return view;


    
    }
    
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
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[@"胜负", @"让分", @"大小"]];
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
        
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:102],[NSNumber numberWithFloat:68],[NSNumber numberWithFloat:68],[NSNumber numberWithFloat:72], nil] ;
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
        
        headView.tag = OddsTag+2 ;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(seg.mas_bottom).offset(7.5) ;
            make.left.equalTo(view).offset(5) ;
            make.height.equalTo(@30);
            make.right.equalTo(view).offset(-5);
        }];
        
    }
//主负  主胜
    //
    DPLiveOddsHeaderView* headView = (DPLiveOddsHeaderView*)[view viewWithTag:OddsTag+2] ;
    [headView setTitles:[NSArray arrayWithObjects:@"公司名",@"客水", @"盘口",@"主水",nil]];
    
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 1) {
        static NSString* cellWin_Reuse = @"cellWin_Reuse" ;
        DPLiveOddsPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWin_Reuse] ;
        if (cell == nil) {
            NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:104],[NSNumber numberWithFloat:102],[NSNumber numberWithFloat:104], nil] ;
            cell = [[DPLiveOddsPositionCell alloc]initWithItemWithArray:arr reuseIdentifier:cellWin_Reuse withHigh:30];
            cell.cellView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        }
        
        if (_rowNumber<=0) {
            cell.noDataImgLabel.hidden = NO ;
            return cell ;
        }else
            cell.noDataImgLabel.hidden = YES ;
        
        string company,odds[3]; int trends[3]={0};
        _dateCenter->GetOddsHandicapItem(self.type, indexPath.row, company, odds, trends) ;
        
        NSString* arrowStr1 = trends[0]>0?@"↑":trends[0]<0?@"↓":@"" ;
        NSString* arrowStr2 = trends[1]>0?@"↑":trends[1]<0?@"↓":@"" ;
        
        NSString* strColor1 = trends[0]>0?@"#e7161a":trends[0]<0?@"#3456A4":@"#2F2F2F" ;
        NSString* strColor2 = trends[1]>0?@"#e7161a":trends[1]<0?@"#3456A4":@"#2F2F2F" ;
        
        NSString* firstStr = [NSString stringWithFormat:@"<font size = 11 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:company.c_str()]];
        NSString* secondtStr = [NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@%@</font>",strColor1,[NSString stringWithUTF8String:odds[0].c_str()],arrowStr1];
        NSString* thirdStr = [NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@%@</font>",strColor2,[NSString stringWithUTF8String:odds[1].c_str()],arrowStr2];
        
        NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondtStr,thirdStr, nil] ;
        
        [cell.cellView setTitles:titlesAray];
        
        if (indexPath.row%2 == 0) {
            cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff] ;
        }else
            cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xf7f4ef] ;
        
        
        return cell ;

    }
    
    static NSString* cell_Reuse = @"cell_Reuse" ;
    DPLiveOddsPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse] ;
    if (cell == nil) {
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:102],[NSNumber numberWithFloat:68],[NSNumber numberWithFloat:68],[NSNumber numberWithFloat:72], nil] ;
        cell = [[DPLiveOddsPositionCell alloc]initWithItemWithArray:arr reuseIdentifier:cell_Reuse withHigh:30];
        cell.cellView.titleFont = [UIFont dp_systemFontOfSize:11] ;
    }
    
    if (_rowNumber<=0) {
        cell.noDataImgLabel.hidden = NO ;
        return cell ;
    }else
        cell.noDataImgLabel.hidden = YES ;
    
    string company,odds[3]; int trends[3]={0};
    _dateCenter->GetOddsHandicapItem(self.type, indexPath.row, company, odds, trends) ;
    
    NSString* arrowStr1 = trends[0]>0?@"↑":trends[0]<0?@"↓":@"" ;
    NSString* arrowStr2 = trends[1]>0?@"↑":trends[1]<0?@"↓":@"" ;
    NSString* arrowStr3 = trends[2]>0?@"↑":trends[2]<0?@"↓":@"" ;
    
    NSString* strColor1 = trends[0]>0?@"#e7161a":trends[0]<0?@"#3456A4":@"#2F2F2F" ;
    NSString* strColor2 = trends[1]>0?@"#e7161a":trends[1]<0?@"#3456A4":@"#2F2F2F" ;
    NSString* strColor3 = trends[2]>0?@"#e7161a":trends[2]<0?@"#3456A4":@"#2F2F2F" ;
    
    NSString* firstStr = [NSString stringWithFormat:@"<font size = 11 color=\"#535353\">%@</font>",[NSString stringWithUTF8String:company.c_str()]];
    NSString* secondtStr = [NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@%@</font>",strColor1,[NSString stringWithUTF8String:odds[0].c_str()],arrowStr1];
    NSString* thirdStr = [NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@%@</font>",strColor2,[NSString stringWithUTF8String:odds[1].c_str()],arrowStr2];

    NSString* fourStr = [NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@%@</font>",strColor3,[NSString stringWithUTF8String:odds[2].c_str()],arrowStr3];
    NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondtStr,thirdStr,fourStr, nil] ;
    
    [cell.cellView setTitles:titlesAray];
    
    if (indexPath.row%2 == 0) {
        cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff] ;
    }else
        cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xf7f4ef] ;
    
    
    
    return cell ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DPLiveOddsPositionDetailVC * vc =[[DPLiveOddsPositionDetailVC alloc]initWIthGameType:GameTypeLcNone withSelectIndex:self.type companyIndx:indexPath.row withMatchId:g_matchId];
//    vc.defaultIndexPath = indexPath ;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    
    if (self.type != seg.selectedIndex+1) {
        [self setType:(seg.selectedIndex+1)];
        _rowNumber =  _dateCenter->GetOddsHandicapCount(self.type) ;
        [self.tableView reloadData];
    }

    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_ODDSHANDICAP ] object:nil];
}

- (void)Notify:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _rowNumber =  _dateCenter->GetOddsHandicapCount(self.type)<=0?0:_dateCenter->GetOddsHandicapCount(self.type) ;
        [self.tableView reloadData];
//        self.tableView.tableFooterView= self.signlLabel ;
    }) ;
    
//    vector<string> areaName;
//    vector<int> areaColor;
//    _dateCenter->GetStandingsAreas(areaName, areaColor);
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation DPLiveOddsPositionCell

-(instancetype)initWithItemWithArray:(NSArray*)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height{
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        self.cellView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:height withWidth:kScreenWidth-10];
        self.cellView.numberOfLabLines = 2 ;
        
        self.cellView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        self.cellView.textColors = UIColorFromRGB(0x535353) ;
        [self.cellView createHeaderWithWidthArray:widthArray whithHigh:height withSeg:YES] ;
        [self.contentView addSubview:self.cellView];
        
        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;
        
        
        UIImageView* imgView = [[UIImageView alloc]init];
        imgView.image = dp_ResultImage(@"arrow_right.png") ;
        
        [self.cellView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@12);
            
            make.centerY.equalTo(self.cellView);
            make.right.equalTo(self.cellView.mas_right).offset(-2);
        }] ;
        
        
        _noDataImgLabel  = [[DPImageLabel alloc]init];
        _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _noDataImgLabel.hidden = YES ;
        _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
        _noDataImgLabel.image = dp_SportLiveImage(@"baskBigNo.png") ;
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

