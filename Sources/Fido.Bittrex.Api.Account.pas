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

unit Fido.Bittrex.Api.Account;

interface

uses
  Spring.Collections,

  Fido.Http.Types,
  Fido.Api.Client.VirtualApi.Intf,
  Fido.Api.Client.VirtualApi.Attributes,

  Fido.Bittrex.Api.Account.Types;

type
  IBittrexAccountApi = interface(IClientVirtualApi)
    ['{F69D9501-E284-4FC8-B55B-4715CB14B6E7}']

    [Endpoint(rmGet, '/account')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetInfo(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexAccount;

    [Endpoint(rmGet, '/account/fees/fiat')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetFiatTransactionFees(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexFiatTransactionFee>;

    [Endpoint(rmGet, '/account/fees/fiat/{currencySymbol}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetFiatTransactionFeesByCurrencySymbol(const currencySymbol: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexFiatTransactionFee>;

    [Endpoint(rmGet, '/account/fees/trading')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetTradeFees(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexTradingFee>;

    [Endpoint(rmGet, '/account/fees/trading/{marketSymbol}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetTradeFeeByMarketSymbol(const marketSymbol: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexTradingFee;

    [Endpoint(rmGet, '/account/volume')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function Get30DayVolume(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexAccountVolume;

    [Endpoint(rmGet, '/account/permissions/markets')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetTradingPermissions(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexMarketPolicy>;

    [Endpoint(rmGet, '/account/permissions/markets/{marketSymbol}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetTradingPermissionsByMarketSymbol(const marketSymbol: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexMarketPolicy>;

    [Endpoint(rmGet, '/account/permissions/currencies')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetCurrencyPermissions(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexCurrencyPolicy>;

    [Endpoint(rmGet, '/account/permissions/currencies/{currencySymbol}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function GetCurrencyPermissionsByCurrencySymbol(const currencySymbol: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexCurrencyPolicy>;
  end;

implementation

end.
