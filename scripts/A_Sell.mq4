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
 int ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,"",255,0,CLR_NONE);

   if (ticket > 0) {
	OrderSelect(ticket,SELECT_BY_TICKET);
	OrderModify(OrderTicket(), OrderOpenPrice(), Bid+StopLoss*Point, Bid-TakeProfit*Point,0,CLR_NONE);
   } else {
     Alert("no order ticket returned!");
   }
   return(0);
  }
//+------------------------------------------------------------------+
