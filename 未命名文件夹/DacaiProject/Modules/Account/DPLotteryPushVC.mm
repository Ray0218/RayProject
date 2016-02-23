//
//  DPLotteryPushVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-30.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryPushVC.h"
#import "DPSetPushCell.h"
#import "FrameWork.h"
#import "NotifyType.h"
@interface DPLotteryPushVC () <UITableViewDelegate, UITableViewDataSource,DPSetPushCellDelegate> {
@private
    UITableView *_tableView;
    BOOL _isPushWInNumber;
    int _gameTypes[7];
    CLotteryCommon *_cloInstance;
    BOOL _isWinActive;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray, *imageArray;
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation DPLotteryPushVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cloInstance = CFrameWork::GetInstance()->GetLotteryCommon();
        _cloInstance->RefPushConfig();
        for (int i=0; i<7; i++) { 
             _gameTypes[i]=0;
        }
        _isWinActive=NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPushWInNumber = 1;
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.title = @"推送";
    self.view.backgroundColor = UIColorFromRGB(0xfaf9f2);

    self.titleArray = [NSMutableArray arrayWithObjects:
                                          [NSMutableArray arrayWithObjects:@"中奖提醒", @"比分直播推送", @"追号到期提醒", @"夜间免打扰模式", nil],
                                          [NSMutableArray arrayWithObjects:@"双色球", @"大乐透", @"3D", @"排列三", @"排列五", @"七星彩", @"七乐彩", nil],
                                          nil];
    self.imageArray = [NSMutableArray arrayWithObjects:
                                          [NSMutableArray arrayWithObjects:dp_AccountImage(@"push01.png"), dp_AccountImage(@"push02.png"), dp_AccountImage(@"push03.png"), dp_AccountImage(@"push04.png"), nil],
                                          [NSMutableArray arrayWithObjects:dp_ProjectImage(@"ssq.png"), dp_ProjectImage(@"dlt.png"), dp_ProjectImage(@"fucai3D.png"), dp_ProjectImage(@"pls.png"), dp_ProjectImage(@"plw.png"), dp_ProjectImage(@"qxc.png"), dp_ProjectImage(@"qlc.png"), nil],
                                          nil];
    self.infoArray = [[NSMutableArray alloc] initWithObjects:@"购买的彩种中奖后，第一时间通知", @"购买和关注的比赛将推送比赛实时赛果通知", @"追号方案到期后，第一时间通知", @"夜间23:00-8:00不会推送任何内容", nil];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onNavLeft)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
    _cloInstance->SetDelegate(self);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark--UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((section == 1) && (!_isPushWInNumber)) {
        return 0;
    }
    if (section==0) {
        return 1;
    }
    return [[self.titleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", indexPath.section];
    DPSetPushCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPSetPushCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate=self;
    }
    UIImage *image = [[self.imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.titleImageView.image = image;
    cell.topTitleLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
         cell.sevSwitch.on=_isWinActive;
        if (indexPath.row >= self.infoArray.count) {
            return cell;
        }
       
        cell.bottomTitleLabel.text = [self.infoArray objectAtIndex:indexPath.row];
        return cell;
    
    }
     cell.sevSwitch.on=_gameTypes[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView dp_viewWithColor:UIColorFromRGB(0xfaf9f2)];
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.backgroundColor = [UIColor clearColor];
    leftImageView.image = dp_AccountImage(@"push05.png");
    [view addSubview:leftImageView];

    UILabel *topLable = [[UILabel alloc] init];
    topLable.backgroundColor = [UIColor clearColor];
    topLable.text = @"开奖推送";
    topLable.textAlignment = NSTextAlignmentLeft;
    topLable.textColor = UIColorFromRGB(0x5f5c48);
    topLable.font = [UIFont dp_lightSystemFontOfSize:13];

//    UILabel *bottomLabel = [[UILabel alloc] init];
//    bottomLabel.backgroundColor = [UIColor clearColor];
//    bottomLabel.text = @"夜间23:00-8:00不会推送任何消息";
//    bottomLabel.textAlignment = NSTextAlignmentLeft;
//    bottomLabel.textColor = UIColorFromRGB(0xbbb19e);
//    bottomLabel.font = [UIFont dp_lightSystemFontOfSize:11];

    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:_isPushWInNumber ? dp_CommonImage(@"black_arrow_up.png") : dp_CommonImage(@"black_arrow_down.png")];
    rightImageView.backgroundColor = [UIColor clearColor];

    UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xe4e0d7)];
    [view addSubview:leftImageView];
    [view addSubview:rightImageView];
    [view addSubview:topLable];
