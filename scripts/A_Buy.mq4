//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
//#property copyright ""
//#property link      ""


//#property show_inputs

extern double StopLoss = 10;
extern double TakeProfit = 100;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
 
   double lots = GlobalVariableGet("ordersize");
//----
 int ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,Ask-StopLoss*Point,Ask+TakeProfit*Point,"",255,0,Green);
   return(0);
  }
//+------------------------------------------------------------------+