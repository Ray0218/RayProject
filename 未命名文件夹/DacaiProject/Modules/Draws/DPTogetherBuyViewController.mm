//
//  DPTogetherBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "../../Common/Component/DPCollapseTableView/DPCollapseTableView.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "../../Common/Utilities/DPVerifyUtilities.h"
#import "DPTogetherBuyViewController.h"
#import "DPNavigationTitleButton.h"
#import "DPTogetherBuyViews.h"
#import "DPKeyboardCenter.h"
#import "DPImageLabel.h"
#import "FrameWork.h"
#import "DPNavigationMenu.h"
#import "DPAccountViewControllers.h"
#import "DPRedPacketViewController.h"
#import "DPProjectDetailVC.h"

#define kSearchBarHeight    40.0f

const static NSString *DPTogetherBuyTabBarItemKey1      = @"DPTogetherBuyTabBarItemKey1";
const static NSString *DPTogetherBuyTabBarItemKey2      = @"DPTogetherBuyTabBarItemKey2";
const static NSString *DPTogetherBuyTabBarItemKey3      = @"DPTogetherBuyTabBarItemKey3";
const static NSString *DPTogetherBuyTabBarIndicateKey   = @"DPTogetherBuyTabBarIndicateKey";

@interface DPTogetherBuyViewController () <
    DPCollapseTableViewDelegate,
    DPCollapseTableViewDataSource,
    DPKeyboardCenterDelegate,
    UIGestureRecognizerDelegate,
    UITextFieldDelegate,
    DPTogetherBuyAppendCellDelegate,
    ModuleNotify,
    DPNavigationMenuDelegate,
    DPRedPacketViewControllerDelegate
> {
@private
    CTogetherBuyCenter *_buyCenter;
    DPNavigationMenu *_menu;
    UIImageView      *_indicateView; // 无搜索结果指示图
    NSInteger   _cmdId; //
}

@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) UIView *searchBarView;
@property (nonatomic, strong, readonly) UIView *tabBarView;
@property (nonatomic, strong, readonly) UITextField *searchField;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, assign) NSInteger typeIndex;

@property (nonatomic,assign) GameTypeId gameTypeId;
@property (nonatomic,assign) int projectid;
@property (nonatomic, assign) NSInteger projectAmount;      // 方案金额
@property (nonatomic, strong) NSString *gameName;

@end

@implementation DPTogetherBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _buyCenter = CFrameWork::GetInstance()->GetTogetherBuyCenter();
        _buyCenter->SetDelegate(self);
        _defaultTabIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initialize];
    [self _buildLayout];
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.titleView = self.titleButton;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onHome)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_TogetherBuyImage(@"search.png") target:self action:@selector(pvt_onNavSearch)];
    
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap:)];
        tap.delegate = self;
        tap;
    })];
    
    [self.view addSubview:_indicateView];
    [_indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    __block __typeof(_buyCenter) weakBuyCenter = _buyCenter;
    __weak __typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tableView.showsInfiniteScrolling = NO;
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weakBuyCenter->Refresh(true));
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weakBuyCenter->Refresh());
    }];
    self.tableView.showsInfiniteScrolling = NO;

}

- (void)_initialize {
    _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    _titleButton.titleText = @"合买大厅";
    
    _indicateView = [[UIImageView alloc]initWithImage:dp_TogetherBuyImage(@"noneResult.png")];
    _indicateView.hidden = YES;
    
    _searchBarView = [[UIView alloc] init];
    _searchBarView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    _tabBarView = [[UIView alloc] init];
    _tabBarView.backgroundColor = [UIColor colorWithRed:0.98 green:0.96 blue:0.95 alpha:1];
    
    _tableView = [[DPCollapseTableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.expandMutual = YES;
    _tableView.zOrder = DPTableViewZOrderAsec;
    
    _searchField = [[UITextField alloc] init];
    _searchField.backgroundColor = [UIColor colorWithRed:0.9 green:0.87 blue:0.84 alpha:1];
    _searchField.placeholder = @"请输入用户名全称";
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.layer.cornerRadius = 5;
    _searchField.font = [UIFont dp_systemFontOfSize:14];
    _searchField.textColor = [UIColor dp_flatBlackColor];
    _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchField.delegate = self;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.leftView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        view;
    });
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor dp_coverColor];
    _coverView.hidden = YES;
}

- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.items = @[@"全部彩种", @"双色球", @"大乐透", @"竞彩足球", @"胜负彩", @"任选九", @"福彩3D", @"竞彩篮球", @"北京单场", @"排列三", @"排列五", @"七星彩", @"七乐彩"];
    }
    return _menu;
}

- (void)_buildLayout {
    [self.view addSubview:self.searchBarView];
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.tableView];
    
    [self.searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kSearchBarHeight));
        make.top.equalTo(self.view).offset(-kSearchBarHeight);
    }];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.searchBarView.mas_bottom);
        make.height.equalTo(@30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *searchButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.84 alpha:1]];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button.layer setCornerRadius:3];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
        [button addTarget:self action:@selector(pvt_onSearch) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIView *separatorLine1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.82 green:0.78 blue:0.72 alpha:1];
        view;
    });
    
    [self.searchBarView addSubview:self.searchField];
    [self.searchBarView addSubview:searchButton];
    [self.searchBarView addSubview:separatorLine1];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarView).offset(10);
        make.top.equalTo(self.searchBarView).offset(5);
        make.bottom.equalTo(self.searchBarView).offset(-5);
        make.right.equalTo(searchButton.mas_left).offset(-5);
    }];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchBarView).offset(-10);
        make.top.equalTo(self.searchBarView).offset(5);
        make.bottom.equalTo(self.searchBarView).offset(-5);
        make.width.equalTo(@65);
    }];
    [separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarView);
        make.right.equalTo(self.searchBarView);
        make.bottom.equalTo(self.searchBarView);
        make.height.equalTo(@0.5);
    }];
    
    UIView *separatorLine2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatRedColor];
        view;
    });
    [self.tabBarView addSubview:separatorLine2];
    [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.height.equalTo(@0.5);
    }];
    
    DPImageLabel *imageLabel1 = ({
        DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.imagePosition = DPImagePositionRight;
        imageLabel.text = @"进度";
        imageLabel.textColor = [UIColor dp_flatBlackColor];
        imageLabel.image = dp_TogetherBuyImage(@"unselected.png");
        imageLabel.highlightedTextColor = [UIColor dp_flatRedColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:12];
        imageLabel.spacing = 2;
        imageLabel.tag = -1;
        imageLabel;
    });
    DPImageLabel *imageLabel2 = ({
        DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.imagePosition = DPImagePositionRight;
        imageLabel.text = @"金额";
        imageLabel.textColor = [UIColor dp_flatBlackColor];
        imageLabel.image = dp_TogetherBuyImage(@"unselected.png");
        imageLabel.highlightedTextColor = [UIColor dp_flatRedColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:12];
        imageLabel.spacing = 2;
        imageLabel.tag = -2;
        imageLabel;
    });
    DPImageLabel *imageLabel3 = ({
        DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.imagePosition = DPImagePositionRight;
        imageLabel.text = @"人气";
        imageLabel.textColor = [UIColor dp_flatBlackColor];
        imageLabel.image = dp_TogetherBuyImage(@"unselected.png");
        imageLabel.highlightedTextColor = [UIColor dp_flatRedColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:12];
        imageLabel.spacing = 2;
        imageLabel.tag = -3;
        imageLabel;
    });
    UIView *indicateView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatRedColor];
        view.tag = 10;
        view;
    });
    
    [self.tabBarView addSubview:imageLabel1];
    [self.tabBarView addSubview:imageLabel2];
    [self.tabBarView addSubview:imageLabel3];
    [self.tabBarView addSubview:indicateView];
    [imageLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabBarView);
        make.top.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.width.equalTo(self.tabBarView).multipliedBy(0.3);
    }];
    [imageLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageLabel2.mas_left);
        make.top.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.width.equalTo(self.tabBarView).multipliedBy(0.3);
    }];
    [imageLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageLabel2.mas_right);
        make.top.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.width.equalTo(self.tabBarView).multipliedBy(0.3);
    }];
    
    [self.tabBarView dp_setStrongObject:imageLabel1 forKey:DPTogetherBuyTabBarItemKey1];
    [self.tabBarView dp_setStrongObject:imageLabel2 forKey:DPTogetherBuyTabBarItemKey2];
    [self.tabBarView dp_setStrongObject:imageLabel3 forKey:DPTogetherBuyTabBarItemKey3];
    [self.tabBarView dp_setStrongObject:indicateView forKey:DPTogetherBuyTabBarIndicateKey];
    
    [self tabBarSelectedIndex:self.defaultTabIndex];
    
    // cover view
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBarView.mas_bottom);
    }];
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    
    _buyCenter->Clear();
}

