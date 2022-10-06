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

unit Fido.Bittrex.Websockets.Intf;

interface

uses
  Fido.Web.Client.WebSocket.SignalR.Types,
  Fido.Bittrex.Websockets.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.Executions.Types,
  Fido.Bittrex.Api.Markets.Types;

type
  TBittrexOnWebsocketHeartBeat = reference to procedure;
  TBittrexOnWebsocketTicker = reference to procedure(const Ticker: IBittrexTicker);
  TBittrexOnWebsocketBalance = reference to procedure(const Balance: IBittrexBalance);
  TBittrexOnWebsocketCandle = reference to procedure(const Candle: IBittrexWebsocketCandle);
  TBittrexOnWebsocketConditionalOrder = reference to procedure(const Candle: IBittrexWebsocketConditionalOrder);
  TBittrexOnWebsocketDeposit = reference to procedure(const Deposit: IBittrexWebsocketDeposit);
  TBittrexOnWebsocketExecution = reference to procedure(const Execution: IBittrexWebsocketExecution);
  TBittrexOnWebsocketMarketSummary = reference to procedure(const MarketSummary: IBittrexMarketSummary);
  TBittrexOnWebsocketMarketSummaries = reference to procedure(const MarketSummaries: IBittrexWebsocketMarketSummaries);
  TBittrexOnWebsocketOrder = reference to procedure(const Order: IBittrexWebsocketOrder);
  TBittrexOnWebsocketOrderBook = reference to procedure(const OrderBook: IBittrexWebsocketOrderBook);
  TBittrexOnWebsocketTickers = reference to procedure(const Tickers: IBittrexWebsocketTickers);
  TBittrexOnWebsocketTrade = reference to procedure(const Trade: IBittrexWebsocketTrade);

  IBittrexWebsockets = interface(IInvokable)
    ['{ED6D8E3C-F90B-441D-A18C-B273A1A15C7F}']

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

end.
