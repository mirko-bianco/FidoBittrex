unit Fido.Bittrex.WebsocketStream;

interface

uses
  System.SysUtils,
  System.Generics.Defaults,

  Spring.Collections,

  Fido.Boxes,
  Fido.Utilities,

  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Intf,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Websockets.Types,
  Fido.Web.Client.WebSocket.SignalR.Types,

  Fido.Bittrex.WebsocketStream.Intf;

type
  TBittrexWebsocketStream<TWebSocketData, TApiData> = class(TInterfacedObject, IBittrexWebsocketStream<TWebSocketData, TApiData>)
  private var
    FDestroying: Boolean;
    FBittrex: IBittrex;
    FLock: IReadWriteSync;
    FSequence: IBox<Integer>;
    FDataMap: IDictionary<string, TApiData>;
    FOnUpdatedData: TOnUpdatedData<TApiData>;
    FSynchronized: IBox<Boolean>;
    FExtractSequenceFromWebsocketData: TExtractSequenceFromWebsocketData<TWebSocketData>;
    FExtractDataFromWebsocketData: TExtractDataFromWebsocketData<TWebSocketData, TApiData>;
    FSetMapItem: TSetMapItem<TApiData>;
    FGetApiData: TGetApiData<TApiData>;
  private
    procedure LoadApiData;
    procedure OnReceivedWebsocketData(const WebsocketData: TWebSocketData);
  public
    constructor Create(const Bittrex: IBittrex; const SetOnWebsocketEvent: TSetOnWebsocketEvent<TWebSocketData>; const OnUpdatedData: TOnUpdatedData<TApiData>;
      const ExtractSequenceFromWebsocketData: TExtractSequenceFromWebsocketData<TWebSocketData>; const ExtractDataFromWebsocketData: TExtractDataFromWebsocketData<TWebSocketData, TApiData>;
      const SetMapItem: TSetMapItem<TApiData>; const GetApiData: TGetApiData<TApiData>);
    destructor Destroy; override;

    function GetData: IReadOnlyList<TApiData>;
  end;

  TBittrexWebsocketCandleStream = class(TInterfacedObject, IBittrexWebsocketCandleStream)
  private var
    FBittrex: IBittrex;
    FLock: IReadWriteSync;
    FDataMap: IDictionary<string, IList<IBittrexCandle>>;
    FSynchronized: IDictionary<string, Boolean>;
    FSequences: IDictionary<string, Integer>;
    FOnCandlesUpdatedLock: IReadWriteSync;
    FOnUpdatedData: TOnUpdatedCandles;
  private
    procedure LoadApiData(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);
    procedure OnReceivedWebsocketData(const WebsocketData: IBittrexWebsocketCandle);
    function MakeKey(const marketSymbol: string; const candleInterval: TBittrexCandleInterval): string; overload;
    function MakeKey(const marketSymbol: string; const candleInterval: string): string; overload;
  public
    constructor Create(const Bittrex: IBittrex; const OnUpdatedData: TOnUpdatedCandles); reintroduce;

    procedure Subscribe(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);
    procedure Unsubscribe(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);

    function GetData(const marketSymbol: string; const candleInterval: TBittrexCandleInterval): IReadOnlyList<IBittrexCandle>;
  end;

implementation

{ TBittrexWebsocketStream<TWebSocketData, TApiData> }

constructor TBittrexWebsocketStream<TWebSocketData, TApiData>.Create(
  const Bittrex: IBittrex;
  const SetOnWebsocketEvent: TSetOnWebsocketEvent<TWebSocketData>;
  const OnUpdatedData: TOnUpdatedData<TApiData>;
  const ExtractSequenceFromWebsocketData: TExtractSequenceFromWebsocketData<TWebSocketData>;
  const ExtractDataFromWebsocketData: TExtractDataFromWebsocketData<TWebSocketData, TApiData>;
  const SetMapItem: TSetMapItem<TApiData>; const GetApiData: TGetApiData<TApiData>);
