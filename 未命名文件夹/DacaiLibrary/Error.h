//
//  Error.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef DacaiProject_Error_h
#define DacaiProject_Error_h


#define SERVER_ERROR_DEFAULT    500     // 服务器500错误



// -1        错误

// -2 |  -100   网络错误

#define ERROR_TimeOut           -6          // 发送或接收数据超时
//#define ERROR_HostNotExist     
#define ERROR_ConnectHostFail   -5          // 网络无法到达
#define ERROR_NET               -2          // 网路其他错误
#define ERROR_CANCEL            -100        // 主动取消

#define ERROR_DATA              -9          // 数据异常

// -400 | -500 公共错误提示
#define ERROR_FAIL              -400    // 失败
#define ERROR_UNKNOW            -401    // 未知错误
#define ERROR_CONTENT_EMPTY     -412    // 数据不能为空
#define ERROR_NO_DATA           -413    // 无数据
#define ERROR_VERSION_TOO_LOW   -414    // 版本过低, 请升级客户端

#define ERROR_PARAMETER         -417    // 参数错误
#define ERROR_RELOGIN           -418    // token过期, 请重新登录
#define ERROR_NOT_LOGIN         -419    // 用户未登录
#define ERROR_NOT_READY         -420    // 数据未准备完成
#define ERROR_DUPLICATE_REQ     -421    // 请求重复
#define ERROR_CHANNEL_NOT_EXIST -422    // 渠道号不存在
#define ERROR_SERVER_ERROR      -498    // 系统繁忙, 使用服务端返回的错误提示
#define ERROR_SYSTEM_BUSY       -499    // 系统繁忙

// -500|-700 逻辑性错误
#define ERROR_illegalNote       -500    // 非有效注内容
#define ERROR_InvalidParameter  -501    // 无效参数
#define ERROR_InvalidTarget     -502    // 无效的目标

#define ERROR_OUT_Of_BOUNDS     -504    // 参数越界
#define ERROR_LOAD_FINISH       -505    // 没有更多数据(加载更多的时候)

#define ERROR_INVALID_BET       -600    // 投注方式无效

#define ERROR_PAY_NO_GAMEID     -601    // 未获取到期号
#define ERROR_PAY_CONTENT       -602    // 投注内容无效

#define ERROR_MODULE_TAB        -800    // -800 ~ -1000    //每个模块有自己的解释
//#define ERROR_NotReady







//////////////////////////  Account模块错误码
#define ERROR_LOGINPASSWD -801   // 登陆密码错误
#define ERROR_USERPASSWD -802    //用户名登入密码错误
#define ERROR_HAD_SETPASSWD -803 //用户已经设置过提款密码
#define ERROR_IVALIDECARD -804   //卡号不正常


#define ERROR_CARD_BOUNDED  -813    // 该卡已经被绑定
#define ERROR_HAD_ADDED   -814      // 该账户已添加，请勿重复添加
#define ERROR_USER_UNTOUCH -815   // 用户未激活
#define ERROR_ZHIFUBAO_BUSY -816  // 支付宝提款系统维护中, 请尝试使用银行卡提款
#define ERROR_MIN5YUAN -817       // 最少提款为5元
#define ERROR_AUTHENTICATION -818 // 请先进行实名制认证
#define ERROR_DRAWPASSWD -819     // 提款密码错误

#define ERROR_DRAWPASSWDUNFORMAT -820 //提款密码不符合规范（设置的情况）
#define ERROR_DRAWPASSWDHASSET -821   //已经设置过提款密码
#define ERROR_HASAUTHENTICATION -822  //已经实名
#define ERROR_CANNOTFINDCARD -823     //找不到该银行卡
#define ERROR_INVALIDCARD -824        //无效的银行卡
#define ERROR_LMONEY -825             //余额不足
#define ERROR_SUPPORTCARD -826        // 不支持该银行卡

#define ERROR_MIN1YUAN -827 // 最少提款为1元

