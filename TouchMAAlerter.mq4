//+------------------------------------------------------------------+
//|                                                      TouchMA.mq4 |
//|                                                       Hans Baier |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      ""

//--- input parameters

extern double CatchPips     = 3;
extern bool   Trade5EMA     = false;
extern bool   Trade10EMA    = true;
extern bool   Trade21EMA    = false;
extern bool   Trade35SMA    = true;
extern bool   Trade50EMA    = true;
extern bool   Trade89EMA    = true;
extern bool   Trade144EMA   = true;
extern bool   Trade200SMA   = true;

int Bars5EMA  = 0;
int Bars10EMA  = 0;
int Bars21EMA  = 0;
int Bars35SMA  = 0;
int Bars50EMA  = 0;
int Bars89EMA  = 0;
int Bars144EMA  = 0;
int Bars200SMA  = 0;


extern bool   debug = true;


double multiplier = 1.0;
int digits;

int init() {
   digits = MarketInfo(Symbol(), MODE_DIGITS);
   if (digits == 5) multiplier = 10.0;
   Print("TouchEAAlerter init... happy trading...");

   return(0);
}

int deinit() {
   return(0);
}

int start() {
   

   
   double price  = 0.0;
   double spread = Ask - Bid;
       
      string comment;

      if (Trade5EMA && Bars > Bars5EMA) {
         comment = "Touch5";
         double ema5  = iMA(NULL, 0,  5, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema5, digits);
         Bars5EMA = checkTouch(price, comment);
      } 

      if (Trade10EMA && Bars > Bars10EMA) {
         comment = "Touch10";
         double ema10  = iMA(NULL, 0,  10, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema10, digits);
         Bars10EMA = checkTouch(price, comment);
      } 

      if (Trade21EMA && Bars > Bars21EMA) {
         comment = "Touch21";
         double ema21  = iMA(NULL, 0,  21, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema21, digits);
         Bars21EMA = checkTouch(price, comment);
      } 

      if (Trade35SMA && Bars > Bars35SMA) {
         comment = "Touch35";
         double sma35  = iMA(NULL, 0,  35, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma35, digits);
         Bars35SMA = checkTouch(price, comment);
      } 

      if (Trade50EMA && Bars > Bars50EMA) {
         comment = "Touch50";
         double ema50  = iMA(NULL, 0,  50, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema50, digits);
         Bars50EMA = checkTouch(price, comment);
      } 

      if (Trade89EMA && Bars > Bars89EMA) {
         comment = "Touch89";
         double ema89  = iMA(NULL, 0,  89, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema89, digits);
         Bars89EMA = checkTouch(price, comment);
      } 

      if (Trade144EMA && Bars > Bars144EMA) {
         comment = "Touch144";
         double ema144 = iMA(NULL, 0, 144, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema144, digits);
         Bars144EMA = checkTouch(price, comment);
      } 

      if (Trade200SMA && Bars > Bars200SMA) {
         comment = "Touch200";
         double sma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma200, digits);
         Bars200SMA = checkTouch(price, comment);
      } 
      
      if(debug) {
         //Print("Digits: " + digits + " multiplier: " + multiplier + " Point: " + Point);
         Print("_________________________");
         Print("Spread: " + spread);
         Print("Bid Price: " + Bid);
         Print("Price MA: " + price);
         Print("comment" + comment);
      }
         
   return(0);
}

int checkTouch(double price, string comment) {
      if (debug) {
         Print("Bars" + Bars);
         Print(comment + " " + Bars10EMA);
      }
      double distance = MathAbs(Bid - price);
      if(distance < CatchPips * Point * multiplier) {
         distance /= Point * multiplier;
         Alert("PriceAlert " + comment + " on " + Symbol() + " " + Period() + " price: " + price + " distance " + distance);
         return(Bars);
      } 
      
      return(0);
}

