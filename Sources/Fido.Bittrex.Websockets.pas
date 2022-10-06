(*
 * Copyright 2022 Mirko Bianco (email: writetomirko@gmail.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without Apiriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)

unit Fido.Bittrex.Websockets;

interface

uses
  System.Classes,
  System.SysUtils,
  System.NetEncoding,
  System.ZLib,
  System.JSON,
  System.Hash,
  System.DateUtils,
  System.Generics.Collections,

  Spring,
  Spring.Collections,
  Fido.Boxes,
  Fido.Utilities,
  Fido.JSON.Marshalling,
  Fido.Web.Client.WebSocket.Intf,
  Fido.Web.Client.WebSocket.SignalR,
  Fido.Web.Client.WebSocket.SignalR.Types,

  Fido.Bittrex.Intf,
  Fido.Bittrex.Websockets.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Websockets.Intf;

type
  TBittrexWebsockets = class(TInterfacedObject, IBittrexWebsockets)
  private const
    HUB = 'c3';
    WEBSOCKETHOST = 'socket-v3.bittrex.com';
  private var
    FApiSecret: string;
    FApiKey: string;
    FSubAccountId: string;
    FWS: TSignalR;
    FAuthenticationRequired: IBox<Boolean>;

    FOnWebsocketHeartBeat: TBittrexOnWebsocketHeartBeat;
    FOnWebsocketTicker: TBittrexOnWebsocketTicker;
    FOnWebsocketBalance: TBittrexOnWebsocketBalance;
    FOnWebsocketCandle: TBittrexOnWebsocketCandle;
    FOnWebsocketConditionalOrder: TBittrexOnWebsocketConditionalOrder;
    FOnWebsocketDeposit: TBittrexOnWebsocketDeposit;
    FOnWebsocketExecution: TBittrexOnWebsocketExecution;
    FOnWebsocketMarketSummary: TBittrexOnWebsocketMarketSummary;
    FOnWebsocketMarketSummaries: TBittrexOnWebsocketMarketSummaries;
    FOnWebsocketOrder: TBittrexOnWebsocketOrder;
    FOnWebsocketOrderBook: TBittrexOnWebsocketOrderBook;
    FOnWebsocketTickers: TBittrexOnWebsocketTickers;
    FOnWebsocketTrade: TBittrexOnWebsocketTrade;
  private
    function DecodeAndDecompressBase64GZipString(const Input: string): string;
  public
    constructor Create(const WebSocketClient: IWebSocketClient; const ApiSecret: string; const ApiKey: string; const SubAccountId: string = ''; const OnWebSocketError: TWebSocketOnError = nil);

    function Authenticate: TSignalRMethodResult;
    function IsAuthenticated: TSignalRMethodResult;
    function SubscribeTo(const Channels: array of string): TSignalRMethodResult;
    function UnsubscribeFrom(const Channels: array of string): TSignalRMethodResult;
    procedure Start;
    procedure Stop;
    function IsStarted: Boolean;

    procedure SetOnBalance(const Value: TBittrexOnWebsocketBalance);
    procedure SetOnCandle(const Value: TBittrexOnWebsocketCandle);
    procedure SetOnConditionalOrder(const Value: TBittrexOnWebsocketConditionalOrder);
    procedure SetOnDeposit(const Value: TBittrexOnWebsocketDeposit);
    procedure SetOnExecution(const Value: TBittrexOnWebsocketExecution);
    procedure SetOnHeartBeat(const Value: TBittrexOnWebsocketHeartBeat);
    procedure SetOnMarketSummaries(const Value: TBittrexOnWebsocketMarketSummaries);
    procedure SetOnMarketSummary(const Value: TBittrexOnWebsocketMarketSummary);
    procedure SetOnOrder(const Value: TBittrexOnWebsocketOrder);
    procedure SetOnOrderBook(const Value: TBittrexOnWebsocketOrderBook);
    procedure SetOnTicker(const Value: TBittrexOnWebsocketTicker);
    procedure SetOnTickers(const Value: TBittrexOnWebsocketTickers);
    procedure SetOnTrade(const Value: TBittrexOnWebsocketTrade);
  end;

implementation

{ TBittrexWebsockets }

function TBittrexWebsockets.Authenticate: TSignalRMethodResult;
var
  TimeStamp: string;
  RandomContent: string;
  Content: string;
  SignedContent: string;
  Data: string;
begin
  TimeStamp := IntToStr(Utilities.UNIXTimeInMilliseconds);
  RandomContent := JSONMarshaller.From<TGuid>(TGuid.NewGuid).Trim(['"']);
  Content := Format('%s%s', [TimeStamp, RandomContent]);
  SignedContent := Utilities.CalculateHMACSHA512(Content, FApiSecret);

  Data := Format('"%s", %s, "%s", "%s"', [FApiKey, TimeStamp, RandomContent, SignedContent]);

  Result := FWS.Send(HUB, 'Authenticate', Data, function(const Message: string): TSignalRMethodResult
    var
      AuthenticateResult: IBittrexWebsocketAuthenticateResult;
    begin
      AuthenticateResult := JSONUnmarshaller.To<IBittrexWebsocketAuthenticateResult>(Message);
      Result := TSignalRMethodResult.Create(AuthenticateResult.R.Success, AuthenticateResult.R.ErrorCode.GetValueOrDefault);
    end);

  FAuthenticationRequired.UpdateValue(Result.Success);

  if Result.Success then
    TThread.CreateAnonymousThread(procedure
      var
        ElapsedTime: TDateTime;
      begin
        ElapsedTime := Now;
        while Assigned(FAuthenticationRequired) and FAuthenticationRequired.Value do
        begin
          Sleep(100);
          if not Now.WithinPastMinutes(ElapsedTime, 9) then
          begin
            Authenticate;
            Exit;
          end;
        end;
      end).Start;
end;

constructor TBittrexWebsockets.Create(
  const WebSocketClient: IWebSocketClient;
  const ApiSecret: string;
  const ApiKey: string;
  const SubAccountId: string;
  const OnWebSocketError: TWebSocketOnError);
begin
  inherited Create;

  FOnWebsocketHeartBeat := procedure
    begin
    end;
  FOnWebsocketTicker := procedure(const Ticker: IBittrexTicker)
    begin
    end;
  FOnWebsocketBalance := procedure(const Balance: IBittrexBalance)
    begin
    end;
  FOnWebsocketCandle := procedure(const Candle: IBittrexWebsocketCandle)
    begin
    end;
  FOnWebsocketConditionalOrder := procedure(const Candle: IBittrexWebsocketConditionalOrder)
    begin
    end;
  FOnWebsocketDeposit := procedure(const Deposit: IBittrexWebsocketDeposit)
    begin
    end;
  FOnWebsocketExecution := procedure(const Execution: IBittrexWebsocketExecution)
    begin
    end;
  FOnWebsocketMarketSummary := procedure(const MarketSummary: IBittrexMarketSummary)
    begin
    end;
  FOnWebsocketMarketSummaries := procedure(const MarketSummaries: IBittrexWebsocketMarketSummaries)
    begin
    end;
  FOnWebsocketOrder := procedure(const Order: IBittrexWebsocketOrder)
    begin
    end;
  FOnWebsocketOrderBook := procedure(const OrderBook: IBittrexWebsocketOrderBook)
    begin
    end;
  FOnWebsocketTickers := procedure(const Tickers: IBittrexWebsocketTickers)
    begin
    end;
  FOnWebsocketTrade := procedure(const Trade: IBittrexWebsocketTrade)
    begin
    end;

  Guard.CheckNotNull(WebSocketClient, 'WebSocketClient');

  FAuthenticationRequired :=  Box<Boolean>.Setup(False);

  FApiSecret := ApiSecret;
  FApiKey := ApiKey;
  FSubAccountId := SubAccountId;

  FWS := TSignalR.Create(
    WEBSOCKETHOST,
    True,
    procedure(const MessageType: string; const Message: string)
    var
      Json: Shared<TJSONArray>;
      Index: Integer;
      Payload: string;
    begin
      if (MessageType = BITTREXWEBSOCKETMESSAGES_S[Heartbeat]) then
        FOnWebsocketHeartBeat();

      Json := TJSONValue.ParseJSONValue(Message) as TJSONArray;
      for Index := 0 to Json.Value.Count - 1 do
      begin
        Payload := DecodeAndDecompressBase64GZipString((Json.Value.Items[0] as TJSONString).Value);

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Ticker]) then
          FOnWebsocketTicker(JSONUnmarshaller.To<IBittrexTicker>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Balance]) then
          FOnWebsocketBalance(JSONUnmarshaller.To<IBittrexBalance>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Candle]) then
          FOnWebsocketCandle(JSONUnmarshaller.To<IBittrexWebsocketCandle>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.ConditionalOrder]) then
          FOnWebsocketConditionalOrder(JSONUnmarshaller.To<IBittrexWebsocketConditionalOrder>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Deposit]) then
          FOnWebsocketDeposit(JSONUnmarshaller.To<IBittrexWebsocketDeposit>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Execution]) then
          FOnWebsocketExecution(JSONUnmarshaller.To<IBittrexWebsocketExecution>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.MarketSummary]) then
          FOnWebsocketMarketSummary(JSONUnmarshaller.To<IBittrexMarketSummary>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.MarketSummaries]) then
          FOnWebsocketMarketSummaries(JSONUnmarshaller.To<IBittrexWebsocketMarketSummaries>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Order]) then
          FOnWebsocketOrder(JSONUnmarshaller.To<IBittrexWebsocketOrder>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.OrderBook]) then
          FOnWebsocketOrderBook(JSONUnmarshaller.To<IBittrexWebsocketOrderBook>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Tickers]) then
          FOnWebsocketTickers(JSONUnmarshaller.To<IBittrexWebsocketTickers>(Payload));

        if (MessageType = BITTREXWEBSOCKETMESSAGES_S[TBittrexWebsocketChannel.Trade]) then
          FOnWebsocketTrade(JSONUnmarshaller.To<IBittrexWebsocketTrade>(Payload));
      end;
    end,
    WebSocketClient,
    OnWebSocketError);
