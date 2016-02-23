//
//  DPLiveOddsPositionDetailVC.m
//  DacaiProject
//
//  Created by Ray on 14/12/16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveOddsPositionDetailVC.h"
#import "DPLiveDataCenterViews.h"
#import "FrameWork.h"
@interface DPLiveOddsPositionDetailVC ()<UITableViewDataSource,UITableViewDelegate,ModuleNotify>
{
    
    UITableView* _tableView ;
    UITableView* _infoTableView ;
    UIButton* _nameButton ;
    
    
    CFootballCenter *_dateCenter;
    CBasketballCenter*_basketDataCenter ;
    
    NSInteger _index ;//赔盘类型
  
    NSInteger _companyIdx ;
    
    vector<string> _company ;
    
    GameTypeId _gametype ;
    
    NSInteger _rowNumber ;//详情行数
    
    NSInteger _matchId ;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UITableView *infoTableView;
@property (nonatomic, strong, readonly) UIButton *nameButton;

@end

@implementation DPLiveOddsPositionDetailVC

- (instancetype)initWIthGameType:(GameTypeId)gameType withSelectIndex:(NSInteger)index companyIndx:(NSInteger)companyIndx withMatchId:(NSInteger)matchid
{
    self = [super init];
    if (self) {
        _index = index ;
        _companyIdx = companyIndx ;
        _gametype = gameType ;
        _matchId = matchid ;
        
        if (gameType == GameTypeLcNone) {
            _basketDataCenter = CFrameWork::GetInstance()->GetBasketballCenter();
            _basketDataCenter->SetDelegate(self) ;
        }else{
            _dateCenter = CFrameWork::GetInstance()->GetFootballCenter();
            _dateCenter->SetDelegate(self) ;
        }

    }
    return self;
}


-(void)viewDidLoad{
    
    [super viewDidLoad] ;
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.title = @"欧盘赔率";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nameButton];
    [self.view addSubview:self.infoTableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view) ;
        make.left.equalTo(self.view) ;
        make.width.equalTo(@80) ;
        make.bottom.equalTo(self.view) ;
    }] ;
    
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view) ;
        make.left.equalTo(self.tableView.mas_right).offset(5) ;
        make.right.equalTo(self.view).offset(-5) ;
        make.height.equalTo(@30) ;
    }] ;
    
    [ self.infoTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameButton.mas_bottom) ;
        make.left.equalTo(self.tableView.mas_right).offset(5) ;
        make.right.equalTo(self.view).offset(-5) ;
        make.bottom.equalTo(self.view) ;
    }] ;
    
    _rowNumber = 0 ;
    if (_gametype == GameTypeLcNone) {
        _basketDataCenter->Net_RefreshOdds(_matchId, _companyIdx, _index) ;
        _basketDataCenter->GetOddsCompanys(_index, _company) ;
    }else{
        [self showHUD] ;
        _dateCenter->Net_RefreshOdds(_matchId, _companyIdx, _index) ;
        _dateCenter->GetOddsCompanys(_index, _company) ;
    }

}

- (void)pvt_onBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)infoTableView {
    if (_infoTableView == nil) {
        _infoTableView = [[UITableView alloc] init];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.rowHeight = 30 ;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _infoTableView.showsVerticalScrollIndicator = NO ;
        _infoTableView.backgroundColor = [UIColor clearColor ] ;
        _infoTableView.bounces = NO ;
    }
    
    return _infoTableView;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;\
        _tableView.rowHeight = 30 ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.bounces = NO ;
        
    }
    
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.tableView) {
        if (_gametype == GameTypeLcNone) {
            return _basketDataCenter->GetOddsHandicapCount(_index) ;
        }
        return _dateCenter->GetOddsHandicapCount(_index) ;
    }else{
        if (_rowNumber<=0) {
            return 1 ;
        }
        return _rowNumber ;
    }
    
    return 0 ;
    
}

#define DetailTag 12345
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString* ReusableCell = @"ReusableCell" ;
        OddsPositionDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:ReusableCell] ;
        if (cell == nil) {
            cell = [[OddsPositionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCell];
        }
        
//        vector<string>companys ;
//        _dateCenter ->GetOddsCompanys(_index, companys) ;
        
        cell.nameLabel.text  = [NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:_company[indexPath.row].c_str()]]  ;//@"威廉希尔" ;
        return cell ;
    }else if(tableView == self.infoTableView){
        
        static NSString* ReusableInfoCell = @"ReusableInfoCell" ;
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ReusableInfoCell] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableInfoCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:230];
            headView.titleFont = [UIFont dp_systemFontOfSize:10] ;
            headView.numberOfLabLines = 2 ;
            
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil] ;
            
            if (_gametype == GameTypeLcNone && _index == 1) {
                arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:84], nil];
            }
