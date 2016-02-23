//
//  DPAcountPacketController.m
//  红包页面
//
//  Created by jacknathan on 14-9-11.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import "DPAcountPacketController.h"
#import "DPPacketTableViewCell.h"
#import "FrameWork.h"
#import "Account.h"
#import "ModuleNotify.h"
#import "NSObject+DPAdditions.h"
#import "DPWebViewController.h"
#define kTapBarIndicatorLineHeight 2.8
#define kTapBarIndicatorWidthScale 0.5
#define kAnimationTime             0.3f


@protocol DPAcountPacketTabBarDelegate <NSObject>

- (void)tapBarItemChangedToTag:(int)tag;

@end

@interface DPAcountPacketTabBar : UIView

@property(weak, nonatomic)id <DPAcountPacketTabBarDelegate> delegate;

//tabBarItem变换选中状态
- (void)selectedItemChangeTo:(int)tag isDelegateSend:(BOOL)isDelegate;
@end

@interface DPAcountPacketTabBar ()
{
    UIButton        *_selectedBtn; // 被选中按钮
    UIView          *_indicatorLine; // 指示下划线
    NSArray         *_tabBarItems; // 按钮组
}

@end

@implementation DPAcountPacketTabBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return self;
}
- (void)buildUIWithDefaultIndex:(int)index
{
    UIButton *usefulBtn = [self tabButtonWithTitle:@"可使用" tag:0];
    UIButton *sendingBtn = [self tabButtonWithTitle:@"派发中" tag:1];
    UIButton *overdueBtn = [self tabButtonWithTitle:@"已用完/过期" tag:2];
    UIView *indicatorLine = [[UIView alloc]init];
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#d6d2cd"];
    indicatorLine.backgroundColor = [UIColor dp_colorFromHexString:@"#be0201"];
    
    [self addSubview:usefulBtn];
    [self addSubview:sendingBtn];
    [self addSubview:overdueBtn];
    [self addSubview:indicatorLine];
    [self addSubview:bottomLine];
    
    _indicatorLine = indicatorLine;
    _tabBarItems = @[usefulBtn, sendingBtn, overdueBtn];
    
//    CGFloat width = self.bounds.size.width / 3;
    NSNumber *width = [NSNumber numberWithFloat:kScreenWidth / 3.0f];
    [usefulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(width);
//        make.width.equalTo(sendingBtn);
//        make.width.equalTo(overdueBtn);
    }];
    
    [sendingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(usefulBtn.mas_right);
        make.bottom.equalTo(self);
        make.width.equalTo(width);
    }];
    
    [overdueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(sendingBtn.mas_right);
//        make.height.equalTo(usefulBtn);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@kTapBarIndicatorLineHeight);
        make.width.equalTo(usefulBtn.titleLabel);
        make.centerX.equalTo(usefulBtn);
    }];
    
    [bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    UIButton *defaultButton = (id)[self viewWithTag:index];
    [self tapBarItemClick:defaultButton]; // 默认选中按钮
}
#pragma mark 按钮初始化
- (UIButton *)tabButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_colorFromHexString:@"#1a1a1a"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_colorFromHexString:@"#be0201"] forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:14];
    btn.tag = tag;
    [btn addTarget:self action:@selector(tapBarItemClick:) forControlEvents:UIControlEventTouchDown];
    
    return btn;
}

#pragma mark - tabBarItem点击事件
- (void)tapBarItemClick:(UIButton *)sender
{
    [self selectedItemChangeTo:sender.tag isDelegateSend:NO];
}

