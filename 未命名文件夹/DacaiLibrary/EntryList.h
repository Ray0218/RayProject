//
//  EntryList.h
//  DacaiLibrary
//
//  Created by WUFAN on 14-9-13.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  合买大厅、资讯列表
//

#ifndef __DacaiLibrary__EntryList__
#define __DacaiLibrary__EntryList__

#include <iostream>
#include <vector>
#include <string>
#include <limits.h>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "include/json/json.h"

class CTogetherBuyCenter : public CModuleBase, public CNotify {
    
protected:
    typedef struct _ProjectItem {
        int     ProjectId;          // 方案id. e.g. 3330032
        string  UserName;           // 发起人. e.g. "dctest111140"
        string  GameName;           // 彩种. e.g. "14021期"
        string  GameTypeName;       // 彩种. e.g. "双色球"
        int     GameType;           // 彩种id. e.g. 4
        int     TotalAmount;        // 方案总金额. e.g. 200
        int     FollowCount;        // 参与人数. e.g. 4
        int     BuyedTotalAmount;   // 已认购金额. e.g. 156
        int     BuyedTotalRate;     // 认购百分比. e.g. 78
        int     FillTotalRate;      // 保底百分比. e.g. 2
        unsigned char Crown;
        unsigned char Sun;
        unsigned char Moon;
        unsigned char Star;
        _ProjectItem(Json::Value value) {
            string BettingScore = value["BettingScore"].asString(); // 战绩. e.g."0000"
            if (BettingScore.size() == 4) {
                Crown = BettingScore.at(0) - '0';
                Sun   = BettingScore.at(1) - '0';
                Moon  = BettingScore.at(2) - '0';
                Star  = BettingScore.at(3) - '0';
            } else {
                Crown = Sun = Moon = Star = 0;
            }
            
            ProjectId           = value["ProjectId"].asInt();
            UserName            = value["LotteryUserName"].asString();
            GameType            = value["GameTypeId"].asInt();
            GameTypeName        = value["GameTypeName"].asString();
            GameName            = value["GameName"].asString();
            TotalAmount         = value["TotalAmount"].asInt();
            FollowCount         = value["FollowCount"].asInt();
            BuyedTotalAmount    = value["BuyedTotalAmount"].asInt();
            BuyedTotalRate      = value["BuyedTotalRate"].asInt();
            FillTotalRate       = value["FillTotalRate"].asInt();
        }
    } ProjectItem;
    
    int mTotal;     // 总记录条数
    int mGameType;  // 彩种id
    int mSortType;  // 类型  1:跟单进度, 2:实际投注战绩, 3:方案总额, 4:跟单人数
    bool mAesc;     // 是否升序
    string mName;   // 发单人
    
