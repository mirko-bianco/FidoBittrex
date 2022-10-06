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

unit Fido.Bittrex.Api.Markets.Types;

interface

uses
  Spring.Collections;

type
  TBittrexMarketStatus = (ONLINE, OFFLINE);

//  {
//    "symbol": "string",
//    "baseCurrencySymbol": "string",
//    "quoteCurrencySymbol": "string",
//    "minTradeSize": "number (double)",
//    "precision": "integer (int32)",
//    "status": "string",
//    "createdAt": "string (date-time)",
//    "notice": "string",
//    "prohibitedIn": [
//      "string"
//    ],
//    "associatedTermsOfService": [
//      "string"
//    ],
//    "tags": [
//      "string"
//    ]
//  }
  IBittrexMarket = interface(IInvokable)
    ['{32F212CB-0CB8-43A8-A9D1-B997BA4C45FE}']

    function symbol: string;
    function baseCurrencySymbol: string;
    function quoteCurrencySymbol: string;
    function minTradeSize: Extended;
    function precision: Integer;
    function status: string;
    function Notice: string;
    function createdAt: TDateTime;
    function prohibitedIn: IReadonlyList<string>;
    function associatedTermsOfService: IReadonlyList<string>;
    function Tags: IReadonlyList<string>;
  end;

//  {
//    "symbol": "string",
//    "high": "number (double)",
//    "low": "number (double)",
//    "volume": "number (double)",
//    "quoteVolume": "number (double)",
//    "percentChange": "number (double)",
//    "updatedAt": "string (date-time)"
//  }
  IBittrexMarketSummary = interface(IInvokable)
    ['{7E8CD8CB-5DE7-40C6-9A71-C7B687B6C61D}']

    function symbol: string;
    function high: Extended;
    function low: Extended;
    function volume: Extended;
    function quoteVolume: Extended;
    function percentChange: Extended;
    function updatedAt: TDateTime;
  end;

//  {
//    "symbol": "string",
//    "lastTradeRate": "number (double)",
//    "bidRate": "number (double)",
//    "askRate": "number (double)"
//  }
  IBittrexTicker = interface(IInvokable)
    ['{B8D31E57-F612-4264-8936-8D5D239485BA}']

    function symbol: string;
    function lastTradeRate: Extended;
    function bidRate: Extended;
    function askRate: Extended;
  end;

  TBittrexOrderbookDepth = (Depth1, Depth25, Depth500);

//  {
//    "bid": [
//      {
//        "quantity": "number (double)",
//        "rate": "number (double)"
//      }
//    ],
//    "ask": [
//      {
//        "quantity": "number (double)",
//        "rate": "number (double)"
//      }
//    ]
//  }
  IBittrexOrderBookItem = interface(IInvokable)
    ['{681DAB33-573C-4056-B5F9-30987D6E1F90}']

    function quantity: Extended;
    function rate: Extended;
  end;

  IBittrexOrderBook = interface(IInvokable)
    ['{7D18905D-B8DD-4731-9EEC-99F7676129C1}']

    function bid: IReadonlyList<IBittrexOrderBookItem>;
    function ask: IReadonlyList<IBittrexOrderBookItem>;
  end;

//  {
//    "id": "string (uuid)",
//    "executedAt": "string (date-time)",
//    "quantity": "number (double)",
//    "rate": "number (double)",
//    "takerSide": "string"
//  }
  IBittrexTrade = interface(IInvokable)
    ['{842EB23A-7385-49E8-A566-48336D1F0319}']

    function id: TGuid;
    function executedAt: TDateTime;
    function quantity: Extended;
    function rate: Extended;
    function takerSide: string;
  end;

  TBittrexCandleInterval = (MINUTE_1, MINUTE_5, HOUR_1, DAY_1);
  TBittrexCandleType = (TRADE, MIDPOINT);

//  {
//    "startsAt": "string (date-time)",
//    "open": "number (double)",
//    "high": "number (double)",
//    "low": "number (double)",
//    "close": "number (double)",
//    "volume": "number (double)",
//    "quoteVolume": "number (double)"
//  }
  IBittrexCandle = interface(IInvokable)
    ['{5FF2F8F8-351E-4197-9713-D5BFE70D0235}']

    function startsAt: TDateTime;
    function open: Extended;
    function high: Extended;
    function low: Extended;
    function close: Extended;
    function volume: Extended;
    function quoteVolume: Extended;
  end;

const
  BITTREXMARKETSTATUS_S: array[TBittrexMarketStatus] of string = ('ONLINE', 'OFFLINE');
  BITTREXORDERBOOKDEPTHS_I: array[TBittrexOrderbookDepth] of Integer = (1, 25, 500);
  BITTREXCANDLEINTERVALS_S: array[TBittrexCandleInterval] of string = ('MINUTE_1', 'MINUTE_5', 'HOUR_1', 'DAY_1');
  BITTREXCANDLETYPES_S: array[TBittrexCandleType] of string = ('TRADE', 'MIDPOINT');


implementation

end.