//            if (_index == 1) {
//                arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:84], nil];
//            }else
//                arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil] ;
            
            
            [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
            
            headView.tag = DetailTag+1 ;
            [cell.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView) ;
                make.left.equalTo(cell.contentView) ;
                make.height.equalTo(@30);
                make.right.equalTo(cell.contentView);
            }];
            
            DPImageLabel*  _noDataImgLabel  = [[DPImageLabel alloc]init];
            _noDataImgLabel.tag = DetailTag+2 ;
            _noDataImgLabel.font = [UIFont dp_systemFontOfSize:13] ;
            _noDataImgLabel.hidden = YES ;
            _noDataImgLabel.textColor =UIColorFromRGB(0xe6e6e6) ;
            if (_gametype == GameTypeLcNone) {
                _noDataImgLabel.image = dp_SportLiveImage(@"baskBigNo.png") ;

            }else
                _noDataImgLabel.image = dp_SportLiveImage(@"noDdataImg.png") ;
            _noDataImgLabel.imagePosition = DPImagePositionTop ;
            _noDataImgLabel.text = @"暂无数据" ;
            _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsZero) ;
            }] ;

            
        }
        
        DPImageLabel*noDataImg = (DPImageLabel*)[cell.contentView viewWithTag:DetailTag+2] ;
        if (_rowNumber<=0) {
            noDataImg.hidden = NO ;
            return cell ;
        }else
            noDataImg.hidden = YES ;
        
        string odds[3],updateTime ;
        int trends[3]={0} ;
        
        if (_gametype == GameTypeLcNone) {
            _basketDataCenter->GetOddsDetailItem(_index, _companyIdx, indexPath.row, odds, trends, updateTime) ;
        }else{
            _dateCenter->GetOddsDetailItem(_index, _companyIdx, indexPath.row, odds, trends, updateTime) ;
        }
        DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:DetailTag+1] ;
        
        NSString* arrowStr1 = trends[0]>0?@"↑":trends[0]<0?@"↓":@"" ;
        NSString* arrowStr2 = trends[1]>0?@"↑":trends[1]<0?@"↓":@"" ;
        NSString* arrowStr3 = trends[2]>0?@"↑":trends[2]<0?@"↓":@"" ;
        
        NSString* strColor1 = trends[0]>0?@"#dc2804":trends[0]<0?@"#3456A4":@"#2F2F2F" ;
        NSString* strColor2 = trends[1]>0?@"#dc2804":trends[1]<0?@"#3456A4":@"#2F2F2F" ;
        NSString* strColor3 = trends[2]>0?@"#dc2804":trends[2]<0?@"#3456A4":@"#2F2F2F" ;
        
        
        NSString* firstStr= [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor1, [NSString stringWithUTF8String:odds[0].c_str()],arrowStr1];
        NSString *secondStr = [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor2, [NSString stringWithUTF8String:odds[1].c_str()],arrowStr2];
        NSString* thirdStr = [NSString stringWithFormat:@"<font size = 10 color=\"%@\">%@%@</font>",strColor3, [NSString stringWithUTF8String:odds[2].c_str()],arrowStr3];

        if (_index == 1 && _gametype == GameTypeLcNone) {
            [cellView setTitles:[NSArray arrayWithObjects:firstStr,secondStr,[NSString stringWithUTF8String:updateTime.c_str()], nil]];
        }else
            [cellView setTitles:[NSArray arrayWithObjects:firstStr,secondStr,thirdStr,[NSString stringWithUTF8String:updateTime.c_str()], nil]];

        
        
        if (indexPath.row%2 == 0) {
            cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff] ;
        }else{
            cellView.backgroundColor = [UIColor dp_colorFromRGB:0xf7f4ef] ;
        }
        
        return cell ;
        
        
    }
    
    return nil ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.infoTableView) {
        if (_rowNumber<=0) {
            return 150 ;
        }
    }
    
    return 30 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (tableView == self.tableView) {
        
        static NSString *HeaderReuse = @"HeaderReuse";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderReuse];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderReuse];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor dp_flatWhiteColor] ;
                view;
            });
            
            UILabel* label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor] ;
            label.font = [UIFont dp_systemFontOfSize:14] ;
            label.textAlignment = NSTextAlignmentCenter ;
            label.textColor = UIColorFromRGB(0xA5A3A2) ;
            label.text = @"公司名" ;
            
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view) ;
            }];
            
            UIView *lineView = ({
                UIView* view = [[UIView alloc]init] ;
                view.backgroundColor = UIColorFromRGB(0xDAD3C7) ;
                view ;
            });
            [view addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view) ;
                make.right.equalTo(view) ;
                make.bottom.equalTo(view) ;
                make.height.equalTo(@0.5) ;
            }];
            
            
            UIImageView * rightView = ({
                UIImageView* rview = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"live_normal.png")] ;
                rview.backgroundColor = [UIColor clearColor] ;
                rview ;
            }) ;
            
            [view addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view) ;
                make.right.equalTo(view) ;
                make.bottom.equalTo(view) ;
            }];
        }
        
        return view ;
    }else if (tableView == self.infoTableView) {
        
        static NSString *HeaderInfoReuse = @"HeaderInfoReuse";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderInfoReuse];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderInfoReuse];
          
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor dp_flatWhiteColor] ;
                view;
            });
        
            DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
            headView.textColors = UIColorFromRGB(0x7E7D7B) ;
            NSArray* titles ; // = [NSArray arrayWithObjects:@"胜",@"平",@"负",@"更新时间", nil];
            NSArray* widths ;//= [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];

            if(_gametype == GameTypeLcNone){

                if (_index == 1) {
                    titles = [NSArray arrayWithObjects:@"主胜",@"主负",@"更新时间", nil];
                    widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:84], nil];
                }else{
                    titles = [NSArray arrayWithObjects:@"客水",@"盘口",@"主水",@"更新时间", nil];
                    widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];
                }
            }else{
                titles = [NSArray arrayWithObjects:@"胜",@"平",@"负",@"更新时间", nil];
                widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];
            
            }
          
            
            [headView createHeaderWithWidthArray:widths whithHigh:30 withSeg:YES];
            [headView setTitles:titles];
            [view.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view) ;
                make.centerX.equalTo(view) ;
                make.width.equalTo(@230) ;
                make.height.equalTo(@30) ;
            }];
        }
        
        return view ;
        
    }
    
    
    return nil ;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.tableView) {
        _companyIdx = indexPath.row ;
        
        [_nameButton setTitle:[NSString stringWithUTF8String:_company[indexPath.row].c_str()]forState:UIControlStateNormal];
        
        int count=0 ;
        if(_gametype == GameTypeLcNone){
            count = _basketDataCenter->GetOddsDetailCount(_index, indexPath.row) ;
            if (count<=0) {
                [self showHUD];
                _basketDataCenter->Net_RefreshOdds(_matchId, indexPath.row, _index) ;
            }else{
                _rowNumber = _basketDataCenter->GetOddsDetailCount(_index, _companyIdx) ;
                [self.infoTableView reloadData];
            }
        }else{
            count =  _dateCenter->GetOddsDetailCount(_index, indexPath.row) ;
            if (count<=0) {
                [self showHUD];
                _dateCenter->Net_RefreshOdds(_matchId, indexPath.row, _index) ;
            }else
            {
                _rowNumber = _dateCenter->GetOddsDetailCount(_index, _companyIdx) ;
                [self.infoTableView reloadData];
            }
        
        }
        
    }
}