end;

function TBittrexWebsockets.DecodeAndDecompressBase64GZipString(const Input: string): string;
var
  DecompressionStream: Shared<TZDecompressionStream>;
  Encoding: Shared<TBase64Encoding>;
  BytesResponse: TBytes;
  SourceStream: Shared<TBytesStream>;
  DestinationStream: Shared<TStringStream>;
begin
  Encoding := TBase64Encoding.Create;
  BytesResponse := Encoding.Value.DecodeStringToBytes(Input);
  SourceStream := TBytesStream.Create(BytesResponse);
  SourceStream.Value.Position := 0;
  DecompressionStream := TZDecompressionStream.Create(SourceStream, -15);
  DestinationStream := TStringStream.Create;
  DestinationStream.Value.CopyFrom(DecompressionStream, 0);
  Result := DestinationStream.Value.DataString;
end;

function TBittrexWebsockets.IsAuthenticated: TSignalRMethodResult;
begin
  Result := FWS.Send(HUB, 'IsAuthenticated', '', function(const Message: string): TSignalRMethodResult
    var
      IsAuthenticatedResult: IBittrexWebsocketIsAuthenticatedResult;
    begin
      IsAuthenticatedResult := JSONUnmarshaller.To<IBittrexWebsocketIsAuthenticatedResult>(Message);
      Result := TSignalRMethodResult.Create(IsAuthenticatedResult.R, IsAuthenticatedResult.I);
    end);
