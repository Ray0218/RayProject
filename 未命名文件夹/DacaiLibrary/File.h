//
//  File.h
//  DacaiLibrary
//
//  Created by WUFAN on 14-10-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiLibrary__File__
#define __DacaiLibrary__File__

#include <iostream>
#include <string>

using namespace std;

class CFile {
public:
    static int SaveString(const char *key, const char *value);
    //    static int SecureSaveString(const char *key, const char *value);
    //    static int SaveData(const char *file, const void *data, int len);
    
    //    static int GetSecureString(const char *key, string &string);
    //    int GetFileSize(const char *file);
    //    int GetData(const char *file, void *data, int len);
    static int GetString(const char *key, string &string);
    
protected:
    static string md5OutHex(const unsigned char *v, const int len);
    static string encryptOutBase64(const unsigned char *key, const int len, unsigned char *byte, int inLen);
};

extern const char *g_HomeBuyCacheKey;
extern const char *g_ActiveVersionKey;
extern const char *g_ActiveGUIDKey;
extern const char *g_DeviceTokenKey;
extern const char *g_WebsocketAddrKey;
extern const char *g_LotteryResultKey;

#endif /* defined(__DacaiLibrary__File__) */
