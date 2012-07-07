//-----------------------------------------
//+------------------------------------------------------------------+
//| CloseAll.mq4 |
//| m0j1 |
//| |
//+------------------------------------------------------------------+
#property copyright "m0j1"
#property link ""
// #property show_confirm
//+------------------------------------------------------------------+
//| script program start function |
//+------------------------------------------------------------------+
int i,total,err;
int start()
{
  //----
  total = OrdersTotal();
  while(total>0){
    total=OrdersTotal();
    if(OrderSelect(0,SELECT_BY_POS, MODE_TRADES)) {
      if(OrderType()==OP_BUY) {
	OrderClose(OrderTicket(),OrderLots( ),Bid,10,CLR_NONE);
	err=GetLastError();

	while(err==129) {
	  RefreshRates();
	  //Sleep(100);
	  OrderClose(OrderTicket(),OrderLots( ),Bid,10,CLR_NONE);
	  err=GetLastError();
	}
	Print("Buy Error: ",err);
	//Print("Order Buy closed at :",Bid," Order Number: ",OrdersTotal());
      }

      if(OrderType()==OP_SELL) {
	OrderClose(OrderTicket(),OrderLots( ),Ask,10,CLR_NONE);
	err=GetLastError();

	while(err==129) {
	  RefreshRates();
	  //Sleep(100);
	  OrderClose(OrderTicket(),OrderLots( ),Ask,10,CLR_NONE);
	  err=GetLastError();
	} 
	Print("Sell Error: ",err);
	//Print("Order Sell closed at:",Bid," Order Number: ",OrdersTotal());
      }
    } else {
      Print("ERROR SELECTING");
    }
  }
  //----
  return(0);
}
//+------------------------------------------------------------------+

