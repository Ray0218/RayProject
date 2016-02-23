//
//  DPErrorParser.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPErrorParser.h"
#import "FrameWork.h"

@implementation DPErrorParser

+ (NSString *)AccountErrorMsg:(NSInteger)code {
    switch (code) {
        case ERROR_LOGINPASSWD:
            return @"登陆密码错误";
        case ERROR_USERPASSWD:
            return @"用户名登入密码错误";
        case ERROR_HAD_SETPASSWD:
            return @"用户已经设置过提款密码";
        case ERROR_IVALIDECARD:
            return @"卡号不正常";
        
        case ERROR_CARD_BOUNDED:
            return @" 该卡已经被绑定";
        case ERROR_HAD_ADDED:
            return @" 该账户已添加，请勿重复添加";
            // 失败
        case ERROR_USER_UNTOUCH:
            return @"用户未激活";
        case ERROR_ZHIFUBAO_BUSY:
            return @"支付宝提款系统维护中, 请尝试使用银行卡提款";
        case ERROR_MIN5YUAN:
            return @"最少提款为5元";
        case ERROR_AUTHENTICATION:
            return @"请先进行实名制认证";
        case ERROR_DRAWPASSWD:
            return @"提款密码错误";
        case ERROR_DRAWPASSWDUNFORMAT:
            return @"提款密码不符合规范";
        case ERROR_DRAWPASSWDHASSET:
            return @"已经设置过提款密码";
        case ERROR_HASAUTHENTICATION:
            return @"已经实名";
        case ERROR_CANNOTFINDCARD:
            return @"找不到该银行卡";
        case ERROR_INVALIDCARD:
            return @"无效的银行卡";
        case ERROR_LMONEY:
            return @"余额不足";
        case ERROR_SUPPORTCARD:
            return @"不支持该银行卡";
        case ERROR_MIN1YUAN:
            return @"最少提款为1元";
        case ERROR_USERHAS:
            return @"该账户已添加，请勿重复添加";
        case ERROR_CARDHADBIND:
            return @"该卡已经被绑定";
            case ERROR_MOST5:
            return @"银行卡最多添加五条";
        case ERROR_AMT1:
            return @"金额范围10-5000";
//        case ERROR_DIEVICEID:
//            return @"系统繁忙";
        case ERROR_MUSTONEYUAN:
            return @"金额必须为整数且至少1元";
        case ERROR_TOPUP_FAIL:
            return @"充值失败";
        case ERROR_TOPUP_TIMES:
            return @"次数过多";
        case ERROR_UMPAY_AMT:
            return @"充值金额1-5000";
        case ERROR_UMPAY_REAL:
            return @"未实名认证";
        case ERROR_UNIONPAY_AMT:
            return @"充值金额10-2000";
        case ERROR_WECHAT_AMT:
            return @"金额范围为1-1000";
        case ERROR_TENCENT_AMT:
            return @"充值金额 1-1000";
        case ERROR_ALIPAY_AMT:
            return @"充值金额 1-50000";
        case ERROR_FINDPWD_UNBIND:
            return @"用户没有绑定手机";
        case ERROR_USER_BINDED_MD:
            return @"用户已绑定过手机";
        case ERROR_FINDPWD_UNPASS:
            return @" 验证码还未过期 不能重复获取";
        case ERROR_NOTPAY_HANDLED:
            return @"订单已被处理";
        case ERROR_NOTPAY_PASSED:
            return @"订单已过期";
        case ERROR_NOTPAY_NOT_EXIST:
            return @"订单不存在";
        case ERROR_NOTPAY_FAIL:
            return @"付款失败";
        case ERROR_MB_FORMAT:
            return @"手机号码格式不正确";
        case ERROR_USER_NOT_EXIST:
            return @"用户不存在";
        case ERROR_MB_BINDED:
            return @"该手机号码已被使用";
        case ERROR_MB_UNBINDED:
            return @"未绑定过手机号";
        case ERROR_VCODE_PASSED:
            return @"验证码过期";
        case ERROR_VCODE_INCORRECT:
            return @"验证码错误";
        case ERROR_MB_INCORRECT:
            return @"用户原始手机号码错误";
        case ERROR_MB_UNMATCHING:
            return @"和用户绑定的手机号码不相等";
        case ERROR_IDCARD_INVAILD:
            return @"身份证号码无效";
        case ERROR_USER_HAS_CERTIFIED:
            return @"用户已经实名过";
        case ERROR_NAME_INCORRECT:
            return @"用户姓名不规范";
        case ERROR_CARD_CANNT_FIND:
            return @"输入银行卡错误";
        case ERROR_HAD_DACAI_USER:
            return @"已经绑定过大彩用户";
        case ERROR_USERNAME_HASUSED:
            return @"用户名已经存在";
        case ERROR_USERNAME_FORMAT:
            return @"用户名格式错误";
        case ERROR_PASSWORD_FORMAT:
            return @"密码格式错误";
        case ERROR_OLD_PASSWORD_ERROR:
            return @"原始密码错误";
        case ERROR_UNSET_DRAWPWD:
            return @"未设置过提款密码";
        case ERROR_MB_NOT_MATCH:
            return @"手机号码不相符";
        case ERROR_LOGIN_NAME_PWD:
            return @"用户名或密码错误";
        case ERROR_LOGIN_FAIL:
            return @"登录失败";
        case ERROR_REGISTER_FAIL:
            return @"注册失败";
        case ERROR_PWD_LEN_6_15:
            return @"密码长度6-15";
        case ERROR_USER_EXIST:
            return @"用户名已存在";
        case ERROR_REDPKT_PRO_PASS:
            return @"方案已满" ;
        default:
            return ((code <= -800) ? @"系统繁忙, 请稍后在试" : nil);
    }
}

