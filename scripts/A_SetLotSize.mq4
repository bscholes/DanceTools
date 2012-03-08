 
#property show_inputs
 
       double Lots              =          0.01;
       bool   UseMoneyMgmt      =          True;
extern double RiskPercent       =             0.5;
extern double StopLoss          =            10.0;
       string Input             = " Buy Price ";
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start() { 
  double Risk = RiskPercent / 100.0;
  
  double multiplier = 1.0;
  int digits = MarketInfo(Symbol(), MODE_DIGITS);
  if (digits == 5) multiplier = 10.0;
   
  double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE) * multiplier;
  Print("Tick Value: " + tickValue);
  
  if (UseMoneyMgmt) { 
   Lots = NormalizeDouble(AccountBalance() * Risk / StopLoss / tickValue, 2); 
  }
   
  if(Lots > 0) {
   GlobalVariableSet("ordersize", Lots);
   Print("Set LotSize to: " + Lots);
  }
 
   return(0);
}