begin
  inherited Create;

  FDestroying := False;
  FDataMap := TCollections.CreateSortedDictionary<string, TApiData>(TIStringComparer.Ordinal);
  FBittrex := Utilities.CheckNotNullAndSet(Bittrex, 'Bittrex');
  FExtractSequenceFromWebsocketData := Utilities.CheckNotNullAndSet<TExtractSequenceFromWebsocketData<TWebSocketData>>(ExtractSequenceFromWebsocketData, 'ExtractSequenceFromWebsocketData');
  FExtractDataFromWebsocketData := Utilities.CheckNotNullAndSet<TExtractDataFromWebsocketData<TWebSocketData, TApiData>>(ExtractDataFromWebsocketData, 'ExtractDataFromWebsocketData');
  FSetMapItem := Utilities.CheckNotNullAndSet<TSetMapItem<TApiData>>(SetMapItem, 'SetMapItem');
  FGetApiData := Utilities.CheckNotNullAndSet<TGetApiData<TApiData>>(GetApiData, 'GetApiData');

  FLock := TMREWSync.Create;
  FSequence := Box<Integer>.Setup(0);
  FSynchronized := Box<Boolean>.Setup(False);
  FOnUpdatedData := Utilities.CheckNotNullAndSet<TOnUpdatedData<TApiData>>(OnUpdatedData, 'OnUpdatedData');
  Utilities.CheckNotNullAndSet<TSetOnWebsocketEvent<TWebSocketData>>(SetOnWebsocketEvent, 'SetOnWebsocketEvent');
  SetOnWebsocketEvent(Bittrex, OnReceivedWebsocketData);
  OnUpdatedData(GetApiData.Data, TCollections.CreateList<TApiData>.AsReadonly);
end;

destructor TBittrexWebsocketStream<TWebSocketData, TApiData>.Destroy;
begin
  FDestroying := True;
  FDataMap.Clear;

  inherited;
end;

function TBittrexWebsocketStream<TWebSocketData, TApiData>.GetData: IReadOnlyList<TApiData>;
begin
  if FDestroying then
    Exit(TCollections.CreateList<TApiData>([]).AsReadOnly);

  FLock.BeginRead;
  try
    Result := TCollections.CreateList<TApiData>(FDataMap.Values).AsReadOnly;
  finally
    FLock.EndRead;
  end;
end;

procedure TBittrexWebsocketStream<TWebSocketData, TApiData>.LoadApiData;
var
  List: TSequencedResult<IReadonlyList<TApiData>>;
  Item: TApiData;
begin
  List := FGetApiData();

  FSequence.UpdateValue(0);
  FLock.BeginWrite;
  try
    FDataMap.Clear;
  finally
    FLock.EndWrite;
  end;

  FSequence.UpdateValue(StrToInt(List.Sequence));
  for Item in List.Data do
  begin
    FLock.BeginWrite;
    try
      FSetMapItem(FDataMap, Item);
    finally
      FLock.EndWrite;
    end;
  end;
end;

procedure TBittrexWebsocketStream<TWebSocketData, TApiData>.OnReceivedWebsocketData(const WebsocketData: TWebSocketData);
var
  Item: TApiData;
  Delta: IReadonlyList<TApiData>;
  Data: IReadonlyList<TApiData>;
begin
  if FDestroying then
    Exit;
  
  if (FSequence.Value = 0) or
     ((not (FExtractSequenceFromWebsocketData(WebsocketData) = (FSequence.Value + 1))) and FSynchronized.Value) then
  begin
    FSynchronized.UpdateValue(False);
    LoadApiData;
    Data := GetData;
    FOnUpdatedData(Data, Data);
  end;

  if FExtractSequenceFromWebsocketData(WebsocketData) = (FSequence.Value + 1) then
  begin
    FSynchronized.UpdateValue(True);
    FSequence.UpdateValue(FExtractSequenceFromWebsocketData(WebsocketData));
    Delta := FExtractDataFromWebsocketData(WebsocketData);
    for Item in Delta do
    begin
      FLock.BeginWrite;
      try
        if not FDestroying then
          FSetMapItem(FDataMap, Item);
      finally
        FLock.EndWrite;
      end;
    end;
    FOnUpdatedData(GetData, Delta);
  end;
end;

{ TBittrexWebsocketCandleStream }

constructor TBittrexWebsocketCandleStream.Create(
  const Bittrex: IBittrex;
  const OnUpdatedData: TOnUpdatedCandles);
begin
  inherited Create;

  FBittrex := Utilities.CheckNotNullAndSet(Bittrex, 'Bittrex');
  FOnUpdatedData := Utilities.CheckNotNullAndSet<TOnUpdatedCandles>(OnUpdatedData, 'OnUpdatedData');
  FSequences := TCollections.CreateDictionary<string, Integer>;

  FLock := TMREWSync.Create;
  FSynchronized := TCollections.CreateDictionary<string, Boolean>;
  FDataMap := TCollections.CreateSortedDictionary<string, IList<IBittrexCandle>>(TIStringComparer.Ordinal);

  Bittrex.SetOnWebsocketCandle(OnReceivedWebsocketData);

  FOnUpdatedData := OnUpdatedData;

  FOnCandlesUpdatedLock := TMREWSync.Create;
end;

function TBittrexWebsocketCandleStream.GetData(const marketSymbol: string; const candleInterval: TBittrexCandleInterval): IReadOnlyList<IBittrexCandle>;
var
  Data: IList<IBittrexCandle>;
begin
  FLock.BeginRead;
  try
    if not FDataMap.TryGetValue(MakeKey(marketSymbol, candleInterval), Data) then
      Data := TCollections.CreateList<IBittrexCandle>;
    Result := TCollections.CreateList<IBittrexCandle>(Data).AsReadOnly;
  finally
    FLock.EndRead;
  end;
