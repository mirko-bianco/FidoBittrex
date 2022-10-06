unit Fido.Bittrex.WebsocketStream.Intf;

interface

uses
  Spring.Collections,

  Fido.Utilities,

  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Intf,

  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Websockets.Types;

type
  TOnUpdatedData<TApiData> = reference to procedure(const Data: IReadOnlyList<TApiData>; const Delta: IReadOnlyList<TApiData>);
  TOnReceivedData<TWebSocketData> = reference to procedure(const Data: TWebSocketData);
  TSetOnWebsocketEvent<TWebSocketData> = reference to procedure(const Bittrex: IBittrex; const OnReceivedData: TOnReceivedData<TWebSocketData>);
  TExtractSequenceFromWebsocketData<TWebSocketData> = reference to function(const Data: TWebSocketData): Integer;
  TExtractDataFromWebsocketData<TWebSocketData, TApiData> = reference to function(const Data: TWebSocketData): IReadonlyList<TApiData>;
  TSetMapItem<TApiData> = reference to procedure(const Map: IDictionary<string, TApiData>; const Item: TApiData);
  TGetApiData<TApiData> = reference to function: TSequencedResult<IReadonlyList<TApiData>>;
  TOnUpdatedCandles = reference to procedure(const marketSymbol: string; const candleInterval: TBittrexCandleInterval; const Data: IReadOnlyList<IBittrexCandle>; const Delta: IReadOnlyList<IBittrexCandle>);

  IBittrexWebsocketStream<TWebSocketData, TApiData> = interface(IInvokable)
    ['{745F783A-9FC3-4177-929C-EDD93640E2A8}']

    function GetData: IReadOnlyList<TApiData>;
  end;

  IBittrexWebsocketCandleStream = interface(IInvokable)
    ['{A8203726-64D2-4F19-8943-05F50BDD2325}']

    procedure Subscribe(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);
    procedure Unsubscribe(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);

    function GetData(const marketSymbol: string; const candleInterval: TBittrexCandleInterval): IReadOnlyList<IBittrexCandle>;
  end;

implementation

end.
