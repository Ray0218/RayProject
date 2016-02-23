//
//  SecurityCenter.h
//  DacaiProject
//
//  Created by WUFAN on 14/12/4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  安全中心模块
//

#ifndef __DacaiProject__SecurityCenter__
#define __DacaiProject__SecurityCenter__

#include <stdio.h>
#include "../ModuleBase.h"
#include "../include/json/json.h"
#include "AccountCommon.h"

class CSecurityCenter : virtual public CModuleBase {
public:
    
    /**
     *  异步登录
     *
     *  @param userName [in]用户名
     *  @param password [in]密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Net_Login(const char *userName, const char *password);
    /**
     *  注册
     *
     *  @param userName [in]用户名
     *  @param password [in]密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Net_Reg(const char *userName, const char *password);
    /**
     *  第三方账号登录
     *
     *  @param oauthToken   [in]SDK返回值 QQ:access_token, 微信:code, 新浪微博:token
     *  @param oauthId      [in]SDK返回值 QQ:OpenId, 微信:NULL, 新浪微博:uid
     *  @param oauthType    [in]第三方标识, 6:支付宝, 7:QQ, 9:微信, 2:新浪微博
     *
     *  @callback 已经绑定大彩用户result = 0, 未绑定大彩用户result = 1, 进入绑定/注册流程
     *
     *  @return cmdId
     */
    int Net_OAuthLogin(const char *oauthToken, const char *oauthId, int oauthType);
    
    /**
     *  绑定已有的大彩账户
     *
     *  @param oauthToken    [in]SDK返回值 QQ:access_token, 微信:NULL, 新浪微博:token
     *  @param oauthId       [in]SDK返回值 QQ:OpenId, 微信:NULL, 新浪微博:uid
     *  @param oauthType     [in]第三方标识, 6:支付宝, 7:QQ, 9:微信, 2:新浪微博
     *  @param userName      [in]用户名
     *  @param password      [in]密码
     *
     *  @return cmdId
     */
    int Net_OAuthBindAct(const char *oauthToken, const char *oauthId, int oauthType, const char *userName, const char *password);
    /**
     *  注册大彩账户并绑定
     *
     *  @param oauthToken    [in]SDK返回值 QQ:access_token, 微信:NULL, 新浪微博:token
     *  @param oauthId       [in]SDK返回值 QQ:OpenId, 微信:NULL, 新浪微博:uid
     *  @param oauthType     [in]第三方标识, 6:支付宝, 7:QQ, 9:微信, 2:新浪微博
     *  @param userName      [in]用户名
     *  @param password      [in]密码
     *
     *  @return cmdId
     */
    int Net_OAuthRegAct(const char *oauthToken, const char *oauthId, int oauthType, const char *userName, const char *password);
    
    /**
     *  修改用户名
     *
     *  @param userName [in]用户名
     *
     *  @return cmdId
     */
    int Net_ChangeName(const char *userName);
    /**
     *  修改用户名跟密码
     *
     *  @param userName [in]用户名
     *  @param pwd      [in]密码
     *
     *  @return cmdId
     */
    int Net_ChangeNameAndPwd(const char *userName, const char *pwd);
    
public:
    int GetRegisterAds(string &adsTitle, string &adsURL);
    
protected:
    int _saveSession(Json::Value &value);
    
    int _dealNotifyLogin(DCHttpRes &res);
    int _dealNotifyReg(DCHttpRes &res);
    int _dealNotifyOAuthLogin(DCHttpRes &res);
    int _dealNotifyOAuthBindAct(DCHttpRes &res);
    int _dealNotifyOAuthRegAct(DCHttpRes &res);
    int _dealNotifyChangeName(DCHttpRes &res);
    int _dealNotifyChangeNameAndPwd(DCHttpRes &res);
    
private:
    string mWxToken;
    string mWxOpenId;
    string mRegisterAdsURL;
    string mRegisterAdsTitle;
};

#endif /* defined(__DacaiProject__SecurityCenter__) */