end;

procedure TBittrexWebsockets.SetOnBalance(const Value: TBittrexOnWebsocketBalance);
begin
  FOnWebsocketBalance := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketBalance>(Value, 'OnWebsocketBalance');
end;

procedure TBittrexWebsockets.SetOnCandle(const Value: TBittrexOnWebsocketCandle);
begin
  FOnWebsocketCandle := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketCandle>(Value, 'OnWebsocketCandle');
end;

procedure TBittrexWebsockets.SetOnConditionalOrder(const Value: TBittrexOnWebsocketConditionalOrder);
begin
  FOnWebsocketConditionalOrder := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketConditionalOrder>(Value, 'OnWebsocketConditionalOrder');
end;

procedure TBittrexWebsockets.SetOnDeposit(const Value: TBittrexOnWebsocketDeposit);
begin
  FOnWebsocketDeposit := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketDeposit>(Value, 'OnWebsocketDeposit');
end;

procedure TBittrexWebsockets.SetOnExecution(const Value: TBittrexOnWebsocketExecution);
begin
  FOnWebsocketExecution := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketExecution>(Value, 'OnWebsocketExecution');
end;

procedure TBittrexWebsockets.SetOnHeartBeat(const Value: TBittrexOnWebsocketHeartBeat);
begin
  FOnWebsocketHeartBeat := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketHeartBeat>(Value, 'OnWebsocketHeartBeat');
