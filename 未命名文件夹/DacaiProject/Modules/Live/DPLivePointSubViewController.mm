//
//  DPLivePointSubViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLivePointSubViewController.h"
#import "DPNoInsetOffsetTableView.h"
#import "DPLiveDataCenterViews.h"
#import "FrameWork.h"
#import "DPScoreLiveDefine.h"
#import "DPImageLabel.h"

@interface DPLivePointSubViewController () {
@private
    CFootballCenter *_dateCenter;
    UILabel* _signlLabel ;

    NSInteger _rowNumber ;//行数
    NSInteger _colorNumber ;//底部说明行数
}
@property(nonatomic,strong,readonly)UILabel* signlLabel ;

@end

@implementation DPLivePointSubViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notify:) name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_STANDINGS] object:nil];
        
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"kLiveDataNotifyName%d",FOOTBALLCENTER_STANDINGS] object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.title = @"积分";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rowNumber = 0 ;
    _colorNumber = 0 ;
    self.tableView.tableFooterView =self.signlLabel ;
}

- (void)Notify:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _rowNumber = _dateCenter->GetStandingsCount()<=0?0:_dateCenter->GetStandingsCount() ;
        
        vector<string> areaName;
        vector<int> areaColor;
        _dateCenter->GetStandingsAreas(areaName, areaColor);
        _colorNumber = areaName.size()>0?1:0 ;
        [self.tableView reloadData];
//        if (areaName.size() == 0) {
////            self.tableView.tableFooterView = nil;
//        } else {
//            CGFloat x = 0, y = 0;
//            CGFloat width = kScreenWidth - 10;
//            CGFloat height = 20;
//            CGFloat margin = 10;
//            UIView *view = [[UIView alloc] init];
//            for (int i = 0; i < areaName.size(); i++) {
//                DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
//                imageLabel.text = [NSString stringWithUTF8String:areaName[i].c_str()];
//                imageLabel.image = [[UIImage dp_imageWithColor:UIColorFromRGB(areaColor[i])] dp_resizedImageToSize:CGSizeMake(7, 7)];
//                imageLabel.imagePosition = DPImagePositionLeft;
//                imageLabel.font = [UIFont dp_systemFontOfSize:10];
//                imageLabel.spacing = 3;
//                if (x + imageLabel.dp_intrinsicWidth + margin > width) {
//                    x = 0;
//                    y += height;
//                }
//                
//                imageLabel.frame = CGRectMake(x, y, imageLabel.dp_intrinsicWidth + margin, height);
//                x += imageLabel.dp_width;
//                
//                [view addSubview:imageLabel];
//            }
//            view.frame = CGRectMake(5, 0, width, y + height + 5);
//            self.tableView.tableFooterView = view;
//        }
//        
//        [self.tableView reloadData];


    }) ;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(section == 1){
        return _colorNumber ;
    }
    if (_rowNumber<=0) {
        return 1 ;
    }
    return _rowNumber ;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *CellIdentifier = @"Cell";
//    DPLivePointRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[DPLivePointRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    if (indexPath.row == 0) {
//        cell.rankLabel.text  = @"排名";
//        cell.teamLabel.text  = @"球队";
//        cell.countLabel.text = @"已赛";
//        cell.winLabel.text   = @"胜";
//        cell.tieLabel.text   = @"平";
//        cell.loseLabel.text  = @"负";
//        cell.pointLabel.text = @"积分";
//        
//        cell.rankLabel.textColor  =
//        cell.teamLabel.textColor  =
//        cell.countLabel.textColor =
//        cell.winLabel.textColor   =
//        cell.tieLabel.textColor   =
//        cell.loseLabel.textColor  =
//        cell.pointLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
//    } else {
//        int orderNumber, total, win, tie, lose, point, color;
//        string teamName;
//        _dateCenter->GetStandingsItem(indexPath.row - 1, orderNumber, teamName, total, win, tie, lose, point, color);
//        
//        cell.rankView.backgroundColor = UIColorFromRGB(color);
//        cell.rankLabel.text  = [NSString stringWithFormat:@"%d", orderNumber];
//        cell.teamLabel.text  = [NSString stringWithUTF8String:teamName.c_str()];
//        cell.countLabel.text = [NSString stringWithFormat:@"%d", total];
//        cell.winLabel.text   = [NSString stringWithFormat:@"%d", win];
//        cell.tieLabel.text   = [NSString stringWithFormat:@"%d", tie];
//        cell.loseLabel.text  = [NSString stringWithFormat:@"%d", lose];
//        cell.pointLabel.text = [NSString stringWithFormat:@"%d", point];
//        
//        cell.rankLabel.textColor  =
//        cell.teamLabel.textColor  =
//        cell.countLabel.textColor =
//        cell.winLabel.textColor   =
//        cell.tieLabel.textColor   =
//        cell.loseLabel.textColor  =
//        cell.pointLabel.textColor = [UIColor dp_flatBlackColor];
//    }
//    
//    return cell;
//}

