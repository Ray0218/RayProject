//
//  DPAppParser.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-13.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAppRootViewController.h"
#import "DPAppParser.h"
#import "DPAppDelegate.h"
#import "XTSideMenu.h"
#import "FrameWork.h"

#pragma mark -

// 投注页面
#import "Modules/HomeBuy/DPBigLotteryVC.h"          // 数组彩
#import "Modules/HomeBuy/DPSevenHappyLotteryVC.h"
#import "Modules/HomeBuy/DPDoubleHappyLotteryVC.h"
#import "Modules/HomeBuy/DPElevnSelectFiveVC.h"
#import "Modules/HomeBuy/DPSdBuyViewController.h"
#import "Modules/HomeBuy/DPPsBuyViewController.h"
#import "Modules/HomeBuy/DPQxcBuyViewController.h"
#import "Modules/HomeBuy/DPPwBuyViewController.h"
#import "Modules/HomeBuy/DPRank5TransferVC.h"

#import "Modules/HomeBuy/DPQuick3LotteryVC.h"       // 高频彩
#import "Modules/HomeBuy/DPQuick3transferVC.h"       // 高频彩

#import "Modules/HomeBuy/DPPksBuyViewController.h"
#import "Modules/HomeBuy/DPPoker3transferVC.h"

#import "Modules/HomeBuy/DPElevnSelectFiveTransferVC.h"
#import "Modules/HomeBuy/DPSfcViewController.h"     // 竞技彩
#import "Modules/HomeBuy/DPZcNineViewController.h"
#import "Modules/HomeBuy/DPJclqBuyViewController.h"
#import "Modules/HomeBuy/DPJczqBuyViewController.h"
#import "Modules/HomeBuy/DPJcdgBuyVC.h"
#import "Modules/HomeBuy/DPBdBuyViewController.h"

// 中转界面
#import "DPWF3DTicketTransferVC.h"
#import "DPRank3TransferVC.h"
#import "DPRank5TransferVC.h"
#import "DPSevenStartransferVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPSevenLuckTransferVC.h"

// 各模块入口
#import "DPLotteryInfoViewController.h"
#import "DPTogetherBuyViewController.h"
#import "DPLotteryResultViewController.h"

#import "DPLiveDataCenterViewController.h"
#import "DPPersonalCenterViewController.h"

#import "DPAccountViewControllers.h"
#import "DPRechargeVC.h"
#import "DPWebViewController.h"
#import "DPAcountPacketController.h"
#import "DPExchangeViewController.h"
#import "DPSecurityCenterViewController.h"
#import "DPFundFlowViewController.h"
#import "DPDrawingsVC.h"
#import "DPHelpWebViewController.h"
#import "DPSettingVC.h"
#import "DPLotteryPushVC.h"

#import "DPProjectDetailVC.h"
#import "DPSpecifyInfoViewController.h"
#import "DPResultListViewController.h"

#define kAppParserVersion   1

typedef NS_ENUM(NSInteger, DPSchemeActionType) {
    DPSchemeActionTypeNone,
    DPSchemeActionTypeHomeBuy       = 1,    // 首页
    DPSchemeActionTypeTogetherBuy   = 2,    // 合买大厅
    DPSchemeActionTypeBuy           = 3,    // 投注界面
    DPSchemeActionTypeTransfer      = 4,    // 中转界面
    DPSchemeActionTypeProject       = 5,    // 方案详情
    DPSchemeActionTypePersonal      = 6,    // 个人中心
    DPSchemeActionTypeTopup         = 7,    // 充值
    DPSchemeActionTypeDrawings      = 8,    // 提款
    DPSchemeActionTypeRedPackets    = 9,    // 红包
    DPSchemeActionTypeRedeemPackets = 10,   // 兑换红包
    DPSchemeActionTypeBuyRedPackets = 11,   // 购买红包
    DPSchemeActionTypeRealNameAuth  = 12,   // 实名认证
    DPSchemeActionTypeDrawNotice    = 13,   // 开奖公告
    DPSchemeActionTypeDrawDetail    = 14,   // 开奖详情
    DPSchemeActionTypeInformation   = 15,   // 资讯
    DPSchemeActionTypeInfoDetail    = 16,   // 资讯详情
    DPSchemeActionTypeGameLive      = 17,   // 比分直播
    DPSchemeActionTypeDataCenter    = 18,   // 数据界面
    DPSchemeActionTypeFunding       = 19,   // 资金明细
    DPSchemeActionTypeSetting       = 20,   // 设置
    DPSchemeActionTypePushSetting   = 21,   // 推送设置
    DPSchemeActionTypeHelp          = 22,   // 帮助
    DPSchemeActionTypeHelpDetail    = 23,   // 帮助详细
    DPSchemeActionTypeShare         = 24,   // 分享
    DPSchemeActionTypeLogin         = 25,   // 登录
    
    DPSchemeActionTypeHTML5         = 99,   // HTML
    DPSchemeActionTypeCustom        = 100,  // 自定义
};

