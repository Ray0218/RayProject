//
//  HelperMacro.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject_HelperMacro_H__
#define __DacaiProject_HelperMacro_H__

// 图片文件夹路径
#define kImageBundlePath                [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images"]

#define kCommonImageBundlePath          [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Common"]
#define kNavigationImageBundlePath      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Navigation"]
#define kDigitLotteryImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/DigitLottery"]
#define kSportLotteryImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/SportLottery"]
#define kQuickThreeImageBundlePath      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/QuickThree"]
#define kPokerThreeImageBundlePath      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/PokerThree"]
#define kAccountImageBundlePath         [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Account"]
#define kProjectBundlePath              [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Project"]
#define kLotteryResultBundlePath        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/LotteryResult"]
#define kAppRootBundlePath              [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/AppRoot"]
#define kSportLiveBundlePath            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/SportLive"]
#define kTogetherBuyBundlePath          [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/TogetherBuy"]
#define kRedPacketBundlePath            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/RedPacket"]
#define kBankIconImageBundlePath        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/BankIcon"]
#define kStartupImageBundlePath         [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Startup"]
#define kGameLiveImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/GameLive"]

// 图片路径
#define dp_ImagePath(bundlePath, name)      [bundlePath stringByAppendingPathComponent:name]

// 图片
#define dp_CommonImage(name)                [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, name)]
#define dp_NavigationImage(name)            [UIImage dp_retinaImageNamed:dp_ImagePath(kNavigationImageBundlePath, name)]
#define dp_SportLotteryImage(name)          [UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, name)]
#define dp_DigitLotteryImage(name)          [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, name)]
#define dp_QuickThreeImage(name)            [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, name)]
#define dp_PokerThreeImage(name)            [UIImage dp_retinaImageNamed:dp_ImagePath(kPokerThreeImageBundlePath, name)]
#define dp_AccountImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kAccountImageBundlePath, name)]
#define dp_ProjectImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kProjectBundlePath, name)]
#define dp_ResultImage(name)                [UIImage dp_retinaImageNamed:dp_ImagePath(kLotteryResultBundlePath, name)]
#define dp_AppRootImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kAppRootBundlePath, name)]
#define dp_SportLiveImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kSportLiveBundlePath, name)]
#define dp_TogetherBuyImage(name)           [UIImage dp_retinaImageNamed:dp_ImagePath(kTogetherBuyBundlePath, name)]
#define dp_RedPacketImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kRedPacketBundlePath, name)]
#define dp_BankIconImage(name)              [UIImage dp_retinaImageNamed:dp_ImagePath(kBankIconImageBundlePath, name)]
#define dp_GameLiveImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kGameLiveImageBundlePath, name)]

#define dp_CommonResizeImage(name)          [UIImage dp_resizeImageNamed:dp_ImagePath(kCommonImageBundlePath, name)]
#define dp_NavigationResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kNavigationImageBundlePath, name)]
#define dp_SportLotteryResizeImage(name)    [UIImage dp_resizeImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, name)]
#define dp_DigitLotteryResizeImage(name)    [UIImage dp_resizeImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, name)]
#define dp_QuickThreeResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, name)]
#define dp_PokerThreeResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kPokerThreeImageBundlePath, name)]
#define dp_AccountResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kAccountImageBundlePath, name)]
#define dp_ProjectResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kProjectBundlePath, name)]
#define dp_ResultResizeImage(name)          [UIImage dp_resizeImageNamed:dp_ImagePath(kLotteryResultBundlePath, name)]
#define dp_AppRootResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kAppRootBundlePath, name)]
#define dp_SportLiveResizeImage(name)       [UIImage dp_resizeImageNamed:dp_ImagePath(kSportLiveBundlePath, name)]
#define dp_TogetherBuyResizeImage(name)     [UIImage dp_resizeImageNamed:dp_ImagePath(kTogetherBuyBundlePath, name)]
#define dp_BankIconResizeImage(name)        [UIImage dp_resizeImageNamed:dp_ImagePath(kBankIconImageBundlePath, name)]
#define dp_RedPackertResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kRedPacketBundlePath, name)]
//#define dp_GameLiveResizeImage(name)        [UIImage dp_resizeImageNamed:dp_ImagePath(kGameLiveImageBundlePath, name)]

// 重新请求
#define REQUEST_RELOAD(_cmdId_m, _cmd_m) ({                     \
    if (_cmdId_m >= 200) {                                      \
        CFrameWork::GetInstance()->CmdCancel(_cmdId_m);         \
    }                                                           \
    _cmdId_m = _cmd_m;                                          \
    _cmdId_m;                                                   \
})

// BLOCK内重新请求, 先判断strongSelf是否为nil
#define REQUEST_RELOAD_BLOCK(_cmdId_m, _cmd_m) ({               \
    if (strongSelf && _cmdId_m >= 200) {                        \
        CFrameWork::GetInstance()->CmdCancel(_cmdId_m);         \
    }                                                           \
    int _internal_cmdId_m = _cmd_m;                             \
    if (strongSelf) {                                           \
        _cmdId_m = _internal_cmdId_m;                           \
    }                                                           \
    _internal_cmdId_m;                                          \
})

// 取消网络请求
#define REQUEST_CANCEL(_cmdId_m)    if (_cmdId_m >= 200) { CFrameWork::GetInstance()->CmdCancel(_cmdId_m); _cmdId_m = 0; }



#endif