end;

procedure TBittrexWebsockets.SetOnMarketSummaries(const Value: TBittrexOnWebsocketMarketSummaries);
begin
  FOnWebsocketMarketSummaries := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketMarketSummaries>(Value, 'OnWebsocketMarketSummaries');
end;

procedure TBittrexWebsockets.SetOnMarketSummary(const Value: TBittrexOnWebsocketMarketSummary);
begin
  FOnWebsocketMarketSummary := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketMarketSummary>(Value, 'OnWebsocketMarketSummary');
end;

procedure TBittrexWebsockets.SetOnOrder(const Value: TBittrexOnWebsocketOrder);
begin
  FOnWebsocketOrder := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketOrder>(Value, 'OnWebsocketOrder');
end;

procedure TBittrexWebsockets.SetOnOrderBook(const Value: TBittrexOnWebsocketOrderBook);
begin
  FOnWebsocketOrderBook := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketOrderBook>(Value, 'OnWebsocketOrderBook');
end;

procedure TBittrexWebsockets.SetOnTicker(const Value: TBittrexOnWebsocketTicker);
begin
  FOnWebsocketTicker := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketTicker>(Value, 'OnWebsocketTicker');
end;

procedure TBittrexWebsockets.SetOnTickers(const Value: TBittrexOnWebsocketTickers);
begin
  FOnWebsocketTickers := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketTickers>(Value, 'OnWebsocketTickers');
end;

procedure TBittrexWebsockets.SetOnTrade(const Value: TBittrexOnWebsocketTrade);
begin
  FOnWebsocketTrade := Utilities.CheckNotNullAndSet<TBittrexOnWebsocketTrade>(Value, 'OnWebsocketTrade');;
end;

procedure TBittrexWebsockets.Start;
begin
  FAuthenticationRequired.UpdateValue(True);
  FWs.Start;
end;

function TBittrexWebsockets.IsStarted: Boolean;
begin
  Result := FWs.Started;
end;

procedure TBittrexWebsockets.Stop;
begin
  FAuthenticationRequired.UpdateValue(False);
  FWs.Stop;
end;

function TBittrexWebsockets.SubscribeTo(const Channels: array of string): TSignalRMethodResult;
begin
  Result := FWS.Send<IReadonlyList<string>>(HUB, 'Subscribe', TCollections.CreateList<string>(Channels).AsReadOnlyList, function(const Message: string): TSignalRMethodResult
    var
      SubscribeResult: IBittrexWebsocketSubscribeResult;
      LResult: Boolean;
      LErrorMessage: Shared<TStringList>;
    begin
      LErrorMessage := TStringList.Create;
      SubscribeResult := JSONUnmarshaller.To<IBittrexWebsocketSubscribeResult>(Message);
      LResult := not SubscribeResult.R.IsEmpty;
      SubscribeResult.R.ForEach(procedure(const Item: IChannelResult)
        begin
          LResult := LResult and Item.Success;
          if Item.ErrorCode.HasValue then
            LErrorMessage.Value.Add(Item.ErrorCode.Value)
        end);

      Result := TSignalRMethodResult.Create(LResult, LErrorMessage.Value.DelimitedText);
    end);
end;

function TBittrexWebsockets.UnsubscribeFrom(const Channels: array of string): TSignalRMethodResult;
begin
  Result := FWS.Send<IReadonlyList<string>>(HUB, 'Unsubscribe', TCollections.CreateList<string>(Channels).AsReadOnlyList, function(const Message: string): TSignalRMethodResult
    var
      UnsubscribeResult: IBittrexWebsocketUnsubscribeResult;
      LResult: Boolean;
      LErrorMessage: Shared<TStringList>;
    begin
      LErrorMessage := TStringList.Create;
      UnsubscribeResult := JSONUnmarshaller.To<IBittrexWebsocketUnsubscribeResult>(Message);
      LResult := not UnsubscribeResult.R.IsEmpty;
      UnsubscribeResult.R.ForEach(procedure(const Item: IChannelResult)
        begin
          LResult := LResult and Item.Success;
          if Item.ErrorCode.HasValue then
            LErrorMessage.Value.Add(Item.ErrorCode.Value)
        end);

      Result := TSignalRMethodResult.Create(LResult, LErrorMessage.Value.DelimitedText);
    end);
end;

end.
