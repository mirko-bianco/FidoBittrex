program BittrexExample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Variants,
  Spring,
  Spring.Container,
  Spring.Collections,
  Fido.Utilities,
  Fido.Boxes,
  Fido.JSON.Marshalling,
  Fido.Functional,
  Fido.Functional.Tries,
  Fido.Functional.Retries,
  Fido.Web.Client.WebSocket.Intf,
  Fido.Web.Client.WebSocket,
  Fido.Web.Client.WebSocket.TcpClient,
  Fido.Web.Client.WebSocket.TcpClient.Intf,
  Fido.Web.Client.WebSocket.SignalR.Types,
  Fido.Bittrex.Registration,
  Fido.Bittrex.Intf,
  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Api.Entities,
  Fido.Bittrex.Websockets.Types,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Withdrawals.Types;

const
  APISECRET = 'YOUR_API_SECRET';
  APIKEY = 'YOUR_API_KEY';

var
  Container: IShared<TContainer>;
  Channels: TArray<string>;
  Bittrex: IBittrex;
  SignalRMethodResult: TSignalRMethodResult;
begin
  ReportMemoryLeaksOnShutdown := True;

  Container := Shared.Make(TContainer.Create);

  Container.RegisterType<TWebSocketIdTCPClient>;
  Container.RegisterType<IWebSocketTCPClient, TWebSocketTCPClient>;
  Container.RegisterType<IWebSocketClient, TWebSocketClient>;

  Register(Container, APISECRET, APIKEY);

  container.Build;

  Bittrex := Container.Resolve<IBittrex>;

  Bittrex.SetOnWebsocketHeartBeat(procedure
    begin
      Writeln('Heartbeat');
    end);

  Bittrex.SetOnWebsocketTicker(procedure(const Ticker: IBittrexTicker)
    begin
      Writeln('Ticker: ', JSONMarshaller.From(Ticker));
    end);

  Bittrex.SetOnWebsocketCandle(procedure(const Candle: IBittrexWebsocketCandle)
    begin
      Writeln('Candle: ', JSONMarshaller.From(Candle));
    end);

  Bittrex.SetOnWebsocketConditionalOrder(procedure(const ConditionalOrder: IBittrexWebsocketConditionalOrder)
    begin
      Writeln('ConditionalOrder: ', JSONMarshaller.From(ConditionalOrder));
    end);

  Bittrex.SetOnWebsocketDeposit(procedure(const Deposit: IBittrexWebsocketDeposit)
    begin
      Writeln('Deposit: ', JSONMarshaller.From(Deposit));
    end);

  Bittrex.SetOnWebsocketExecution(procedure(const Execution: IBittrexWebsocketExecution)
    begin
      Writeln('Execution: ', JSONMarshaller.From(Execution));
    end);

  Bittrex.SetOnWebsocketMarketSummaries(procedure(const MarketSummaries: IBittrexWebsocketMarketSummaries)
    begin
      Writeln('MarketSummaries: ', JSONMarshaller.From(MarketSummaries));
    end);

  Bittrex.SetOnWebsocketMarketSummary(procedure(const MarketSummary: IBittrexMarketSummary)
    begin
      Writeln('MarketSummary: ', JSONMarshaller.From(MarketSummary));
    end);

  Bittrex.SetOnWebsocketOrder(procedure(const Order: IBittrexWebsocketOrder)
    begin
      Writeln('Order: ', JSONMarshaller.From(Order));
    end);

  Bittrex.SetOnWebsocketOrderBook(procedure(const OrderBook: IBittrexWebsocketOrderBook)
    begin
      Writeln('OrderBook: ', JSONMarshaller.From(OrderBook));
    end);

  Bittrex.SetOnWebsocketTickers(procedure(const Tickers: IBittrexWebsocketTickers)
    begin
      Writeln('Tickers: ', JSONMarshaller.From(Tickers));
    end);

  Bittrex.SetOnWebsocketTrade(procedure(const Trade: IBittrexWebsocketTrade)
    begin
      Writeln('Trade: ', JSONMarshaller.From(Trade));
    end);

  try
    Bittrex.StartWebsocket;

    SignalRMethodResult := Bittrex.AuthenticateWebsocket;
    if not SignalRMethodResult.Success then
    begin
      Writeln('Cannot authenticate to Bittrex: ', SignalRMethodResult.ErrorMessage);
      Exit;
    end;

    Channels := [
      BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Heartbeat)
      ,BittrexWebsocketChannels.TickerAsString('BTC-USD')
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Balance)
      ,BittrexWebsocketChannels.CandleAsString('BTC-USD', MINUTE_1)
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.ConditionalOrder)
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Deposit)
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Execution)
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.MarketSummaries)
      ,BittrexWebsocketChannels.MarketSummaryAsString('BTC-USD')
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Order)
      ,BittrexWebsocketChannels.OrderbookAsString('BTC-USD', Depth25)
      ,BittrexWebsocketChannels.AsString(TBittrexWebsocketChannel.Tickers)
      ,BittrexWebsocketChannels.TradeAsString('BTC-USD')
      ];

    SignalRMethodResult := Bittrex.SubscribeWebsocketTo(Channels);
    if not SignalRMethodResult.Success then
    begin
      Writeln('Cannot subscribe: ', SignalRMethodResult.ErrorMessage);
      Exit;
    end;

    Readln;

    SignalRMethodResult := Bittrex.UnsubscribeWebsocketFrom(Channels);
    if not SignalRMethodResult.Success then
    begin
      Writeln('Cannot unsubscribe: ', SignalRMethodResult.ErrorMessage);
      Exit;
    end;
    Sleep(100);

    Bittrex.StopWebsocket;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
