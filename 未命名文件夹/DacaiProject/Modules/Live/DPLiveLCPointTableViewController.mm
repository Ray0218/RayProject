     //
//  DPLiveLCPointTableViewController.m
//  DacaiProject
//
//  Created by Ray on 14/12/8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveLCPointTableViewController.h"
#import "DPSegmentedControl.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPScoreLiveDefine.h"
#import "FrameWork.h"


@interface DPLiveLCPointTableViewController (){
@private
    
    CBasketballCenter *_dateCenter;
    UILabel* _signlLabel ;
    vector<string>titles ;
    NSInteger _rowNumber ;//行数

}

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,strong,readonly)UILabel* signlLabel ;


@end

@implementation DPLiveLCPointTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_SOCREBOARD] object:nil];
        
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
    
    self.type = 0 ;
    self.title = @"积分";
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
    if (_rowNumber<=0) {
        return 1 ;
    }
    return _rowNumber ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45+25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_rowNumber<=0) {
        return 150 ;
    }
    return 25 ;
}


#define PointLCTag 77777
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (titles.size()<=0) {
        static NSString *HeaderNodataIdentifier = @"HeaderNodataIdentifier";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderNodataIdentifier];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderNodataIdentifier];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromRGB(0xF4F3EF) ;
                view;
            });
        }

        return view ;
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
        NSMutableArray* titlesArr = [[NSMutableArray alloc]init];
        for (int i=0;i<titles.size();i++) {
            [titlesArr addObject:[NSString stringWithUTF8String:titles[i].c_str()]];
        }
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:titlesArr];

//        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[@"东部", @"西部"]];
        seg.tag = PointLCTag+1 ;
        seg.selectedIndex = self.type;
        [seg setTintColor:[UIColor colorWithRed:0.49 green:0.45 blue:0.32 alpha:1]];
        
        [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:seg];
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(7.5) ;
            make.width.equalTo(@140);
            make.height.equalTo(@30);
            make.centerX.equalTo(view);
        }];
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
        headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
        headView.textColors = [UIColor dp_colorFromRGB:0x817e7c] ;
        headView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:77.5],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:77.5], nil] ;
        [headView createHeaderWithWidthArray:arr whithHigh:25 withSeg:YES];
        
        headView.tag = 999 ;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(seg.mas_bottom).offset(7.5) ;
            make.left.equalTo(view).offset(5) ;
            make.height.equalTo(@25);
            make.right.equalTo(view).offset(-5);
        }];
        [headView setTitles:[NSArray arrayWithObjects:@"排名",@"球队",@"胜",@"负", @"胜率",@"近期状态",nil]];

    }
    
    
//    NSMutableArray* arr = [[NSMutableArray alloc]init];
//    for (int i=0;i<titles.size();i++) {
//        [arr addObject:[NSString stringWithUTF8String:titles[i].c_str()]];
//    }
//    [seg.containerView setItems:arr];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cell_Reuse = @"cell_Reuse" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse] ;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.contentView.backgroundColor = [UIColor clearColor] ;
        cell.backgroundColor = [UIColor clearColor] ;
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:25 withWidth:kScreenWidth-10];
        headView.textColors = UIColorFromRGB(0x535353) ;
        headView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:77.5],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:38.75],[NSNumber numberWithFloat:77.5], nil] ;
        [headView createHeaderWithWidthArray:arr whithHigh:25 withSeg:YES];
        headView.tag = PointLCTag+2 ;
        [cell.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView) ;
            make.left.equalTo(cell.contentView).offset(5) ;
            make.height.equalTo(@25);
            make.right.equalTo(cell.contentView).offset(-5);
        }];
        
       DPImageLabel* _noDataImgLabel  = [[DPImageLabel alloc]init];
        _noDataImgLabel.tag = PointLCTag+ 3 ;
        _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _noDataImgLabel.hidden = YES ;
        _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
        _noDataImgLabel.image = dp_SportLiveImage(@"baskBigNo.png") ;
        _noDataImgLabel.imagePosition = DPImagePositionTop ;
        _noDataImgLabel.text = @"暂无数据" ;
        _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        [cell.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;


    }
    
    DPImageLabel*noDataImg = (DPImageLabel*)[cell.contentView viewWithTag:PointLCTag+3] ;
    if (_rowNumber<=0) {
        noDataImg.hidden = NO ;
        return cell ;
    }else
        noDataImg.hidden = YES ;
    
    
    int order=0,win=0,loss=0,percentage=0;
    string teamName ,recentState;
    _dateCenter->GetScoreboardRecordItem(self.type, indexPath.row, order, teamName, win, loss, percentage, recentState) ;
    
    DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:PointLCTag+2] ;

    NSString* firstStr = [NSString stringWithFormat:@"%d",order] ;//[NSString stringWithFormat:@"%d",indexPath.row];
    
    NSString* secondColor= @"#535353" ;
    if ([[NSString stringWithUTF8String:teamName.c_str()] isEqualToString:g_homeName] ||[[NSString stringWithUTF8String:teamName.c_str()] isEqualToString:g_awayName]) {
        secondColor = @"#dc2804" ;
    }
    NSString* secondtStr =[NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@</font>",secondColor,[NSString stringWithUTF8String:teamName.c_str()]];
    
    [NSString stringWithUTF8String:teamName.c_str()] ;//[NSString stringWithFormat:@"莫火车头"];
    
    NSString* thirdStr =[NSString stringWithFormat:@"%d",win] ;// [NSString stringWithFormat:@"%d",arc4random()%20+1];
    NSString* fourStr =[NSString stringWithFormat:@"%d",loss] ;// [NSString stringWithFormat:@"%d",arc4random()%20+1];
    NSString* fivStr =[NSString stringWithFormat:@"%d%%",percentage] ;// [NSString stringWithFormat:@"%d%%",arc4random()%100+1];
    
    NSString* recentSta =[ NSString stringWithUTF8String:recentState.c_str()] ;
    NSString* colorStr = [recentSta hasSuffix:@"胜"]?@"#dc2804":@"#3456A4" ;
    NSString* sixStr =[NSString stringWithFormat:@"<font size = 11 color=\"%@\">%@</font>",colorStr,[NSString stringWithUTF8String:recentState.c_str()]];
    
    
    NSArray* titlesAray  =[NSArray arrayWithObjects: firstStr,secondtStr,thirdStr,fourStr,fivStr,sixStr, nil] ;
    
    [cellView setTitles:titlesAray];
    
    if (indexPath.row%2 == 0) {
        
        cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff] ;
    }else{
        cellView.backgroundColor = [UIColor dp_colorFromRGB:0xf7f4ef] ;
    }
    
    
    return cell ;
}


- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    if (self.type != seg.selectedIndex) {
        [self setType:(seg.selectedIndex)];
        _rowNumber = _dateCenter->GetScoreboardRecordCount(self.type) ;
        [self.tableView reloadData];
    }

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",BASKETBALL_SOCREBOARD] object:nil];
}

- (void)Notify:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _dateCenter->GetScoreboardTitles(titles) ;
        _rowNumber = _dateCenter->GetScoreboardRecordCount(self.type)<=0?0:_dateCenter->GetScoreboardRecordCount(self.type) ;
        [self.tableView reloadData];
        
//        if (titles.size()>0) {
//            self.tableView.tableFooterView= self.signlLabel ;
//        }else
//            self.tableView.tableFooterView= nil ;
    }) ;
    
   
    
    
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
