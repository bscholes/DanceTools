//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
//#property copyright ""
//#property link      ""


//#property show_inputs

extern double StopLoss = 120;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   double lots = GlobalVariableGet("ordersize");
//----
   int digits   = MarketInfo(Symbol(), MODE_DIGITS);
   double price = NormalizeDouble(WindowPriceOnDropped(), digits);
  
   int ticket=OrderSend(Symbol(), OP_BUYLIMIT, lots, price, 2, price - StopLoss*Point, 0, "", GlobalVariableGet("ordermagic"), 0, CLR_NONE);
   return(0);
  }
//+------------------------------------------------------------------+
