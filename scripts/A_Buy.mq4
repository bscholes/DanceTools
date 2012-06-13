//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
//#property copyright ""
//#property link      ""


//#property show_inputs

extern double StopLoss = 10;
extern double TakeProfit = 20;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   if(IsTradeContextBusy()) Alert("Trade context is busy. Please wait");

   double lots = GlobalVariableGet("ordersize");
//----
   int ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,"", GlobalVariableGet("ordermagic"),0,CLR_NONE);

   if (ticket > 0) {
	OrderSelect(ticket,SELECT_BY_TICKET);
	OrderModify(OrderTicket(), OrderOpenPrice(), Ask-StopLoss*Point, Ask+TakeProfit*Point,0,CLR_NONE);
   } else {
     Alert("no order ticket returned!");
   }
	
   return(0);
  }
//+------------------------------------------------------------------+