#pragma mark - event
- (void)tabBarSelectedIndex:(NSInteger)index {
    [[DPToast sharedToast]dismiss];
    DPImageLabel *imageLabel1 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey1];
    DPImageLabel *imageLabel2 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey2];
    DPImageLabel *imageLabel3 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey3];
    UIView *indicateView = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarIndicateKey];
    
    [@[imageLabel1, imageLabel2, imageLabel3] enumerateObjectsUsingBlock:^(DPImageLabel *obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            if (obj.highlighted) {
                obj.tag = -obj.tag;
            }
            obj.highlighted = NO;
            obj.highlightedImage = obj.tag > 0 ? dp_TogetherBuyImage(@"selected1.png") : dp_TogetherBuyImage(@"selected2.png");
            obj.highlighted = YES;
            
            [indicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj);
                make.right.equalTo(obj);
                make.bottom.equalTo(self.tabBarView);
                make.height.equalTo(@2.5);
            }];
        } else {
            obj.highlighted = NO;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.tabBarView layoutIfNeeded];
    }];
    
    [self pvt_refresh];
}

- (void)pvt_onHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pvt_onNavSearch {
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.searchBarView && obj.firstAttribute == NSLayoutAttributeTop) {
            if (obj.constant == 0) {
                obj.constant = -kSearchBarHeight;
                
                self.searchField.text = nil;
                if (self.searchField.isEditing) {
                    [self.searchField endEditing:YES];
                }
                
                [self pvt_refresh];
            } else {
                obj.constant = 0;
                
                [self.searchField becomeFirstResponder];
            }
            
            *stop = YES;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)pvt_onNavTitle {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.typeIndex];
    [self.menu show];
}

