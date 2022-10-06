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

unit Fido.Bittrex.Api.Deposits;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Http.Types,
  Fido.Api.Client.VirtualApi.Intf,
  Fido.Api.Client.VirtualApi.Attributes,

  Fido.Bittrex.Api.Deposits.Types;

type
  IBittrexDepositsApi = interface(IClientVirtualApi)
    ['{781957ED-A6B2-436E-A2AB-41098A29FD62}']

    [Endpoint(rmGet, '/deposits/open')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [QueryParam('currencySymbol')]
    function ListOpen(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string; const currencySymbol: Nullable<string>): IReadonlyList<IBittrexDeposit>;

    [Endpoint(rmHead, '/deposits/open')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [HeaderParam('Sequence')]
    [QueryParam('currencySymbol')]
    function GetSequence(out Sequence: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string; const currencySymbol: Nullable<string>): IReadonlyList<IBittrexDeposit>;

    [Endpoint(rmGet, '/deposits/closed')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [QueryParam('status')]
    [QueryParam('currencySymbol')]
    [QueryParam('nextPageToken')]
    [QueryParam('previousPageToken')]
    [QueryParam('pageSize')]
    [QueryParam('startDate')]
    [QueryParam('endDate')]
    function ListClosed(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string; const status: string;
      const currencySymbol: Nullable<string>; const nextPageToken: Nullable<string>; const  previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>; const startDate: Nullable<string>;
      const endDate: Nullable<string>): IReadonlyList<IBittrexDeposit>;

    [Endpoint(rmGet, '/deposits/ByTxId/{txid}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function ListByTxId(const txid: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexDeposit>;

    [Endpoint(rmGet, '/deposits/{depositId}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function ById(const depositId: TGuid; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexDeposit;
  end;

implementation

end.

