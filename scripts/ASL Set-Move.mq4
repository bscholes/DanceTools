#property copyright "what?"
#property link      "who cares!"

//+------------------------------------------------------------------+
//| couldn't recall a fancy comment here                             |
//+------------------------------------------------------------------+
int start()
  {
//----
   int digits   = MarketInfo(Symbol(),MODE_DIGITS);
   double value = NormalizeDouble(WindowPriceOnDropped(),digits);
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=Symbol())
         continue;
      
      RefreshRates();
      
      if(OrderType()==OP_BUY)     
      if(value<Bid)
         OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),White);
      if(OrderType()==OP_SELL)
      if(value>Ask)
         OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),White);      
      if((OrderType()==OP_BUYSTOP) || (OrderType()==OP_BUYLIMIT))     
      if(value<OrderOpenPrice())
         OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),White);   
      if((OrderType()==OP_SELLSTOP) || (OrderType()==OP_SELLLIMIT))
      if(value>OrderOpenPrice())
         OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),White);                  
   }   
   return(0);
  }
//+------------------------------------------------------------------+