//+------------------------------------------------------------------+
//|                                                      TouchMA.mq4 |
//|                                                       Hans Baier |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      ""

//--- input parameters
extern bool   Long          = true;

extern double CatchPips     = 1.5;
extern double StopLoss      = 10.0;
extern bool   Trade10EMA    = false;
extern bool   Trade21EMA    = false;
extern bool   Trade35SMA    = false;
extern bool   Trade50EMA    = false;
extern bool   Trade89EMA    = false;
extern bool   Trade144EMA   = false;
extern bool   Trade200SMA   = false;

extern bool   debug = false;

int ticket = 0;

int init() {
   Print("TouchEA init... good trading...");
   return(0);
}

int deinit() {
   return(0);
}

int start() {
   double multiplier = 1.0;
   int digits = MarketInfo(Symbol(), MODE_DIGITS);
   if (digits == 5) multiplier = 10.0;
   
   double lots   = GlobalVariableGet("ordersize");
   double price  = 0.0;
   double spread = Ask - Bid;
    
   if (OrdersTotal() == 0) {
         ticket = 0;
   }
   
   if (debug) Print("ticket: " + ticket);
   
   if(ticket == 0) {      
      string comment;
      if (Trade35SMA) {
         comment = "Touch35";
         double sma35  = iMA(NULL, 0,  35, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma35, digits);
      } else if (Trade50EMA) {
         comment = "Touch50";
         double ema50  = iMA(NULL, 0,  50, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema50, digits);
      } else if (Trade10EMA) {
         comment = "Touch10";
         double ema10  = iMA(NULL, 0,  10, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema10, digits);
      } else if (Trade21EMA) {
         comment = "Touch21";
         double ema21  = iMA(NULL, 0,  21, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema21, digits);
      } else if (Trade89EMA) {
         comment = "Touch89";
         double ema89  = iMA(NULL, 0,  89, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema89, digits);
      } else if (Trade144EMA) {
         comment = "Touch144";
         double ema144 = iMA(NULL, 0, 144, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema144, digits);
      } else if (Trade200SMA) {
         comment = "Touch200";
         double sma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma200, digits);
      } 
      
      int    cmd;
      double stop;
      double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
      
      if(MathAbs(Bid - price) < CatchPips * Point * multiplier) {
         if(Long) {
            cmd = OP_BUY;
            price = Ask;
            stop = price - StopLoss * Point * multiplier; 
            PlaySound("analyze buy.wav");
         } else {
            cmd = OP_SELL;
            price = Bid;
            stop = price + StopLoss * Point * multiplier;
            PlaySound("analyze sell.wav");
         }
         Sleep(2000); // to let the sound play
      } else {
         return(0);
      }
      
      stop  = NormalizeDouble(stop, digits);
      
      if(debug) {
         //Print("Digits: " + digits + " multiplier: " + multiplier + " Point: " + Point);
         Print("_________________________");
         Print("Spread: " + spread);
         Print("Price MA: " + price);
         Print("Price Order: " + price);
         Print("Stop loss:" + stop);
         Print("StopLevel: " + stopLevel);
      }
      
      ticket=OrderSend(Symbol(), cmd, lots, price, 1 * Point * multiplier, stop, 0, comment, 255, 0, CLR_NONE);
      int err=GetLastError();
      if (err != 0) ticket = 0;
   } else if(ticket > 0) {
         if(OrderSelect(ticket, SELECT_BY_TICKET)) {
            double stopLoss = OrderStopLoss();
            if(stopLoss == 0.0) {
               if(OrderType()==OP_BUY) {    
                  stopLoss = NormalizeDouble(OrderOpenPrice() - StopLoss * Point * multiplier, digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), OrderExpiration(), CLR_NONE);
               }
               
               if(OrderType()==OP_SELL) {
                  stopLoss = NormalizeDouble(OrderOpenPrice() + StopLoss * Point * multiplier, digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), OrderExpiration(), CLR_NONE);
               }
            }
         }
      }
   
   return(0);
}