-(UIButton*)nameButton{
    
    if (_nameButton == nil) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _nameButton.backgroundColor = [UIColor clearColor] ;
        _nameButton.titleLabel.font = [UIFont dp_systemFontOfSize:15] ;
        [_nameButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal] ;
        [_nameButton setTitle:@" 公司名" forState:UIControlStateNormal];
        _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
        [_nameButton setImage:dp_SportLiveImage(@"live_spot.png") forState:UIControlStateNormal];
    }
    
    return _nameButton ;
}


- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
        
        [_nameButton setTitle:[NSString stringWithUTF8String:_company[_companyIdx].c_str()]forState:UIControlStateNormal];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_companyIdx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        
        if (_gametype == GameTypeLcNone) {
            _rowNumber =  _basketDataCenter->GetOddsDetailCount(_index, _companyIdx)<=0?0:_basketDataCenter->GetOddsDetailCount(_index, _companyIdx) ;
        }else
            _rowNumber = _dateCenter->GetOddsDetailCount(_index, _companyIdx)<=0?0:_dateCenter->GetOddsDetailCount(_index, _companyIdx) ;
        
        [self.infoTableView reloadData];

    }) ;
}

@end


@implementation OddsPositionDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectedBackgroundView = ({
            UIView* view = [[UIView alloc]init];
            view.backgroundColor = [UIColor clearColor] ;
            view ;
        }) ;
        
        
        [self buildUI];
        
    }
    return self;
}

-(void)buildUI{
    UIView* contentView = self.contentView ;
    
    UIImageView *lineView = ({
        UIImageView* view = [[UIImageView alloc]initWithImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xDAD3C7)]  highlightedImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xDAD3C7)]] ;
        view.backgroundColor = [UIColor clearColor] ;
        view ;
    });
    
    
    UIImageView * rightView = ({
        UIImageView* view = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"live_normal.png")  highlightedImage:dp_SportLiveImage(@"live_oddsSelected.png")] ;
        view.backgroundColor = [UIColor clearColor] ;
        view ;
    }) ;
    
    
    [contentView addSubview:lineView];
    [contentView addSubview:self.nameLabel];
    [contentView addSubview:rightView];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView) ;
        make.top.equalTo(contentView) ;
        make.right.equalTo(contentView).offset(-7) ;
        make.bottom.equalTo(contentView).offset(-0.5) ;
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView) ;
        make.top.equalTo(self.nameLabel.mas_bottom) ;
        make.right.equalTo(contentView).offset(-1) ;
        make.bottom.equalTo(contentView) ;
        
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView) ;
        make.top.equalTo(contentView) ;
        make.bottom.equalTo(contentView) ;
        make.width.equalTo(@7) ;
    }];
    
}

-(UILabel*)nameLabel{
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter ;
        _nameLabel.font = [UIFont dp_systemFontOfSize:11] ;
        _nameLabel.highlightedTextColor = [UIColor dp_flatRedColor] ;
        _nameLabel.textColor = [UIColor blackColor] ;
        _nameLabel.userInteractionEnabled = YES ;
    }
    
    return _nameLabel ;
}



@end

