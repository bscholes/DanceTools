//+------------------------------------------------------------------+
//|                                                     BarAlert.mq4 |
//|                                                       Hans Baier |
//|                                         http://www.hans-baier.de |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      "http://www.hans-baier.de"

#property indicator_chart_window

int lastBar = 0;

int init()
  {
   return(0);
  }
  
int deinit()
  {
   return(0);
  }

int start()
  {
   if (Bars > lastBar) {
      Alert("New Bar on " + Symbol() + " " + Period());
      lastBar = Bars;
   }
   return(0);
  }