@implementation DPAppParser

+ (void)backToLeftRootViewController:(BOOL)animated withTabIndex:(int)index
{
    [self backToLeftRootViewController:YES];
    DPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.rootController.leftMenuViewController) {
        UINavigationController *leftMnue = (UINavigationController *)appDelegate.rootController.leftMenuViewController;
          DPPersonalCenterViewController *personal = (DPPersonalCenterViewController *)leftMnue.viewControllers.firstObject;
        [personal recordTabResetForTag:index];
    }

}
+ (void)backToLeftRootViewController:(BOOL)animated {
    DPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.rootController.visibleType == XTSideMenuVisibleTypeLeft) {
        if (appDelegate.rootController.leftMenuViewController.presentedViewController) {
            [appDelegate.rootController.leftMenuViewController.presentedViewController dismissViewControllerAnimated:animated completion:nil];
        }
        if (CFrameWork::GetInstance()->IsUserLogin()) {
            [(UINavigationController *)appDelegate.rootController.leftMenuViewController popToRootViewControllerAnimated:animated];
        }
    } else if (appDelegate.rootController.contentViewController.presentedViewController) {
        [appDelegate.rootController.contentViewController.presentedViewController dismissViewControllerAnimated:animated completion:nil];
        [appDelegate.rootController presentLeftViewController];
    } else {
        [appDelegate.rootController presentLeftViewController];
    }
}

+ (void)backToCenterRootViewController:(BOOL)animated {
    DPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.rootController.visibleType == XTSideMenuVisibleTypeLeft) {
        if (appDelegate.rootController.leftMenuViewController.presentedViewController) {
            [appDelegate.rootController.leftMenuViewController.presentedViewController dismissViewControllerAnimated:animated completion:nil];
        }
//        if (CFrameWork::GetInstance()->IsUserLogin()) {
            [appDelegate.rootController hideMenuViewController];
            [appDelegate.rootController setPanGestureEnabled:YES];
//            [(UINavigationController *)appDelegate.rootController.leftMenuViewController dp_popToRootViewControllerAnimated:YES completion:^{
//                [appDelegate.rootController hideMenuViewController];
//                [appDelegate.rootController setPanGestureEnabled:YES];
//            }];
//            [(UINavigationController *)appDelegate.rootController.leftMenuViewController popToRootViewControllerAnimated:YES];
//            [appDelegate.rootController hideMenuViewController];
//            [appDelegate.rootController setPanGestureEnabled:YES];
//        }
    } else if (appDelegate.rootController.contentViewController.presentedViewController) {
        [appDelegate.rootController.contentViewController.presentedViewController dismissViewControllerAnimated:animated completion:nil];
    }
}

+ (UIViewController *)visibleViewController {
    UIViewController *viewController;
    DPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.rootController.visibleType == XTSideMenuVisibleTypeLeft) {
        UINavigationController *navigationController = (id)appDelegate.rootController.leftMenuViewController;
        DbgAssert([navigationController isKindOfClass:[UINavigationController class]]);
        viewController = navigationController.visibleViewController;
    } else if (appDelegate.rootController.contentViewController.presentedViewController) {
        UINavigationController *navigationController = (id)appDelegate.rootController.contentViewController.presentedViewController;
        DbgAssert([navigationController isKindOfClass:[UINavigationController class]]);
        viewController = navigationController.visibleViewController;
    } else {
        viewController = appDelegate.rootController.contentViewController;
    }
    return viewController;
}