- (void)pvt_onHandleTap:(UITapGestureRecognizer *)tap {
    if ([self isHUDAppear]) {
        return;
    }
    
    if (DPKeyboardCenter.defaultCenter.isKeyboardAppear) {
        [self.view endEditing:YES];
    } else {
        CGPoint point = [tap locationInView:self.view];
        if (CGRectContainsPoint(self.tableView.frame, point)) {
            point = [tap locationInView:self.tableView];
            
            BOOL isAppendCell = NO;
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
            
            if (indexPath == nil) {
                return;
            }
            
            NSIndexPath *modelIndex = [self.tableView modelIndexFromTableIndex:indexPath expand:&isAppendCell];
            
            if (!isAppendCell) {
                DPTogetherBuyCell *cell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
                point = [tap locationInView:cell.contentView];
                
                if (point.x > kScreenWidth / 2 && point.x < kScreenWidth * 3 / 4) {
                    NSIndexPath *modelIndexs = [[self.tableView expandModelIndexs] firstObject];
                    NSIndexPath *tableIndex = [self.tableView tableIndexFromModelIndex:modelIndexs expand:NO];
                  
                    
                    if ([tableIndex isEqual:indexPath]) {
                        if ([cell.arrowView.image isEqual:dp_TogetherBuyImage(@"jtx.png")]) {
                            cell.arrowView.image =dp_TogetherBuyImage(@"jts.png") ;
                        } else {
                            cell.arrowView.image =dp_TogetherBuyImage(@"jtx.png") ;
                        }
                    } else {
                        cell.arrowView.image = dp_TogetherBuyImage(@"jts.png") ;
                        DPTogetherBuyCell* ccell = (id) [self.tableView cellForRowAtIndexPath:tableIndex] ;
                        ccell.arrowView.image = dp_TogetherBuyImage(@"jtx.png") ;
                    }
                    [self.tableView toggleCellAtModelIndex:modelIndex];
                } else {
                    int projectId, gameType;
                    _buyCenter->GetProjectId(modelIndex.row, projectId, gameType);
                    DPProjectDetailVC *viewController = [[DPProjectDetailVC alloc] init];
                    [viewController projectDetailPriojectId:projectId gameType:(GameTypeId)gameType pdBuyId:2 gameName:0];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
        } else if (CGRectContainsPoint(self.tabBarView.frame, point)) {
            point = [tap locationInView:self.tabBarView];
            
            DPImageLabel *imageLabel1 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey1];
            DPImageLabel *imageLabel2 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey2];
            DPImageLabel *imageLabel3 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey3];
            
            [@[imageLabel1, imageLabel2, imageLabel3] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                if (CGRectContainsPoint(obj.frame, point)) {
                    [self tabBarSelectedIndex:idx];
                }
            }];
        }
    }
}

- (void)pvt_onSearch {
    [self pvt_refresh];
    [self.searchField endEditing:YES];
}

#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    self.typeIndex = index;
    self.titleButton.titleText = menu.items[index];
    
    [self pvt_refresh];
}

- (void)pvt_refresh {
    static int GameTypes[] = {
        GameTypeNone, GameTypeSsq, GameTypeDlt,
        GameTypeJcNone, GameTypeZc14, GameTypeZc9,
        GameTypeSd, GameTypeLcNone, GameTypeBdNone,
        GameTypePs, GameTypePw, GameTypeQxc,
        GameTypeQlc,
    };
    
    DPImageLabel *imageLabel1 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey1];
    DPImageLabel *imageLabel2 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey2];
    DPImageLabel *imageLabel3 = [self.tabBarView dp_strongObjectForKey:DPTogetherBuyTabBarItemKey3];
    
    int type = 0;
    bool aesc = false;
    if (imageLabel1.highlighted) {
        type = 1;
        aesc = imageLabel1.tag > 0;
    } else if (imageLabel2.highlighted) {
        type = 3;
        aesc = imageLabel2.tag > 0;
    } else if (imageLabel3.highlighted) {
        type = 4;
        aesc = imageLabel3.tag > 0;
    }
    
    _buyCenter->SetRequestPars(GameTypes[self.typeIndex], type, aesc, self.searchField.text ? self.searchField.text.UTF8String : "");
    REQUEST_RELOAD(_cmdId, _buyCenter->Refresh(true));
    self.tableView.showsInfiniteScrolling = NO;
    
    NSIndexPath *modelIndexs = [[self.tableView expandModelIndexs] firstObject];
    NSIndexPath *tableIndex = [self.tableView tableIndexFromModelIndex:modelIndexs expand:NO];
    DPTogetherBuyCell* ccell =(id) [self.tableView cellForRowAtIndexPath:tableIndex] ;
    ccell.arrowView.image = dp_TogetherBuyImage(@"jtx.png");
    
    [self showHUD];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
}

#pragma mark - table view's data source and delegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if ([[DPKeyboardCenter defaultCenter] isKeyboardAppear]) {
//        [self.view endEditing:YES];
//    }
//}

