//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef NETLEVELHEADER
#define  NETLEVELHEADER
#include<string>
#include "ModuleBase.h"
#include "NotifyType.h"

#define HTTP_PATH(path) ((char *)"/v3" path)
#define CONNECTTIMEOUT  10
using  namespace  std;
class WorkSleave{
protected:
    
public:
    WorkSleave(){
        live=0;
    }
    
    pthread_t tid;
    int live;

    virtual int PrepareSend(string &head, string &body) = 0;
    virtual int SendDone(DCHttpRes &res, int tag) = 0;
};

class RSAProvider;
typedef struct SPacket{
    CModuleBase * leader;
    int cmdId;
    void * pd;
    int specialData;
	int Cancel;//主动停止
	int stopTime;//超时时间
    int tag;
    string *head;
    string *body;
    
    char *rawBody;
    int rawLength;
    RSAProvider *pRSAProvider;
    
}SPacket;
int NetInit(char *ip,int port);
int NetSetWebSocketIp(char *ip,int port);//设置websocket ip
int NetUnInit();
int AddSleave(WorkSleave *sleave);
int DelSleave(WorkSleave * sleave);
int NetPushPacket(int specialData,string & head,string& body, CModuleBase *leader,int tag = 0);

/**
 *  http请求, 对post数据进行加密操作
 *
 *  @date 2014/12/24
 *  @author wufan
 */
int NetSafePushPacket(int specialData, const char *uri, const string &origbody, CModuleBase *leader, int tag = 0);

int NetPacketCancel(int cmdId);
void _DelConnect(int socket);
int _NewConnect();
/////////////////;
int WebSocketClose();
int WebSocketConnect(int StopTime);
int GetHttpResult(int sock);
int  WebSockPackRead(unsigned char *temp, int maxlen);
int PackWebSend(unsigned char *source, int len);
void GetTestStr(string & ss);
/////////////////////

#endif