//    [view addSubview:bottomLabel];
    [view addSubview:lineView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@24);
        make.centerY.equalTo(view);
        make.height.equalTo(@24);
    }];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.centerY.equalTo(view);
    }];
    [topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(8);
        make.right.equalTo(view).offset(-70);
        make.top.equalTo(view).offset(5);
        make.bottom.equalTo(view).offset(-5);
    }];
//    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(topLable);
//        make.right.equalTo(topLable);
//        make.top.equalTo(topLable.mas_bottom).offset(-3);
//        make.height.equalTo(@20);
//    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];
    return view;
}

- (void)pvt_onNavLeft {
    vector<int> lotteryType;
    for (int i=0; i<7; i++) {
//        int count=0;
        if (_gameTypes[i]==1) {
            lotteryType.push_back([self gameTypeNumber:i]);
//            count=count+1;
        }
    }
    _cloInstance->SetPushConfig(lotteryType, _isWinActive);
    [self.navigationController popViewControllerAnimated:YES];
   
}
-(int)gameTypeNumber:(int)number{
    int lotteryType=0;
    switch (number) {
        case 0:
            lotteryType=GameTypeSsq;
            break;
        case 1:
             lotteryType=GameTypeDlt;
            break;
        case 2:
             lotteryType=GameTypeSd;
            break;
        case 3:
             lotteryType=GameTypePs;
            break;
        case 4:
             lotteryType=GameTypePw;
            break;
        case 5:
             lotteryType=GameTypeQxc;
            break;
        case 6:
             lotteryType=GameTypeQlc;
            break;
        default:
            break;
    }
    return lotteryType;
 
}
-(int)gameTyeIndex:(int )gameType{
    int lotteryType=0;
    switch (gameType) {
        case GameTypeSsq:
            lotteryType=0;
            break;
        case GameTypeDlt:
            lotteryType=1;
            break;
        case GameTypeSd:
            lotteryType=2;
            break;
        case GameTypePs:
            lotteryType=3;
            break;
        case GameTypePw:
            lotteryType=4;
            break;
        case GameTypeQxc:
            lotteryType=5;
            break;
        case GameTypeQlc:
            lotteryType=6;
            break;
        default:
            break;
    }
    return lotteryType;
}
- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    _isPushWInNumber = !_isPushWInNumber;
    [self.tableView reloadData];
}
#pragma make - getter, setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(void)pushViewSwitchClick:(DPSetPushCell *)cell{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    if (indexPath.section==0) {
        _isWinActive=cell.sevSwitch.on;
        return;
    }
    _gameTypes[indexPath.row]=cell.sevSwitch.on;
}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        // 解析数据
        switch (cmdtype) {
            case GET_PUSH_CONFIG:
            {
                if (ret<0) {
                    return ;
                }
                vector<int> gameTypes;
                bool winActive;
                _cloInstance->GetPushConfig(gameTypes, winActive);
                _isWinActive=winActive;
                for (int i=0; i<gameTypes.size(); i++) {
                    int gameIndex=[self gameTyeIndex:gameTypes[i]];
                    _gameTypes[gameIndex]=YES;
                }
                [self.tableView reloadData];
            }
                break;
            case SET_PUSH_CONFIG:
            {
                
            }
                break;
            default:
                break;
        }
       
        
    });
}

@end