- (CGFloat)tableView:(DPCollapseTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(DPCollapseTableView *)tableView numberOfRowsInSection:(NSInteger)section {
   int result = _buyCenter->GetCount();
    if (result > 0) {
        _indicateView.hidden = YES;
    }
    return result;
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InfoCell";
    DPTogetherBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPTogetherBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    string userName, gameTypeName, gameName; int totalAmt, followCount, buyedAmt, buyedRate, fillRate, crown, sun, moon, star;
    _buyCenter->GetProjectInfo(indexPath.row, userName, gameTypeName, gameName, totalAmt, followCount, buyedAmt, buyedRate, fillRate, crown, sun, moon, star);
    NSArray *dengjiData = @[[NSNumber numberWithInt:crown],[NSNumber numberWithInt:sun],[NSNumber numberWithInt:moon],[NSNumber numberWithInt:star]];
    cell.gameTypeLabel.text = [NSString stringWithUTF8String:gameTypeName.c_str()];
    cell.subscriptionLabel.text = [NSString stringWithFormat:@"%d", buyedRate];
    cell.guaranteeLabel.hidden = fillRate < 0;
    cell.guaranteeLabel.text = [NSString stringWithFormat:@"%d%c", fillRate, '%'];
    cell.userNameLabel.text = [NSString stringWithUTF8String:userName.c_str()];
    cell.amountLabel.text = [NSString stringWithFormat:@"%d", totalAmt];
    cell.surplusLabel.text = [NSString stringWithFormat:@"%d", totalAmt - buyedAmt];
    cell.turnoutLabel.text = [NSString stringWithFormat:@"%d", followCount];
    cell.dengjiArray = dengjiData;
    return cell;
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AppendCell";
    DPTogetherBuyAppendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPTogetherBuyAppendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.amountField.delegate = self;
        cell.delegate = self;
    }
    int totalAmt, buyedAmt;
    _buyCenter->GetProjectAmount(indexPath.row, totalAmt, buyedAmt);
    cell.amountField.placeholder = [NSString stringWithFormat:@"%d元可买", totalAmt - buyedAmt];
    cell.amountField.tag = totalAmt - buyedAmt;
    cell.amountField.text = nil;
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return cell;
}


