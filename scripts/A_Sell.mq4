//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
//#property copyright ""
//#property link      ""


//#property show_inputs

extern double StopLoss = 19;
extern double TakeProfit = 100;


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   double lots = GlobalVariableGet("ordersize");
//----
 int ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,Bid+StopLoss*Point,Bid-TakeProfit*Point,"",255,0,Green);
   return(0);
  }
//+------------------------------------------------------------------+