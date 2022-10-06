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

unit Fido.Bittrex.Api.Currencies.Types;

interface

uses
  Spring.Collections;

type
  TBittrexCurrencyStatus = (ONLINE, OFFLINE);

//  {
//    "symbol": "string",
//    "name": "string",
//    "coinType": "string",
//    "status": "string",
//    "minConfirmations": "integer (int32)",
//    "notice": "string",
//    "txFee": "number (double)",
//    "logoUrl": "string",
//    "prohibitedIn": [
//      "string"
//    ],
//    "baseAddress": "string",
//    "associatedTermsOfService": [
//      "string"
//    ],
//    "tags": [
//      "string"
//    ]
//  }
  IBittrexCurrency = interface(IInvokable)
    ['{29B66526-57B8-4A3A-AD9F-1F9692C63AE7}']

    function symbol: string;
    function name: string;
    function coinType: string;
    function status: string;
    function minConfirmations: Integer;
    function notice: string;
    function txFee: Extended;
    function logoUrl: string;
    function prohibitedIn: IReadonlyList<string>;
    function baseAddress: string;
    function associatedTermsOfService: IReadonlyList<string>;
    function tags: IReadonlyList<string>;
  end;

const
  BITTREXCURRENCYSTATUSSES_S: array[TBittrexCurrencyStatus] of string = ('ONLINE', 'OFFLINE');

implementation

end.