+ (NSString *)CommonErrorMsg:(NSInteger)code {
    switch (code) {
            // 网络错误
        case ERROR_TimeOut:
            return @"请求超时";
        case ERROR_ConnectHostFail:
            return @"连接服务器失败";
        case ERROR_NET:
            return @"网络请求失败";
        case ERROR_CANCEL:
            return nil;
            return @"请求已取消";
        case ERROR_DATA:
            return @"数据异常";
            // 失败
        case ERROR_FAIL:
            return @"失败";
        case ERROR_UNKNOW:
            return @"未知错误";
        case ERROR_CONTENT_EMPTY:
            return @"数据不能为空";
        case ERROR_PARAMETER:
            return @"参数错误";
        case ERROR_RELOGIN:
            return @"登录超时, 请重新登录";
        case ERROR_NOT_LOGIN:
            return @"用户未登录";
        case ERROR_NOT_READY:
            return @"数据未准备完成";
        case ERROR_DUPLICATE_REQ:
            return @"请求重复";
        case ERROR_CHANNEL_NOT_EXIST:
            return @"渠道号不存在";
        case ERROR_SERVER_ERROR: {
            string errorMsg;
            CFrameWork::GetInstance()->GetLastError(errorMsg);
            return [NSString stringWithUTF8String:errorMsg.c_str()];
        }
        case ERROR_SYSTEM_BUSY:
            return @"系统繁忙, 请稍后在试";
        case ERROR_illegalNote:
            return @"非有效注内容";
        case ERROR_InvalidParameter:
            return @"无效参数";
        case ERROR_InvalidTarget:
            return @"无效的目标";
        case ERROR_OUT_Of_BOUNDS:
            return @"参数越界";
        case ERROR_LOAD_FINISH:
            return @"数据已加载完成";
        case ERROR_INVALID_BET:
            return @"投注方式无效";
        case ERROR_PAY_NO_GAMEID:
            return @"未获取到期号";
        case ERROR_PAY_CONTENT:
            return @"投注内容无效";
        default:
            return ((code > -800) ? @"系统繁忙, 请稍后在试" : nil);
    }
}

@end