end;

procedure TBittrexWebsocketCandleStream.LoadApiData(const marketSymbol: string; const candleInterval: TBittrexCandleInterval);
var
  List: TSequencedResult<IReadonlyList<IBittrexCandle>>;
  Item: IBittrexCandle;
  Key: string;
  DataMapList: IList<IBittrexCandle>;
begin
  List := FBittrex.CandlesByMarketSymbolCandleTypeAndCandleInterval(marketSymbol, TBittrexCandleType.TRADE, candleInterval);
  Key := MakeKey(marketSymbol, candleInterval);

  FSequences[Key] := 0;
  if not FDataMap.TryGetValue(Key, DataMapList) then
    FDataMap[Key] := TCollections.CreateList<IBittrexCandle>;

  FDataMap[Key].Clear;

  FSequences[Key] := StrToInt(List.Sequence);
  for Item in List.Data do
    FDataMap[Key].Add(Item);
end;

function TBittrexWebsocketCandleStream.MakeKey(
  const marketSymbol: string;
  const candleInterval: string): string;
begin
  Result := Format('%s_%s', [marketSymbol, candleInterval]);
end;

function TBittrexWebsocketCandleStream.MakeKey(
  const marketSymbol: string;
  const candleInterval: TBittrexCandleInterval): string;
begin
  Result := MakeKey(marketSymbol, BITTREXCANDLEINTERVALS_S[candleInterval]);
end;

procedure TBittrexWebsocketCandleStream.OnReceivedWebsocketData(const WebsocketData: IBittrexWebsocketCandle);
var
  Item: IBittrexCandle;
  Data: IReadonlyList<IBittrexCandle>;
  Key: string;
  Sequence: Integer;
  Synchronized: Boolean;
  Index: TBittrexCandleInterval;
  Interval: TBittrexCandleInterval;
begin
  Key := MakeKey(WebsocketData.marketSymbol, WebsocketData.interval);

  Interval := Low(TBittrexCandleInterval);
  for Index := Low(TBittrexCandleInterval) to High(TBittrexCandleInterval) do
    if WebsocketData.interval = BITTREXCANDLEINTERVALS_S[Index] then
      Interval := Index;

  FLock.BeginRead;
  try
    if not FSequences.TryGetValue(Key, Sequence) then
      Sequence := 0;
    if not FSynchronized.TryGetValue(Key, Synchronized) then
      Synchronized := False;
  finally
    FLock.EndRead;
  end;

  if (Sequence = 0) or
     ((not (WebsocketData.sequence = (Sequence + 1))) and Synchronized) then
  begin
    FLock.BeginWrite;
    try
      FSynchronized[Key] := False;
      LoadApiData(WebsocketData.marketSymbol,  Interval);
      Data := GetData(WebsocketData.marketSymbol,  Interval);
      FOnUpdatedData(WebsocketData.marketSymbol,  Interval, Data, Data);
    finally
      FLock.EndWrite;
    end;
  end;

  if WebsocketData.sequence = (Sequence + 1) then
  begin
    FSynchronized[Key] := True;
    FSequences[Key] := WebsocketData.sequence;
    Item := WebsocketData.delta;

    FLock.BeginWrite;
    try
      FDataMap[Key].Delete(0);
      FDataMap[Key].Add(Item);
    finally
      FLock.EndWrite;
    end;

    Data := GetData(WebsocketData.marketSymbol,  Interval);
    FOnUpdatedData(WebsocketData.marketSymbol,  Interval, Data, TCollections.CreateList<IBittrexCandle>([Item]).AsReadOnly);
  end;
end;

procedure TBittrexWebsocketCandleStream.Subscribe(
  const marketSymbol: string;
  const candleInterval: TBittrexCandleInterval);
var
  SignalRMethodResult: TSignalRMethodResult;
begin
  repeat
    SignalRMethodResult := FBittrex.SubscribeWebsocketTo([BittrexWebsocketChannels.CandleAsString(marketSymbol, candleInterval)]);
  until SignalRMethodResult.Success;

  FOnUpdatedData(marketSymbol, candleInterval, GetData(marketSymbol, candleInterval), TCollections.CreateList<IBittrexCandle>.AsReadOnly);
end;

procedure TBittrexWebsocketCandleStream.Unsubscribe(
  const marketSymbol: string;
  const candleInterval: TBittrexCandleInterval);
var
  SignalRMethodResult: TSignalRMethodResult;
begin
  repeat
    SignalRMethodResult := FBittrex.UnsubscribeWebsocketFrom([BittrexWebsocketChannels.CandleAsString(marketSymbol, candleInterval)]);
  until SignalRMethodResult.Success;
end;

end.