+ (void)rootViewController:(UIViewController *)rootController animated:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"Version"] != nil && [[userInfo objectForKey:@"Version"] integerValue] > kAppParserVersion) {
        [[DPToast makeText:@"请更新客户端"] show];
        return;
    }
    NSInteger action = [[userInfo objectForKey:@"Action"] integerValue];
    
    switch (action) {
        case DPSchemeActionTypeHomeBuy:
            [self rootViewController:rootController gotoHomeBuy:animated];
            break;
        case DPSchemeActionTypeTogetherBuy:
            [self rootViewController:rootController gotoTogetherBuy:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeBuy:
            [self rootViewController:rootController gotoBuy:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeTransfer:
            [self rootViewController:rootController gotoTransfer:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeProject:
            [self rootViewController:rootController gotoProject:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypePersonal:
            [self rootViewController:rootController gotoPersonal:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeTopup:
            [self rootViewController:rootController gotoTopup:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeDrawings:
            [self rootViewController:rootController gotoDrawings:animated];
            break;
        case DPSchemeActionTypeRedPackets:
            [self rootViewController:rootController gotoRedPackets:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeRedeemPackets:
            [self rootViewController:rootController gotoRedeemPackets:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeBuyRedPackets:
            [self rootViewController:rootController gotoBuyRedPackets:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeRealNameAuth:
            [self rootViewController:rootController gotoRealNameAuth:animated];
            break;
        case DPSchemeActionTypeDrawNotice:
            [self rootViewController:rootController gotoDrawNotice:animated];
            break;
        case DPSchemeActionTypeDrawDetail:
            [self rootViewController:rootController gotoDrawDetail:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeInformation:
            [self rootViewController:rootController gotoInformation:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeInfoDetail:
            [self rootViewController:rootController gotoInfoDetail:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeGameLive:
            break;
        case DPSchemeActionTypeDataCenter:
            break;
        case DPSchemeActionTypeFunding:
            [self rootViewController:rootController gotoFunding:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeSetting:
            [self rootViewController:rootController gotoSetting:animated];
            break;
        case DPSchemeActionTypePushSetting:
            [self rootViewController:rootController gotoPushSetting:animated];
            break;
        case DPSchemeActionTypeHelp:
            [self rootViewController:rootController gotoHelp:animated];
            break;
        case DPSchemeActionTypeHelpDetail:
            break;
        case DPSchemeActionTypeShare:
            break;
        case DPSchemeActionTypeLogin:
            [self rootViewController:rootController gotoLogin:animated];
            break;
        case DPSchemeActionTypeHTML5:
            [self rootViewController:rootController gotoHTML5:animated userInfo:userInfo];
            break;
        case DPSchemeActionTypeCustom:
            [self rootViewController:rootController gotoCustom:animated userInfo:userInfo];
            break;
        default:
            break;
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoHomeBuy:(BOOL)animated {
    [self backToCenterRootViewController:animated];
}

+ (void)rootViewController:(UIViewController *)rootController gotoTogetherBuy:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];

    DPTogetherBuyViewController *viewController = [[DPTogetherBuyViewController alloc] init];
    viewController.defaultTabIndex = [userInfo[@"Tab"] intValue];
    UINavigationController *navigationController = [UINavigationController dp_controllerWithRootViewController:viewController];
    [kRootController.contentViewController presentViewController:navigationController animated:animated completion:nil];
}

+ (void)rootViewController:(UIViewController *)rootController gotoBuy:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];
    
    GameTypeId typeId = (GameTypeId)[[userInfo dp_safeObjectForKey:@"GameTypeId"] integerValue];
    NSInteger index = [[userInfo dp_safeObjectForKey:@"GameIndex"] integerValue];
    UINavigationController *naviewContro ;
    
    switch (typeId) {
        case GameTypeSd :{
//          DPSdBuyViewController*  viewController = [[DPSdBuyViewController alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            break;
        case GameTypeSsq :{
//            DPDoubleHappyLotteryVC *viewControlle = [[DPDoubleHappyLotteryVC alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewControlle];
        }
            break;
        case GameTypeQlc :{
//           DPSevenHappyLotteryVC* viewController = [[DPSevenHappyLotteryVC alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            break;
        case GameTypeDlt :{
//            DPBigLotteryVC* viewController = [[DPBigLotteryVC alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            break;
        case GameTypePs :{
//            DPPsBuyViewController *viewController = [[DPPsBuyViewController alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            break;
        case GameTypePw :{
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
//            DPPwBuyViewController* viewControl =   [[DPPwBuyViewController alloc]init] ;
//            [naviewContro setViewControllers:@[[[DPRank5TransferVC alloc] init],viewControl ]];

        }
            break;
        case GameTypeQxc :{
//           DPQxcBuyViewController* viewController = [[DPQxcBuyViewController alloc]init];
//            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            break;
        case GameTypeNmgks:{
            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
            DPQuick3LotteryVC* viewControl =   [[DPQuick3LotteryVC alloc]init] ;
            viewControl.gameType= (KSType)index ;
            [naviewContro setViewControllers:@[[[DPQuick3transferVC alloc] init],viewControl ]];
        }
            break ;
        case GameTypeSdpks: {
            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
           DPPksBuyViewController* viewContro =  [[DPPksBuyViewController alloc]init] ;
            viewContro.gameIndex = (PksGameIndex)index ;
            [naviewContro setViewControllers:@[[[DPPoker3transferVC alloc] init], viewContro]];
        }
            break ;
        case GameTypeJxsyxw: {
            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
            DPElevnSelectFiveVC* viewContr = [[DPElevnSelectFiveVC  alloc]init];
            viewContr.gameIndex = index ;
            [naviewContro setViewControllers:@[[[DPElevnSelectFiveTransferVC alloc] init], viewContr]];
        }
            break;
        case GameTypeDfljy:
            
            break;
        case GameTypeZjtcljy:
            
            break;
        case GameTypeTc22x5:
            
            break;
        case GameTypeZc14: {
           DPSfcViewController* viewController = [[DPSfcViewController alloc]init];
            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewController];
        }
            
            break;
        case GameTypeZc9: {
            DPZcNineViewController* viewContr= [[DPZcNineViewController alloc]init];
            naviewContro = [UINavigationController dp_controllerWithRootViewController:viewContr];
        }
            break;
        case GameTypeZc4:
            
            break;
        case GameTypeZc6:
            
            break;
        case GameTypeBdNone: //北单
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc: {
            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
            DPBdBuyViewController*   viewContr = [[DPBdBuyViewController alloc]init];
            viewContr.gameIndex = index ;
            [naviewContro setViewControllers:@[viewContr]];
        }
            break;
        case GameTypeJcNone: // 竞彩足球
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeJcSpf:{
            if (index == 6) {
                naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
                DPJcdgBuyVC *  viewContr = [[DPJcdgBuyVC alloc]init];
                [naviewContro setViewControllers:@[viewContr]];
            } else {
                naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
                DPJczqBuyViewController *  viewContr = [[DPJczqBuyViewController alloc]init];
                viewContr.gameIndex = index ;
                [naviewContro setViewControllers:@[viewContr]];
            }
        }
            break;
        case GameTypeLcNone: // 竞彩篮球
        case GameTypeLcHt:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:{
            naviewContro = [UINavigationController dp_controllerWithRootViewController:nil];
            DPJclqBuyViewController *  viewContr = [[DPJclqBuyViewController alloc]init];
            viewContr.gameIndex = index ;
            [naviewContro setViewControllers:@[viewContr]];
        }
            break;
        default:
            break;
    }
    
    if (naviewContro) {
        [kRootController.contentViewController presentViewController:naviewContro animated:animated completion:nil];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoTransfer:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];
    
    GameTypeId gameType = (GameTypeId)[[userInfo dp_safeObjectForKey:@"GameTypeId"] integerValue];
    UINavigationController *targetCtrl = nil;
    switch (gameType) {
        case GameTypeSd:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPWF3DTicketTransferVC alloc]init]];
            break;
        case GameTypeSsq:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPDoubleHappyTransferVC alloc]init]];
            break;
        case GameTypeQlc:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPSevenLuckTransferVC alloc]init]];
            break;
        case GameTypeDlt:
           targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPBigHappyTransferVC alloc]init]];
            break;
        case GameTypePs:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPRank3TransferVC alloc]init]];
            break;
        case GameTypePw:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPRank5TransferVC alloc]init]];
            break;
        case GameTypeQxc:
            targetCtrl = [UINavigationController dp_controllerWithRootViewController:[[DPSevenStartransferVC alloc]init]];
            break;
