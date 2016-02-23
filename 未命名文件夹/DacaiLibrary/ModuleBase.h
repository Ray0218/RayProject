//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef MODULEBASE
#define MODULEBASE
#include "DcHttp.h"
#include <string>
#include <unistd.h>

using namespace std;

#include <pthread.h>
typedef enum _ReadTab {
    Prepare = 0,
    Ready
} ReadTab;

class CModuleBase {
    friend class ModuleGuide;

protected:
    int m_moduleType;
    ReadTab m_ready;
    pthread_mutex_t m_mutex;

public:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag) = 0;
    CModuleBase() {
        m_ready = Ready;
        pthread_mutex_init(&m_mutex, NULL);
        return;
    };
    virtual ~CModuleBase() {
    }
    void SetReadySafely(ReadTab tab) {
        pthread_mutex_lock(&m_mutex);
        this->m_ready = tab;
        pthread_mutex_unlock(&m_mutex);
    }
    ReadTab GetReadyTab() {
        return m_ready;
    }
    int _Enter() {
        /*for(int i=0;i<10;i++){
        pthread_mutex_lock(&m_mutex);
	if(this->m_ready==Ready){
	return 0;
	}
	pthread_mutex_unlock(&m_mutex);
	usleep(1000);
	}
	return -22;*/
        return 0;
    }
    void _Leave() {
        //  pthread_mutex_unlock(&m_mutex);
    }
};
class ModuleGuide {
public:
    ModuleGuide(CModuleBase *para) {
        sucess = 0;
        this->me = para;
        for (int i = 0; i < 10; i++) {
            pthread_mutex_lock(&me->m_mutex);
            if (me->m_ready == Ready) {
                sucess = 1;
                return;
            }
            pthread_mutex_unlock(&me->m_mutex);
            usleep(1000);
        }
        sucess = 0;
    }

    ~ModuleGuide() {
        if (sucess == 1) {
            pthread_mutex_unlock(&me->m_mutex);
        }
        return;
    }

public:
    int sucess;

protected:
    CModuleBase *me;
};
#endif
