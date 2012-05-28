// array of open positions as it was on the previous tick
int pre_OrdersArray[][2]; // [amount of positions][ticket #, positions type]
 
// variables of events
int eventBuyClosed_SL  = 0, eventBuyClosed_TP  = 0;
int eventSellClosed_SL = 0, eventSellClosed_TP = 0;
int eventBuyLimitDeleted_Exp  = 0, eventBuyStopDeleted_Exp  = 0;
int eventSellLimitDeleted_Exp = 0, eventSellStopDeleted_Exp = 0;
int eventBuyLimitOpened  = 0, eventBuyStopOpened  = 0;
int eventSellLimitOpened = 0, eventSellStopOpened = 0;
 
void CheckEvents( int magic = 0 )
{
    // flag of the first launch
    static bool first = true;
    // the last error code
    int _GetLastError = 0;
    // total amount of positions
    int _OrdersTotal = OrdersTotal();
    // the amount of positions met the criteria (the current symbol and the specified MagicNumber),
    // as it is on the current tick
    int now_OrdersTotal = 0;
    // the amount of positions met the criteria as on the previous tick
    static int pre_OrdersTotal = 0;
    // array of open positions as of the current tick
    int now_OrdersArray[][2]; // [# in the list][ticket #, position type]
    // the current number of the position in array now_OrdersArray (for searching)
    int now_CurOrder = 0;
    // the current number of the position in array pre_OrdersArray (for searching)
    int pre_CurOrder = 0;
 
    // array for storing the amount of closed positions of each type
    int now_ClosedOrdersArray[6][3]; // [order type][closing type]
    // array for storing the amount of triggered pending orders
    int now_OpenedPendingOrders[4]; // [order type]
 
    // temporary flags
    bool OrderClosed = true, PendingOrderOpened = false;
    // temporary variables
    int ticket = 0, type = -1, close_type = -1;
 
    //zeroize the variables of events
    eventBuyClosed_SL  = 0; eventBuyClosed_TP  = 0;
    eventSellClosed_SL = 0; eventSellClosed_TP = 0;
    eventBuyLimitDeleted_Exp  = 0; eventBuyStopDeleted_Exp  = 0;
    eventSellLimitDeleted_Exp = 0; eventSellStopDeleted_Exp = 0;
    eventBuyLimitOpened  = 0; eventBuyStopOpened  = 0;
    eventSellLimitOpened = 0; eventSellStopOpened = 0;
 
    // change the open positions array size for the current amount
    ArrayResize( now_OrdersArray, MathMax( _OrdersTotal, 1 ) );
    // zeroize the array
    ArrayInitialize( now_OrdersArray, 0.0 );
 
    // zeroize arrays of closed positions and triggered orders
    ArrayInitialize( now_ClosedOrdersArray, 0.0 );
    ArrayInitialize( now_OpenedPendingOrders, 0.0 );
 
    //+------------------------------------------------------------------+
    //| Search in all positions and write in the array only those
    //| meeting the criteria
    //+------------------------------------------------------------------+
    for ( int z = _OrdersTotal - 1; z >= 0; z -- )
    {
        if ( !OrderSelect( z, SELECT_BY_POS ) )
        {
            _GetLastError = GetLastError();
            Print( "OrderSelect( ", z, ", SELECT_BY_POS ) - Error #", _GetLastError );
            continue;
        }
        // Count the amount of orders on the current symbol with the specified MagicNumber
        if ( true ) // OrderMagicNumber() == magic && OrderSymbol() == Symbol() )
        {
            now_OrdersArray[now_OrdersTotal][0] = OrderTicket();
            now_OrdersArray[now_OrdersTotal][1] = OrderType();
            now_OrdersTotal ++;
        }
    }
    // change the open positions array size for the amount of positions meeting the criteria
    ArrayResize( now_OrdersArray, MathMax( now_OrdersTotal, 1 ) );
 
    //+-------------------------------------------------------------------------------------------------+
    //| Search in the list of the previous tick positions and count how many positions have been closed
    //| and pending orders triggered
    //+-------------------------------------------------------------------------------------------------+
    for ( pre_CurOrder = 0; pre_CurOrder < pre_OrdersTotal; pre_CurOrder ++ )
    {
        // memorize the ticket number and the order type
        ticket = pre_OrdersArray[pre_CurOrder][0];
        type   = pre_OrdersArray[pre_CurOrder][1];
        // assume that, if it is a position, it has been closed
        OrderClosed = true;
        // assume that, if it is a pending order, it has not triggered
        PendingOrderOpened = false;
 
        // search in all positions from the current list of open positions
        for ( now_CurOrder = 0; now_CurOrder < now_OrdersTotal; now_CurOrder ++ )
        {
            // if there is a position with such a ticket number in the list,
            if ( ticket == now_OrdersArray[now_CurOrder][0] )
            {
                // it means that the position has not been closed (the order has not been cancelled)
                OrderClosed = false;
 
                // if its type has changed,
                if ( type != now_OrdersArray[now_CurOrder][1] )
                {
                    // it means that it was a pending order and it triggered
                    PendingOrderOpened = true;
                }
                break;
            }
        }
        // if a position has been closed (an order has been cancelled),
        if ( OrderClosed )
        {
            // select it
            if ( !OrderSelect( ticket, SELECT_BY_TICKET ) )
            {
                _GetLastError = GetLastError();
                Print( "OrderSelect( ", ticket, ", SELECT_BY_TICKET ) - Error #", _GetLastError );
                continue;
            }
            // and check HOW the position has been closed (the order has been cancelled):
            if ( type < 2 )
            {
                // Buy and Sell: 0 - manually, 1 - by SL, 2 - by TP
                close_type = 0;
                if ( StringFind( OrderComment(), "[sl]" ) >= 0 ) close_type = 1;
                if ( StringFind( OrderComment(), "[tp]" ) >= 0 ) close_type = 2;
            }
            else
            {
                // Pending orders: 0 - manually, 1 - expiration
                close_type = 0;
                if ( StringFind( OrderComment(), "expiration" ) >= 0 ) close_type = 1;
            }
            
            // and write in the closed orders array that the order of the type 'type' 
            // was closed by close_type
            now_ClosedOrdersArray[type][close_type] ++;
            continue;
        }
        // if a pending order has triggered,
        if ( PendingOrderOpened )
        {
            // write in the triggered orders array that the order of type 'type' triggered
            now_OpenedPendingOrders[type-2] ++;
            continue;
        }
    }
 
    //+--------------------------------------------------------------------------------------------------+
    //| All necessary information has been collected - assign necessary values to the variables of events
    //+--------------------------------------------------------------------------------------------------+
    // if it is not the first launch of the Expert Advisor
    if ( !first )
    {
        // search in all elements of the triggered pending orders array
        for ( type = 2; type < 6; type ++ )
        {
            // if the element is not empty (an order of the type has not triggered), change the variable value
            if ( now_OpenedPendingOrders[type-2] > 0 )
                SetOpenEvent( type );
        }
 
        // search in all elements of the closed positions array
        for ( type = 0; type < 6; type ++ )
        {
            for ( close_type = 0; close_type < 3; close_type ++ )
            {
                // if the element is not empty (a position has been closed), change the variable value
                if ( now_ClosedOrdersArray[type][close_type] > 0 )
                    SetCloseEvent( type, close_type );
            }
        }
    }
    else
    {
        first = false;
    }
 
    //---- save the current positions array in the previous positions array
    ArrayResize( pre_OrdersArray, MathMax( now_OrdersTotal, 1 ) );
    for ( now_CurOrder = 0; now_CurOrder < now_OrdersTotal; now_CurOrder ++ )
    {
        pre_OrdersArray[now_CurOrder][0] = now_OrdersArray[now_CurOrder][0];
        pre_OrdersArray[now_CurOrder][1] = now_OrdersArray[now_CurOrder][1];
    }
    pre_OrdersTotal = now_OrdersTotal;
}
void SetOpenEvent( int SetOpenEvent_type )
{
    switch ( SetOpenEvent_type )
    {
        case OP_BUYLIMIT: eventBuyLimitOpened ++; return(0);
        case OP_BUYSTOP: eventBuyStopOpened ++; return(0);
        case OP_SELLLIMIT: eventSellLimitOpened ++; return(0);
        case OP_SELLSTOP: eventSellStopOpened ++; return(0);
    }
}
void SetCloseEvent( int SetCloseEvent_type, int SetCloseEvent_close_type )
{
    switch ( SetCloseEvent_type )
    {
        case OP_BUY:
        {
            if ( SetCloseEvent_close_type == 1 ) eventBuyClosed_SL ++;
            if ( SetCloseEvent_close_type == 2 ) eventBuyClosed_TP ++;
            return(0);
        }
        case OP_SELL:
        {
            if ( SetCloseEvent_close_type == 1 ) eventSellClosed_SL ++;
            if ( SetCloseEvent_close_type == 2 ) eventSellClosed_TP ++;
            return(0);
        }
        case OP_BUYLIMIT:
        {
            if ( SetCloseEvent_close_type == 1 ) eventBuyLimitDeleted_Exp ++;
            return(0);
        }
        case OP_BUYSTOP:
        {
            if ( SetCloseEvent_close_type == 1 ) eventBuyStopDeleted_Exp ++;
            return(0);
        }
        case OP_SELLLIMIT:
        {
            if ( SetCloseEvent_close_type == 1 ) eventSellLimitDeleted_Exp ++;
            return(0);
        }
        case OP_SELLSTOP:

        {
            if ( SetCloseEvent_close_type == 1 ) eventSellStopDeleted_Exp ++;
            return(0);
        }
    }
}