    vector<CTogetherBuyCenter::ProjectItem *> mList;
    
public:
    CTogetherBuyCenter() {
        mTotal = INT_MAX;
        mGameType = 0;
        mSortType = 1;
        mAesc = false;
    }
    ~CTogetherBuyCenter() {
        Clear();
    }
    
public:
    /**
     *  设置请求参数
     *
     *  @param gameType [in]彩种id
     *  @param sortType [in]排序类型  1:跟单进度, 2:实际投注战绩, 3:方案总额, 4:跟单人数
     *  @param aesc     [in]是否升序
     *  @param userName [in]发单人
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetRequestPars(int gameType, int sortType, bool aesc, string userName);
    int Refresh(int reload = false);
    void Clear();
    
    /**
     *  获取合买记录数
     *
     *  @return <0表示失败, >=0表示成功, 即记录数
     */
    size_t GetCount();
    /**
     *  是否有更多数据
     *
     *  @return <0表示失败, >=0表示成功, >0表示有数据
     */
    int HasMoreRecord();
    /**
     *  获取方案信息
     *
     *  @param index       [in]索引
     *  @param userName    [out]发起人
     *  @param gameName    [out]彩种
     *  @param totalAmt    [out]方案总金额
     *  @param followCount [out]跟单人数
     *  @param buyedAmt    [out]已认购金额
     *  @param buyedRate   [out]认购百分比(0~100)   e.g. 43
     *  @param fillRate    [out]保底百分比(-1 ,0~100)   e.g. 12,  -1(表示无保底)
     *  @param crown       [out]积分, 王冠个数
     *  @param sun         [out]积分, 太阳个数
     *  @param moon        [out]积分, 月亮个数
     *  @param star        [out]积分, 星星个数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetProjectInfo(int index, string &userName, string &gameTypeName, string &gameName, int &totalAmt, int &followCount, int &buyedAmt, int &buyedRate, int &fillRate, int &crown, int &sun, int &moon, int &star);
    /**
     *  获取方案金额
     *
     *  @param index    [in]索引
     *  @param totalAmt [out]方案总金额
     *  @param buyedAmt [out]已认购金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetProjectAmount(int index, int &totalAmt, int &buyedAmt);
    /**
     *  获取方案id
     *
     *  @param index     [in]索引
     *  @param projectId [out]方案id
     *  @param gameType  [out]彩种类型
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetProjectId(int index, int &projectId, int &gameType);
    
protected:
    
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyTogetherBuy(DCHttpRes &data, int reload);
};

#define Info_Announcement   0
#define Info_Recommend      1
#define Info_Lottery        2

class CLotteryInfo : public CModuleBase, public CNotify {
public:
    CLotteryInfo() {
    }
    ~CLotteryInfo() {
        Clear();
    }
    
public:
    /**
     *  公告
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshAnnouncement(int reload = false);
    void ClearAnnouncement();
    
    /**
     *  推荐
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshRecommend(int reload = false);
    void ClearRecommend();
    
    /**
     *  设置彩种
     *
     *  @param gameType [in]彩种
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetGameType(int gameType);
    /**
     *  彩种资讯
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshLottery(int reload = false);
    void ClearLottery();
    
    size_t GetAnnouncementCount();
    size_t GetRecommendCount();
    size_t GetLotteryCount();
    
    void Clear();
    
    int GetAnnouncementTarget(int index, string &title, string &time, string &url, int &gameType);
    int GetRecommendTarget(int index, string &title, string &time, string &url, int &gameType);
    int GetLotteryTarget(int index, string &title, string &time, string &url, int &gameType);
    
protected:
    typedef struct _ListItem {
        string Title;
        string Time;
        string URL;
        int GameType;
        
        _ListItem(Json::Value value) {
            Title    = value["Title"].asString();
            Time     = value["Time"].asString();
            URL      = value["Url"].asString();
            GameType = value["GameTypeId"].asInt();
        }
    } ListItem;
    typedef struct _List {
        int                                 Total;
        vector<CLotteryInfo::ListItem *>    List;
        
        _List() {
            Total = INT_MAX;
        }
        
        void Clear() {
            Total = INT_MAX;
            for (int i = 0; i < List.size(); i++) {
                if (List[i]) {
                    delete List[i];
                    List[i] = NULL;
                }
            }
            List.clear();
        }
        
        bool hasMore() {
            return List.size() < Total;
        }
    } List;
    
    int mGameType;
    CLotteryInfo::List mAnnouncement;
    CLotteryInfo::List mRecommend;
    CLotteryInfo::List mLottery;
    
    int _getTarget(CLotteryInfo::List &list, int index, string &title, string &time, string &url, int &gameType);
    
protected:
    
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    int _dealNotifyAnnouncement(DCHttpRes &data, int reload);
    int _dealNotifyRecommend(DCHttpRes &data, int reload);
    int _dealNotifyLottery(DCHttpRes &data, int reload);
    
    int _parseData(CLotteryInfo::List &list, Json::Value &data);
};

#endif /* defined(__DacaiLibrary__EntryList__) */
