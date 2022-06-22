//+------------------------------------------------------------------+
//|                                                         soup.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double   distance=3;
input double   tp=34;
input double   sl=4.0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime lastOnOrderExecution;

int OnInit()
{
 return(INIT_SUCCEEDED);
}

  
void OnOrderTimer()
{
     if(distance > sl && distance < tp && tp > sl && Ask - Bid < 1.6)
     {
        double ema = iMA(Symbol(),PERIOD_M1, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
         
         if(Bid > ema)
         {
            OrderSend(Symbol(), OP_BUYSTOP, 0.1, Bid+distance ,1, Bid+sl, Bid+tp,NULL,0,0);
         }
         if(Ask < ema)
         {
            OrderSend(Symbol(), OP_SELLSTOP, 0.1, Ask-distance ,1, Ask-sl, Ask-tp,NULL,0,0);
         }
     }
}



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(TimeCurrent() > lastOnOrderExecution+60)
   {
      OnOrderTimer();
      lastOnOrderExecution =  TimeCurrent();
   }
   
   int TotalOrders = OrdersTotal();
   for(int t = 0; t < TotalOrders; t++)
   {
     if(OrderSelect(t,SELECT_BY_POS) == true)
     { 
        if(TimeCurrent() - OrderOpenTime()>= 20 && (OrderType() == OP_BUY && OrderType() == OP_SELL))
        {
           OrderDelete(OrderTicket());
        }
     }
   }
}
  