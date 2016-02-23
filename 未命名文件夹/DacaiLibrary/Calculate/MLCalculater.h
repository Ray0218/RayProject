#ifndef MLCALCULATER_H
#define MLCALCULATER_H

#include "Array.h"
#include "MLAnalyser.h"
#include "aculateType.h"
#include "MLOptions.h"
#include "MLBetCountor.h"
#include "MLMaxBonusCalculater.h"
#include "MLMinBonusCalculater.h"

class MLCalculater
{
    public:
        MLCalculater(Array<MLAnalyser*>* fieldAnalyserArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes);
        virtual ~MLCalculater();
         Int64 GetBetCount();
         double GetMaxBonus();
         double GetMinBonus();
    protected:
    private:

        MLOptions* mlInfos;
        Array<MLAnalyser*>* fieldAnalyserArray;
        Array<int>* gallIndexArray;
        Array<int>* gallRangeArray;
        Array<PassMode*>* passModes;
        Array<Array<int>*>* feildLenArray;
         Array<double>* maxSps;
         Array<double>* minSps;
         Array<int>* hadAllArray;
        void Init();
};

#endif // MLCALCULATER_H