#pragma mark - text field
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.searchField) {
        [self.coverView setAlpha:0];
        [self.coverView setHidden:NO];
        [UIView animateWithDuration:0.2 animations:^{
            [self.coverView setAlpha:1];
        }];
    } else {
        self.activeField = textField;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.searchField) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.coverView setAlpha:0];
        } completion:^(BOOL finished) {
            [self.coverView setHidden:YES];
        }];
    } else {
        self.activeField = nil;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.infiniteScrollingView.enabled = _buyCenter->HasMoreRecord();
        textField.text = [NSString stringWithFormat:@"%d",[textField.text intValue]] ;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.searchField) {
        return YES;
    } else {
        NSString *finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (![DPVerifyUtilities isNumber:finalText]) {
            return NO;
        }
        
        if (finalText.integerValue > textField.tag) {
            textField.text = [NSString stringWithFormat:@"%d", textField.tag];
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - DPTogetherBuyAppendCellDelegate

- (void)buyoutTogetherBuyAppendCell:(DPTogetherBuyAppendCell *)cell {
    cell.amountField.text = [NSString stringWithFormat:@"%d", cell.amountField.tag];
    DPLog(@"全包");
}

- (void)payTogetherBuyAppendCell:(DPTogetherBuyAppendCell *)cell {
    [self.view endEditing:YES];
    
    if ([cell.amountField.text intValue]<=0) {
        [[DPToast makeText:@"至少一元"]show];
        return ;
    }
    
    BOOL isAppendCell = YES;
    NSIndexPath* tableIndexpath = [_tableView modelIndexForCell:cell expand:&isAppendCell] ;
//    DPTogetherBuyCell* buyCell = (DPTogetherBuyCell*)[_tableView cellForRowAtIndexPath:tableIndexpath] ;
    
    string userName, gameTypeName, gameName; int totalAmt, followCount, buyedAmt, buyedRate, fillRate, crown, sun, moon, star,projectId,gameType;
    _buyCenter->GetProjectInfo(tableIndexpath.row, userName, gameTypeName, gameName, totalAmt, followCount, buyedAmt, buyedRate, fillRate, crown, sun, moon, star);
    _buyCenter->GetProjectId(tableIndexpath.row, projectId, gameType) ;
    self.gameTypeId=(GameTypeId)gameType;
    self.projectid = projectId ;
    self.projectAmount = [cell.amountField.text intValue] ;
    self.gameName = [NSString stringWithUTF8String:(char *)gameName.c_str()];
    if (![self.gameName hasSuffix:@"期"]) {
        self.gameName = [self.gameName stringByAppendingString:@"期"];
    }
    
    __weak __typeof(self) weakSelf = self;
    int amount = [cell.amountField.text intValue];
    void (^finishBlock)() = ^() {
        [weakSelf showDarkHUD];
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(gameType, 3, amount, 0);
    };
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        finishBlock();
    } else {
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = finishBlock;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - keyboard manager
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [[DPKeyboardCenter defaultCenter] removeListener:self];
    
}

- (void)keyboardEvent:(DPKeyboardListenerEvent)event info:(NSDictionary *)info {
    if (self.activeField) {
        CGRect frameEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) + 60, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd), 0);
        CGRect frame = [self.tableView convertRect:self.activeField.bounds fromView:self.activeField];
        NSIndexPath *tableIndex = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tableIndex];
        
        [self.tableView scrollRectToVisible:cell.frame animated:YES];
    }
}

#pragma mark - ModuleNotify

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    break;
                }
                BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                  isRedpacket=YES;
                }
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName(self.gameTypeId);
                viewController.projectAmount = self.projectAmount;
                viewController.gameType = self.gameTypeId;
                viewController.buyType = 2;
                viewController.rengouType = 1;
                viewController.projectid = self.projectid;
                viewController.delegate = self;
                viewController.entryType = kEntryTypeTogetherBuy;
                viewController.gameNameText = self.gameName;
                viewController.isredPacket=isRedpacket;
                [self.navigationController pushViewController:viewController animated:YES];
                
                NSIndexPath *modelIndexs = [[self.tableView expandModelIndexs] firstObject];
                NSIndexPath *tableIndex = [self.tableView tableIndexFromModelIndex:modelIndexs expand:NO];
                DPTogetherBuyCell* ccell =(id) [self.tableView cellForRowAtIndexPath:tableIndex] ;
                ccell.arrowView.image = dp_TogetherBuyImage(@"jtx.png");
            }
                break;
            case ACCOUNT_JOINBUY: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
                } else {
                    [self goPayCallback];
                }
            }
                break;
            case REFRESH: {
                [self dismissHUD];
                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView.infiniteScrollingView stopAnimating];
                [self.tableView closeAllCells];
                [self.tableView reloadData];
                [self.tableView setShowsInfiniteScrolling:_buyCenter->GetCount() > 0];
                [self.tableView.infiniteScrollingView setEnabled:_buyCenter->HasMoreRecord()];
                
                _indicateView.hidden = [self.tableView numberOfRowsInSection:0];
                
                if (ret < 0) {
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                }
            }
            default:
                break;
        }
    });
}

- (void)goPayCallback {
    int buyType; string guid; string url;
    CFrameWork::GetInstance()->GetAccount()->GetJoinBuyWebPayment( buyType, guid);
    NSString *string = kConfirmPayURL(buyType, [NSString stringWithUTF8String:guid.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    kAppDelegate.gotoHomeBuy = YES;
}

#pragma mark - DPRedPacketViewControllerDelegate

- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (ret >= 0) {
        [self goPayCallback];
    }
}

@end