//        case GameTypeBdNone:
//        case GameTypeBdRqspf:
//        case GameTypeBdSxds:
//        case GameTypeBdZjq:
//        case GameTypeBdBf:
//        case GameTypeBdBqc:
//        case GameTypeBdSf:
//            break;
//        case GameTypeNmgks:
//
//            break;
//        case GameTypeSdpks:
//
//            break;
//        case GameTypeJxsyxw:
//
//            break;
//        case GameTypeJcNone:
//        case GameTypeJcRqspf:
//        case GameTypeJcBf:
//        case GameTypeJcZjq:
//        case GameTypeJcBqc:
//        case GameTypeJcGJ:
//        case GameTypeJcGYJ:
//        case GameTypeJcHt:
//        case GameTypeJcSpf:
//
//            break;
//        case GameTypeLcNone:
//        case GameTypeLcSf:
//        case GameTypeLcRfsf:
//        case GameTypeLcSfc:
//        case GameTypeLcDxf:
//        case GameTypeLcHt:
//
//            break;
//        case GameTypeZc14:
//
//            break;
//        case GameTypeZc9:
//
//            break;
        default:
            break;
    }
    if (targetCtrl) {
        UIViewController *content = (id)kAppDelegate.rootController.contentViewController;
        [content presentViewController:targetCtrl animated:YES completion:nil];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoProject:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    @autoreleasepool {
        [self backToLeftRootViewController:NO];
    }

    if (kIsUserLogin) {
        NSInteger projectId = [[userInfo dp_safeObjectForKey:@"ProjectId"] integerValue];
        GameTypeId gameType = (GameTypeId)[[userInfo dp_safeObjectForKey:@"GameTypeId"] integerValue];
        NSInteger buyType = [[userInfo dp_safeObjectForKey:@"BuyType"] integerValue];
        NSInteger orderId = [[userInfo dp_safeObjectForKey:@"OrderId"] integerValue];
        
        DPProjectDetailVC *viewController = [[DPProjectDetailVC alloc] init];
        [viewController setBackToRefresh:YES];
        [viewController setPurchaseOrderId:orderId];
        [viewController projectDetailPriojectId:projectId gameType:gameType pdBuyId:buyType gameName:0];
        
        [(UINavigationController *)kRootController.leftMenuViewController pushViewController:viewController animated:animated];
        [kRootController setPanGestureEnabled:NO];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoPersonal:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO withTabIndex:[userInfo[@"Tab"] intValue]];
}

