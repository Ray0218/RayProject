//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef INCLUDED_DCHTTP
#define INCLUDED_DCHTTP

#include <string>
#include <map>
#include <vector>

using  namespace  std;

class RSAProvider;

class DCHttpReq
{
public:
    DCHttpReq(bool gzip = false);
    ~DCHttpReq();
public:
    int SetRequestLine(const char *method, const char *url, const char *version);
    int SetHeader(  char * head,   char * value);
    int SetBody(const char * data, int len = -1);
    int SetBodyLen(size_t len);
    int SetBodyLen(int len);
    int OutputHeader( char * buf, int maxlen ) ;
    int OutpuHeader(string * buf);
    int GetBodyLen();
    char *GetBody();
    
protected:
    string  m_method ;
    string  m_url;
    string m_version;
    std::map<string,string> m_headers;
    std::vector<char> m_body;
};

class DCHttpRes {
public:
    DCHttpRes();
    ~DCHttpRes();

public:
    // int ParseHeader(string &data);
    int PushData(const char *data, int len);
    int NewParseHeader(const char *data, int len);

//    int ParseHeader(const char *data, int len);
    int parse_first_line(char *data);
    int parse_head_line(char *data);
    int GetBodyLen();
//    int GetBody(char *data);
    int GetBody(char **p);
    
    void SetRSAProvider(RSAProvider *provider) {
        pRSAProvider = provider;
    }
public:
    int m_bodyLen;

protected:
    string m_method;
    string m_url;
    string m_version;
    std::map<string, string> m_headers;
    std::vector<char> m_body;
    int m_isRequest;
    bool m_status;
    string m_reason;
    std::vector<char> m_recvHead;
    
    bool m_gzip;
    RSAProvider *pRSAProvider;
    
private:
    static char *s_gzip_buff;
    static char *s_rsa_buff;
};

#endif
