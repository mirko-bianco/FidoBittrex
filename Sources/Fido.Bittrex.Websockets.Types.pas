unit Fido.Bittrex.Websockets.Types;

interface

uses
  System.SysUtils,

  Spring,
  Spring.Collections,

  Fido.Web.Client.WebSocket.SignalR.Types,

  Fido.Bittrex.Types,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Deposits.Types,
  Fido.Bittrex.Api.Executions.Types,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.Orders.Types;

type
  TBittrexWebsocketChannel = (Heartbeat, Ticker, Balance, Candle, ConditionalOrder, Deposit, Execution, MarketSummaries, MarketSummary, Order, Orderbook, Tickers, Trade);

  BittrexWebsocketChannels = record
    class function AsString(const Channel: TBittrexWebsocketChannel): string; static;
    class function TickerAsString(const MarketSymbol: string): string; static;
    class function CandleAsString(const MarketSymbol: string; const CandleInterval: TBittrexCandleInterval): string; static;
    class function MarketSummaryAsString(const MarketSymbol: string): string; static;
    class function OrderbookAsString(const MarketSymbol: string; const OrderbookDepth: TBittrexOrderbookDepth): string; static;
    class function TradeAsString(const MarketSymbol: string): string; static;
  end;

  //{"R":{"Success":true,"ErrorCode":null},"I":"1"}
  IBittrexWebsocketAuthenticateResult = interface(IInvokable)
    ['{3E507499-9FE7-4CF9-977E-F0E8D72B8BB4}']

    function R: IChannelResult;
    function I: string;
  end;

  //{"R":true,"I":"2"}
  IBittrexWebsocketIsAuthenticatedResult = interface(IInvokable)
    ['{C5F876A3-6913-41B3-B666-E52BB9B658BE}']

    function R: Boolean;
    function I: string;
  end;

  //{"R":[{"Success":true,"ErrorCode":null},{"Success":true,"ErrorCode":null}],"I":"3"}
  IBittrexWebsocketSubscribeResult = interface(IInvokable)
    ['{D1FDB0D8-F7CD-43F7-ABA0-D1FD5366933F}']

    function R: IReadonlyList<IChannelResult>;
    function I: string;
  end;

  //{"R":[{"Success":true,"ErrorCode":null},{"Success":true,"ErrorCode":null}],"I":"4"}
  IBittrexWebsocketUnsubscribeResult = interface(IBittrexWebsocketSubscribeResult)
    ['{AEC2A156-CEB0-40E8-953B-7B27E517A998}']
  end;

//  {
//    "accountId": "string (uuid)",
//    "sequence": "int",
//    "delta": {
//      "currencySymbol": "string",
//      "total": "number (double)",
//      "available": "number (double)",
//      "updatedAt": "string (date-time)"
//    }
//  }
  IBittrexWebsocketBalance = interface(IInvokable)
    ['{49EED900-5407-4F64-9805-2FF660B8A0E9}']

    function accountId: TGuid;
    function sequence: Integer;
    function Delta: IBittrexBalance;
  end;

//  {
//    "sequence": "int",
//    "marketSymbol": "string",
//    "interval": "string",
//    "delta": {
//      "startsAt": "string (date-time)",
//      "open": "number (double)",
//      "high": "number (double)",
//      "low": "number (double)",
//      "close": "number (double)",
//      "volume": "number (double)",
//      "quoteVolume": "number (double)"
//    }
//  }
  IBittrexWebsocketCandle = interface(IInvokable)
    ['{6F566348-02B4-483A-A5CF-5A8B5579CE7F}']

    function sequence: Integer;
    function marketSymbol: string;
    function interval: string;
    function delta: IBittrexCandle;
  end;