#define PointCellTag 999
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        static NSString *bottomCellIdentifer = @"bottomCellIdentifer" ;
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bottomCellIdentifer] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bottomCellIdentifer];
            cell.backgroundColor = [UIColor clearColor] ;
            cell.contentView.backgroundColor = [UIColor clearColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            
            MDHTMLLabel*lable = [[MDHTMLLabel alloc]init];
            lable.tag = PointCellTag+4 ;
            lable.backgroundColor = [UIColor clearColor] ;
            [cell.contentView addSubview:lable];
            
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 0)) ;
            }];
            
        }
        
        vector<string> areaName;
        vector<int> areaColor;
        _dateCenter->GetStandingsAreas(areaName, areaColor);
        
        MDHTMLLabel *labell = (MDHTMLLabel*)[cell.contentView viewWithTag:PointCellTag+4] ;
        NSMutableString * mutStr = [[NSMutableString alloc]initWithString:@""];
        for (int i=0; i<areaName.size(); i++) {
            NSString* str = [NSString stringWithFormat:@" <font size = 11 color=\"#%06x\">■</font><font size = 11 color=\"#535353\">%@</font> ",areaColor[i], [NSString stringWithUTF8String:areaName[i].c_str()]];
            [mutStr appendString:str];
        }
        
        labell.htmlText =mutStr ;
        
        return cell ;
    }
    
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor] ;
        cell.contentView.backgroundColor = [UIColor clearColor] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth-10];
        headView.textColors = [UIColor dp_flatBlackColor];
        headView.titleFont = [UIFont dp_systemFontOfSize:12] ;
        NSArray *arr =[NSArray arrayWithObjects:[NSNumber numberWithFloat:47], [NSNumber numberWithFloat:80],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:47],nil] ;
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
        headView.backgroundColor =[UIColor dp_flatWhiteColor] ;
        
        headView.tag = PointCellTag+1 ;
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
        _noDataImgLabel.tag = PointCellTag+3;
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
    
    DPImageLabel* imgLabe = (DPImageLabel*)[cell.contentView viewWithTag:PointCellTag+3] ;
    
        
    if (_rowNumber<=0) {
        imgLabe.hidden = NO ;
        return cell ;
    }else
        imgLabe.hidden = YES ;

    
     DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:PointCellTag+1] ;
   
    
        int orderNumber=0, total=0, win=0, tie=0, lose=0, point=0, color=0;
        string teamName;
        _dateCenter->GetStandingsItem(indexPath.row, orderNumber, teamName, total, win, tie, lose, point, color);
        
        cellView.backgroundColor = UIColorFromRGB(color);
        NSString* ranktext  = [NSString stringWithFormat:@"%d", orderNumber];
        NSString* teamtext  = [NSString stringWithUTF8String:teamName.c_str()];
        NSString* countLtext = [NSString stringWithFormat:@"%d", total];
        NSString* wintext   = [NSString stringWithFormat:@"%d", win];
        NSString* tietext   = [NSString stringWithFormat:@"%d", tie];
        NSString* losetext  = [NSString stringWithFormat:@"%d", lose];
        NSString* pointtext = [NSString stringWithFormat:@"%d", point];
    
    NSArray* titlesArr = [NSArray arrayWithObjects:ranktext,teamtext,countLtext,wintext,tietext,losetext,pointtext ,nil] ;
    [cellView setTitles:titlesArr];
    
    return cell;
}


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
        lab.tag = PointCellTag ;
        [view.contentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.contentView);
            make.left.equalTo(view.contentView) ;
            make.right.equalTo(view.contentView) ;
            make.height.equalTo(@35);
        }];
        
        DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:YES withHigh:0 withWidth:0 ] ;
        headView.backgroundColor = [UIColor dp_flatWhiteColor] ;

//        headView.text = @"";
//        headView.textAlignment = NSTextAlignmentCenter ;
//        headView.textColor = [UIColor colorWithRed:0.57 green:0.5 blue:0.34 alpha:1];
//        headView.font = [UIFont dp_systemFontOfSize:15];
        
        headView.tag = PointCellTag+2 ;
        headView.textColors = [UIColor colorWithRed:0.55 green:0.55 blue:0.54 alpha:1];
        headView.titleFont = [UIFont dp_systemFontOfSize:10];
        [headView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:47], [NSNumber numberWithFloat:80],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:34],[NSNumber numberWithFloat:47],nil] whithHigh:30 withSeg:NO];
        
        [view.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(view.contentView) ;
//            make.left.equalTo(view.contentView).offset(5) ;
//            make.right.equalTo(view.contentView).offset(-5) ;
//            make.height.equalTo(@30) ;

            
            make.top.equalTo(lab.mas_bottom) ;
            make.centerX.equalTo(view.contentView) ;
            make.width.equalTo(@310) ;
            make.height.equalTo(@30) ;
        }] ;

    }
    UILabel* lab = (UILabel*)[view.contentView viewWithTag:PointCellTag] ;
    string title;
    _dateCenter->GetStandingsTitle(title);
    lab.text = [NSString stringWithUTF8String:title.c_str()];
    DPLiveOddsHeaderView *headView = (DPLiveOddsHeaderView*)[view.contentView viewWithTag:PointCellTag+2] ;

    [headView setTitles:[NSArray arrayWithObjects:@"排名",@"球队",@"已赛",@"胜",@"平",@"负",@"积分", nil]];

    
    
//    if (_dateCenter->GetStandingsCount()<=0) {
//        headView.layer.borderColor = UIColorFromRGB(0xF4F3EF).CGColor ;
//
//        headView.backgroundColor = UIColorFromRGB(0xF4F3EF) ;
////        headView.text = kNoDataSignal ;
//    }else{
//    
//        headView.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor ;
//
//        [headView setTitles:[NSArray arrayWithObjects:@"排名",@"球队",@"已赛",@"胜",@"平",@"负",@"积分", nil]];
////        headView.text = @"" ;
//
//
//    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0 ;
    }
    return 35+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 20 ;
    }
    if (_rowNumber<=0) {
        return 150 ;
    }
    return 30;
}

@end

