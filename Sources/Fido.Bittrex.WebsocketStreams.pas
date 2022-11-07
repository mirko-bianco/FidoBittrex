unit Fido.Bittrex.WebsocketStreams;

interface

uses
  System.SysUtils,

  Spring.Collections,

  Fido.Utilities,
  Fido.Functional,
  Fido.Functional.Retries,

  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Intf,
  Fido.Bittrex.Websockets.Intf,

  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Api.Account.Types,
  Fido.Bittrex.Websockets.Types,

  Fido.Bittrex.WebsocketStream.Intf,
  Fido.Bittrex.WebsocketStream;

type
  BittrexWebsocketStreams = record
    class function Tickers(const Bittrex: IBittrex; const OnUpdatedData: TOnUpdatedData<IBittrexTicker>): IBittrexWebsocketStream<IBittrexWebsocketTickers, IBittrexTicker>; static;
    class function Balances(const Bittrex: IBittrex; const OnUpdatedData: TOnUpdatedData<IBittrexBalance>): IBittrexWebsocketStream<IBittrexWebsocketBalance, IBittrexBalance>; static;
    class function ConditionalOrders(const Bittrex: IBittrex; const OnUpdatedData: TOnUpdatedData<IBittrexConditionalOrder>): IBittrexWebsocketStream<IBittrexWebsocketConditionalOrder, IBittrexConditionalOrder>; static;
    class function Orders(const Bittrex: IBittrex; const OnUpdatedData: TOnUpdatedData<IBittrexOrder>): IBittrexWebsocketStream<IBittrexWebsocketOrder, IBittrexOrder>; static;
    class function Candles(const Bittrex: IBittrex; const OnUpdatedCandle: TOnUpdatedCandles): IBittrexWebsocketCandleStream; static;
  end;

implementation

{ BittrexWebsocketStreams }

class function BittrexWebsocketStreams.Balances(
  const Bittrex: IBittrex;
  const OnUpdatedData: TOnUpdatedData<IBittrexBalance>): IBittrexWebsocketStream<IBittrexWebsocketBalance, IBittrexBalance>;
begin
  Result := TBittrexWebsocketStream<IBittrexWebsocketBalance, IBittrexBalance>.Create(
    Bittrex,
    procedure(const Bittrex: IBittrex; const OnReceivedData: TOnReceivedData<IBittrexWebsocketBalance>)
    begin
      Bittrex.SetOnWebsocketBalance(TBittrexOnWebsocketBalance(OnReceivedData));
    end,
    procedure(const Data: IReadOnlyList<IBittrexBalance>; const Delta: IReadOnlyList<IBittrexBalance>)
    begin
      try
        OnUpdatedData(Data, Delta);
      except
      end;
    end,
    function(const Data: IBittrexWebsocketBalance): Integer
    begin
      Result := Data.sequence;
    end,
    function(const Data: IBittrexWebsocketBalance): IReadonlyList<IBittrexBalance>
    begin
      Result := TCollections.CreateList<IBittrexBalance>([Data.delta]).AsReadOnly;
    end,
    procedure(const Map: IDictionary<string, IBittrexBalance>; const Item: IBittrexBalance)
    begin
      Map[Item.currencySymbol] := Item;
    end,
    function: TSequencedResult<IReadonlyList<IBittrexBalance>>
    begin
      Result := Retry<void>.New(Void.Get).Map<TSequencedResult<IReadonlyList<IBittrexBalance>>>(function(const Value: Void): TSequencedResult<IReadonlyList<IBittrexBalance>>
        begin
          Result := Bittrex.Balances;
        end,
        function(const E: Exception): Boolean
        begin
          Result := E.InheritsFrom(EBittrexApiServiceUnavailable);
        end);
    end);
end;

class function BittrexWebsocketStreams.Candles(
  const Bittrex: IBittrex;
  const OnUpdatedCandle: TOnUpdatedCandles): IBittrexWebsocketCandleStream;
begin
  Result := TBittrexWebsocketCandleStream.Create(Bittrex, OnUpdatedCandle);
end;

class function BittrexWebsocketStreams.ConditionalOrders(
  const Bittrex: IBittrex;
  const OnUpdatedData: TOnUpdatedData<IBittrexConditionalOrder>): IBittrexWebsocketStream<IBittrexWebsocketConditionalOrder, IBittrexConditionalOrder>;
