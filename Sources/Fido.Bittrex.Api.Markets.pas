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

unit Fido.Bittrex.Api.Markets;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Http.Types,
  Fido.Api.Client.VirtualApi.Intf,
  Fido.Api.Client.VirtualApi.Attributes,

  Fido.Bittrex.Api.Markets.Types;

type
  IBittrexMarketsApi = interface(IClientVirtualApi)
    ['{622CEA8F-16CF-4EB5-9E71-B2B07C5AA9BF}']

    [Endpoint(rmGet, '/markets')]
    function List: IReadonlyList<IBittrexMarket>;

    [Endpoint(rmGet, '/markets/summaries')]
    function ListSummaries: IReadonlyList<IBittrexMarketSummary>;

    [Endpoint(rmHead, '/markets/summaries')]
    [HeaderParam('Sequence')]
    procedure GetSummariesSequence(out Sequence: string);

    [Endpoint(rmGet, '/markets/tickers')]
    function ListTickers: IReadonlyList<IBittrexTicker>;

    [Endpoint(rmHead, '/markets/tickers')]
    [HeaderParam('Sequence')]
    procedure GetTickersSequence(out Sequence: string);

    [Endpoint(rmGet, '/markets/{marketSymbol}/ticker')]
    function TickerByMarketSymbol(const marketSymbol: string): IBittrexTicker;

    [Endpoint(rmGet, '/markets/{marketSymbol}')]
    function ByMarketSymbol(const marketSymbol: string): IBittrexMarket;

    [Endpoint(rmGet, '/markets/{marketSymbol}/summary')]
    function SummaryByMarketSymbol(const marketSymbol: string): IBittrexMarketSummary;

    [Endpoint(rmGet, '/markets/{marketSymbol}/orderbook')]
    [QueryParam('depth')]
    function OrderbookByMarketSymbol(const marketSymbol: string; const depth: Nullable<Integer>): IBittrexOrderBook;

    [Endpoint(rmHead, '/markets/{marketSymbol}/orderbook')]
    [QueryParam('depth')]
    [HeaderParam('Sequence')]
    procedure GetOrderbookSequenceByMarketSymbol(out Sequence: string; const marketSymbol: string; const depth: Nullable<Integer>);

    [Endpoint(rmGet, '/markets/{marketSymbol}/trades')]
    function TradesByMarketSymbol(const marketSymbol: string): IReadonlyList<IBittrexTrade>;

    [Endpoint(rmHead, '/markets/{marketSymbol}/trades')]
    [HeaderParam('Sequence')]
    procedure GetTradesSequenceByMarketSymbol(out Sequence: string; const marketSymbol: string);

    [Endpoint(rmGet, '/markets/{marketSymbol}/candles/{candleType}/{candleInterval}/recent')]
    function CandlesByMarketSymbolCandleTypeAndCandleInterval(const marketSymbol: string; const candleType: string; const candleInterval: string): IReadonlyList<IBittrexCandle>;

    [Endpoint(rmHead, '/markets/{marketSymbol}/candles/{candleType}/{candleInterval}/recent')]
    [HeaderParam('Sequence')]
    procedure GetCandlesSequenceByMarketSymbolCandleTypeAndCandleInterval(out Sequence: string; const marketSymbol: string; const candleType: string; const candleInterval: string);

    [Endpoint(rmGet, '/markets/{marketSymbol}/candles/{candleType}/{candleInterval}/historical/{year}/{month}/{day}')]
    function CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(const marketSymbol: string; const candleType: string; const candleInterval: string; const year: Integer;
      const month: Integer; const day: Integer): IReadonlyList<IBittrexCandle>;
  end;

implementation

end.