+ (void)rootViewController:(UIViewController *)rootController gotoTopup:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPRechargeVC *vc = [[DPRechargeVC alloc] init];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoDrawings:(BOOL)animated {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPDrawingsVC *vc = [[DPDrawingsVC alloc] init];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoRedPackets:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPAcountPacketController *vc = [[DPAcountPacketController alloc] init];
        vc.defaultIndex = [userInfo[@"Tab"] intValue];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoRedeemPackets:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        NSString *code = [userInfo objectForKey:@"RedeemCode"];
        
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPExchangeViewController *vc = [[DPExchangeViewController alloc] init];
        vc.exchangeField.text = code;
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoBuyRedPackets:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        DPLog(@"该版本不支持");
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoRealNameAuth:(BOOL)animated {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPSecurityCenterViewController *vc = [[DPSecurityCenterViewController alloc] init];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoDrawNotice:(BOOL)animated {
    [self backToCenterRootViewController:NO];
    
    DPLotteryResultViewController *viewController = [[DPLotteryResultViewController alloc] init];
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:viewController];
    [kRootController.contentViewController presentViewController:nav animated:animated completion:nil];
}

+ (void)rootViewController:(UIViewController *)rootController gotoDrawDetail:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];
    
    DPLotteryResultViewController *viewController1 = [[DPLotteryResultViewController alloc] init];
    DPResultListViewController *viewController2 = [[DPResultListViewController alloc] init];
    viewController2.gameType = (GameTypeId)[[userInfo dp_safeObjectForKey:@"GameTypeId"] integerValue];
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:nil];
    [nav setViewControllers:@[viewController1, viewController2]];
    [kRootController.contentViewController presentViewController:nav animated:animated completion:nil];
}