begin
  Result := TBittrexWebsocketStream<IBittrexWebsocketConditionalOrder, IBittrexConditionalOrder>.Create(
    Bittrex,
    procedure(const Bittrex: IBittrex; const OnReceivedData: TOnReceivedData<IBittrexWebsocketConditionalOrder>)
    begin
      Bittrex.SetOnWebsocketConditionalOrder(TBittrexOnWebsocketConditionalOrder(OnReceivedData));
    end,
    procedure(const Data: IReadOnlyList<IBittrexConditionalOrder>; const Delta: IReadOnlyList<IBittrexConditionalOrder>)
    begin
      try
        OnUpdatedData(Data, Delta);
      except
      end;
    end,
    function(const Data: IBittrexWebsocketConditionalOrder): Integer
    begin
      Result := Data.sequence;
    end,
    function(const Data: IBittrexWebsocketConditionalOrder): IReadonlyList<IBittrexConditionalOrder>
    begin
      Result := TCollections.CreateList<IBittrexConditionalOrder>([Data.delta]).AsReadOnly;
    end,
    procedure(const Map: IDictionary<string, IBittrexConditionalOrder>; const Item: IBittrexConditionalOrder)
    begin
      Map[Item.id.ToString] := Item;
    end,
    function: TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>
    begin
      Result := Retry<void>.New(Void.Get).Map<TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>>(function(const Value: Void): TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>
        begin
          Result := Bittrex.OpenConditionalOrders;
        end,
        function(const E: Exception): Boolean
        begin
          Result := E.InheritsFrom(EBittrexApiServiceUnavailable);
        end);
    end);
end;

class function BittrexWebsocketStreams.Orders(
  const Bittrex: IBittrex;
  const OnUpdatedData: TOnUpdatedData<IBittrexOrder>): IBittrexWebsocketStream<IBittrexWebsocketOrder, IBittrexOrder>;
begin
  Result := TBittrexWebsocketStream<IBittrexWebsocketOrder, IBittrexOrder>.Create(
    Bittrex,
    procedure(const Bittrex: IBittrex; const OnReceivedData: TOnReceivedData<IBittrexWebsocketOrder>)
    begin
      Bittrex.SetOnWebsocketOrder(TBittrexOnWebsocketOrder(OnReceivedData));
    end,
    procedure(const Data: IReadOnlyList<IBittrexOrder>; const Delta: IReadOnlyList<IBittrexOrder>)
    begin
      try
        OnUpdatedData(Data, Delta);
      except
      end;
    end,
    function(const Data: IBittrexWebsocketOrder): Integer
    begin
      Result := Data.sequence;
    end,
    function(const Data: IBittrexWebsocketOrder): IReadonlyList<IBittrexOrder>
    begin
      Result := TCollections.CreateList<IBittrexOrder>([Data.delta]).AsReadOnly;
    end,
    procedure(const Map: IDictionary<string, IBittrexOrder>; const Item: IBittrexOrder)
    begin
      Map[Item.id.ToString] := Item;
    end,
    function: TSequencedResult<IReadonlyList<IBittrexOrder>>
    begin
      Result := Retry<void>.New(Void.Get).Map<TSequencedResult<IReadonlyList<IBittrexOrder>>>(function(const Value: Void): TSequencedResult<IReadonlyList<IBittrexOrder>>
        begin
          Result := Bittrex.OpenOrders;
        end,
        function(const E: Exception): Boolean
        begin
          Result := E.InheritsFrom(EBittrexApiServiceUnavailable);
        end);
    end);
end;

class function BittrexWebsocketStreams.Tickers(
  const Bittrex: IBittrex;
  const OnUpdatedData: TOnUpdatedData<IBittrexTicker>): IBittrexWebsocketStream<IBittrexWebsocketTickers, IBittrexTicker>;
begin
  Result := TBittrexWebsocketStream<IBittrexWebsocketTickers, IBittrexTicker>.Create(
    Bittrex,
    procedure(const Bittrex: IBittrex; const OnReceivedData: TOnReceivedData<IBittrexWebsocketTickers>)
    begin
      Bittrex.SetOnWebsocketTickers(TBittrexOnWebsocketTickers(OnReceivedData));
    end,
    procedure(const Data: IReadOnlyList<IBittrexTicker>; const Delta: IReadOnlyList<IBittrexTicker>)
    begin
      try
        OnUpdatedData(Data, Delta);
      except
      end;
    end,
    function(const Data: IBittrexWebsocketTickers): Integer
    begin
      Result := Data.sequence;
    end,
    function(const Data: IBittrexWebsocketTickers): IReadonlyList<IBittrexTicker>
    begin
      Result := Data.deltas;
    end,
    procedure(const Map: IDictionary<string, IBittrexTicker>; const Item: IBittrexTicker)
    begin
      Map[Item.symbol] := Item;
    end,
    function: TSequencedResult<IReadonlyList<IBittrexTicker>>
    begin
      Result := Retry<void>.New(Void.Get).Map<TSequencedResult<IReadonlyList<IBittrexTicker>>>(function(const Value: Void): TSequencedResult<IReadonlyList<IBittrexTicker>>
        begin
          Result := Bittrex.Tickers;
        end,
        function(const E: Exception): Boolean
        begin
          Result := E.InheritsFrom(EBittrexApiServiceUnavailable);
        end);
    end);
end;

end.
