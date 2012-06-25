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
extern bool WriteScreenshots = true;

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
	Screenshot("Entry");
   } else {
     Alert("no order ticket returned!");
   }
	
   return(0);
  }

//+------------------------------------------------------------------+
void Screenshot(string moment_name)
{
    if ( WriteScreenshots )
        WindowScreenShot(WindowExpertName()+"_"+Symbol()+"_M"+Period()+"_"+
                         Year()+"-"+two_digits(Month())+"-"+two_digits(Day())+"_"+
                         two_digits(Hour())+"-"+two_digits(Minute())+"-"+two_digits(Seconds())+"_"+
                         moment_name+".gif", 1024, 768);
}

string two_digits(int i)
{
    if (i < 10)
        return ("0"+i);
    else
        return (""+i);
}