#pragma mark tabBarItem变换选中状态
- (void)selectedItemChangeTo:(int)tag isDelegateSend:(BOOL)isDelegate
{
    CGFloat animationTime = isDelegate ? 0 : kAnimationTime;
    
    UIButton *sender;
    if (_tabBarItems.count > 0) {
        sender = _tabBarItems[tag];
    }
    if (_selectedBtn == sender) {
        // 重复点击
        return;
    }
    if (_selectedBtn == nil) {
        // 初始化选择
        _selectedBtn = sender;
        animationTime = 0; // 初始化的时候，不能加动画，加了动画下面页面layout刷新时候就像有出场动画
        
    }else{
        _selectedBtn.selected = NO;
        sender.selected = YES;
        _selectedBtn = sender;
    }
    sender.selected = YES;
    
    

    [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@kTapBarIndicatorLineHeight);
        make.width.equalTo(sender.titleLabel);
        make.centerX.equalTo(sender);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    
    [UIView animateWithDuration:animationTime animations:^{
        [self layoutIfNeeded];
    }];
    
    if (!isDelegate) {
        if ([self.delegate respondsToSelector:@selector(tapBarItemChangedToTag:)]) {
            
            [self.delegate tapBarItemChangedToTag:sender.tag];
        }
    }

}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kTapBarHeight 30
#define kTableViewTagStart 100
#define ktableViewRowHeight 60

static const NSString * USEFUL_TABLE_KEY =      @"usefullTableKey";
static const NSString * SENDING_TABLE_KEY =     @"sendingTableKey";
static const NSString * TERMINATE_TABLE_KEY =   @"terminateTableKey";
@interface DPAcountPacketController () <DPAcountPacketTabBarDelegate,UITableViewDataSource, UITableViewDelegate, ModuleNotify>
{
    @private
    DPAcountPacketTabBar        *_tabBar;
    UIScrollView                *_scrollView;
    NSArray                     *_dataArray; // 假数据
    CAccount                    *_accountCenter;
    UITableView                 *_usefulTable;
    UITableView                 *_sendingTable;
    UITableView                 *_terminate;
    CGPoint                     _offsetTag;
    UIView                      *_noDataView_left; // 无数据提示视图
    UIView                      *_noDataView_middle; // 无数据提示视图
    UIView                      *_noDataView_right; // 无数据提示视图
}
@property (nonatomic, strong, readonly)UIView *noDataView_left;
@property (nonatomic, strong, readonly)UIView *noDataView_middle;
@property (nonatomic, strong, readonly)UIView *noDataView_right;
@end

@implementation DPAcountPacketController
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        _defaultIndex = 0;
//        _accountCenter = CFrameWork::GetInstance() -> GetAccount();
//        _accountCenter -> RefreshActRedPacket();
//        _accountCenter -> SetDelegate(self);
//        [self showHUD];
//    }
//    return self;
//}
- (instancetype)init
{
    if (self = [super init]) {
        _defaultIndex = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accountCenter = CFrameWork::GetInstance() -> GetAccount();
    _accountCenter -> RefreshActRedPacket();
    _accountCenter -> SetDelegate(self);
    [self showHUD];
    
    self.title = @"红包";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navBackItemClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"提示.png") target:self action:@selector(navRightItemClick)];
    _offsetTag = CGPointZero;
    
    [self buildLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _accountCenter->SetDelegate(self);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _scrollView.contentOffset = CGPointZero;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    _offsetTag = _scrollView.contentOffset;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_offsetTag.x != 0) {
        _scrollView.contentOffset = _offsetTag;
        _offsetTag = CGPointZero;
    }