//  {
//    "accountId": "string (uuid)",
//    "sequence": "int",
//    "delta": {
//      "id": "string (uuid)",
//      "marketSymbol": "string",
//      "operand": "string",
//      "triggerPrice": "number (double)",
//      "trailingStopPercent": "number (double)",
//      "createdOrderId": "string (uuid)",
//      "orderToCreate": {
//        "marketSymbol": "string",
//        "direction": "string",
//        "type": "string",
//        "quantity": "number (double)",
//        "ceiling": "number (double)",
//        "limit": "number (double)",
//        "timeInForce": "string",
//        "clientOrderId": "string (uuid)",
//        "useAwards": "boolean"
//      },
//      "orderToCancel": {
//        "type": "string",
//        "id": "string (uuid)"
//      },
//      "clientConditionalOrderId": "string (uuid)",
//      "status": "string",
//      "orderCreationErrorCode": "string",
//      "createdAt": "string (date-time)",
//      "updatedAt": "string (date-time)",
//      "closedAt": "string (date-time)"
//    }
//  }
  IBittrexWebsocketConditionalOrder = interface(IInvokable)
    ['{7A570702-884E-4696-B238-1FFA512768D0}']

    function accountId: TGuid;
    function sequence: Integer;
    function delta: IBittrexConditionalOrder;
  end;

//  {
//    "accountId": "string (uuid)",
//    "sequence": "int",
//    "delta": {
//      "id": "string (uuid)",
//      "currencySymbol": "string",
//      "quantity": "number (double)",
//      "cryptoAddress": "string",
//      "fundsTransferMethodId": "string (uuid)",
//      "cryptoAddressTag": "string",
//      "txId": "string",
//      "confirmations": "integer (int32)",
//      "updatedAt": "string (date-time)",
//      "completedAt": "string (date-time)",
//      "status": "string",
//      "source": "string",
//      "accountId": "string (uuid)",
//      "error": {
//        "code": "string",
//        "detail": "string",
//        "data": "object"
//      }
//    }
//  }
  IBittrexWebsocketDeposit = interface(IInvokable)
    ['{15A5A16D-DFA8-45F1-8BC8-1A28C2F986AB}']

    function accountId: TGuid;
    function sequence: Integer;
    function delta: IBittrexDeposit;
  end;

//  {
//    "accountId": "string (uuid)",
//    "sequence": "int",
//    "deltas": [
//      {
//        "id": "string (uuid)",
//        "marketSymbol": "string",
//        "executedAt": "string (date-time)",
//        "quantity": "number (double)",
//        "rate": "number (double)",
//        "orderId": "string (uuid)",
//        "commission": "number (double)",
//        "isTaker": "boolean"
//      }
//    ]
//  }
  IBittrexWebsocketExecution = interface(IInvokable)
    ['{2EAABB81-513D-4236-BB40-3B33FEEACF2C}']

    function accountId: TGuid;
    function sequence: Integer;
    function deltas: IReadonlyList<IBittrexExecution>;
  end;

//  {
//    "sequence": "int",
//    "deltas": [
//      {
//        "symbol": "string",
//        "high": "number (double)",
//        "low": "number (double)",
//        "volume": "number (double)",
//        "quoteVolume": "number (double)",
//        "percentChange": "number (double)",
//        "updatedAt": "string (date-time)"
//      }
//    ]
//  }
  IBittrexWebsocketMarketSummaries = interface(IInvokable)
    ['{55FD77B1-141E-4902-A103-536983D39816}']

    function sequence: Integer;
    function deltas: IReadonlyList<IBittrexMarketSummary>;
  end;

//  {
//    "accountId": "string (uuid)",
//    "sequence": "int",
//    "delta": {
//      "id": "string (uuid)",
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "limit": "number (double)",
//      "ceiling": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "fillQuantity": "number (double)",
//      "commission": "number (double)",
//      "proceeds": "number (double)",
//      "status": "string",
//      "createdAt": "string (date-time)",
//      "updatedAt": "string (date-time)",
//      "closedAt": "string (date-time)",
//      "orderToCancel": {
//        "type": "string",
//        "id": "string (uuid)"
//      }
//    }
//  }
  IBittrexWebsocketOrder = interface(IInvokable)
    ['{A4DA2E1A-A78F-4D27-AD53-70A7E5436759}']

    function accountId: TGuid;
    function sequence: Integer;
    function delta: IBittrexOrder;
  end;

