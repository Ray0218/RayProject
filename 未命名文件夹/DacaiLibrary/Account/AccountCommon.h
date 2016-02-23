//
//  AccountCommon.h
//  DacaiProject
//
//  Created by WUFAN on 14/12/3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __ACCOUNTCOMMON_H__
#define __ACCOUNTCOMMON_H__

#include <stdio.h>
#include "../Error.h"

#define ACCOUNT_LOGIN 0        // 登录
#define ACCOUNT_REG 1          // 注册
#define ACCOUNT_REF_INFO 2     // 获取账户信息
#define ACCOUNT_REF_BIND 3     // 获取绑定信息(手机, 身份证, 提款密码)
#define ACCOUNT_REF_DRAW 4     // 获取提款信息(提款账户)
#define ACCOUNT_REF_BUY 5      // 获取购彩记录
#define ACCOUNT_REF_FUND 15    // 获取资金明细
#define ACCOUNT_BIND_ID 6      // 绑定身份证
#define ACCOUNT_CHK_MB 7       // 验证是否是已经绑定过的手机号
#define ACCOUNT_SEND_SMS 8     // 获取验证码
#define ACCOUNT_MODIFY_PHONE 60     // 修改已绑定的手机号
#define ACCOUNT_MODIFY_LOGIN_PWD   61     // 修改手机号
#define ACCOUNT_MODIFY_DRAW_PWD 63  // 修改提款密码
#define ACCOUNT_BIND_MB 9      // 绑定手机号
#define ACCOUNT_OAUTH_LOGIN  70   // 第三方登录
#define ACCOUNT_OAUTH_REG   10      //第三方绑定注册
#define ACCOUNT_OAUTH_BIND  11      //第三方绑定

#define ACCOUNT_SET_DRAWPWD 12      //设置取款密码
#define ACCOUNT_GETPROVINCE 13      //获取省份信息
#define ACCOUNT_GETCITY     14      //获取城市信息
#define ACCOUNT_DRAWBANK    16      //获取提款银行卡信息
#define ACCOUNT_BANKNAME    17      //转换卡号 开户行
#define ACCOUNT_CHARGE      18      //获取手续费
#define ACCOUNT_DRAWMONEY1 19  //提款动作
#define ACCOUNT_DRAWMONEY2 20  //提款动作
#define ACCOUNT_DRAWMONEY3 21  //提款动作
#define ACCOUNT_DRAWMONEY4 22  //提款动作
#define ACCOUNT_DRAWMONEY5 23  //提款动作
#define ACCOUNT_DRAWMONEY6 24  //提款动作

#define ACCOUNT_WECHATTOPUP 25     //微信在线充值
#define ACCOUNT_PAYUNIONPAY 26     //银联充值
#define ACCOUNT_PAYTENCENT 27      //财付通
#define ACCOUNT_PAYALIPAY 28       //支付宝sdk
#define ACCOUNT_RED_PACKET 35      // 红包数
#define ACCOUNT_RED_PACKET_LIST 36 // 个人中户红包列表
#define ACCOUNT_LL_BANK_LIST    37  // 连连银行列表
#define ACCOUNT_LL_TOPUP        38  // 连连获取token
#define ACCOUNT_UMPAY_TOPUP     39  // U付获取token

#define ACCOUNT_JOINBUY 45 // 跟单
#define ACCOUNT_NOT_HANDLE_PAY 46  // 未支付
#define ACCOUNT_EXCHANGE_PACKAGE  47 //

#define ACCOUNT_FINDPWD_GETCODE 50  // 找回密码
#define ACCOUNT_FINDPWD_CHKCODE 51  // 验证验证码
#define ACCOUNT_FINDPWD_SETPWD  52  // 设置新密码
#define ACCOUNT_NOTPAY_GENREDIS 53  // 未支付, 生成web使用的token

#define ACCOUNT_ACTIVE_CONFIRMPAY  54 // 未支付激活订单

#define ACCOUNT_CHANGE_NAME     57  // 修改用户名
#define ACCOUNT_CHANGE_NAMEPWD  58  // 修改用户名密码

#define ACCOUNT_RECORD_MAX 200




#endif