#property copyright "what?"
#property link      "who cares!"

//+------------------------------------------------------------------+
//| Set Stop Loss on last opened Order                               |
//+------------------------------------------------------------------+
int start()
  {
//----
   int   digits   = MarketInfo(Symbol(), MODE_DIGITS);
   double   value = NormalizeDouble(WindowPriceOnDropped(), digits);
   int lastTicket = LastOpenTicket();

   if(!OrderSelect(lastTicket, SELECT_BY_TICKET, MODE_TRADES))
     return(-1);

   if(OrderSymbol() != Symbol())
     return(-1);
      
   RefreshRates();
      
   if(OrderType()==OP_BUY)     
     if(value<Bid)
       OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),CLR_NONE);

   if(OrderType()==OP_SELL)
     if(value>Ask)
       OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),CLR_NONE);      

   if((OrderType()==OP_BUYSTOP) || (OrderType()==OP_BUYLIMIT))     
     if(value<OrderOpenPrice())
       OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),CLR_NONE);   

   if((OrderType()==OP_SELLSTOP) || (OrderType()==OP_SELLLIMIT)) 
     if(value>OrderOpenPrice())
       OrderModify(OrderTicket(),OrderOpenPrice(),value, OrderTakeProfit(),OrderExpiration(),CLR_NONE);                  

   return(0);
  }
//+------------------------------------------------------------------+


// return ticket of last opened order on this charts currency
int LastOpenTicket() {
    int      pos;
    datetime lastTime  = 0;
    int      lastTicket = -1; // None open.
    for(pos = OrdersTotal()-1; pos >= 0 ; pos--) {
      if ( OrderSelect(pos, SELECT_BY_POS) 
        && OrderSymbol() == Symbol() 
        && OrderOpenTime() > lastTime) {
        lastTime   = OrderOpenTime();
        lastTicket = OrderTicket();
      }
    }

    return(lastTicket);
}

