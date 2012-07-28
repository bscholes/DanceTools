//+------------------------------------------------------------------+
//|                                                   ChartServe.mq4 |
//|                                                       Hans Baier |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      ""

extern int TimerInterval = 2000;
extern int ImageWidth    = 1024;
extern int ImageHeight   = 768;

int init() {
   timer();
}

void timer() {

   while(true) {
    Sleep(TimerInterval);

    if(IsStopped() || !IsExpertEnabled()) {
     return;
    }

    RefreshRates();
    start();
   }
}

int start() {
   Comment(StringConcatenate(TimeHour(TimeCurrent()), ":", TimeMinute(TimeCurrent()), ":", TimeSeconds(TimeCurrent())));
   WindowScreenShot(StringConcatenate("chartserve\\", Symbol(), Period(), ".gif"), ImageWidth, ImageHeight);
   Comment("");
}