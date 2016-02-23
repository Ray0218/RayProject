#ifndef MLANALYSER_H
#define MLANALYSER_H

#include "Array.h"


const int MLAnalyserMaxMinValue=10000000;

class MLAnalyser
{
    public:
        virtual bool IsHadAllOption()=0;

	    virtual int GetGameTypeLen()=0;

	    virtual Array<int>* GetGameTypeOptionLenArray()=0;

	    virtual double GetMaxComSp()=0;

	    virtual double GetMinComSp()=0;
    protected:
    private:
};

/*
class MLAnalyser
{
    public:
        virtual bool IsHadAllOption()
        {return false;}

	    virtual int GetGameTypeLen()
	    {
	      return 0;
	    }

	    virtual Array<int>* GetGameTypeOptionLenArray()
	    {
	        return 0;
        }

	    virtual double GetMaxComSp()
	    {
	       return 0;
	    }

	    virtual double GetMinComSp()
	    {
	      return 0;
	    }
    protected:
    private:
};*/

#endif // MLANALYSER_H
