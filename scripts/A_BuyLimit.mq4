//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
//#property copyright ""
//#property link      ""


//#property show_inputs

extern double StopLoss = 10;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   double lots = GlobalVariableGet("ordersize");
//----
   int digits   = MarketInfo(Symbol(), MODE_DIGITS);
   double price = NormalizeDouble(WindowPriceOnDropped(), digits);
   double multiplier = 1.0;
   if (digits == 5) multiplier = 10.0;
  
   int ticket=OrderSend(Symbol(), OP_BUYLIMIT, lots, price, 2, price - StopLoss*Point*multiplier, 0, "Touch", 255, 0, CLR_NONE);
   return(0);
  }
//+------------------------------------------------------------------+