#define ERROR_USERHAS -828     //该账户已添加，请勿重复添加
#define ERROR_CARDHADBIND -829 //    该卡已经被绑定
#define ERROR_MOST5 -830       //银行卡最多添加五条
#define ERROR_AMT1 -831        //金额范围10-5000
//////////////////////////////////////////////跟单
#define ERROR_DIEVICEID -832   // 设备号不正确 (4ios , 3 安卓)
#define ERROR_MUSTONEYUAN -833 // 金额必须为整数且至少1元

// 充值
#define ERROR_TOPUP_FAIL -840  // 充值失败
#define ERROR_TOPUP_TIMES -841 // 充值次数过多

#define ERROR_UMPAY_AMT -842    // 充值金额1-5000
#define ERROR_UMPAY_REAL -843   // 未实名认证
#define ERROR_UNIONPAY_AMT -844 // 充值金额10-2000
#define ERROR_WECHAT_AMT -845   // 金额范围为1-1000
#define ERROR_TENCENT_AMT -846  // 充值金额 1-1000
#define ERROR_ALIPAY_AMT -847   // 充值金额 1-50000

// ACCOUNT_FIND_PWD
#define ERROR_FINDPWD_UNBIND -850 // 用户没有绑定手机
#define ERROR_USER_BINDED_MD -851 // 用户已绑定过手机
#define ERROR_FINDPWD_UNPASS -852 // 验证码还未过期 不能重复获取

// ACCOUNT_NOT_HANDLE_PAY
#define ERROR_NOTPAY_HANDLED -855 // 订单已被处理
#define ERROR_NOTPAY_PASSED - 856 // 订单已过期
#define ERROR_NOTPAY_NOT_EXIST - 857 // 订单不存在
#define ERROR_NOTPAY_FAIL     -858   // 付款失败

// ACCOUNT_JOINBUY

// ACCOUNT_BIND_MB
#define ERROR_MB_FORMAT -860       // 手机号码格式不正确
#define ERROR_USER_NOT_EXIST -861  // 用户不存在
#define ERROR_MB_BINDED -862       // 该手机号码已被使用
#define ERROR_MB_UNBINDED -863     // 未绑定过手机号
#define ERROR_VCODE_PASSED -864    // 验证码过期
#define ERROR_VCODE_INCORRECT -865 // 验证码错误
#define ERROR_MB_INCORRECT -866    // 用户原始手机号码错误
#define ERROR_MB_UNMATCHING -867   // 和用户绑定的手机号码不相等

#define ERROR_IDCARD_INVAILD -870     // 身份证号码无效
#define ERROR_USER_HAS_CERTIFIED -871 // 用户已经实名过
#define ERROR_NAME_INCORRECT -872     // 用户姓名不规范

#define ERROR_CARD_CANNT_FIND -875 // 输入银行卡错误

#define ERROR_HAD_DACAI_USER    -880    // 已经绑定过大彩用户
#define ERROR_USERNAME_HASUSED  -881    // 用户名已经存在
#define ERROR_USERNAME_FORMAT   -882    // 用户名格式错误
#define ERROR_PASSWORD_FORMAT   -883    // 密码格式错误
#define ERROR_OLD_PASSWORD_ERROR    -884  // 原始密码错误
#define ERROR_UNSET_DRAWPWD   -885  // 未设置过提款密码
#define ERROR_MB_NOT_MATCH  -886    // 手机号码不相符

#define ERROR_REDPKT_PRO_PASS  -890 // 方案已满
#define ERROR_MONEY_OVERFLOW  -891  // 金额超出上限
#define ERROR_ACTIVEPAY_FAIL  -892  // 付款失败

// 注册登录错误码
#define ERROR_LOGIN_FAIL    -1001   // 登录失败
#define ERROR_LOGIN_NAME_PWD -1002  // 用户名或密码错误

#define ERROR_REGISTER_FAIL  -1005  // 注册失败
#define ERROR_PWD_LEN_6_15  -1006   // 密码长度6-15
#define ERROR_USER_EXIST   -1007    // 用户名已存在


#endif