//    _scrollView.contentOffset = _offsetTag;
}
- (void)buildLayout
{
    DPAcountPacketTabBar *tabBar = [[DPAcountPacketTabBar alloc]init];
    [tabBar buildUIWithDefaultIndex:self.defaultIndex];
    tabBar.delegate = self;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor dp_colorFromHexString:@"#F4F3EF"];

    [self.view addSubview:tabBar];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    _tabBar = tabBar;
    
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@kTapBarHeight);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    // 3个tableView
    UITableView *leftTable = [self createTableViewWithTag:0 + kTableViewTagStart];
    UITableView *middleTable = [self createTableViewWithTag:1 + kTableViewTagStart];
    UITableView *rightTable = [self createTableViewWithTag:2 + kTableViewTagStart];
    

    [scrollView addSubview:self.noDataView_left];
    [scrollView addSubview:self.noDataView_middle];
    [scrollView addSubview:self.noDataView_right];
    self.noDataView_left.hidden = YES;
    self.noDataView_middle.hidden = YES;
    self.noDataView_right.hidden = YES;
    
    [scrollView addSubview:leftTable];
    [scrollView addSubview:middleTable];
    [scrollView addSubview:rightTable];
    
    [leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    [middleTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(leftTable.mas_right);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    [rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(middleTable.mas_right);
        make.right.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    [self.noDataView_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftTable);
        make.top.equalTo(leftTable).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@180);
    }];
    
    [self.noDataView_middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleTable);
        make.top.equalTo(middleTable).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@180);
    }];
    
    [self.noDataView_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightTable);
        make.top.equalTo(rightTable).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@180);
    }];

    [_scrollView dp_setStrongObject:leftTable forKey:USEFUL_TABLE_KEY];
    [_scrollView dp_setStrongObject:middleTable forKey:SENDING_TABLE_KEY];
    [_scrollView dp_setStrongObject:rightTable forKey:TERMINATE_TABLE_KEY];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)createTableViewWithTag:(int)tag
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = tag;
    tableView.rowHeight = ktableViewRowHeight;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        view;
    });

    return tableView;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UITableView *usefulTable = [_scrollView dp_strongObjectForKey:USEFUL_TABLE_KEY];
    UITableView *sendingTabel = [_scrollView dp_strongObjectForKey:SENDING_TABLE_KEY];
    UITableView *terminateTable = [_scrollView dp_strongObjectForKey:TERMINATE_TABLE_KEY];
    int rows;
    if (tableView == usefulTable) {
       rows = _accountCenter -> GetRedPacketUseableCount();
        if (rows > 0) {
            self.noDataView_left.hidden = YES;
        }
        return rows;
    }else if (tableView == sendingTabel){
        rows = _accountCenter -> GetRedPacketSendingCount();
        if (rows > 0) {
            self.noDataView_middle.hidden = YES;
        }
        return rows;
    }else if (tableView == terminateTable){
        rows = _accountCenter -> GetRedPacketTerminateCount();
        if (rows > 0) {
            self.noDataView_left.hidden = YES;
        }
        return rows;
    }
    
    return 0;
}

- (DPPacketTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    DPRedPacketData *cellData = [[DPRedPacketData alloc]init];

    int amount=0, currAmt=0;
    string name, desc, date, status;
    if (tableView.tag == kTableViewTagStart + 0) {
        _accountCenter -> GetRedPacketUseableTarget(indexPath.row, amount, currAmt, name, desc, date);
        cellData.packetType = kPacketUsefulType;
    }else if (tableView.tag == kTableViewTagStart + 1){
        _accountCenter -> GetRedPacketSendingTarget(indexPath.row, amount, name, desc, date);
        cellData.packetType = kPacketSendingType;
    }else if (tableView.tag == kTableViewTagStart + 2){
        _accountCenter -> GetRedPacketTerminateTarget(indexPath.row, amount, name, desc, status);
        cellData.packetType = kPacketOverdue;
    }
    
    cellData.packetTitle = [NSString stringWithUTF8String:name.c_str()];
    cellData.packetSubTitle = [NSString stringWithUTF8String:desc.c_str()];
    cellData.packetNumber = amount;
    cellData.leftMoney = currAmt;
    cellData.closingDate = [NSString stringWithUTF8String:date.c_str()];
    cellData.packetState = [NSString stringWithUTF8String:status.c_str()];
    cellData.sendingTime = [NSString stringWithUTF8String:date.c_str()];
    
    DPPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[DPPacketTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.packetData = cellData;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSLog(@"selected");
}
#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [_tabBar selectedItemChangeTo:page isDelegateSend:YES];
    }
    
}