//  {
//    "marketSymbol": "string",
//    "depth": "int",
//    "sequence": "int",
//    "bidDeltas": [
//      {
//        "quantity": "number (double)",
//        "rate": "number (double)"
//      }
//    ],
//    "askDeltas": [
//      {
//        "quantity": "number (double)",
//        "rate": "number (double)"
//      }
//    ]
//  }
  IBittrexWebsocketOrderBook = interface(IInvokable)
    ['{7D18905D-B8DD-4731-9EEC-99F7676129C1}']

    function marketSymbol: string;
    function depth: Integer;
    function sequence: Integer;
    function bidDeltas: IReadonlyList<IBittrexOrderBookItem>;
    function askDeltas: IReadonlyList<IBittrexOrderBookItem>;
  end;

//  {
//    "sequence": "int",
//      "deltas": [
//          {
//            "symbol": "string",
//            "lastTradeRate": "number (double)",
//            "bidRate": "number (double)",
//            "askRate": "number (double)"
//          }
//        ]
//  }
  IBittrexWebsocketTickers = interface(IInvokable)
    ['{779129AA-6F83-421F-AFC2-F94083F49B60}']

    function sequence: Integer;
    function deltas: IReadonlyList<IBittrexTicker>;
  end;

//  {
//    "sequence": "int",
//    "marketSymbol": "string",
//    "deltas": [
//      {
//        "id": "string (uuid)",
//        "executedAt": "string (date-time)",
//        "quantity": "number (double)",
//        "rate": "number (double)",
//        "takerSide": "string"
//      }
//    ]
//  }
  IBittrexWebsocketTrade = interface(IInvokable)
    ['{35B76734-1DE4-4114-B69A-97A81D1F1CFF}']

    function sequence: Integer;
    function marketSymbol: string;
    function deltas: IReadonlyList<IBittrexTrade>;
  end;

const
  BITTREXWEBSOCKETCHANNELS_S: array[TBittrexWebsocketChannel] of string = ('heartbeat', 'ticker_%s', 'balance', 'candle_%s_%s', 'conditional_order', 'deposit', 'execution', 'market_summaries', 'market_summary_%s', 'order', 'orderbook_%s_%d', 'tickers', 'trade_%s');
  BITTREXWEBSOCKETMESSAGES_S: array[TBittrexWebsocketChannel] of string = ('heartbeat', 'ticker', 'balance', 'candle', 'conditionalOrder', 'deposit', 'execution', 'marketSummaries', 'marketSummary', 'order', 'orderBook', 'tickers', 'trade');
  
implementation

{ BittrexWebsocketChannels }

class function BittrexWebsocketChannels.AsString(const Channel: TBittrexWebsocketChannel): string;
begin
  Result := BITTREXWEBSOCKETCHANNELS_S[Channel];
end;

class function BittrexWebsocketChannels.CandleAsString(const MarketSymbol: string; const CandleInterval: TBittrexCandleInterval): string;
begin
  Result := Format(AsString(TBittrexWebsocketChannel.Candle), [MarketSymbol, BITTREXCANDLEINTERVALS_S[CandleInterval]]);
end;

class function BittrexWebsocketChannels.MarketSummaryAsString(const MarketSymbol: string): string;
begin
  Result := Format(AsString(TBittrexWebsocketChannel.MarketSummary), [MarketSymbol]);
end;

class function BittrexWebsocketChannels.OrderbookAsString(const MarketSymbol: string; const OrderbookDepth: TBittrexOrderbookDepth): string;
begin
  Result := Format(AsString(TBittrexWebsocketChannel.Orderbook), [MarketSymbol, BITTREXORDERBOOKDEPTHS_I[orderbookDepth]]);
end;

class function BittrexWebsocketChannels.TickerAsString(const MarketSymbol: string): string;
begin
  Result := Format(AsString(TBittrexWebsocketChannel.Ticker), [MarketSymbol]);
end;

class function BittrexWebsocketChannels.TradeAsString(const MarketSymbol: string): string;
begin
  Result := Format(AsString(TBittrexWebsocketChannel.Trade), [MarketSymbol]);
end;

end.
