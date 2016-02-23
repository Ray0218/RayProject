//
//  DPLiveBreakevenSubViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveBreakevenSubViewController.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPLiveDataCenterViews.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"

@interface DPLiveBreakevenSubViewController () {
@private
    CFootballCenter *_dateCenter;
    UILabel* _signlLabel ;
    NSInteger _rowNumber ;//行数

}
@property(nonatomic,strong,readonly)UILabel* signlLabel ;

@end

@implementation DPLiveBreakevenSubViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_PROFITANDLOSS] object:nil];
        
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
//        view.sectionOffset = -185;
        view.sectionOffset = -85;

        view;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_PROFITANDLOSS] object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.title = @"盈亏";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rowNumber = 0 ;
    self.tableView.tableFooterView= self.signlLabel ;

}

- (void)Notify:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _rowNumber = _dateCenter->GetBreakevenCount()<=0?0:_dateCenter->GetBreakevenCount() ;
        
//        if (_rowNumber == 0) {
//            self.tableView.tableFooterView= nil ;
//
//        }else
//            self.tableView.tableFooterView= self.signlLabel ;

        [self.tableView reloadData];
        
    }) ;}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_rowNumber <=0) {
        return 1 ;
    }
    return _rowNumber;
    
    

}
#define breakCEllTag 1111

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    static NSString *HeaderIdentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
        view.arrowView.hidden = YES;
        
        UILabel* lab =[[UILabel alloc]init];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont dp_systemFontOfSize:15];
        lab.textColor = [UIColor colorWithRed:0.57 green:0.5 blue:0.34 alpha:1];
        lab.text =  @"交易盈亏";
        [view.contentView addSubview:lab];
        lab.tag = breakCEllTag+3 ;
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.contentView);
            make.left.equalTo(view.contentView) ;
            make.right.equalTo(view.contentView) ;
            make.height.equalTo(@35);
        }];
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:YES withHigh:0 withWidth:0 ] ;
        
        headView.textColors = [UIColor colorWithRed:0.55 green:0.55 blue:0.54 alpha:1];
        headView.titleFont = [UIFont dp_systemFontOfSize:11];
        [headView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:75],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:75],nil] whithHigh:30 withSeg:NO];
        [headView setTitles:[NSArray arrayWithObjects:@"项目",@"成交额",@"赔率",@"比例",@"庄家盈亏", nil]];
        [view.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(view.contentView) ;
//            make.left.equalTo(view.contentView).offset(5) ;
//            make.right.equalTo(view.contentView).offset(-5) ;
//            make.height.equalTo(@30) ;
            
            make.bottom.equalTo(view) ;
            make.centerX.equalTo(view) ;
            make.width.equalTo(@310) ;
            make.height.equalTo(@30) ;
        }] ;
    }
    
       return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_rowNumber <=0) {
        return 150 ;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor] ;
        cell.contentView.backgroundColor = [UIColor clearColor] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
        headView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        headView.textColors = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
        headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:75],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:75],nil];
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
        [headView changeFontWithIndex:0 withFont:[UIFont dp_systemFontOfSize:12]] ;
        headView.backgroundColor =[UIColor dp_flatWhiteColor] ;
        
        headView.tag = breakCEllTag+1 ;
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
        _noDataImgLabel.tag = breakCEllTag+4 ;
        _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
        _noDataImgLabel.image = dp_SportLiveImage(@"noDdataImg.png") ;
        _noDataImgLabel.imagePosition = DPImagePositionTop ;
        _noDataImgLabel.text = @"暂无数据" ;
        _noDataImgLabel.backgroundColor =[UIColor dp_flatWhiteColor] ;
        [cell.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;


    }
    DPImageLabel* imgLabe = (DPImageLabel*)[cell.contentView viewWithTag:breakCEllTag+4] ;
    
    if (_rowNumber <=0) {
        imgLabe.hidden = NO ;
        return cell ;
    }else
        imgLabe.hidden = YES ;
    
    
    DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:breakCEllTag+1] ;
    
    string title, amount, odds, ratio, breakeven;
    _dateCenter->GetBreakevenItem(indexPath.row , title, amount, odds, ratio, breakeven);

   NSString* projecttext = [NSString stringWithUTF8String:title.c_str()];
    NSString* amounttext = [NSString stringWithUTF8String:amount.c_str()];
    NSString* oddstext = [NSString stringWithUTF8String:odds.c_str()];
    NSString* ratiotext = [[NSString stringWithUTF8String:ratio.c_str()] stringByAppendingString:@"%"];
    NSString* breakeventext = [NSString stringWithUTF8String:breakeven.c_str()];
    NSArray* titleArray = [NSArray arrayWithObjects:projecttext,amounttext,oddstext,ratiotext,breakeventext, nil] ;
    [cellView setTitles:titleArray];

    
    return cell;
}

@end