#pragma mark - tabBar代理方法
- (void)tapBarItemChangedToTag:(int)tag
{
    CGFloat offsetX = CGRectGetWidth(_scrollView.bounds) * tag;
    _scrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - navBarItem点击
- (void)navBackItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navRightItemClick
{
    DPWebViewController *web = [[DPWebViewController alloc]init];
    web.title = @"红包说明";
    web.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kHongbaoIntroduceURL]];
    
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - 数据加载代理
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    UITableView *usefulTable = [_scrollView dp_strongObjectForKey:USEFUL_TABLE_KEY];
    UITableView *sendingTabel = [_scrollView dp_strongObjectForKey:SENDING_TABLE_KEY];
    UITableView *terminateTable = [_scrollView dp_strongObjectForKey:TERMINATE_TABLE_KEY];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ret < 0) {
            NSString *errorString = @"";
            if (ret <= -800) {
                errorString = [DPErrorParser AccountErrorMsg:ret];
            } else {
                errorString = [DPErrorParser CommonErrorMsg:ret];
            }
            [[DPToast makeText:errorString] show];
            return;
        }
        [usefulTable reloadData];
        [sendingTabel reloadData];
        [terminateTable reloadData];
        [self dismissHUD];
        _scrollView.contentOffset = CGPointMake(self.defaultIndex * 320, 0);
        self.noDataView_left.hidden = [usefulTable numberOfRowsInSection:0];
        self.noDataView_middle.hidden = [sendingTabel numberOfRowsInSection:0];
        self.noDataView_right.hidden = [terminateTable numberOfRowsInSection:0];
    });
}
- (UIView *)noDataView_left
{
    if (_noDataView_left == nil) {
        _noDataView_left = [[UIView alloc]init];
        _noDataView_left.backgroundColor = [UIColor clearColor];
        _noDataView_left.userInteractionEnabled = NO;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"noDataFace.png")];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.textColor = [UIColor dp_colorFromHexString:@"#a19e7d"];
        label.text = @"您暂时没有可用的红包";
        label.numberOfLines = 1;
        [_noDataView_left addSubview:label];
        [_noDataView_left addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView_left);
            make.centerY.equalTo(_noDataView_left);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(_noDataView_left);
        }];
        
    }
    
    return _noDataView_left;
}

- (UIView *)noDataView_middle
{
    if (_noDataView_middle == nil) {
        _noDataView_middle = [[UIView alloc]init];
        _noDataView_middle.backgroundColor = [UIColor clearColor];
        _noDataView_middle.userInteractionEnabled = NO;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"noDataFace.png")];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.textColor = [UIColor dp_colorFromHexString:@"#a19e7d"];
        label.text = @"暂无红包数据";
        label.numberOfLines = 1;
        [_noDataView_middle addSubview:label];
        [_noDataView_middle addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView_middle);
            make.centerY.equalTo(_noDataView_middle);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(_noDataView_middle);
        }];
        
    }
    
    return _noDataView_middle;
}
- (UIView *)noDataView_right
{
    if (_noDataView_right == nil) {
        _noDataView_right = [[UIView alloc]init];
        _noDataView_right.backgroundColor = [UIColor clearColor];
        _noDataView_right.userInteractionEnabled = NO;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"noDataFace.png")];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.textColor = [UIColor dp_colorFromHexString:@"#a19e7d"];
        label.text = @"暂无红包数据";
        label.numberOfLines = 1;
        [_noDataView_right addSubview:label];
        [_noDataView_right addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView_right);
            make.centerY.equalTo(_noDataView_right);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(_noDataView_right);
        }];
        
    }
    
    return _noDataView_right;
}
- (void)dealloc
{
    _accountCenter -> ClearActRedPacket();
}
@end
