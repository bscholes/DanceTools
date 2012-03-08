//+------------------------------------------------------------------+
//|                                                      TouchMA.mq4 |
//|                                                       Hans Baier |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      ""

//--- input parameters

extern double CatchPips     = 1.5;
extern double StopLoss      = 10.0;
extern bool   Trade10EMA    = false;
extern bool   Trade21EMA    = false;
extern bool   Trade35SMA    = false;
extern bool   Trade50EMA    = false;
extern bool   Trade89EMA    = false;
extern bool   Trade144EMA   = false;
extern bool   Trade200SMA   = false;

int Bars10EMA  = 0;
int Bars21EMA  = 0;
int Bars35SMA  = 0;
int Bars50EMA  = 0;
int Bars89EMA  = 0;
int Bars144EMA  = 0;
int Bars200SMA  = 0;


extern bool   debug = false;

int ticket = 0;

int init() {
   Print("TouchEAAlerter init... happy trading...");
   return(0);
}

int deinit() {
   return(0);
}

int start() {
   double multiplier = 1.0;
   int digits = MarketInfo(Symbol(), MODE_DIGITS);
   if (digits == 5) multiplier = 10.0;
   
   double price  = 0.0;
   double spread = Ask - Bid;
       
      string comment;

      if (Trade35SMA && Bars > Bars35SMA) {
         comment = "Touch35";
         double sma35  = iMA(NULL, 0,  35, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma35, digits);
         Bars35SMA = Bars;
      } 

      if (Trade50EMA && Bars > Bars50EMA) {
         comment = "Touch50";
         double ema50  = iMA(NULL, 0,  50, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema50, digits);
         Bars50EMA = Bars;
      } 

      if (Trade10EMA && Bars > Bars10EMA) {
         comment = "Touch10";
         double ema10  = iMA(NULL, 0,  10, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema10, digits);
         Bars10EMA = Bars;
      } 

      if (Trade21EMA && Bars > Bars21EMA) {
         comment = "Touch21";
         double ema21  = iMA(NULL, 0,  21, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema21, digits);
         Bars21EMA = Bars;
      } 

      if (Trade89EMA && Bars > Bars89EMA) {
         comment = "Touch89";
         double ema89  = iMA(NULL, 0,  89, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema89, digits);
         Bars89EMA = Bars;
      } 

      if (Trade144EMA && Bars > Bars144EMA) {
         comment = "Touch144";
         double ema144 = iMA(NULL, 0, 144, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema144, digits);
         Bars144EMA = Bars;
      } 

      if (Trade200SMA && Bars > Bars200SMA) {
         comment = "Touch200";
         double sma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma200, digits);
         Bars200SMA = Bars;
      } 
            
      if(MathAbs(Bid - price) < CatchPips * Point * multiplier) {
         Alert("PriceAlert " + comment + " on " + Symbol() + " " + Period() + " price: " + price);
      } 
      
      if(debug) {
         //Print("Digits: " + digits + " multiplier: " + multiplier + " Point: " + Point);
         Print("_________________________");
         Print("Spread: " + spread);
         Print("Price MA: " + price);
      }
         
   return(0);
}