+ (void)rootViewController:(UIViewController *)rootController gotoInformation:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];
    
    DPLotteryInfoViewController *viewController = [[DPLotteryInfoViewController alloc] init];
    viewController.defaultIndex = [userInfo[@"Tab"] intValue];
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:viewController];
    [kRootController.contentViewController presentViewController:nav animated:animated completion:nil];
}

+ (void)rootViewController:(UIViewController *)rootController gotoInfoDetail:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToCenterRootViewController:NO];
    
    DPLotteryInfoViewController *viewController1 = [[DPLotteryInfoViewController alloc] init];
    DPSpecifyInfoViewController *viewController2 = [[DPSpecifyInfoViewController alloc] init];
    viewController2.gameType = (GameTypeId)[[userInfo dp_safeObjectForKey:@"GameTypeId"] integerValue];
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:nil];
    [nav setViewControllers:@[viewController1, viewController2]];
    [kRootController.contentViewController presentViewController:nav animated:animated completion:nil];
}

+ (void)rootViewController:(UIViewController *)rootController gotoGameLive:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    DPLog(@"不支持");
}

+ (void)rootViewController:(UIViewController *)rootController gotoDataCenter:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    DPLog(@"不支持");
}

+ (void)rootViewController:(UIViewController *)rootController gotoFunding:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPFundFlowViewController *vc = [[DPFundFlowViewController alloc] init];
        vc.fundType = [userInfo[@"Tab"] intValue];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoSetting:(BOOL)animated {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPSettingVC *vc = [[DPSettingVC alloc] init];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoPushSetting:(BOOL)animated {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPSettingVC *settingVC = [[DPSettingVC alloc] init];
        DPLotteryPushVC *pushVC = [[DPLotteryPushVC alloc] init];
        NSMutableArray *mutableArray = nav.viewControllers.mutableCopy;
        [mutableArray addObject:settingVC];
        [mutableArray addObject:pushVC];
        [nav setViewControllers:mutableArray animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoHelp:(BOOL)animated {
    [self backToLeftRootViewController:NO];
    if (kIsUserLogin) {
        UINavigationController *nav = (id)kAppDelegate.rootController.leftMenuViewController;
        DPHelpWebViewController *vc = [[DPHelpWebViewController alloc] init];
        [nav pushViewController:vc animated:animated];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoHelpDetail:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    [self backToLeftRootViewController:NO];
    DPLog(@"不支持");
}

+ (void)rootViewController:(UIViewController *)rootController gotoShare:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    DPLog(@"不支持");
}

+ (void)rootViewController:(UIViewController *)rootController gotoLogin:(BOOL)animated {
    if (!kIsUserLogin) {
        [self backToLeftRootViewController:NO];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoHTML5:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    animated = [userInfo objectForKey:@"Animated"] == nil ? animated : [[userInfo objectForKey:@"Animated"] boolValue];
    [self backToCenterRootViewController:NO];
    
    DPWebViewController *viewController = [[DPWebViewController alloc] init];
    viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[userInfo dp_safeObjectForKey:@"URL"]]];;
    viewController.showToolBar = [userInfo objectForKey:@"ShowToolBar"] == nil || [[userInfo objectForKey:@"ShowToolBar"] boolValue];
    viewController.customTitle = [[userInfo objectForKey:@"CustomTitle"] boolValue];
    viewController.type = (DPWebViewLoadingType)[[userInfo objectForKey:@"LoadingType"] integerValue];
    if ([userInfo objectForKey:@"ShowNav"] == nil || ![[userInfo dp_safeObjectForKey:@"ShowNav"] boolValue]) {
        [kRootController.contentViewController presentViewController:viewController animated:NO completion:nil];
    } else {
        viewController.title = [userInfo dp_safeObjectForKey:@"Title"];
        [kRootController.contentViewController presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:animated completion:nil];
    }
}

+ (void)rootViewController:(UIViewController *)rootController gotoCustom:(BOOL)animated userInfo:(NSDictionary *)userInfo {
    
}

+ (void)mutualWebView:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"Version"] != nil && [[userInfo objectForKey:@"Version"] integerValue] > kAppParserVersion) {
        [[DPToast makeText:@"请更新客户端"] show];
        return;
    }
    
    NSInteger action = [[userInfo objectForKey:@"Action"] integerValue];
    switch (action) {
        case 1: // 同步账户
        {
//            NSString *userName = [de]
        }
            break;
        default:
            break;
    }
}

@end
